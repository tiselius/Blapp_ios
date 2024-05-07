//
//  CameraView.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-18.
//

import SwiftUI



struct CameraViewReference: View {
    
    @StateObject var frameHandler : FrameHandler
    var image: CGImage?
    @State private var isLoading = true
    private let label = Text("frame")
    
    
    var body: some View {
        ZStack{
            if let image = frameHandler.frame {
                Image(image, scale: 1.0, orientation: .up, label: label)
                    .resizable()
                
            } else {
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1, green: 0.39, blue: 0.39),
                            Color(red: 1, green: 0.55, blue: 0.63),
                            Color(red: 1, green: 0.56, blue: 0.64),
                            Color(red: 1, green: 0.56, blue: 0.65),
                            Color(red: 1, green: 0.57, blue: 0.66),
                            Color(red: 1, green: 0.71, blue: 0.87)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                }
            }

        }
        .onTapGesture { location in
            touchY = Int32(location.y * (1920 / screenHeight))
            touchX = Int32(location.x * (1080 / screenWidth))
            frameHandler.captureSession.stopRunning()
            print("You touched me at x = \(String(describing: touchX)), y = \(String(describing: touchY))")

            referenceImage = getReferenceOverlay(image: frameHandler.frame!)
            let cgreference = referenceImage?.cgImage
            
            frameHandler.frame = cgreference

            relativeAreaOfObject = OpenCVWrapper().centerArea(referenceImage!)

            let referenceArea = getReferenceArea(image: frameHandler.frame!)
            let pixelSize = currentReference.area / Float(referenceArea)
            let finalArea = pixelSize * Float(relativeAreaOfObject)
            print(finalArea)
        }
    }
}