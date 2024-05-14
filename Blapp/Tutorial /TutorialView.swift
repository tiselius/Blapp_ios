//
//  TutorialView.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-30.
//

import Foundation
import SwiftUI

struct TutorialView: View {
   
@Binding var isPresented: Bool
    var body: some View {
        ZStack(){
            Image("Tutorial_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Tutorial")
                    .font(.custom("YuseiMagic-Regular", size: 30))
                    .foregroundColor(.black)
                    .offset(y: -120)
                    
                
                ScrollView(.horizontal) {
                    HStack(spacing:20) {
                        TutorialCards(title:"This is a liquid scanning app designed to estimate the spilled liquid on a flat surface area")
                        TutorialCards(title:"Using built in camera functions OR a reference object Spilled is a able to make an estimation")
                        TutorialCards(title:"LiDAR or dual camera technology can estimate the distance essenntial for the calculations needed to aquire the area")
                        TutorialCards(title: "With the focal length of the camera and distance the size of each pixel can be determined.")
                        TutorialCards(title: "Countour detection detect the amount of pixels the spilled area contains. With the pixelsize the area is determined")
                        TutorialCards(title: "If the properties of the liquid is known the height of the spilled liquid on flat surface can be calculated. When both height and area is know, volume can be estimated.")
                        TutorialCards(title: "Scan the spilled area with the device as parallel as possible to the surface for best results. The scanned liquid will be marked on the screen.")
                        TutorialCards(title: "The calulated volume is an esimation of the spilled liquid.")
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                }
                .background(Color.clear)
                .offset(y: -50)
            }
            Button(action: {
                isPresented = false
            }) {
                Image("Return")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.black) // Set the color of the return button
            }//Button
            .offset(x: -150, y: 370) // Adjust the offset top position the button
        }
    }
}

struct TutorialCards: View{
    let title: String
    var body: some View {
        VStack() {
            Text(title)
                .font(.system(size: 25))
                .frame(width: 250, height: 250, alignment: .topLeading)
                .foregroundColor(.white)
        }
        .frame(width:300, height: 300)
        .background(Color(red: 1.0, green: 0.71, blue: 0.87))
        .cornerRadius(25)
    }
}
//
//#Preview {
//    TutorialView()
//}
