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
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                    .offset(y: -120)
                ZStack{
                    Text("")
                        .foregroundColor(.white)
                        .frame(width:350, height: 300)
                        .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                        .cornerRadius(25)
                        .offset(y: -120)
                    Text("This App was made as a project in the II1305 course at KTH during spring 2024. Eight students from the Degree programme in information technology made this app.")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .frame(width:325, height: 300)
                        .background(.clear)
                        .cornerRadius(25)
                        .offset(y: -120)
                }//ZStack
                Link("Link to website", destination: URL(string:"https://spilledowner.wixsite.com/spilled")!)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width:325, height: 50)
                        .background(Color(red: 255.0/255.0, green: 124.0/255.0, blue: 136.0/255.0))
                        .cornerRadius(25)
                        .offset(y: -120)
                        .padding(.bottom,20)
                
                
            }//VStack
        }//ZStack
    }//Body
}//Struct


#Preview {
    AboutUsView()
}


