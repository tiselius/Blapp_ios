//
//  getReferenceArea.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-29.
//

import Foundation

func getReferenceOverlay(image : CGImage) -> UIImage {
    let referenceImage = OpenCVWrapper().referenceObjectOverlay(UIImage(cgImage: image), touchX!, touchY!)
//    print("Relative area of reference object is \(area)")
    
    return referenceImage
}


func getReferenceArea(image : CGImage) -> Int {
    let referenceArea = OpenCVWrapper().referenceObjectArea(UIImage(cgImage: image), touchX!, touchY!)
//    print("Relative area of reference object is \(area)")
    return Int(referenceArea)
}
