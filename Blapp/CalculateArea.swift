//
//  CalculateArea.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-25.
//

import Foundation
import SwiftUI
func calculateArea(pixelSize: Float32, relativeArea: Int32) -> Float32{
    return pixelSize * pixelSize * Float32(relativeArea)
}
