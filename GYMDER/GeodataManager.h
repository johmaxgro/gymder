//
//  GeodataManager.h
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubblesViewController.h"
@import CoreLocation;


@interface GeodataManager : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) BubblesViewController *bubblesVC;

@end
