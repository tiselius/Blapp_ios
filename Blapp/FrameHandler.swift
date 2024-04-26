



import AVFoundation
import CoreImage
import Combine
import UIKit


class FrameHandler: NSObject, ObservableObject, AVCaptureDepthDataOutputDelegate{
    @Published var frame: CGImage?
    @Published var distance: Float32 = 0// Add a published property for distance
    @Published var meanvalue: Float = 0.0// Add a published property for mean value
    @Published var area: Float32 = 0.0
    
    private var distanceArray = [Float]() // Array to store distances , Vi testar den genom att sätta in 9 st element och ser ifall array töms efter 10 då mean value då kommer ändras ifrån 2.98
    
    private var cameraDevice: AVCaptureDevice!
    
    private var permissionGranted = true
    let captureSession = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    private var processFrame : ProcessFrame
    private var depthDataOutput: AVCaptureDepthDataOutput?
    private var pixelSize: Float32 = 0
    private var relativeArea : Int32 = 0
    
    var audioPlayer: AVAudioPlayer?

    
    override init() {
        self.processFrame = ProcessFrame()
        super.init()
        self.checkPermission()
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
        
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.permissionGranted = true
            
        case .notDetermined: // The user has not yet been asked for camera access.
            self.requestPermission()
            
            // Combine the two other cases into the default case
        default:
            self.permissionGranted = false
        }
    }
    
    func requestPermission() {
        // Strong reference not a problem here but might become one in the future.
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    
    
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        depthDataOutput = AVCaptureDepthDataOutput()
        guard permissionGranted else { return }
        
        let lidar = AVCaptureDevice.DeviceType.builtInLiDARDepthCamera
        let dualCamera = AVCaptureDevice.DeviceType.builtInDualCamera
        let dualWideCamera = AVCaptureDevice.DeviceType.builtInDualWideCamera
        
        // Create a discovery session to find devices of the specified type
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [lidar,dualWideCamera,dualCamera], mediaType: .video, position: .back)
        
        guard let backCamera = discoverySession.devices.first else {
            print("Unable to access back camera")
            return
        }
        cameraDevice = backCamera
        //guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        
        // otherwise our frame is displayed sideways on screen
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
        
        guard let depthDataOutput = depthDataOutput else {
            print("Failed to create AVCaptureDepthDataOutput")
            return
        }
        
        if captureSession.canAddOutput(depthDataOutput) {
            captureSession.addOutput(depthDataOutput)
            depthDataOutput.setDelegate(self, callbackQueue: DispatchQueue(label: "depthDataOutputQueue"))
        } else {
            print("Failed to add AVCaptureDepthDataOutput to capture session")
        }
        
        
        
        
        let path = Bundle.main.path(forResource: "320906__suzenako__ding6", ofType:"wav")
        let url = URL(fileURLWithPath: path!)
        do {
           if audioPlayer == nil {
           audioPlayer = try AVAudioPlayer(contentsOf: url)
           }
//           audioPlayer?.play()
        } catch let error {
           print(error.localizedDescription)
        }
        
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        // we uppdate the array with distancees until we have reached 10 distances in which it prints out the mean distance
        distanceArray.append(distance)
        
        if (distanceArray.count == 10) {
            
            let sum = distanceArray.reduce(0, +)
            let mean = sum / (10)
            distanceArray.removeAll() // Clear the Array
            
            // Update mean property
            DispatchQueue.main.async {
                self.meanvalue = Float(mean)
                
            }
        }
        self.processFrame.findObject(cgImage: cgImage) { [self] processedFrame in
            DispatchQueue.main.async {
                self.frame = processedFrame
            }
        }
    }
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Dropped frame")
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return cgImage
    }
    
    
    
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        // Extract the depth data map
        let depthData = (depthData as AVDepthData?)!.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32)
        let depthDataMap = depthData.depthDataMap
        
        DispatchQueue.main.async{
            self.distance = self.getDepthAtCenter(from: depthDataMap)!
        }
        // Calculate depth value at the center of the frame
        DispatchQueue.main.async{
            if let frame = self.frame { // Check if frame is not nil
                let uiImage = UIImage(cgImage: frame)
                self.pixelSize = getPixelSize(for: self.cameraDevice, with: uiImage, with: self.distance)
                self.relativeArea = OpenCVWrapper().centerArea(uiImage)
                calculateArea(pixelSize: self.pixelSize, relativeArea: self.relativeArea)
                calculateVolume()
            } else {
                // Handle the case where frame is nil
                print("Frame is nil. Unable to process.")
            }
        }
    }
    
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didDrop depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        print("Dropped depthFrame")
    }
    
    
    private func getDepthAtCenter(from depthDataMap: CVPixelBuffer) -> Float32? {
        // Lock the pixel buffer and get a pointer to its data
        CVPixelBufferLockBaseAddress(depthDataMap, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(depthDataMap, .readOnly) }
        
        // Get information about the pixel buffer
        let width = CVPixelBufferGetWidth(depthDataMap)
        let height = CVPixelBufferGetHeight(depthDataMap)
        
        // Get a pointer to the pixel data
        guard CVPixelBufferGetBaseAddress(depthDataMap) != nil else {
            print("Unable to get base address of the pixel buffer")
            return nil
        }
        
        // Calculate the center coordinates
        let square_x = 5
        let square_y = 5
        let x_init = width / 2 - square_x
        let y_init = height / 2 - square_y
        let x_end = width / 2 + square_x
        let y_end = height / 2 + square_y
        
        CVPixelBufferLockBaseAddress(depthDataMap, CVPixelBufferLockFlags(rawValue: 0))
        let depthPointer = unsafeBitCast(CVPixelBufferGetBaseAddress(depthDataMap), to: UnsafeMutablePointer<Float32>.self)
        
        var depthValues: [Float32] = []
        
        for x in stride(from: x_init, to: x_end, by: 1) {
            for y in stride(from: y_init, to: y_end, by: 1) {
                let depth = depthPointer[Int(width * y + x)]
                depthValues.append(depth)
            }
        }
        
        // Sort the depth values
        depthValues.sort()
        
        // Find the median
        let count = depthValues.count
        var median: Float32 = 0
        if count % 2 == 0 {
            // Even number of elements, average the two middle values
            let middleIndex1 = count / 2 - 1
            let middleIndex2 = count / 2
            median = (depthValues[middleIndex1] + depthValues[middleIndex2]) / 2
        } else {
            // Odd number of elements, take the middle value
            let middleIndex = count / 2
            median = depthValues[middleIndex]
        }
        distance = median
        
        
        return distance
    }
}
