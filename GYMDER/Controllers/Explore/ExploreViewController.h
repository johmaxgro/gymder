//
//  ExploreViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 22.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipe;
- (IBAction)rightSwipe:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipe;
- (IBAction)leftSwipe:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIImageView *arenaMenuIcon;
@property (weak, nonatomic) IBOutlet UIImageView *radarMenuIcon;
@property (weak, nonatomic) IBOutlet UIImageView *profileMenuIcon;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
- (IBAction)longPress:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapArena;
@property (weak, nonatomic) IBOutlet UIImageView *navigationButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRadar;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapProfile;
- (IBAction)tapArena:(id)sender;
- (IBAction)tapRadar:(id)sender;
- (IBAction)tapProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapBeside;
- (IBAction)tapBeside:(id)sender;

@property (strong, nonatomic) NSMutableArray *navigationVCs;
@property (weak, nonatomic) IBOutlet UIView *upSwipeArea;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipe;
- (IBAction)upSwipe:(id)sender;

//@property (strong, nonatomic) ViewControllerManager *viewControllerManager;
@property (weak, nonatomic) IBOutlet UIView *exploreContainer;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *swipeDownArea;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeDown;
- (IBAction)swipeDown:(id)sender;

-(void)searchViewShow;
-(void)searchViewHidden;
-(void)keyBoardAway;

@end
