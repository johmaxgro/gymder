//
//  Filters.m
//  GYMDER
//
//  Created by Johannes Groschopp on 19.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "Filters.h"
#import <UIKit/UIKit.h>

@implementation Filters

-(void)beastFilter:(UIImage *)imageToFilter toImageView:(UIImageView*)iv andWaterMarkIV:(UIImageView*)watermarkIV{
    
    
    
    UIImageOrientation originalOrientation = iv.image.imageOrientation;
    //    CIImage *bgnImage = [[CIImage alloc] initWithCGImage:[imageToFilter CGImage]];
    
    //    UIImage *fixedImage = [self scaleAndRotateImage:imageToFilter];
    UIImage *fixedImage =imageToFilter;
    
    CIImage *bgnImage = [CIImage imageWithCGImage:fixedImage.CGImage];
    
    CIFilter *saturation = [CIFilter filterWithName:@"CIVibrance"];
    [saturation setDefaults];
    [saturation setValue: bgnImage forKey: @"inputImage"];
    [saturation setValue: [NSNumber numberWithFloat:0.6f]
                  forKey:@"inputAmount"];
    
    CIImage *outputImage = [saturation valueForKey:@"outputImage"];
    
    CIFilter *imgFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, outputImage, @"inputIntensity", [NSNumber numberWithFloat:1.0], nil];
    outputImage = [imgFilter outputImage];
    
    CIFilter *brightnesContrastFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [brightnesContrastFilter setDefaults];
    [brightnesContrastFilter setValue: outputImage forKey: @"inputImage"];
    [brightnesContrastFilter setValue: [NSNumber numberWithFloat:5.0]
                               forKey:@"inputPower"];
    outputImage = [brightnesContrastFilter valueForKey: @"outputImage"];
    
    // Color Controls
    
    CIFilter *colorControlFilter = [CIFilter filterWithName:@"CIColorControls"];
    [colorControlFilter setDefaults];
    [colorControlFilter setValue: outputImage forKey: @"inputImage"];
    [colorControlFilter setValue: [NSNumber numberWithFloat:1.0]
                          forKey:@"inputSaturation"];
    [colorControlFilter setValue: [NSNumber numberWithFloat:0.05]
                          forKey:@"inputBrightness"];
    outputImage = [colorControlFilter valueForKey: @"outputImage"];
    
    // Beats Mask Filter
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]]; // 10
    
    // Draw the image in screen
    UIImage* backgroundImage = [[UIImage alloc] initWithCGImage:cgimg scale:1.0 orientation:imageToFilter.imageOrientation];
    
    UIImage *watermarkImage = [UIImage imageNamed:@"BEAST-MASK.png"];
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, 0, iv.frame.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *imageToDisplay =
    [UIImage imageWithCGImage:[result CGImage]
                        scale:[result scale]
                  orientation: imageToFilter.imageOrientation];
    
    [iv setImage:result];
}

-(void)angelFilter:(UIImage *)imageToFilter toImageView:(UIImageView*)iV andWaterMarkIV:(UIImageView*)watermarkIV
{
    UIImageOrientation originalOrientation = iV.image.imageOrientation;
    //    CIImage *inputImage = [[CIImage alloc] initWithCGImage:[imageToFilter CGImage]];;
    
   // UIImage *fixedImage = [self scaleAndRotateImage:imageToFilter];
    UIImage *fixedImage = imageToFilter;
    CIImage *inputImage = [CIImage imageWithCGImage:fixedImage.CGImage];
    
    // Saturation
    CIFilter *saturation = [CIFilter filterWithName:@"CIVibrance"];
    [saturation setDefaults];
    [saturation setValue: inputImage forKey: @"inputImage"];
    [saturation setValue: [NSNumber numberWithFloat:0.6f]
                  forKey:@"inputAmount"];
    
    CIImage *outputImage = [saturation valueForKey:@"outputImage"];
    
    CIFilter *imgFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, outputImage, @"inputIntensity", [NSNumber numberWithFloat:1.0], nil];
    outputImage = [imgFilter outputImage];
    
    CIFilter *brightnesContrastFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [brightnesContrastFilter setDefaults];
    [brightnesContrastFilter setValue: outputImage forKey: @"inputImage"];
    [brightnesContrastFilter setValue: [NSNumber numberWithFloat:1.0]
                               forKey:@"inputPower"];
    outputImage = [brightnesContrastFilter valueForKey: @"outputImage"];
    
    // Color Controls
    
    CIFilter *colorControlFilter = [CIFilter filterWithName:@"CIColorControls"];
    [colorControlFilter setDefaults];
    [colorControlFilter setValue: outputImage forKey: @"inputImage"];
    [colorControlFilter setValue: [NSNumber numberWithFloat:1.0]
                          forKey:@"inputSaturation"];
    [colorControlFilter setValue: [NSNumber numberWithFloat:0.1]
                          forKey:@"inputBrightness"];
    outputImage = [colorControlFilter valueForKey: @"outputImage"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImgRef = [context  createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage* backgroundImage = [[UIImage alloc] initWithCGImage:cgImgRef scale:1.0 orientation:imageToFilter.imageOrientation];
    
    UIImage *watermarkImage = [UIImage imageNamed:@"ANGEL MASK.png"];
    watermarkIV.image = watermarkImage;
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(watermarkIV.frame.origin.x, watermarkIV.frame.origin.y, watermarkImage.size.width, watermarkImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    UIImage* img = [[UIImage alloc] initWithCGImage:cgImgRef scale:1.0 orientation:originalOrientation];
    UIImage *imageToDisplay =
    [UIImage imageWithCGImage:[result CGImage]
                        scale:[result scale]
                  orientation: imageToFilter.imageOrientation];
    
    [iV setImage:backgroundImage];
    
    
    
}



- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


@end
