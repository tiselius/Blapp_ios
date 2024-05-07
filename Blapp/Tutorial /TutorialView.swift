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
                        TutorialCards(title:"👁️")
                        TutorialCards(title:"🫦")
                        TutorialCards(title:"👁️")
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
                       }
                       .offset(x: -150, y: 370) // Adjust the offset to position the button
                   }
        }
}

struct TutorialCards: View{
    let title: String
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 200))
        }
        .frame(width:300, height: 300)
        .background(Color(red: 1.0, green: 0.71, blue: 0.87))
        .cornerRadius(25)
    }
}


