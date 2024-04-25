//
//  PixelSize.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-25.
//

import Foundation
import AVFoundation
import SwiftUI

func getPixelSize(for cameraDevice: AVCaptureDevice, with photo : UIImage, with currentDepth : Float32) -> (Float32){
        // Get the focal length
        let fieldOfViewDegrees = cameraDevice.activeFormat.videoFieldOfView // in degrees
        let fieldOfViewRadians = fieldOfViewDegrees * Float32.pi / 180
        
        // Adjust for wide field of view
        let adjustedFieldOfViewRadians = fieldOfViewRadians > Float32.pi / 2 ? Float32.pi - fieldOfViewRadians : fieldOfViewRadians
        
        let realWorldWidth = Float32(tan(Float32(adjustedFieldOfViewRadians) / 2)) * Float32(currentDepth) * 2
        let imageWidth = Float32(photo.size.height) * Float32(photo.scale)
        let pixelSize = Float32(realWorldWidth / imageWidth)
return pixelSize
}
