//
//  ContourDetectionView.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-22.
//

import SwiftUI
import Vision

struct ContourDetectionView: View {
    @ObservedObject var frameHandler: FrameHandler
    
    var body: some View {
        if let frame = frameHandler.frame {
            Image(uiImage: UIImage(cgImage: frame))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onAppear {
                    detectContours(cgImage: frame)
                }
        } else {
            Text("No frame available")
        }
    }
    
    private func detectContours(cgImage: CGImage) {
        let ciImage = CIImage(cgImage: cgImage)
        let request = VNDetectContoursRequest()
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try handler.perform([request])
            
            guard let observations = request.results else {
                return
            }
            
            // Process contour observations here
        } catch {
            print("Error detecting contours: \(error)")
        }
    }
}

