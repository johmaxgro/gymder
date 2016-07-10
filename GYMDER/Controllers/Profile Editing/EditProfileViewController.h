//
//  EditProfileViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 21.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnUserData.h"

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *insideScrollViewView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIView *workoutView1;
@property (weak, nonatomic) IBOutlet UIView *workoutView2;
@property (weak, nonatomic) IBOutlet UIView *workoutView3;
@property (weak, nonatomic) IBOutlet UIView *workoutView4;
@property (weak, nonatomic) IBOutlet UIView *workoutView5;
@property (weak, nonatomic) IBOutlet UIView *workoutView6;

@property (weak, nonatomic) IBOutlet UILabel *workoutLabel1;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel2;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel3;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel4;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel5;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel6;

@property (nonatomic) CGColorRef mainWorkoutColor;
@property (strong, nonatomic) UIColor *color1;
@property (strong, nonatomic) UIColor *color2;
@property (strong, nonatomic) UIColor *color3;
@property (strong, nonatomic) UIColor *color4;
@property (strong, nonatomic) UIColor *color5;
@property (strong, nonatomic) UIColor *color6;

@property (strong, nonatomic) NSString *workout1;
@property (strong, nonatomic) NSString *workout2;
@property (strong, nonatomic) NSString *workout3;
@property (strong, nonatomic) NSString *workout4;
@property (strong, nonatomic) NSString *workout5;
@property (strong, nonatomic) NSString *workout6;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *gymLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *gym;
@property (strong, nonatomic) NSString *info;

@property (weak, nonatomic) IBOutlet UISwitch *messagesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *followersSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *powSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *premiumSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showmeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *contactSwitch;

@property (weak, nonatomic) IBOutlet UIView *workoutTouchView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *workoutTap;
- (IBAction)tapWorkout:(id)sender;
@property (nonatomic, strong) NSMutableArray *workouts;
@property (nonatomic, strong) OwnUserData *ownUserDataObject;
-(void)updateCircles;
@property (strong, nonatomic) NSMutableArray *circleArray;
-(void)clearCircles;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *usernameTap;
- (IBAction)editUsername:(id)sender;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *infoTap;
- (IBAction)editInfo:(id)sender;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *emailTap;
- (IBAction)editEmail:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *ageTap;
- (IBAction)editAge:(id)sender;

-(void)updateUsername;
-(void)updateInfo;
-(void)updatePhone;
-(void)updateEmail;
-(void)updateGender;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *phoneTap;
- (IBAction)editPhone:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *genderTap;
- (IBAction)editGender:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gymTap;
- (IBAction)editGym:(id)sender;
- (IBAction)switchMessages:(id)sender;
- (IBAction)switchFollowers:(id)sender;
- (IBAction)switchPows:(id)sender;
- (IBAction)switchPremium:(id)sender;
- (IBAction)switchShowme:(id)sender;
- (IBAction)switchFacebook:(id)sender;
- (IBAction)switchContact:(id)sender;

- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) NSMutableArray *navigationVCs;

@property (weak, nonatomic) IBOutlet UILabel *logOutLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *logOutTap;
- (IBAction)logOutTap:(id)sender;

@end
