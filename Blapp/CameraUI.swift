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
        VStack(alignment: .center){
            ZStack{
                if(!self.useReference){
                    CameraView(frameHandler: frameHandler)
                        .frame(height: UIScreen.main.bounds.height*0.85)
                        .clipShape(.rect(
                            topLeadingRadius: 40,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 40
                        ))
//                        .ignoresSafeArea()
                }
                else{
                    CameraViewReference(frameHandler: frameHandler)
                        .frame(height: UIScreen.main.bounds.height*0.85)
                        .clipShape(.rect(
                            topLeadingRadius: 40,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 40
                        ))
                }
                Text("\(frameHandler.distance) m")
                    .padding(8)
                    .foregroundColor(Color.white)
                    .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .offset(y: -320)
            }  //Zstack
            .padding(-50)
            .offset(y: -10)
            HStack(){
                Button(action: {
                    dismiss()
                }) {
                    Image("Return")
                        .resizable()
                        .frame(width: 80, height: 80)
//                        .foregroundColor(.black) // Set the color of the return button
                }
                .offset(y: 10)// Adjust the offset to position the button
                Spacer()
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
                }//Button
                .offset(x: 3)
                Spacer()
                Spacer()
                Spacer()
            }//Hstack
            .offset(y:30)
        }//Vstack
        .offset(y:20)
    } //View
    
}//Struct


