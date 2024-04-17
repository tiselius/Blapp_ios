//
//  CameraUI.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-17.
//

import SwiftUI

struct CameraUI: View {
    var body: some View {
        
        VStack{
            
            ZStack{
                CameraView()
                    .frame(height: UIScreen.main.bounds.height*0.7)
                
                Rectangle()
                    .strokeBorder(LinearGradient(
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
                        ), lineWidth: 2)
                    .padding(2)
            }
            //Buttons
            HStack(spacing: 20){
                Button(action: {
                        // First button action
                }) {
                    Text("Blood")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                            
                Button(action: {
                        // Second button action
                }) {
                    Text("Water")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                            
                    Button(action: {
                        // Third button action
                    }) {
                        Text("Oil")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    // Camera Button
                    Button(action: {
                            // Take photo action
                    }) {
                        Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20) // Add spacing between buttons and camera button
                    }
                    .padding() // Add padding to the outer VStack
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
