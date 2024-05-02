//
//  TutorialView.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-30.
//

import Foundation
import SwiftUI

struct TutorialView: View {
    //@Binding var isPresented: Bool
    var body: some View {
        ZStack(){
            Image("Tutorial_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        
            
            VStack {
                Text("Slide 1!")
                    .font(.custom("YuseiMagic-Regular", size: 20))
                    .foregroundColor(.white)
                    .padding(20)
                
                Text("This is slide 1. You can describe the functions of your app here.")
                    .font(.custom("YuseiMagic-Regular", size: 10))
                    .foregroundColor(.white)
                    .padding()
                
                // Add more slides as needed
                
                Button("Close") {
                   // isPresented = false
                    
                }
                .foregroundColor(.white)
                .padding()
            }
            .frame(width: 300, height: 200)
            .background(Color(red: 1.0, green: 0.71, blue: 0.87))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.bottom, 200)
            
            Text("Tutorial")
                    .font(.custom("YuseiMagic-Regular", size: 36))
                    .foregroundColor(Color(red: 1.0, green: 0.71, blue: 0.87))
                    .padding(.bottom, 700) // Adjust the padding as needed
        }
        
    }
}

#Preview {
    TutorialView()
}
