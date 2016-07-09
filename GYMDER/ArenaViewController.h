//
//  ArenaViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 22.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArenaViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipe;
- (IBAction)rightSwipe:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipe;
- (IBAction)leftSwipe:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapArena;
@property (weak, nonatomic) IBOutlet UIImageView *navigationButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRadar;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapProfile;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapExplore;

- (IBAction)tapRadar:(id)sender;
- (IBAction)tapProfile:(id)sender;
- (IBAction)tapExplore:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapBeside;
- (IBAction)tapBeside:(id)sender;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) IBOutlet UIImageView *exploreMenuIcon;
@property (weak, nonatomic) IBOutlet UIImageView *radarMenuIcon;
@property (weak, nonatomic) IBOutlet UIImageView *profileMenuIcon;

@property (strong, nonatomic) NSMutableArray *navigationVCs;
@property (weak, nonatomic) IBOutlet UIView *upSwipeArea;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipe;
- (IBAction)upSwipe:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *firstPows;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *secondPows;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UILabel *thirdName;
@property (weak, nonatomic) IBOutlet UILabel *thirdPows;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;
@property (weak, nonatomic) IBOutlet UILabel *fourthName;
@property (weak, nonatomic) IBOutlet UILabel *fourthPows;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImage;
@property (weak, nonatomic) IBOutlet UILabel *fifthPows;
@property (weak, nonatomic) IBOutlet UILabel *fifthName;
@property (weak, nonatomic) IBOutlet UIImageView *sixthImage;
@property (weak, nonatomic) IBOutlet UILabel *sixthName;
@property (weak, nonatomic) IBOutlet UILabel *sixthPows;
@property (weak, nonatomic) IBOutlet UIImageView *seventhImage;
@property (weak, nonatomic) IBOutlet UILabel *seventhName;
@property (weak, nonatomic) IBOutlet UILabel *seventhPows;
@property (weak, nonatomic) IBOutlet UIImageView *eigthImage;
@property (weak, nonatomic) IBOutlet UILabel *eigthName;
@property (weak, nonatomic) IBOutlet UILabel *eigthPows;
@property (weak, nonatomic) IBOutlet UIImageView *ninethImage;
@property (weak, nonatomic) IBOutlet UILabel *ninethName;
@property (weak, nonatomic) IBOutlet UILabel *ninethPows;
@property (weak, nonatomic) IBOutlet UIImageView *tenthImage;
@property (weak, nonatomic) IBOutlet UILabel *tenthName;
@property (weak, nonatomic) IBOutlet UILabel *tenthPows;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *firstImageTap;
- (IBAction)firstImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *secondImageTap;
- (IBAction)secondImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *thirdImageTap;
- (IBAction)thirdImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *fourthImageTap;
- (IBAction)fourthImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *fifthImageTap;
- (IBAction)fifthImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *sixthImageTap;
- (IBAction)sixthImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *seventhImageTap;
- (IBAction)seventhImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *eighthImageTap;
- (IBAction)eighthImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *ninethImageTap;
- (IBAction)ninethImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tenthImageTap;
- (IBAction)tenthImageTap:(id)sender;

@end
