//
//  Filters.h
//  GYMDER
//
//  Created by Johannes Groschopp on 19.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//  FILTERS for shot images

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Filters : NSObject

-(void)beastFilter:(UIImage *)imageToFilter toImageView:(UIImageView*)iv andWaterMarkIV:(UIImageView*)watermarkIV;

-(void)angelFilter:(UIImage *)imageToFilter toImageView:(UIImageView*)iV andWaterMarkIV:(UIImageView*)watermarkIV;

@end
