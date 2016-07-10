//
//  GooglePlacesTableViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymEditViewController.h"
@import GoogleMaps;

@interface GooglePlacesTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *repository;
@property (strong, nonatomic) GymEditViewController *gymEditVC;
@property (strong, nonatomic) NSMutableArray*placesIDs;
@property (strong, nonatomic) GMSPlacesClient *placesClient;

@end
