//
//  CameraViewController.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//

import UIKit
import AVFoundation
import SwiftUI

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    // AVCaptureSession and related variables
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: AVCapturePhotoCaptureDelegate?
    var Output: AVCapturePhotoOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and configure the capture session and preview layer
        setupCameraComponents()

        // Add the capture button to the view
        //setupCaptureButton()
    
    }

    func setupCaptureButton() {
            let captureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            captureButton.backgroundColor = .white
            captureButton.layer.cornerRadius = 35
            captureButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.height - 280)
            captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
            view.addSubview(captureButton)
            view.bringSubviewToFront(captureButton)
        }
    func setupCameraComponents() {
        // Create a new AVCaptureSession
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        // Set up the camera
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera")
            return
        }
        
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

            // Initialize photoOutput and add it to the session
            Output = AVCapturePhotoOutput()
            if captureSession.canAddOutput(Output) {
                captureSession.addOutput(Output)
            } else {
                print("Could not add photo output to the session")
                return
            }
            
            // Create AVCaptureVideoPreviewLayer and add it to the view
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            
            // Start the capture session
            captureSession.startRunning()
        } catch {
            print("Error setting up capture session: \(error)")
        }
    }

    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto  // Adjust flash settings as needed
        Output.capturePhoto(with: settings, delegate: self)
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
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Check if previewLayer is nil or not
        if let previewLayer = previewLayer {
            // If previewLayer is not nil, set its frame
            previewLayer.frame = view.bounds
        } else {
            // If previewLayer is nil, print a message to indicate the issue
            print("Preview layer is nil")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}
