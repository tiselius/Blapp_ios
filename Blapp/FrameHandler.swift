



import AVFoundation
import CoreImage
import Combine

class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    @Published var distance: Float = 0.0 // Add a published property for distance
    @Published var meanvalue: Float = 0.0// Add a published property for mean value
    
    private var distanceArray = [2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2] // Array to store distances , Vi testar den genom att sätta in 9 st element och ser ifall array töms efter 10 då mean value då kommer ändras ifrån 2.98

    
    private var permissionGranted = true
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()

    override init() {
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
        guard permissionGranted else { return }
        var cameraDevice: AVCaptureDevice!

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
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }

        
    // Perform distance calculation (delegate)
        let distance = calculateDistance(sampleBuffer: sampleBuffer)

        
      // we uppdate the array with distancees until we have reached 10 distances in which it prints out the mean distance
        distanceArray.append(Double(distance))
        
        if (distanceArray.count == 10) {
            
            let sum = distanceArray.reduce(0, +)
            let mean = sum / Double(distanceArray.count)
            distanceArray.removeAll() // Clear the Array
           
            // Update mean property
            DispatchQueue.main.async {
            self.meanvalue = Float(mean)
            print("Current mean value: \(self.meanvalue)") // Print current mean
                   }
               }
    
    // All UI updates should be performed on the main queue.
        DispatchQueue.main.async {
            self.frame = cgImage
        }
        
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return cgImage
    }
    
    private func calculateDistance(sampleBuffer: CMSampleBuffer) -> Float {
        // Implement your distance calculation logic here
        // You can access the depth data from the sample buffer and perform the calculation
        
//--------------kod för att mäta djup---------------------------------------------------------------------
        
        
  
//---------------------------------------------------------------------------------------------------------
        
       // print("done")
        
        return 10 // Dummy value for demonstration
    }
   }
