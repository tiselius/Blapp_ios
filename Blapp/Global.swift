//
//  Global.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-29.
//

import Foundation

//Variables
var touchX : Int32?
var touchY : Int32?
var referenceImage : UIImage?
let referenceAreaReal : Float = 0.00461488
var relativeAreaOfObject : Int32 = 0

//Constants
let m3ToDl : Float = 10000
let surfaceTensionOfBlood = 3.1
let densityOfBlood = 2.1
let surfaceTensionOfWater = 3.0
let densityOfWater = 2.2
let surfaceTensionOfLiquidLava = 3.123
let densityOfLiquidLava = 2.123


var currentLiquid : String = "Blood"
var currentLanguage : String = "Svenska"
var currentReference: Reference = {
    if let savedReferenceOption = UserDefaults.standard.string(forKey: "selectedReferenceOption"),
       let index = referenceManager.references.firstIndex(where: { $0.id.uuidString == savedReferenceOption }) {
        return referenceManager.references[index]
    } else {
        return referenceManager.references[0]
    }
}()
var densityOfCurrentLiquid = 0.5
var surfaceTensionOfCurrentLiquid = 1.2

//Structs

struct Reference : Identifiable, Equatable {
    let id = UUID()
    let name : String
    let image : String
    let area : Float
    let removeable : Bool
}

//Flags
var useReference : Bool = UserDefaults.standard.bool(forKey: "useReference")
var noDepthCameraAvailable : Bool = false

//Managers
var referenceManager = ReferenceManager.shared

//Functions

// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height * 0.8
}

func applyLiquidSetting(for option: String) {
    UserDefaults.standard.set(option, forKey: "selectedLiquidOption")
    switch option {
    case "Blood":
        surfaceTensionOfCurrentLiquid = surfaceTensionOfBlood
        densityOfCurrentLiquid = surfaceTensionOfBlood
        currentLiquid = option
        break
    case "Water":
        surfaceTensionOfCurrentLiquid = surfaceTensionOfWater
        densityOfCurrentLiquid = surfaceTensionOfWater
        currentLiquid = option
        break
    case "Liquid Lava":
        surfaceTensionOfCurrentLiquid = surfaceTensionOfLiquidLava
        densityOfCurrentLiquid = surfaceTensionOfLiquidLava
        currentLiquid = option
        break
    default:
        break
    }
}


func applyLanguageSetting(for option: String) {
    UserDefaults.standard.set(option, forKey: "selectedLanguageOption")
    switch option {
    case "Svenska":
        currentLanguage = "Svenska"
        break
    case "English":
        currentLanguage = "English"
        break
    case "Rastafarian":
        currentLanguage = "Rastafarian"
        break
    default:
        break
    }
}

func applyReferenceSetting(for reference: Reference) {
    UserDefaults.standard.set(reference.name, forKey: "selectedReferenceOption")
    switch reference {
    case referenceManager.references[0]:
        currentReference = referenceManager.references[0]
        print("reference is \(currentReference.name)")
        break
    case referenceManager.references[1]:
        currentReference = referenceManager.references[1]
        print("reference is \(currentReference.name)")
        break
    case referenceManager.references[2]:
        currentReference = referenceManager.references[2]
        print("reference is \(currentReference.name)")
        break
    case referenceManager.references[3]:
        currentReference = referenceManager.references[3]
        print("reference is \(currentReference.name)")
        break
    case referenceManager.references[4]:
        currentReference = referenceManager.references[4]
        print("reference is \(currentReference.name)")
        break
    default:
        break
    }
    print("Area of current reference is \(currentReference.area) m2, and its name is \(currentReference.name)")
}

