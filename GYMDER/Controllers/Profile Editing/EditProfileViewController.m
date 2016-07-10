//
//  EditProfileViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 21.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "EditProfileViewController.h"
#import "WorkoutsViewController.h"
#import "TextinputViewController.h"
#import "NumberEditViewController.h"
#import "GenderViewController.h"
#import "GymEditViewController.h"
#import "FBSDKLoginManager.h"
#import "FBSDKCoreKit.h"
#import "RadarViewController.h"
@import Quickblox;

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width/2, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"EDIT PROFILE & SETTINGS";
    label.font=[label.font fontWithSize:20];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:20];
    self.navigationItem.titleView = label;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    _profileImage.image = _image;
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*3);
//    [_insideScrollViewView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*3)];
    [_workoutTouchView addGestureRecognizer:_workoutTap];
    
    _circleArray = [NSMutableArray new];
    
    NSMutableDictionary *circleContent1 = [NSMutableDictionary new];
    [circleContent1 setObject:_color1 forKey:@"color"];
    [circleContent1 setObject:_workout1 forKey:@"workout"];
    [_circleArray addObject:circleContent1];
    
    NSMutableDictionary *circleContent2 = [NSMutableDictionary new];
    [circleContent2 setObject:_color2 forKey:@"color"];
    [circleContent2 setObject:_workout2 forKey:@"workout"];
    [_circleArray addObject:circleContent2];

    NSMutableDictionary *circleContent3 = [NSMutableDictionary new];
    [circleContent3 setObject:_color3 forKey:@"color"];
    [circleContent3 setObject:_workout3 forKey:@"workout"];
    [_circleArray addObject:circleContent3];
    
    NSMutableDictionary *circleContent4 = [NSMutableDictionary new];
    [circleContent4 setObject:_color4 forKey:@"color"];
    [circleContent4 setObject:_workout4 forKey:@"workout"];
    [_circleArray addObject:circleContent4];
    
    NSMutableDictionary *circleContent5 = [NSMutableDictionary new];
    [circleContent5 setObject:_color5 forKey:@"color"];
    [circleContent5 setObject:_workout5 forKey:@"workout"];
    [_circleArray addObject:circleContent5];
    
    NSMutableDictionary *circleContent6 = [NSMutableDictionary new];
    [circleContent6 setObject:_color6 forKey:@"color"];
    [circleContent6 setObject:_workout6 forKey:@"workout"];
    [_circleArray addObject:circleContent6];
    
    [_usernameLabel addGestureRecognizer:_usernameTap];
    [_infoLabel addGestureRecognizer:_infoTap];
    [_emailLabel addGestureRecognizer:_emailTap];
    [_ageLabel addGestureRecognizer:_ageTap];
    [_phoneLabel addGestureRecognizer:_phoneTap];
    [_genderLabel addGestureRecognizer:_genderTap];
    [_gymLabel addGestureRecognizer:_gymTap];
    [_logOutLabel addGestureRecognizer:_logOutTap];
    
    _emailLabel.text = _email;
    _phoneLabel.text = _phone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_ownUserDataObject updateUsername];
    [self setSwitches];
}

-(void)viewDidLayoutSubviews{
    [self updateCircles];
    [self setContent];
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width,_insideScrollViewView.frame.size.height+100);
    _scrollView.delaysContentTouches = NO;
}

-(void)updateCircles{
    NSLog(@"Updating circles, circleArray: %@", _circleArray);
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    _profileImage.layer.borderWidth = 3;
    _profileImage.layer.borderColor = _mainWorkoutColor;
    if([_circleArray count] > 0){
        _workoutView1.layer.cornerRadius = _workoutView1.frame.size.width/2;
        _workoutView1.backgroundColor = [[_circleArray objectAtIndex:0]objectForKey:@"color"];
        _workoutLabel1.text = [[_circleArray objectAtIndex:0]objectForKey:@"workout"];
    }
    if([_circleArray count] > 1){
        _workoutView2.layer.cornerRadius = _workoutView2.frame.size.width/2;
        _workoutView2.backgroundColor = [[_circleArray objectAtIndex:1]objectForKey:@"color"];
        _workoutLabel2.text = [[_circleArray objectAtIndex:1]objectForKey:@"workout"];
    }
    if([_circleArray count] > 2){
        _workoutView3.layer.cornerRadius = _workoutView3.frame.size.width/2;
        _workoutView3.backgroundColor = [[_circleArray objectAtIndex:2]objectForKey:@"color"];
        _workoutLabel3.text = [[_circleArray objectAtIndex:2]objectForKey:@"workout"];
    }
    if([_circleArray count] > 3){
        _workoutView4.layer.cornerRadius = _workoutView4.frame.size.width/2;
        _workoutView4.backgroundColor = [[_circleArray objectAtIndex:3]objectForKey:@"color"];;
        _workoutLabel4.text = [[_circleArray objectAtIndex:3]objectForKey:@"workout"];
    }
    if([_circleArray count] > 4){
        _workoutView5.layer.cornerRadius = _workoutView5.frame.size.width/2;
        _workoutView5.backgroundColor = [[_circleArray objectAtIndex:4]objectForKey:@"color"];;
        _workoutLabel5.text = [[_circleArray objectAtIndex:4]objectForKey:@"workout"];
    }
    if([_circleArray count] > 5){
        _workoutView6.layer.cornerRadius = _workoutView6.frame.size.width/2;
        _workoutView6.backgroundColor = [[_circleArray objectAtIndex:5]objectForKey:@"color"];;
        _workoutLabel6.text = [[_circleArray objectAtIndex:5]objectForKey:@"workout"];
    }
    

}

