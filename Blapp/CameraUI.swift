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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack{
            if(!self.useReference){
                CameraView(frameHandler: frameHandler)
                    .frame(height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
            else{
                CameraViewReference(frameHandler: frameHandler)
                    .frame(height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }

            Text(showVolumeText ? "\(currentVolume) dl" : "")
                .padding(30)
                .foregroundColor(Color.white)
                .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                .cornerRadius(10)
                .shadow(radius: 2)
                .offset(x: showVolumeText ? 0 : 1000)
            
            //Buttons
            HStack(){
                Button(action: {
                    dismiss()
                }) {
                    Image("Return")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.black) // Set the color of the return button
                }
                .offset(x: -50, y: 10) // Adjust the offset to position the button
                Button(action: {
                    if(frameHandler.captureSession.isRunning){
                        frameHandler.captureSession.stopRunning()
                        
                        
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
                    Text("Get Volume")
                        .font(.custom("YuseiMagic-Regular", size: 20))
                        .padding()
                        .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .offset(x: -64)
            }
        }
        //        .background(.clear)
    }
}


