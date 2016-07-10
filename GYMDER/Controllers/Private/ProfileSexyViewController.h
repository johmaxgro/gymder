//
//  ProfileSexyViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 18.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnUserData.h"

@interface ProfileSexyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ownImage;
@property (strong, nonatomic) UIImage *ownProfileImage;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeGesture;
@property (strong, nonatomic) IBOutlet UIView *mainView;
- (IBAction)rightSwipe:(id)sender;
@property (nonatomic, strong) OwnUserData *ownUserDataObject;
- (IBAction)settings:(id)sender;
- (IBAction)longPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapBeside;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (weak, nonatomic) IBOutlet UIImageView *navigationButton;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipe;
@property (weak, nonatomic) IBOutlet UIView *upSwipeArea;
- (IBAction)upSwipe:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRadar;
- (IBAction)tapRadar:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapExplore;
- (IBAction)tapExplore:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapArena;
- (IBAction)tapArena:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *arenaMenuIcon;
@property (weak, nonatomic) IBOutlet UIImageView *exploreMenuIcon;
@property (weak, nonatomic) IBOutlet UIImageView *radarMenuIcon;

@property (strong, nonatomic) NSMutableArray *navigationVCs;
@property (weak, nonatomic) IBOutlet UIImageView *notificationsView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *notificationsTap;
- (IBAction)notificationsTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *chatTap;
- (IBAction)chatTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *chatView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *followTap;
- (IBAction)followTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *followView;

@end
