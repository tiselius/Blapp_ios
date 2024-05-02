//
//  AboutUsView.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-30.
//


import SwiftUI
import UIKit

struct AboutUsView: View {
    
    var body: some View {
        ZStack(){
            Image("AboutUs_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("About Us")
                    .font(.custom("YuseiMagic-Regular", size: 30))
                    .foregroundColor(.black)
                    .offset(y: -120)
                ZStack{
                    Text("")
                        .font(.custom("YuseiMagic-Regular", size: 20))
                        .foregroundColor(.white)
                        .frame(width:350, height: 300)
                        .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                        .cornerRadius(25)
                        .offset(y: -120)
                    Text("This App is made by those who made it. The ones who made it keep it. ")
                        .font(.custom("YuseiMagic-Regular", size: 20))
                        .foregroundColor(.white)
                        .frame(width:325, height: 300)
                        .background(.clear)
                        .cornerRadius(25)
                        .offset(y: -120)
                }//ZStack
            }
        }//ZStack
    }//Body
}//Struct


#Preview {
    AboutUsView()
}


