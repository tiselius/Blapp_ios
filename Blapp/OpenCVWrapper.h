//
//  OpenCVWrapper.h
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

@property (nonatomic, readwrite) int area;
@property (nonatomic, weak) UIImage *image;


+ (NSString *)getOpenCVVersion;
+ (UIImage *)grayscaleImg:(UIImage *)image;
+ (UIImage *)resizeImg:(UIImage *)image :(int)width :(int)height :(int)interpolation;
//- (UIImage *) identifyObject: (UIImage *) image;
- (int) centerArea: (UIImage *) image;
- (UIImage *) centerObject: (UIImage *) image;
- (UIImage *) referenceObjectOverlay: (UIImage *) image :(int) x :(int) y;
- (int) referenceObjectArea: (UIImage *) image :(int) x :(int) y;
- (void) centerObjectNew: (UIImage *) image;
- (UIImage *) getObjectImage;
- (int) getObjectArea;
- (void) centerObjectNewTest: (CVImageBufferRef) pixelBuffer;

@end

NS_ASSUME_NONNULL_END
