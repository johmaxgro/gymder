//
//  ExploreCollectionViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 03.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"

@interface ExploreCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSMutableArray *exploreContent;
@property (strong, nonatomic) NSMutableArray *navigationVCs;

@end
