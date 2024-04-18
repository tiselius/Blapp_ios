//
//  CameraViewController.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    // AVCaptureSession and related variables
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!
    let depthDataOutput = AVCaptureDepthDataOutput()
    var cameraDevice: AVCaptureDevice!
    var distanceLbl = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: 0, width: UIScreen.main.bounds.width, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and configure the capture session
        setupCameraComponents()
        
        //initialisera och konfiguera preview layer
        setupPreviewLayer()
        
        setupDepth()
        
        // Add the capture button to the view
        setupCaptureButton()
        
        setupLabels()
        
        print("\(OpenCVWrapper.getOpenCVVersion())")
    }
    
    func setupDepth(){
        
        //setup depth stuff
        captureSession.addOutput(depthDataOutput)
        depthDataOutput.isFilteringEnabled = true
        if let connection = depthDataOutput.connection(with: .depthData) {
            connection.isEnabled = true
        } else {
            print("No AVCaptureConnection")
        }
        photoOutput.isDepthDataDeliveryEnabled = true
        let depthFormats = cameraDevice.activeFormat.supportedDepthDataFormats
        
        print(depthFormats)
    }
    func setupLabels(){
        distanceLbl.text = "test"
        distanceLbl.center = CGPoint(x: view.bounds.midX, y: 55)
        distanceLbl.textAlignment = .center
        view.addSubview(distanceLbl)
        view.bringSubviewToFront(distanceLbl)
    }
    
    func setupPreviewLayer(){
        // Create AVCaptureVideoPreviewLayer and add it to the view
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        print("Preview layer loaded")
    }
    
    func setupCameraComponents() {
        // Create a new AVCaptureSession
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        let lidar = AVCaptureDevice.DeviceType.builtInLiDARDepthCamera
        let dualCamera = AVCaptureDevice.DeviceType.builtInDualCamera
        let dualWideCamera = AVCaptureDevice.DeviceType.builtInDualWideCamera
        
        // Create a discovery session to find devices of the specified type
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [lidar,dualWideCamera,dualCamera], mediaType: .video, position: .back)
        
        
        guard let backCamera = discoverySession.devices.first else {
            
            // If not dual camera is available, try to get the front facing camera with truedepth as a last resort. If it does not have one, throw error.
            guard let frontCamera = try? getFrontFacing() else {
                print("Error: Unable to get front-facing camera")
                return
            }
            cameraDevice = frontCamera
            return
        }

        cameraDevice = backCamera
        print("Camera is \(String(describing: cameraDevice))")
        
        do {
            // Create an input for the back camera
            let input = try AVCaptureDeviceInput(device: cameraDevice)
            
            // Add input to the capture session
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                print("Could not add input to the session")
                return
            }
            
            // Set up photo output for depth data capture.
            self.photoOutput = AVCapturePhotoOutput()
            guard self.captureSession.canAddOutput(photoOutput)
            else { fatalError("Can't add photo output.") }
            self.captureSession.addOutput(photoOutput)
            self.captureSession.sessionPreset = .photo
            
            
            self.captureSession.commitConfiguration()
            
            // Start the capture session
            captureSession.startRunning()
            print("captureSession started")
            
        } catch {
            print("Error setting up capture session: \(error)")
        }
    }
    enum CameraError: Error {
        case noDepthCapturingCameraAvailable
    }

    func getFrontFacing() throws -> AVCaptureDevice {
        let trueDepth = AVCaptureDevice.DeviceType.builtInTrueDepthCamera
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [trueDepth], mediaType: .video, position: .front)
        
        guard let backCamera = discoverySession.devices.first else {
            throw CameraError.noDepthCapturingCameraAvailable
        }
        
        return backCamera
    }
    func setupCaptureButton() {
        let captureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35
        captureButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.height - 85)
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.addSubview(captureButton)
        view.bringSubviewToFront(captureButton)
        print("button added")
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.isDepthDataDeliveryEnabled = true
        settings.flashMode = .auto  // Adjust flash settings as needed
        
        // Capture the photo with the specified settings and delegate
        photoOutput.capturePhoto(with: settings, delegate: self)
        
        print("Photo captured")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            print("Could not get image data")
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            print("Could not create image from data")
            return
        }
        
        //Get depth
        DispatchQueue.main.async {
            self.handlePhotoDepthCalculation(photo: photo)
            
        }
        DispatchQueue.main.async {
            self.getOpenCVData(image: image)
            
        }
    }
    
    func getOpenCVData(image: UIImage) {
        let newImage = OpenCVWrapper().identifyObject(image)
        guard
            let landscapeCGImage = newImage.cgImage
        else { return }
        let portraitImage = UIImage(cgImage: landscapeCGImage, scale: newImage.scale, orientation: .right)
        DispatchQueue.main.async {
            let imageView2 = UIImageView(image: portraitImage)
            imageView2.frame = self.view.bounds
            imageView2.contentMode = .scaleAspectFit
            self.view.addSubview(imageView2)
            self.view.bringSubviewToFront(imageView2)
            print("image displayed")
        }
    }
    
    func handlePhotoDepthCalculation(photo: AVCapturePhoto) {
        //
        // Convert Disparity to Depth
        //
        let depthData = (photo.depthData as AVDepthData?)!.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32)
        let depthDataMap = depthData.depthDataMap //AVDepthData -> CVPixelBuffer
        
        let square_x = 5
        let square_y = 5
        let width = CVPixelBufferGetWidth(depthDataMap)
        let height = CVPixelBufferGetHeight(depthDataMap)
        let x_init = width / 2 - square_x
        let y_init = height / 2 - square_y
        let x_end = width / 2 + square_x
        let y_end = height / 2 + square_y
        print("x init = \(x_init), x end = \(x_end), y init = \(y_init), y end = \(y_end)")
        print("max width = \(width), max height = \(height)")
        //
        // Set Accuracy feedback
        //
        let accuracy = depthData.depthDataAccuracy
        let quality = depthData.depthDataQuality
        print("Quality is \(quality)")
        switch (accuracy) {
        case .absolute:
            /*
             NOTE - Values within the depth map are absolutely
             accurate within the physical world.
             */
            print("Accuracy is absolute")
            break
        case .relative:
            /*
             NOTE - Values within the depth data map are usable for
             foreground/background separation, but are not absolutely
             accurate in the physical world. iPhone always produces this.
             */
            print("Accuracy is relative")
        @unknown default:
            print("Accuracy is unknown")
        }
        //
        // We convert the data
        //
        CVPixelBufferLockBaseAddress(depthDataMap, CVPixelBufferLockFlags(rawValue: 0))
        let depthPointer = unsafeBitCast(CVPixelBufferGetBaseAddress(depthDataMap), to: UnsafeMutablePointer<Float32>.self)
        
        //
        // Get depth value for image center
        //
        /*
         var distanceTotal : Float32
         distanceTotal = 0
         
         for x in stride(from: x_init, to: x_end, by: 1){
         for y in stride(from: y_init, to: y_end, by: 1){
         distanceTotal +=  depthPointer[Int(width * y + x)]
         print(distanceTotal)
         }
         }
         let distance = distanceTotal / Float((x_end - x_init) * (y_end - y_init))
         */
        
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
        
        print("Median depth: \(median)")
        
        let distanceAtXY = "\(median) m"
        let isFiltered = "\(depthData.isDepthDataFiltered)"
        print("Distance to object at center is \(distanceAtXY)")
        print("isDepthDataFiltered = \(isFiltered)")
        distanceLbl.text = distanceAtXY
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    
}
/*
 #Preview {
 CameraViewController()
 }
 */
