import CoreMedia
import AVFoundation

class ProcessFrame: NSObject, ObservableObject {
    let wrapper = OpenCVWrapper()
    let frameProcessingQueue = DispatchQueue(label: "frameProcessingQueue")
    
    func findObject(cgImage: CGImage) -> CGImage {
        var uiImage = UIImage(cgImage: cgImage)
        wrapper.centerObjectNew(uiImage)
        uiImage = wrapper.getObjectImage()
        if let overlayedImage = uiImage.cgImage {
            return overlayedImage
        } else {
            print("Failed to convert UIImage to CGImage")
        }
        return cgImage
    }
    
    func findObjectTest(sampleBuffer : CVPixelBuffer) -> CGImage {
        
        wrapper.centerObjectNewTest(sampleBuffer)
        let uiImage = wrapper.getObjectImage()

        if let overlayedImage = uiImage.cgImage {
            return overlayedImage
        } else {
            print("Failed to convert UIImage to CGImage")
        }
        return uiImage.cgImage!
    }
    
    func findRelativeArea() -> Int32 {
        let area = wrapper.getObjectArea()
        return area
    }
}
