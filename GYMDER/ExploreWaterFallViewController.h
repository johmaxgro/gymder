//
//  ExploreWaterFallViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 07.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//
//
//  ViewController.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "ExploreViewController.h"

@interface ExploreWaterFallViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) IBOutlet UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *exploreContent;

@property (nonatomic, strong) ExploreViewController *exploreVC;

@end
