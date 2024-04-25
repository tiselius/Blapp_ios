import SwiftUI

var touchX = 0
var touchY = 0
struct CameraView: View {

    @StateObject var frameHandler = FrameHandler()
    var image: CGImage?
    @State private var isLoading = true
    private let label = Text("frame")
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var body: some View {
        ZStack {
            if let image = frameHandler.frame {
                Image(image, scale: 1.0, orientation: .up, label: label)
                    .resizable()
                
            } else {
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1, green: 0.39, blue: 0.39),
                            Color(red: 1, green: 0.55, blue: 0.63),
                            Color(red: 1, green: 0.56, blue: 0.64),
                            Color(red: 1, green: 0.56, blue: 0.65),
                            Color(red: 1, green: 0.57, blue: 0.66),
                            Color(red: 1, green: 0.71, blue: 0.87)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                }
            }
            
            // Overlay for mean value
            Text("\(frameHandler.meanvalue) meters")
        }
        .onTapGesture { location in
            print("Screen height is: \(screenHeight)")
            print("Screen width is: \(screenWidth)")
            touchY = Int(location.y * (1920 / 650))
            touchX = Int(location.x * (1080 / screenWidth))
            print("Tapped at \(location)")
            print("Actually - it is at \(touchX), \(touchY)")
        }
        
    }
}
