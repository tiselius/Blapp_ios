//
//  getReferenceArea.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-29.
//

import Foundation

func getReferenceOverlay(image : CGImage) -> UIImage {
    let newTouchX = Int32(CGFloat(touchX!) / scale)
    let newTouchY = Int32(CGFloat(touchY!) / scale)
    let referenceImage = OpenCVWrapper().referenceObjectOverlay(UIImage(cgImage: image), newTouchX, newTouchY)
    return referenceImage
}


func getReferenceArea(image : CGImage) -> Int {
    let newTouchX = Int32(CGFloat(touchX!) / scale)
    let newTouchY = Int32(CGFloat(touchY!) / scale)
    let referenceArea = OpenCVWrapper().referenceObjectArea(UIImage(cgImage: image), newTouchX, newTouchY)
    return Int(referenceArea)
}
