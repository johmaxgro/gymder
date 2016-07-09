//
//  GeoManager.h
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleContent.h"
#import "BubbleViewController.h"
#import "BubblesViewController.h"
@class BubblesViewController;
@import CoreLocation;

@interface GeoManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) BubbleViewController *bubblevc;
@property (strong, nonatomic) BubblesViewController *bubblesVC;

@property (strong, nonatomic) NSMutableArray *allGeoObjects;

@property (strong, nonatomic) CLLocation *currentUserLocation;

@property (nonatomic) BOOL initialized;

-(void)startLocationUpdate;

@end
