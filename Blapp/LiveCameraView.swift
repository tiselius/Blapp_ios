//
//  LiveCameraView.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-18.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    @State private var isLoading = true
    private let label = Text("frame")
    
    var body: some View {
    
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
                .resizable()
                
        } else {
            GeometryReader { geometry in
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
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