-(void)clearCircles{
    _workoutView1.backgroundColor = [UIColor clearColor];
    _workoutView2.backgroundColor = [UIColor clearColor];
    _workoutView3.backgroundColor = [UIColor clearColor];
    _workoutView4.backgroundColor = [UIColor clearColor];
    _workoutView5.backgroundColor = [UIColor clearColor];
    _workoutView6.backgroundColor = [UIColor clearColor];
    
    _workoutLabel1.text = @"";
    _workoutLabel2.text = @"";
    _workoutLabel3.text = @"";
    _workoutLabel4.text = @"";
    _workoutLabel5.text = @"";
    _workoutLabel6.text = @"";

}

-(void)setContent{
    _usernameLabel.text = _username;
    _ageLabel.text = [NSString stringWithFormat:@"%@%@", _age, @" years"];
    _gymLabel.text = _gym;
    _infoLabel.text = _info;
    ////    _emailLabel.text = _email;
    ////    _phoneLabel.text = _phone;
    _genderLabel.text = _gender;
    NSLog(@"gender: %@", _gender);
}

-(void)setSwitches{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    [QBRequest objectsWithClassName:@"UserSettings" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *userObject = [objects objectAtIndex:i];
            if(userObject.userID == [QBSession currentSession].currentUser.ID){
                
                NSMutableDictionary *fields = userObject.fields;
                
                if([[fields objectForKey:@"findfacebookfriends"] intValue]== 0){                    [_facebookSwitch setOn:NO];
                }else{
                    [_facebookSwitch setOn:YES];
                }
                if([[fields objectForKey:@"findcontacts"] intValue] == 0){
                    [_contactSwitch setOn:NO];
                }else{
                    [_contactSwitch setOn:YES];
                }
                if([[fields objectForKey:@"showmeingymder"] intValue] == 0){
                    [_showmeSwitch setOn:NO];
                }else{
                    [_showmeSwitch setOn:YES];
                }
                if([[fields objectForKey:@"messagenotification"] intValue] == 0){
                    [_messagesSwitch setOn:NO];
                }else{
                    [_messagesSwitch setOn:YES];
                }
                if([[fields objectForKey:@"followersnotification"] intValue] == 0){
                    [_followersSwitch setOn:NO];
                }else{
                    [_followersSwitch setOn:YES];
                }
                if([[fields objectForKey:@"powsnotification"] intValue] == 0){
                    [_powSwitch setOn:NO];
                }else{
                    [_powSwitch setOn:YES];
                }
                if([[fields objectForKey:@"powsnotification"] intValue] == 0){
                    [_powSwitch setOn:NO];
                }else{
                    [_powSwitch setOn:YES];
                }
                if([[fields objectForKey:@"premium"] intValue] == 0){
                    [_premiumSwitch setOn:NO];
                }else{
                    [_premiumSwitch setOn:YES];
                }
            
            }}
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)updateUsername{
    _usernameLabel.text = _username;
}

-(void)updateInfo{
    _infoLabel.text = _info;

}

-(void)updatePhone{
    _phoneLabel.text = _phone;
}

-(void)updateEmail{
    _emailLabel.text = _email;
}

-(void)updateGender{
    _genderLabel.text = _gender;
}

-(void)updateGym{
    _gymLabel.text = _gym;
}

-(void)openWorkouts{
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
    WorkoutsViewController *workoutsVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"workoutsVC"];
    [self.navigationController pushViewController:workoutsVC animated:YES];
    workoutsVC.workouts = _workouts;
    workoutsVC.ownUserDataObject = _ownUserDataObject;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)openTextinputEdit:(NSString*)type{
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
    TextinputViewController *textinputVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"textinput"];
    textinputVC.navigationTitle = type;
    [self.navigationController pushViewController:textinputVC animated:YES];
}

-(void)openNumberEdit{
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
    NumberEditViewController *numberEditVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"numberedit"];

    [self.navigationController pushViewController:numberEditVC animated:YES];
}

-(void)openGenderEdit{
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
    GenderViewController *genderVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"gender"];
    genderVC.currentGender = _gender;
    [self.navigationController pushViewController:genderVC animated:YES];
}

