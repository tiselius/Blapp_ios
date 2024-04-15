//
//  CameraViewController.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//

import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    // Declare AVCaptureSession and AVCaptureVideoPreviewLayer variables
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new AVCaptureSession
        captureSession = AVCaptureSession()
        
        // Set the session preset to high to get the best quality
        captureSession.sessionPreset = .high
        
        // Get the back camera
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Unable to access back camera")
            return
        }
        
        do {
            // Create input for the back camera
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            // Add input to the capture session
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            // Create AVCaptureVideoPreviewLayer and add it to the view
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
            
            // Start the capture session
            captureSession.startRunning()
        } catch {
            print("Error setting up capture session: \(error.localizedDescription)")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.layer.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}
