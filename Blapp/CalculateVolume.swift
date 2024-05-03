//
//  CalculateVolume.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-25.
//

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