-(void)openGymEdit{
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
    GymEditViewController *gymVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"gym"];
    gymVC.mainGym = [_ownUserDataObject.userData objectForKey:@"gym"];
    [self.navigationController pushViewController:gymVC animated:YES];
}

- (IBAction)tapWorkout:(id)sender {
    [self openWorkouts];
}
- (IBAction)editUsername:(id)sender {
    [self openTextinputEdit:@"username"];
}
- (IBAction)editInfo:(id)sender {
    [self openTextinputEdit:@"info"];
}
- (IBAction)editEmail:(id)sender {
    [self openTextinputEdit:@"email"];
}
- (IBAction)editAge:(id)sender {
    [self openNumberEdit];
}
- (IBAction)editPhone:(id)sender {
    [self openTextinputEdit:@"phone"];
}
- (IBAction)editGender:(id)sender {
    [self openGenderEdit];
}
- (IBAction)editGym:(id)sender {
    [self openGymEdit];
}

- (IBAction)switchMessages:(id)sender {
    if([_messagesSwitch isOn]){
        [self uploadSettings:@YES forSwitch:@"messagenotification"];
    }else{
        [self uploadSettings:@NO forSwitch:@"messagenotification"];
    }
}

- (IBAction)switchFollowers:(id)sender {
    if([_followersSwitch isOn]){
        [self uploadSettings:@YES forSwitch:@"followersnotification"];
    }else{
        [self uploadSettings:@NO forSwitch:@"followersnotification"];
    }
}

- (IBAction)switchPows:(id)sender {
    if([_powSwitch isOn]){
        [self uploadSettings:@YES forSwitch:@"powsnotification"];
    }else{
        [self uploadSettings:@NO forSwitch:@"powsnotification"];
    }
}

- (IBAction)switchPremium:(id)sender {
    if([_premiumSwitch isOn]){
        [self uploadSettings:@YES forSwitch:@"premium"];
    }else{
        [self uploadSettings:@NO forSwitch:@"premium"];
    }
}

- (IBAction)switchShowme:(id)sender {
    if([_showmeSwitch isOn]){
        [self uploadSettings:@YES forSwitch:@"showmeingymder"];
    }else{
        [self uploadSettings:@NO forSwitch:@"showmeingymder"];
    }
}

- (IBAction)switchFacebook:(id)sender {
    if([_facebookSwitch isOn]){
        [self uploadSettings:@YES forSwitch:@"findfacebookfriends"];
    }else{
        [self uploadSettings:@NO forSwitch:@"findfacebookfriends"];
    }
}

- (IBAction)switchContact:(id)sender {
    if([_contactSwitch isOn]){
        [self uploadSettings:@YES forSwitch:@"findcontacts"];
    }else{
        [self uploadSettings:@NO forSwitch:@"findcontacts"];
    }
}

- (IBAction)logOut:(id)sender {
    BOOL isLoggedIn = NO;
    if ([FBSDKAccessToken currentAccessToken]) {
        isLoggedIn = YES;
        NSLog(@"facebook logging out");
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginOrRegister"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:NO completion:NULL];
        
    }else{
        [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
            // Successful logout
            [self backToStartScreen];
        } errorBlock:^(QBResponse *response) {
            // Handle error
        }];
    }
}

-(void)backToStartScreen{
    NSLog(@"(Profile) Navigation children: %@", [self.navigationController childViewControllers]);
    __block NSInteger foundIndex = NSNotFound;
    NSLog(@"(Profile) Navigation child views: %@", _navigationVCs);
    
    [[self.navigationController childViewControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[RadarViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        [self.navigationController popToViewController:[[self.navigationController childViewControllers] objectAtIndex:foundIndex] animated:YES];
    }
}


-(void)uploadSettings:(NSNumber*)value forSwitch:(NSString*)key{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    [QBRequest objectsWithClassName:@"UserSettings" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *object = [objects objectAtIndex:i];
            if(object.userID == [QBSession currentSession].currentUser.ID){
                
                
                object.className = @"UserSettings"; // your Class name
                [object.fields setObject:value forKey:key];
                
                
                
                [QBRequest updateObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                    // do something when object is successfully created on a server
                } errorBlock:^(QBResponse *response) {
                    // error handling
                    NSLog(@"Response error: %@", [response.error description]);
                }];
                
            }}
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
        
    }];
    
}

- (IBAction)logOutTap:(id)sender {
    BOOL isLoggedIn = NO;
    if ([FBSDKAccessToken currentAccessToken]) {
        isLoggedIn = YES;
        NSLog(@"facebook logging out");
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginOrRegister"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:NO completion:NULL];
        
    }else{
        [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
            // Successful logout
            [self backToStartScreen];
        } errorBlock:^(QBResponse *response) {
            // Handle error
        }];
    }

}
@end
