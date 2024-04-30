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
    
    var body: some View {
        ZStack {
            // Background Gradient
            Image("Startpage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                
            VStack {
                
                    Button(action: {
                        self.isCameraPresented.toggle()
                            }) {
                                Image("Kamera")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75)
                                            }
                            .sheet(isPresented: $isCameraPresented) {
                                // Present the camera view when the flag is true
                                CameraUI()
                            
                            }
                            .padding(.top, 20)
                            
                        }
            .padding(.top, 400)
        }
    }
}



#Preview {
    StartPageUI()
}
