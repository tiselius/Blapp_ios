//
//  FrameHandler.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-18.
//

import AVFoundation
import CoreImage
import Combine
import UIKit


class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private var permissionGranted = true
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    private var processFrame : ProcessFrame
    //private var cameraDevice: AVCaptureDevice!
    
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
        let cameraDevice = backCamera
        //guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
    
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
    }
}


extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }

        self.processFrame.findObject(cgImage: cgImage) { processedFrame in
            DispatchQueue.main.async {
                self.frame = processedFrame
            }
           // print(" \(self.processFrame.getRealArea(cgImage: cgImage)) m")
        }
    }
        

    
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return cgImage
    }
    
//    public func getCameraDevice() -> AVCaptureDevice{
//        return self.cameraDevice
//    }
    
    public func getCurrentDepth() -> Double{
        //TODO
        return 0
    }
    
}
