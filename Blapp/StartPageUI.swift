//
//  StartPageUI.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//  Edited alot by Peter Byström after
//

import UIKit
import AVFoundation
import SwiftUI

struct StartPageUI: View {
    let image = Image("Knapp")
    @State private var isCameraPresented = false
    @State private var isSettingsPresented = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            Rectangle()
                .foregroundColor(.clear)
                .background(
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
                )
                .edgesIgnoringSafeArea(.all) // Adjust for safe area insets
            
            // Text
            Text(" Spilled   ")
                .font(Font.custom("Mervale Script", size: 121))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
                .frame(width: 700, height: 300, alignment: .center)
                .padding()
                .offset(y: -200)
            
            VStack {
                
                Button(action: {
                    self.isCameraPresented.toggle()
                }) {
                    Image("Knapp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                }
                .sheet(isPresented: $isCameraPresented) {
                    // Present the camera view when the flag is true
                    CameraUI()
                    
                }
                Button(action: {
                    self.isSettingsPresented.toggle()
                }) {
                    Image("questionMark")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40) // Adjust the size as needed
                        .padding()
                        .clipShape(Circle())
                }
                .sheet(isPresented: $isSettingsPresented) {
                    // Present the camera view when the flag is true
                    SettingsView()
                }
                .offset(x: -155, y: 370)
            }
            .padding(.top, 400)
        }
    }
}



#Preview {
    StartPageUI()
}
