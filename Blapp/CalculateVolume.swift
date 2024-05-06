//
//  CalculateVolume.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-25.
//

var currentVolumeDL : Float = 0
var currentVolume : Float = 0

import Foundation
/*
                         Surface Tension
 Depth = 2 * root of ( -------------------  )
                        Density * Gravity             */
//let surfaceTensionBlood : Float = 0.058 //Newton per meter
//let densityBlood : Float = 1060 //kg / m^3
let gravity : Double = 9.82

func calculateVolume() {
    let innerArg = surfaceTensionOfCurrentLiquid / (densityOfCurrentLiquid * gravity )
    let depth = 2 * Double.squareRoot(innerArg)()
    currentVolume = Float(depth) * currentArea
}

func calculateVolume2(area: Float) -> Float {
    let innerArg = surfaceTensionOfCurrentLiquid / (densityOfCurrentLiquid * gravity)
    let depth = 2 * Double.squareRoot(innerArg)()
    let volumeInDeciliters = Float(depth) * area
    
    switch selectedVolumeUnit {
    case .deciliters:
        return volumeInDeciliters
    case .ounces:
        return volumeInDeciliters / 0.295735296 // Conversion factor from deciliters to ounces
    }
}



//func calculateVolume2(area: Float) -> Float {
  //  let innerArg = surfaceTensionOfCurrentLiquid / (densityOfCurrentLiquid * gravity )
    //let depth = 2 * Double.squareRoot(innerArg)()
    //currentVolume = Float(depth) * area
    //return currentVolume
//}
