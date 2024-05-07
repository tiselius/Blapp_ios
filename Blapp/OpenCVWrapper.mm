#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"
#include "ObjectDetection.hpp"


/*
 * add a method convertToMat to UIImage class
 */
@interface UIImage (OpenCVWrapper)
- (void)convertToMat: (cv::Mat *)pMat: (bool)alphaExists;
@end

@implementation UIImage (OpenCVWrapper)


- (void)convertToMat: (cv::Mat *)pMat: (bool)alphaExists {
    if (self.imageOrientation == UIImageOrientationRight) {
        /*
         * When taking picture in portrait orientation,
         * convert UIImage to OpenCV Matrix in landscape right-side-up orientation,
         * and then rotate OpenCV Matrix to portrait orientation
         */
        UIImageToMat([UIImage imageWithCGImage:self.CGImage scale:1.0 orientation:UIImageOrientationUp], *pMat, alphaExists);
        cv::rotate(*pMat, *pMat, cv::ROTATE_90_CLOCKWISE);
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        /*
         * When taking picture in portrait upside-down orientation,
         * convert UIImage to OpenCV Matrix in landscape right-side-up orientation,
         * and then rotate OpenCV Matrix to portrait upside-down orientation
         */
        UIImageToMat([UIImage imageWithCGImage:self.CGImage scale:1.0 orientation:UIImageOrientationUp], *pMat, alphaExists);
        cv::rotate(*pMat, *pMat, cv::ROTATE_90_COUNTERCLOCKWISE);
    } else {
        /*
         * When taking picture in landscape orientation,
         * convert UIImage to OpenCV Matrix directly,
         * and then ONLY rotate OpenCV Matrix for landscape left-side-up orientation
         */
        UIImageToMat(self, *pMat, alphaExists);
        if (self.imageOrientation == UIImageOrientationDown) {
            cv::rotate(*pMat, *pMat, cv::ROTATE_180);
        }
    }
}
@end

@implementation OpenCVWrapper


- (UIImage *) referenceObjectOverlay: (UIImage *) image :(int) x :(int) y {
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);

    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    ObjectDetection objectDetection;
    cv::Mat imageWithObject = objectDetection.findObject(convertedColorSpaceImage, x, y);

    return MatToUIImage(imageWithObject);
}

- (int) referenceObjectArea: (UIImage *) image :(int) x :(int) y {
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);

    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    ObjectDetection objectDetection;
    int referenceArea = objectDetection.findObjectArea(convertedColorSpaceImage, x, y);

    return referenceArea;
}


- (UIImage *) centerObject: (UIImage *) image {
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    ObjectDetection objectDetection;
    cv::Mat imageWithObject = objectDetection.identifyCenterObject(convertedColorSpaceImage);
    
    return MatToUIImage(imageWithObject);
}

- (int) centerArea: (UIImage *) image{
    cv::Mat opencvImage;
   UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    ObjectDetection objectDetection;
    int area = objectDetection.identifyCenterObjectArea(convertedColorSpaceImage);
    return area;
}


- (void) centerObjectNew: (UIImage *) image{
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    ObjectDetection objectDetection;
    objectDetection.centerObjectInfo(convertedColorSpaceImage);
    
    self.area = objectDetection.getArea();
    self.image = MatToUIImage(objectDetection.getImage());
}

- (UIImage *) getObjectImage {
    return self.image;
}
- (int) getObjectArea {
    return self.area;
}

//- (UIImage *) identifyObject: (UIImage *) image {
//    // convert uiimage to mat
//    cv::Mat opencvImage;
//    UIImageToMat(image, opencvImage, true);
//    
//    // convert colorspace to the one expected by the lane detector algorithm (RGB)
//    cv::Mat convertedColorSpaceImage;
//    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
//    
//    ObjectDetection objectDetection;
//    cv::Mat imageWithObject = objectDetection.identifyObject(convertedColorSpaceImage);
//    
//    return MatToUIImage(imageWithObject);
//}

+ (NSString *)getOpenCVVersion {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

+ (UIImage *)grayscaleImg:(UIImage *)image {
    cv::Mat mat;
    [image convertToMat: &mat :false];
    
    cv::Mat gray;
    
    NSLog(@"channels = %d", mat.channels());
    
    if (mat.channels() > 1) {
        cv::cvtColor(mat, gray, cv::COLOR_RGB2GRAY);
    } else {
        mat.copyTo(gray);
    }
    
    UIImage *grayImg = MatToUIImage(gray);
    return grayImg;
}

+ (UIImage *)resizeImg:(UIImage *)image :(int)width :(int)height :(int)interpolation {
    cv::Mat mat;
    [image convertToMat: &mat :false];
    
    if (mat.channels() == 4) {
        [image convertToMat: &mat :true];
    }
    
    NSLog(@"source shape = (%d, %d)", mat.cols, mat.rows);
    
    cv::Mat resized;
    
    //    cv::INTER_NEAREST = 0,
    //    cv::INTER_LINEAR = 1,
    //    cv::INTER_CUBIC = 2,
    //    cv::INTER_AREA = 3,
    //    cv::INTER_LANCZOS4 = 4,
    //    cv::INTER_LINEAR_EXACT = 5,
    //    cv::INTER_NEAREST_EXACT = 6,
    //    cv::INTER_MAX = 7,
    //    cv::WARP_FILL_OUTLIERS = 8,
    //    cv::WARP_INVERSE_MAP = 16
    
    cv::Size size = {width, height};
    
    cv::resize(mat, resized, size, 0, 0, interpolation);
    
    NSLog(@"dst shape = (%d, %d)", resized.cols, resized.rows);
    
    UIImage *resizedImg = MatToUIImage(resized);
    
    return resizedImg;
}

@end