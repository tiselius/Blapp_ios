//
//  ContentView.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//

import UIKit
import AVFoundation
import SwiftUI

struct ContentView: View {
    let image = Image("Knapp")
    @State private var isCameraPresented = false
    
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
                            
                        }
            .padding(.top, 400)
        }
    }
}



#Preview {
    ContentView()
}
