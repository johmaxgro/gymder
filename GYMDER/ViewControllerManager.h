//
//  ViewControllerManager.h
//  GYMDER
//
//  Created by Johannes Groschopp on 24.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadarViewController.h"
#import "ExploreViewController.h"
#import "ArenaViewController.h"
#import "ProfileSexyViewController.h"

@interface ViewControllerManager : NSObject

@property (strong, nonatomic) RadarViewController *radarVC;

//@property (strong, nonatomic) ExploreViewController *exploreVC;

@property (strong, nonatomic) ArenaViewController *arenaVC;

@property (strong, nonatomic) ProfileSexyViewController *profileSexyVC;

@end
