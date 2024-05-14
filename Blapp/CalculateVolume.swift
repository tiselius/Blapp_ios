//
//  CalculateVolume.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-25.
//

var currentVolumeDL : Float = 0
var currentVolume : Float = 0
var volumeInDeciliters: Float = 0

import Foundation
/*
                         Surface Tension
 Depth = 2 * root of ( -------------------  )
                        Density * Gravity             */
//let surfaceTensionBlood : Float = 0.058 //Newton per meter
//let densityBlood : Float = 1060 //kg / m^3
let gravity : Double = 9.82


// Create a variable to hold the current selected volume unit
var selectedVolumeUnit: VolumeUnit = {
    if let savedUnitString = UserDefaults.standard.string(forKey: "selectedVolumeUnit"),
       let savedUnit = VolumeUnit(rawValue: savedUnitString) {
        return savedUnit
    } else {
        return .metric // Default to deciliters if no saved unit found
    }
}()

// Update UserDefaults when the selected volume unit changes
func updateSelectedVolumeUnit(_ unit: VolumeUnit) {
    UserDefaults.standard.set(unit.rawValue, forKey: "selectedVolumeUnit")
}

// Update the volume calculation functions to use the selected volume unit
func calculateVolume() {
    let innerArg = (surfaceTensionOfCurrentLiquid / (densityOfCurrentLiquid * gravity)) * (1-cos(75 * .pi / 180))
    let depth = Double.squareRoot(2 * innerArg)()
    let volumeInDeciliters = Float32(depth) * currentArea * m3ToDl
    
    switch selectedVolumeUnit {
    case .metric:
        currentVolume = volumeInDeciliters
    case .imperial:
        currentVolume = volumeInDeciliters / 0.295735296 // Conversion factor from deciliters to ounces
    }
}

func calculateVolume2(area: Float) -> Float {
    let innerArg = surfaceTensionOfCurrentLiquid / (densityOfCurrentLiquid * gravity)
    let depth = 2 * Double.squareRoot(innerArg)()
    let volumeInDeciliters = Float(depth) * area * m3ToDl
    
    switch selectedVolumeUnit {
    case .metric:
        currentVolume = volumeInDeciliters
    case .imperial:
        currentVolume = volumeInDeciliters / 0.295735296 // Conversion factor from deciliters to ounces
    }
    return currentVolume
}
