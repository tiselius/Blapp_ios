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
                
                Text(showVolumeText ? "\(currentVolume * m3ToDl) dl" : "")
                        .padding(30)
                        .font(.custom("YuseiMagic-Regular", size: 20))
                        .foregroundColor(Color.white)
                        .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .offset(x: showVolumeText ? 0 : 1000)
            }

            //Buttons
            HStack(spacing: 20){
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
                
            }
        }
        .background(.white)
    }
    
    
}



