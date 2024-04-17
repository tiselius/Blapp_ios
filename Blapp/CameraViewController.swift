//
//  CameraViewController.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//

import UIKit
import AVFoundation

protocol CaptureDataReceiver: AnyObject {
    func onNewData(capturedData: CameraCapturedData)
}


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureDataOutputSynchronizerDelegate {
    

    // AVCaptureSession and related variables
    var videoDataOutput : AVCaptureVideoDataOutput!
    var depthDataOutput : AVCaptureDepthDataOutput!
    var outputVideoSync : AVCaptureDataOutputSynchronizer!
    private let videoQueue = DispatchQueue(label: "VideoQueue", qos: .userInteractive)
    weak var delegate: CaptureDataReceiver?
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!
    var cameraDevice: AVCaptureDevice!
    var distanceLbl = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: 0, width: 200, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and configure the capture session
        setupCameraComponents()

        //initialisera och konfiguera preview layer
        setupPreviewLayer()
                
        // Add the capture button to the view
        setupCaptureButton()
        
        setupLabels()
        
    }

    func setupLabels(){
        distanceLbl.text = "test"
        distanceLbl.center = CGPoint(x: view.bounds.midX, y: 85)
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
        
        let deviceType = AVCaptureDevice.DeviceType.builtInLiDARDepthCamera
        print("device type is \(deviceType)")
        
        // Create a discovery session to find devices of the specified type
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [deviceType], mediaType: .video, position: .back)
        
        // Get the back camera from the discovered devices
        guard let backCamera = discoverySession.devices.first else {
            print("Unable to access lidar")
            return
        }
        cameraDevice = backCamera
        print("camera is \(cameraDevice!)")
        
        do {
            // Create an input for the back camera
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            // Add input to the capture session
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                print("Could not add input to the session")
                return
            }
            
            self.captureSession.commitConfiguration()

            
            // Create an object to output video sample buffers.
            videoDataOutput = AVCaptureVideoDataOutput()
            captureSession.addOutput(videoDataOutput)


            // Create an object to output depth data.
            depthDataOutput = AVCaptureDepthDataOutput()
           // depthDataOutput.isFilteringEnabled = isFilteringEnabled
            captureSession.addOutput(depthDataOutput)

            // Create an object to synchronize the delivery of depth and video data.
            outputVideoSync = AVCaptureDataOutputSynchronizer(dataOutputs: [depthDataOutput, videoDataOutput])
            outputVideoSync.setDelegate(self, queue: videoQueue)
            
            // Create an object to output photos.
            photoOutput = AVCapturePhotoOutput()
            photoOutput.maxPhotoQualityPrioritization = .quality
            captureSession.addOutput(photoOutput)


            // Enable delivery of depth data after adding the output to the capture session.
            photoOutput.isDepthDataDeliveryEnabled = true
            
            // Start the capture session
            captureSession.startRunning()
            print("captureSession started")
            
        } catch {
            print("Error setting up capture session: \(error)")
        }
    }

    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer,
                                didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        // Retrieve the synchronized depth and sample buffer container objects.
        guard let syncedDepthData = synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData,
              let syncedVideoData = synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData else { return }
        
        guard let pixelBuffer = syncedVideoData.sampleBuffer.imageBuffer,
              let cameraCalibrationData = syncedDepthData.depthData.cameraCalibrationData else { return }
        
        // Package the captured data.
        let data = CameraCapturedData(depth: syncedDepthData.depthData,cameraIntrinsics: cameraCalibrationData.intrinsicMatrix,
                                      cameraReferenceDimensions: cameraCalibrationData.intrinsicMatrixReferenceDimensions)
        delegate?.onNewData(capturedData: data)
 
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

        // Display the image in an ImageView
        DispatchQueue.main.async {
            let imageView = UIImageView(image: image)
            imageView.frame = self.view.bounds
            imageView.contentMode = .scaleAspectFit
            self.view.addSubview(imageView)
            self.view.bringSubviewToFront(imageView)
            print("image displayed")
            
            let point = 5 //ignore
            self.handlePhotoDepthCalculation(point : point,  photo: photo)
        }
    }
    
    func handlePhotoDepthCalculation(point : Int, photo: AVCapturePhoto) {

                
        //
        // Convert Disparity to Depth
        //
        let depthData = (photo.depthData as AVDepthData?)!.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32)
        let depthDataMap = depthData.depthDataMap //AVDepthData -> CVPixelBuffer
        
        let width = CVPixelBufferGetWidth(depthDataMap)
        let height = CVPixelBufferGetHeight(depthDataMap)
        let x = width / 2
        let y = height / 2

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
        let distanceAtXYPoint = depthPointer[Int(y * Int(CGFloat(width)) + x)]
        //
        // Set UI
        //
        let distanceAtXY = "\(distanceAtXYPoint) m" //Returns distance in meters?
        let isFiltered = "\(depthData.isDepthDataFiltered)"
        print("Distance to object at x = \(x), y = \(y) is \(distanceAtXY)")
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
    
    func onNewData(capturedData: CameraCapturedData) {
        videoQueue.async {
            /*
            if !self.processingCapturedResult {
                // Because the views hold a reference to `capturedData`, the app updates each texture separately.
                self.capturedData.depth = capturedData.depth
                self.capturedData.colorY = capturedData.colorY
                self.capturedData.colorCbCr = capturedData.colorCbCr
                self.capturedData.cameraIntrinsics = capturedData.cameraIntrinsics
                self.capturedData.cameraReferenceDimensions = capturedData.cameraReferenceDimensions
                if self.dataAvailable == false {
                    self.dataAvailable = true
                }
            }
            */
            let depthData = capturedData.depth
            let depthDataMap = depthData?.depthDataMap
            
            let square_x = 5
            let square_y = 5
            let width = CVPixelBufferGetWidth(depthDataMap!)
            let height = CVPixelBufferGetHeight(depthDataMap!)
            let x_init = width / 2 - square_x
            let y_init = height / 2 - square_y
            let x_end = width / 2 + square_x
            let y_end = height / 2 + square_y
            var x = x_init
            var y = y_init
            
            CVPixelBufferLockBaseAddress(depthDataMap!, CVPixelBufferLockFlags(rawValue: 0))
                    let depthPointer = unsafeBitCast(CVPixelBufferGetBaseAddress(depthDataMap!), to: UnsafeMutablePointer<Float32>.self)
            
            
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
                       //
                       // Set UI
                       //
                       //let distanceAtXY = "\(distanceAtXYPoint) m" //Returns distance in meters?
                       let distanceAtXY = "\(median) m"
            let isFiltered = "\(depthData!.isDepthDataFiltered)"
                       print("Distance to object at x = \(x), y = \(y) is \(distanceAtXY)")
                       print("isDepthDataFiltered = \(isFiltered)")
            self.distanceLbl.text = distanceAtXY
               }
        }
    }
    

/*
#Preview {
    CameraViewController()
}
*/

class CameraCapturedData {
    
    var depth: AVDepthData?
    var cameraIntrinsics: matrix_float3x3
    var cameraReferenceDimensions: CGSize

    init(depth: AVDepthData? = nil,
         cameraIntrinsics: matrix_float3x3 = matrix_float3x3(),
         cameraReferenceDimensions: CGSize = .zero) {
        
        self.depth = depth
        self.cameraIntrinsics = cameraIntrinsics
        self.cameraReferenceDimensions = cameraReferenceDimensions
    }
}
