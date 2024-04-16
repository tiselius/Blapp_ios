//
//  BlappApp.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // Update the view controller if needed
    }
}

@main
struct BlappApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
