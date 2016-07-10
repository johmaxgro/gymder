//
//  WorkoutsViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 12.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnUserData.h"

@interface WorkoutsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *hardcoreView;
@property (weak, nonatomic) IBOutlet UIView *hiitView;
@property (weak, nonatomic) IBOutlet UIView *combatView;
@property (weak, nonatomic) IBOutlet UIView *liftView;
@property (weak, nonatomic) IBOutlet UIView *spinView;
@property (weak, nonatomic) IBOutlet UIView *bootcampView;
@property (weak, nonatomic) IBOutlet UIView *equipmentView;
@property (weak, nonatomic) IBOutlet UIView *runView;
@property (weak, nonatomic) IBOutlet UIView *teamView;
@property (weak, nonatomic) IBOutlet UIView *crossfitView;
@property (weak, nonatomic) IBOutlet UIView *cardioView;
@property (weak, nonatomic) IBOutlet UIView *danceView;
@property (weak, nonatomic) IBOutlet UIView *bodyweightView;
@property (weak, nonatomic) IBOutlet UIView *fatburnView;
@property (weak, nonatomic) IBOutlet UIView *pilatesView;
@property (weak, nonatomic) IBOutlet UIView *freeView;
@property (weak, nonatomic) IBOutlet UIView *walkView;
@property (weak, nonatomic) IBOutlet UIView *yogaView;

@property (nonatomic, strong) NSMutableArray *workouts;
@property (nonatomic, strong) OwnUserData *ownUserDataObject;
@end
