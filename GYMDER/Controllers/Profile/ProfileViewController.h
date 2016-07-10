//
//  ProfileViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 10.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnUserData.h"
#import "OtherUserData.h"

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeGesture;
- (IBAction)rightSwipe:(id)sender;
-(void)profileImageToImageView:(UIImage*)image;
@property (strong, nonatomic) UIImage *image;
- (IBAction)profileImageTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *profilePhotoTapGesture;
@property (strong, nonatomic) NSMutableDictionary *ownUserData;
@property (strong, nonatomic) NSMutableArray *navigationVCs;
@property (weak, nonatomic) IBOutlet UILabel *pows;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *gym;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (nonatomic, strong) OwnUserData *ownUserDataObject;
@property (nonatomic, strong) OtherUserData *otherUserData;
- (IBAction)plus:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *workout1View;
@property (weak, nonatomic) IBOutlet UILabel *workout1Label;
@property (weak, nonatomic) IBOutlet UIView *workout2View;
@property (weak, nonatomic) IBOutlet UILabel *workout2Label;
@property (weak, nonatomic) IBOutlet UIView *workout3View;
@property (weak, nonatomic) IBOutlet UILabel *workout3Label;
@property (weak, nonatomic) IBOutlet UIView *workout4View;
@property (weak, nonatomic) IBOutlet UILabel *workout4Label;
@property (weak, nonatomic) IBOutlet UIView *workout5View;
@property (weak, nonatomic) IBOutlet UILabel *workout5Label;
@property (weak, nonatomic) IBOutlet UIView *workout6View;
@property (weak, nonatomic) IBOutlet UILabel *workout6Label;
@property (weak, nonatomic) IBOutlet UIImageView *settingsIcon;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *profileSettingsTap;
- (IBAction)profileSettingsTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *profileSettingsTap2;
- (IBAction)profileSettingsTap2:(id)sender;
@property (nonatomic) BOOL ownProfile;
@property (weak, nonatomic) IBOutlet UIButton *powButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
-(void)clearCicles;
-(void)setWorkoutCircles:(NSMutableArray*)workouts;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *chatTap;
- (IBAction)chatTap:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *followTap;
- (IBAction)followTap:(id)sender;
- (IBAction)chat:(id)sender;
- (IBAction)follow:(id)sender;
- (IBAction)pow:(id)sender;

@end
