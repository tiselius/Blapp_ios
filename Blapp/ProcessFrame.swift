import CoreMedia
import AVFoundation

class ProcessFrame: NSObject, ObservableObject {
    let wrapper = OpenCVWrapper()
    let frameProcessingQueue = DispatchQueue(label: "frameProcessingQueue")
    
    func findObject(cgImage: CGImage) -> CGImage {
        var uiImage = UIImage(cgImage: cgImage)
        //        frameProcessingQueue.async() {
        wrapper.centerObjectNew(uiImage)
        uiImage = wrapper.getObjectImage()
        if let overlayedImage = uiImage.cgImage {
            return overlayedImage
        } else {
            print("Failed to convert UIImage to CGImage")
        }
        //        }
        return cgImage
    }
    
    func getDistance(){
        
    }
    
    func findRelativeArea() -> Int32 {
        let area = wrapper.getObjectArea()
        print("number of pixels: \(area)")
        return area
    }
    
    private func findPixelSize(cameraDevice: AVCaptureDevice, currentDepth: Double) -> Double{
//        let cameraDevice = frameHandler.getCameraDevice()
        let fieldOfViewDegrees = cameraDevice.activeFormat.videoFieldOfView // in degrees
//        print("field of view is \(fieldOfViewDegrees) degrees")
        let fieldOfViewRadians = Double(fieldOfViewDegrees) * Double.pi / 180
        //        print("field of view is \(fieldOfViewRadians) rad")
        
        //        print("distance is \(currentDepth)")
        let realWorldWidth = Double(tan(Double(fieldOfViewRadians) / 2 ) ) * Double(currentDepth) * 2
        //        print("real world width is \(realWorldWidth) ")
        let dimensions = CMVideoFormatDescriptionGetDimensions(cameraDevice.activeFormat.formatDescription)
        
        let imageWidth = Double(dimensions.height)  //use height because of landscape vs portrait blabla...
        print("image width is \(imageWidth) ")
        let pixelSize = realWorldWidth / imageWidth
        return pixelSize
    }
    
    private func calculateRealArea(pixelSize : Double, relativeArea : Double) -> Double {
        return pixelSize * pixelSize * relativeArea
    }
    
}
