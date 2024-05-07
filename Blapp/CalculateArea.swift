//
//  CalculateArea.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-25.
//
var currentArea : Float = 0

import Foundation
import SwiftUI
func calculateArea(pixelSize: Float32, relativeArea: Int32) {
    currentArea = pixelSize * pixelSize * Float32(relativeArea)
}
