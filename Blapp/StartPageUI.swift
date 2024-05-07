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
//    @StateObject var frameHandler = FrameHandler()
    @State private var isCameraPresented = false
    @State private var isShowingTutorial = false
    @State private var isSettingsViewPresented = false

    var body: some View {
        ZStack {
            // Background Gradient
            Image("Startpage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: -30) {
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
                    CameraUI(frameHandler: FrameHandler())
                }
                .padding(.top, 100)
                HStack(spacing: 60){
                    Button(action: {self.isShowingTutorial = true
                    }){
                        Image("Tutorial")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                    }
                    .sheet(isPresented: $isShowingTutorial) {
                        TutorialView(isPresented: $isShowingTutorial)
                    }
                    .padding(40)
                    Button(action: {isSettingsViewPresented.toggle()
                    }){
                        Image("Settings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                    }
                    .fullScreenCover(isPresented: $isSettingsViewPresented) {
                        // Present the camera view when the flag is true
                        SettingsView()
                    }
                    .padding(40)
                }
                .padding(.bottom,40)
            }
            .padding(.bottom, -120)
            .padding(.top, 400)
        }
    }
}


#Preview {
    StartPageUI()
}
