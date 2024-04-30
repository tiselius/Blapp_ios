//
//  Global.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-29.
//

import Foundation

//Variables
let m3ToDl : Float = 10000
var touchX : Int32?
var touchY : Int32?
var referenceImage : UIImage?
let referenceAreaReal : Float = 0.00461488
var relativeAreaOfObject : Int32 = 0

//Flags
var useReference : Bool = false
var noDepthCameraAvailable : Bool = false

//Functions

// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height * 0.8
}

