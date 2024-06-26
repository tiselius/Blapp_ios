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
+ (NSString *)getOpenCVVersion;
+ (UIImage *)grayscaleImg:(UIImage *)image;
+ (UIImage *)resizeImg:(UIImage *)image :(int)width :(int)height :(int)interpolation;
- (UIImage *) identifyObject: (UIImage *) image;

@end

NS_ASSUME_NONNULL_END
