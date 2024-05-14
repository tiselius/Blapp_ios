//
//  LiquidManager.swift
//  SpilledUITest
//
//  Created by Aron Tiselius on 2024-04-30.
//

import Foundation

class LiquidManager: ObservableObject {
    static let shared = LiquidManager() // Singleton instance
    
    @Published var liquids: [Liquid] = [
        Liquid(name: "Blood",surfaceTension: surfaceTensionOfBlood, density: densityOfBlood, removeable: false, image: "Blood_Liquid" ),
        Liquid(name: "Water", surfaceTension: surfaceTensionOfWater, density: densityOfWater, removeable: false,image: "Water_Liquid" ),
        Liquid(name: "Cola", surfaceTension: surfaceTensionOfCoke, density: densityOfCoke, removeable: false,image: "Water_Liquid")
    ]
    
    private init() {} // Private initializer to enforce singleton
    
    func addLiquid(_ liquid: Liquid) {
        liquids.append(liquid)
    }
    
    func removeLiquid(_ Liquid: Liquid){
        if let index = liquids.firstIndex(of: Liquid) {
            liquids.remove(at: index)
        }
    }
    
    func nameExists(liquidName: String) -> Bool{
        var nameExists = false
        for ref in liquids {
            if ref.name == liquidName{
                nameExists = true
            }
        }
        return nameExists
    }
    
}
