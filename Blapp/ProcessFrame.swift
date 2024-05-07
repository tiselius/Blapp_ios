import CoreMedia
import AVFoundation

class ProcessFrame: NSObject, ObservableObject {

    let frameProcessingQueue = DispatchQueue(label: "frameProcessingQueue")
    
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
    
    func getDistance(){
        
    }
    
    func findRelativeArea(cgImage: CGImage) -> Double {
        let uiImage = UIImage(cgImage: cgImage)
        let area = OpenCVWrapper().centerArea(uiImage)
        return Double(area)
    }
    
    func getRealArea(cgImage: CGImage, cameraDevice: AVCaptureDevice, currentDepth: Double) -> Double{
        let relativeArea = findRelativeArea(cgImage: cgImage)
        let pixelSize = findPixelSize(cameraDevice: cameraDevice, currentDepth: currentDepth)
        let realArea = calculateRealArea(pixelSize: pixelSize, relativeArea: relativeArea)
        return realArea
    }
    
    private func findPixelSize(cameraDevice: AVCaptureDevice, currentDepth: Double) -> Double{
//        let cameraDevice = frameHandler.getCameraDevice()
//        let fieldOfViewDegrees = cameraDevice.activeFormat.videoFieldOfView // in degrees
        let fieldOfViewDegrees = 67
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
