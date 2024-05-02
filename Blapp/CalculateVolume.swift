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
let surfaceTensionBlood : Float = 0.0728 //Newton per meter
let densityBlood : Float = 997 //kg / m^3
let gravity : Float = 9.82

func calculateVolume() {
    let innerArg = surfaceTensionBlood / (densityBlood * gravity )
    let depth = 2 * Float.squareRoot(innerArg)()
    currentVolume = depth * currentArea
}
