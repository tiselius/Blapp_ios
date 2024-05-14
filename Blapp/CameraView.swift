//
//  CameraView.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-18.
//

import SwiftUI



struct CameraView: View {
    @StateObject var frameHandler: FrameHandler
//    @State private var scale: CGFloat = 1.0 // Track the scale for zooming
    
    var body: some View {
        ZStack {
            if let image = frameHandler.frame {
                Image(uiImage: UIImage(cgImage: image))
                    .resizable()
                    .aspectRatio(contentMode: .fit) //.fit gör att den visar hela bilden. Den går inte utanför sin "box" och den stretchas inte.
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                // Update the scale based on the pinch gesture
                                scale = value.magnitude >= 1 ? value.magnitude : 1
                                
                            }
                    )
            } else {
                // Placeholder view if frame is not available
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
        .onAppear {
            scale = 1.0
        }
//        .edgesIgnoringSafeArea(.all)
    }
}
