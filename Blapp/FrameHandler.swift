



import AVFoundation
import CoreImage
import Combine
import UIKit


class FrameHandler: NSObject, ObservableObject, AVCaptureDepthDataOutputDelegate{
    @Published var frame: CGImage?
    @Published var distance: Float32 = 0// Add a published property for distance
    @Published var meanvalue: Float = 0.0// Add a published property for mean value
    @Published var area: Float32 = 0.0
    @Published private var useReference = UserDefaults.standard.bool(forKey: "useReference")
    var processedFrame : CGImage
    
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
    private let testImage = UIImage(named: "Knapp")
    private var isProcessingFrame = false
    private var processDepthDataOutput : Bool = true
    private let distanceArrayMaxAmount : Int = 10
    /*
     Used for calculating the depthdata
     */
    let height = 180 //temporary
    let width  = 320 //temporary
    let square_x = 5
    let square_y = 5
    let x_init : Int
    let y_init : Int
    let x_end : Int
    let y_end : Int
    
    override init() {
        self.processFrame = ProcessFrame()
        self.processedFrame = (testImage?.cgImage)!
        x_init = width / 2 - square_x
        y_init = height / 2 - square_y
        x_end = width / 2 + square_x
        y_end = height / 2 + square_y
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
        print(videoOutput)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        guard permissionGranted else { return }
        
        let lidar = AVCaptureDevice.DeviceType.builtInLiDARDepthCamera
        let dualCamera = AVCaptureDevice.DeviceType.builtInDualCamera
        let dualWideCamera = AVCaptureDevice.DeviceType.builtInDualWideCamera
        
        // Create a discovery session to find devices of the specified type
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [lidar,dualWideCamera,dualCamera], mediaType: .video, position: .back)
        
        if(discoverySession.devices.first != nil){
            cameraDevice = discoverySession.devices.first
            noDepthCameraAvailable = false
        }
        else{
            cameraDevice = AVCaptureDevice.default(for: .video)
            UserDefaults.standard.set(true, forKey: "usereference")
            noDepthCameraAvailable = true
        }

        guard cameraDevice != nil else{
            print("No suitable camera found.")
            return
        }
        if(useReference){cameraDevice = cameraDevice.constituentDevices.last} //Prevent ultra wide
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice) else{ return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        // otherwise our frame is displayed sideways on screen
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
        print("useReference = \(useReference)")
        if(!useReference){
        depthDataOutput = AVCaptureDepthDataOutput()
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
        }
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard !isProcessingFrame else {
            // Skip processing if a frame is already being processed
            return
        }
        
        isProcessingFrame = true
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard let cgImage = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
                self.isProcessingFrame = false
                return
            }
            
            let processedFrame = self.processFrame.findObject(cgImage: cgImage)
            
            DispatchQueue.main.async { [weak self] in
                self?.frame = processedFrame
                self?.isProcessingFrame = false
            }
        }
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Dropped frame")
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { print("no imagebuffer :(")
            return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {print("no cgImage :(")
            return nil }
        return cgImage
    }
    
    
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        if processDepthDataOutput == true { //Only calculate half of the depthData
            // Extract the depth data map
            let depthData = (depthData as AVDepthData?)!.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32)
            let depthDataMap = depthData.depthDataMap
            // Calculate depth value at the center of the frame
            DispatchQueue.main.async{
                self.distance = self.getDepthAtCenter(from: depthDataMap)!
            }
            //Calculate volume
            DispatchQueue.main.async{
                if let frame = self.frame { // Check if frame is not nil
                    let uiImage = UIImage(cgImage: frame) //WE CAN REMOVE SOME OF THESE
                    self.pixelSize = getPixelSize(for: self.cameraDevice, with: uiImage, with: self.distance)
                    relativeAreaOfObject = self.processFrame.findRelativeArea()
                    calculateArea(pixelSize: self.pixelSize, relativeArea: relativeAreaOfObject)
                    calculateVolume()
                } else {
                    // Handle the case where frame is nil
                    print("Frame is nil. Unable to process.")
                }
            }
            
            // Update the distance-array until we have reached distanceArrayMaxAmount distances in which it calculates the mean distance
            distanceArray.append(distance)
            if (distanceArray.count == distanceArrayMaxAmount) {
                let sum = distanceArray.reduce(0, +)
                let mean = sum / 10//Float(distanceArrayMaxAmount)
                distanceArray.removeAll() // Clear the Array
                // Update mean property
                DispatchQueue.main.async {
                    self.meanvalue = Float(mean)
                }
            }
            processDepthDataOutput.toggle() //Only calculate half of the depthData
        }
        else {
            processDepthDataOutput.toggle() //Only calculate half of the depthData
        }
        
    }
    
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didDrop depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        print("Dropped depthFrame")
    }
    
    
    private func getDepthAtCenter(from depthDataMap: CVPixelBuffer) -> Float32? {
        // Lock the pixel buffer and get a pointer to its data
        CVPixelBufferLockBaseAddress(depthDataMap, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(depthDataMap, .readOnly) }

        // Get a pointer to the pixel data
        guard CVPixelBufferGetBaseAddress(depthDataMap) != nil else {
            print("Unable to get base address of the pixel buffer")
            return nil
        }
        
        CVPixelBufferLockBaseAddress(depthDataMap, CVPixelBufferLockFlags(rawValue: 0))
        let depthPointer = unsafeBitCast(CVPixelBufferGetBaseAddress(depthDataMap), to: UnsafeMutablePointer<Float32>.self)
        
        var depthValues: [Float32] = []
        
        /*Calculate the depth at each pixel of the box 
         described by the dimensions of square_x and square_y
         */
        for x in stride(from: x_init, to: x_end, by: 1) {
            for y in stride(from: y_init, to: y_end, by: 1) {
                let depth = depthPointer[Int(self.width * y + x)]
                depthValues.append(depth)
            }
        }
        
        /* Sort the depth values */
        depthValues.sort()
        
        /* Find the median of all depth values in depthValues */
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
