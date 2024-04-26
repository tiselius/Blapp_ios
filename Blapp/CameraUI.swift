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
    @StateObject var frameHandler = FrameHandler()
    @State private var textOffset: CGFloat = 250
    @State private var showVolumeText = false // State variable to control text visibility

    
    
    
    var body: some View {
        VStack{
            
            ZStack{
                CameraView(frameHandler: frameHandler)
                    .frame(height: UIScreen.main.bounds.height * 0.8)
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
                
                Text(showVolumeText ? "\(currentVolume * m3ToDl) dl" : "")
                        .padding(30)
                        .font(.system(size: 20))
                        .foregroundColor(Color.yellow)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .offset(x: showVolumeText ? 0 : 1000)
            }

            //Buttons
            HStack(spacing: 20){
                Button(action: {
                    if(frameHandler.captureSession.isRunning){
                        frameHandler.captureSession.stopRunning()

                        frameHandler.audioPlayer?.play()
                        
                    } else {
                        frameHandler.sessionQueue.async{
                            frameHandler.captureSession.startRunning()
                        }
                    }
                    withAnimation(.easeIn) {
                        showVolumeText.toggle()
                    }
                }
                ) {
                    Text("Confirm here :)")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                //                Button(action: {
                //                    // Second button action
                //                }) {
                //                    Text("Water")
                //                        .padding()
                //                        .background(Color.blue)
                //                        .foregroundColor(.white)
                //                        .cornerRadius(10)
                //                }
                
                //                Button(action: {
                //                    // Third button action
                //                }) {
                //                    Text("Oil")
                //                        .padding()
                //                        .background(Color.black)
                //                        .foregroundColor(.white)
                //                        .cornerRadius(10)
                //                }
            }
        }
        
        //.padding() // Add padding to the outer VStack
        .background( LinearGradient(
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
        )) // Background color for the entire view
    }
    
    
}



