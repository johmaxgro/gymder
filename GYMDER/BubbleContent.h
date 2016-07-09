//
//  BubbleContent.h
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import UIKit;
@import CoreLocation;


@interface BubbleContent : NSObject

@property (strong, nonatomic) NSMutableDictionary *bubbles;
@property (nonatomic) NSUInteger userID;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *gymderName, *age, *gym, *info;
@property (nonatomic) double physicalDistance;

@property (nonatomic) NSNumber *direction;

@property (strong, nonatomic) CLLocation *userLocation;

-(void)setLocationDirection:(NSNumber*)direction;
//@property (strong, nonatomic) BubbleViewController *bvc;

-(void)createBubble;

@end
