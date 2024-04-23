import CoreMedia

class ProcessFrame: NSObject, ObservableObject {

    
    let frameProcessingQueue = DispatchQueue(label: "frameProcessingQueue")
//    let frameHandler : FrameHandler
    
    override init(){
        //Makes the program crash :)
//        frameHandler = FrameHandler()
        super.init()
    }
    
    func findObject(cgImage: CGImage, completion: @escaping (CGImage) -> Void) {
        var uiImage = UIImage(cgImage: cgImage)
        frameProcessingQueue.async {
            uiImage = OpenCVWrapper().centerObject(uiImage)
            if let overlayedImage = uiImage.cgImage {
                completion(overlayedImage)
            } else {
                print("Failed to convert UIImage to CGImage")
            }
        }
    }
//    
//    func findRelativeArea(cgImage: CGImage) -> Double {
//        let uiImage = UIImage(cgImage: cgImage)
//        let area = OpenCVWrapper().centerArea(uiImage)
//        return Double(area)
//    }
//    
//    func getRealArea(cgImage: CGImage) -> Double{
//        let relativeArea = findRelativeArea(cgImage: cgImage)
//        let pixelSize = findPixelSize()
//        let realArea = calculateRealArea(pixelSize: pixelSize, relativeArea: relativeArea)
//        return realArea
//    }
//    
//    private func findPixelSize() -> Double{
////        let cameraDevice = frameHandler.getCameraDevice()
////        let fieldOfViewDegrees = cameraDevice.activeFormat.videoFieldOfView // in degrees
//        let fieldOfViewDegrees = 67
////        print("field of view is \(fieldOfViewDegrees) degrees")
//        let fieldOfViewRadians = Double(fieldOfViewDegrees) * Double.pi / 180
////        print("field of view is \(fieldOfViewRadians) rad")
//        
//        let currentDepth = frameHandler.getCurrentDepth()
////        print("distance is \(currentDepth)")
//        let realWorldWidth = Double(tan(Double(fieldOfViewRadians) / 2 ) ) * Double(currentDepth) * 2
////        print("real world width is \(realWorldWidth) ")
////        let dimensions = CMVideoFormatDescriptionGetDimensions(cameraDevice.activeFormat.formatDescription)
//
////        let imageWidth = Double(dimensions.height)  //use height because of landscape vs portrait blabla...
////        print("image width is \(imageWidth) ")
////        let pixelSize = realWorldWidth / imageWidth
////        return pixelSize
//        return 0
//    }
//    
//    private func calculateRealArea(pixelSize : Double, relativeArea : Double) -> Double {
//        return pixelSize * pixelSize * relativeArea
//    }
    
}
