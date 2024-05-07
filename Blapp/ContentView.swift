//
//  CameraView.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-18.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = FrameHandler()
    
    var body: some View {
    
        FrameView(image: model.frame)
                        //.frame(height: UIScreen.main.bounds.height * 0.8)
                        .aspectRatio(contentMode: .fit) // Ensure the image fits within the frame

        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
