//
//  CameraUI.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-17.
//

import UIKit
import AVFoundation
import SwiftUI

struct CameraUI: View {
    @StateObject var frameHandler : FrameHandler
    @State private var textOffset: CGFloat = 250
    @State private var showVolumeText = false // State variable to control text visibility
    @State private var useReference = UserDefaults.standard.bool(forKey: "useReference")
    @State private var showVolumeSelection = false // State variable to control volume selection view visibility
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
            VStack {
                ZStack {
                    if (!self.useReference) {
                        CameraView(frameHandler: frameHandler)
                            .frame(height: UIScreen.main.bounds.height * 0.8)
                    } else {
                        CameraViewReference(frameHandler: frameHandler)
                            .frame(height: UIScreen.main.bounds.height * 0.8)
                    }
                  
                    Rectangle()
                        .strokeBorder(LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1, green: 0.39, blue: 0.39),
                                Color(red: 1, green: 0.55, blue: 0.63),
                                Color(red: 1, green: 0.56, blue: 0.64),
                                Color(red: 1, green: 0.56, blue: 0.65),
                                Color(red: 1, green: 0.57, blue: 0.66)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ), lineWidth: 3)
                    
                    
                }

                // Buttons
                HStack(spacing: 20) {
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image("Return")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.black) // Set the color of the return button
                    }
                    .offset(x: -10, y:-200 ) // Adjust the offset to position the button
                    
                    
                    
                    
                    // Button to get volume
                    Button(action: {
                        // Perform logic to obtain current volume from camera
                        
                        
                  if(frameHandler.captureSession.isRunning){
                     frameHandler.captureSession.stopRunning()
                     } else {frameHandler.sessionQueue.async{
                     frameHandler.captureSession.startRunning()
                          }
                }
                        
                withAnimation(.easeIn) {
                         showVolumeText.toggle()
                    }
                        
                        
                        
                        // For now, setting a placeholder value
                        // Show the volume selection view
                        showVolumeSelection = true
                    }) {
                        Text("Get Volume")
                            .font(.custom("YuseiMagic-Regular", size: 20))
                            .padding()
                            .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .background(.white)
            .sheet(isPresented: $showVolumeSelection) {
                // Volume selection view
                GeometryReader { geometry in
                    ZStack {
                        Color(red: 1, green: 0.49, blue: 0.53)
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Text("Volume Selection View")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                            // Display the current volume
                            Text("Current Volume: \(currentVolume) dl")
                                .foregroundColor(.white)
                                .padding()
                            // You can add more content to this view as needed
                           
                            // Display the current distance
                            Text("Current distance: \(frameHandler.meanvalue) meters")
                                .foregroundColor(.white)
                                .padding()
                            // You can add more content to this view as needed
                            
                        
                        }
                    }
                }.presentationDetents([.height(200)])
            }
        }
}
