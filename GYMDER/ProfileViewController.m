//
//  ProfileViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 10.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ProfileViewController.h"
#import "ShootViewController.h"
#import "EditProfileViewController.h"
#import "ChatViewController.h"
@import Quickblox;

@interface ProfileViewController (){
    NSMutableArray *workOutCircles;
    UILabel *label;
    BOOL followed;
    int follower;
    BOOL powed;
    int power;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [_background setBackgroundColor:[UIColor colorWithRed:0.337f green:0.337f blue:0.337f alpha:1.00f]];
    [_background addGestureRecognizer:_rightSwipeGesture];
    _profileImage.layer.cornerRadius = _profileImage.bounds.size.width/2;
    _profileImage.image = _image;
    [_profileImage addGestureRecognizer:_profilePhotoTapGesture];
    
    NSLog(@"Own user data: %@", _ownUserData);
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width/2, 44);
    label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@%@%@", [_ownUserData objectForKey:@"gymdername"], @", ",[_ownUserData objectForKey:@"age"]];
    label.font=[label.font fontWithSize:20];
    self.navigationItem.titleView = label;
    
    _pows.text = [NSString stringWithFormat:@"%@%@", [_ownUserData objectForKey:@"pows"], @" POWs"];
    _gym.text = [_ownUserData objectForKey:@"gym"];
    NSString *infoText = [[_ownUserData objectForKey:@"info"] objectAtIndex:0];
    _info.text = infoText;
    
    _followers.text = [NSString stringWithFormat:@"%lu%@", [[_ownUserData objectForKey:@"followers" ] count], @" Follower"];
    _following.text = [NSString stringWithFormat:@"%lu%@", [[_ownUserData objectForKey:@"following" ] count], @" Following"];
    follower = (int)[[_ownUserData objectForKey:@"followers"]count];
    
    if([_ownUserData objectForKey:@"powpeople"] != nil){
        power = (int)[[_ownUserData objectForKey:@"powpeople"]count];
    }else{
        power = 0;
    }
    
    _profileImage.layer.borderWidth = 3.0;
    _profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [self workoutColor:[_ownUserData objectForKey:@"workouts"]];
    
    if(_ownProfile){
        _powButton.hidden = YES;
        _followButton.hidden = YES;
        _chatButton.hidden = YES;
        [self.view bringSubviewToFront:_powButton];
        [self.view bringSubviewToFront:_chatButton];
        [self.view bringSubviewToFront:_followButton];
    }else{
        _settingsIcon.hidden = YES;
        _settingsLabel.hidden = YES;
        _profileImage.userInteractionEnabled = NO;
        [self followOrUnfollowed];
    }
    
    [_settingsIcon addGestureRecognizer:_profileSettingsTap];
    [_settingsLabel addGestureRecognizer:_profileSettingsTap2];
 
    
    workOutCircles = [NSMutableArray new];
    
    
    
    // 1
    NSMutableDictionary *workoutCircle1 = [NSMutableDictionary new];
    [workoutCircle1 setObject:_workout1View forKey:@"workoutView"];
    [workoutCircle1 setObject:_workout1Label forKey:@"workoutLabel"];
    [workOutCircles addObject:workoutCircle1];
    
    // 2
    NSMutableDictionary *workoutCircle2 = [NSMutableDictionary new];
    [workoutCircle2 setObject:_workout2View forKey:@"workoutView"];
    [workoutCircle2 setObject:_workout2Label forKey:@"workoutLabel"];
    [workOutCircles addObject:workoutCircle2];
    
    // 3
    NSMutableDictionary *workoutCircle3 = [NSMutableDictionary new];
    [workoutCircle3 setObject:_workout3View forKey:@"workoutView"];
    [workoutCircle3 setObject:_workout3Label forKey:@"workoutLabel"];
    [workOutCircles addObject:workoutCircle3];
    
    // 4
    NSMutableDictionary *workoutCircle4 = [NSMutableDictionary new];
    [workoutCircle4 setObject:_workout4View forKey:@"workoutView"];
    [workoutCircle4 setObject:_workout4Label forKey:@"workoutLabel"];
    [workOutCircles addObject:workoutCircle4];
    
    // 5
    NSMutableDictionary *workoutCircle5 = [NSMutableDictionary new];
    [workoutCircle5 setObject:_workout5View forKey:@"workoutView"];
    [workoutCircle5 setObject:_workout5Label forKey:@"workoutLabel"];
    [workOutCircles addObject:workoutCircle5];
    
    // 6
    NSMutableDictionary *workoutCircle6 = [NSMutableDictionary new];
    [workoutCircle6 setObject:_workout6View forKey:@"workoutView"];
    [workoutCircle6 setObject:_workout6Label forKey:@"workoutLabel"];
    [workOutCircles addObject:workoutCircle6];
    
   
    
    if(![self iPhone6PlusDevice]){
        [self workoutCiclesForiPhone5];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Profile appeared; Workouts are: %@", [_ownUserData objectForKey:@"gymdername"]);
    [self setWorkoutCircles:[_ownUserData objectForKey:@"workouts"]];
    [self updateContent];
}

-(void)updateContent{
    NSLog(@"Update Content");
    label.text = [NSString stringWithFormat:@"%@%@%@", [_ownUserData objectForKey:@"gymdername"], @", ",[_ownUserData objectForKey:@"age"]];
    _info.text = [[_ownUserData objectForKey:@"info"]objectAtIndex:0];

}

-(void)viewDidLayoutSubviews{
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width *0.5;
    _workout1View.layer.cornerRadius = _workout1View.frame.size.width/2;
    _workout2View.layer.cornerRadius = _workout2View.frame.size.width/2;
    _workout3View.layer.cornerRadius = _workout3View.frame.size.width/2;
    _workout4View.layer.cornerRadius = _workout4View.frame.size.width/2;
    _workout5View.layer.cornerRadius = _workout5View.frame.size.width/2;
    _workout6View.layer.cornerRadius = _workout6View.frame.size.width/2;
    
    
    if(![self iPhone6PlusDevice]){
        
        _workout2View.frame = CGRectMake(_workout2View.frame.origin.x, _workout2View.frame.origin.y-8, _workout2View.frame.size.width, _workout2View.frame.size.height);
        _workout3View.frame = CGRectMake(_workout3View.frame.origin.x, _workout3View.frame.origin.y-15, _workout3View.frame.size.width, _workout3View.frame.size.height);
        _workout4View.frame = CGRectMake(_workout4View.frame.origin.x, _workout4View.frame.origin.y-18, _workout4View.frame.size.width, _workout4View.frame.size.height);
        _workout5View.frame = CGRectMake(_workout5View.frame.origin.x-5, _workout5View.frame.origin.y-22, _workout5View.frame.size.width, _workout5View.frame.size.height);
        _workout6View.frame = CGRectMake(_workout6View.frame.origin.x-8, _workout6View.frame.origin.y-22, _workout6View.frame.size.width, _workout6View.frame.size.height);
        
        for(NSMutableDictionary *cicleDict in workOutCircles){
            UILabel *workoutLabel = [cicleDict objectForKey:@"workoutLabel"];
            [workoutLabel setFont:[UIFont fontWithName:@"ClanOffcPro-Ultra" size:8]];
        
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

-(BOOL)iPhone6PlusDevice{
    if (!IS_PHONE) return NO;
    if ([UIScreen mainScreen].scale > 2.9) return YES;   // Scale is only 3 when not in scaled mode for iPhone 6 Plus
    return NO;
}

-(void)workoutCiclesForiPhone5{
    for(int i = 0; i < [workOutCircles count]; i++){
        UIView *workoutView = [[workOutCircles objectAtIndex:i] objectForKey:@"workoutView"];
        workoutView.frame = CGRectMake(workoutView.frame.origin.x + 20, workoutView.frame.origin.y, workoutView.frame.size.width, workoutView.frame.size.height);
    }
}

-(void)clearCicles{
    for(int i = 0; i < [workOutCircles count];i++){
        UIView *workoutView = [[workOutCircles objectAtIndex:i] objectForKey:@"workoutView"];
        UILabel *workoutLabel = [[workOutCircles objectAtIndex:i]
                                 objectForKey:@"workoutLabel"];
        workoutView.backgroundColor = [UIColor clearColor];
        workoutLabel.text = @"";
    }
}

-(void)setWorkoutCircles:(NSMutableArray*)workouts{
    for(int i = 0; i < [[_ownUserData objectForKey:@"workouts"] count]; i++){
        UIView *workoutView = [[workOutCircles objectAtIndex:i] objectForKey:@"workoutView"];
        UILabel *workoutLabel = [[workOutCircles objectAtIndex:i]
                                 objectForKey:@"workoutLabel"];
        if([[workouts objectAtIndex:i] isEqualToString:@"hardcore"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.173f green:0.192f blue:0.208f alpha:1.00f];
            workoutLabel.text = @"HARD\nCORE";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"hiit"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.204f green:0.196f blue:0.149f alpha:1.00f];
            workoutLabel.text = @"HIIT";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"combat"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.204f green:0.169f blue:0.180f alpha:1.00f];
            workoutLabel.text = @"COM\nBAT";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"lift"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.243f green:0.275f blue:0.286f alpha:1.00f];
            workoutLabel.text = @"LIFT";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"spin"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.349f green:0.341f blue:0.259f alpha:1.00f];
            workoutLabel.text = @"SPIN";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"bootcamp"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.282f green:0.247f blue:0.259f alpha:1.00f];
            workoutLabel.text = @"BOOT\nCAMP";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"equipment"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.349f green:0.384f blue:0.400f alpha:1.00f];
            workoutLabel.text = @"EQUIP\nMENT";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"run"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.494f green:0.494f blue:0.373f alpha:1.00f];
            workoutLabel.text = @"RUN";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"team"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.400f green:0.353f blue:0.369f alpha:1.00f];
            workoutLabel.text = @"TEAM";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"crossfit"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.424f green:0.467f blue:0.486f alpha:1.00f];
            workoutLabel.text = @"CROSS\nFIT";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"cardio"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.647f green:0.631f blue:0.482f alpha:1.00f];
            workoutLabel.text = @"CAR\nDIO";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"dance"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.475f green:0.416f blue:0.439f alpha:1.00f];
            workoutLabel.text = @"DANCE";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"bodyweight"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.502f green:0.573f blue:0.596f alpha:1.00f];
            workoutLabel.text = @"BODY\nWEIGHT";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"fatburn"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.796f green:0.792f blue:0.584f alpha:1.00f];
            workoutLabel.text = @"FAT\nBURN";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"pilates"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.608f green:0.522f blue:0.553f alpha:1.00f];
            workoutLabel.text = @"PILA\nTES";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"free"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.600f green:0.659f blue:0.682f alpha:1.00f];
            workoutLabel.text = @"FREE";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"walk"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.894f green:0.878f blue:0.659f alpha:1.00f];
            workoutLabel.text = @"WALK";
        }
        else if([[workouts objectAtIndex:i] isEqualToString:@"yoga"]){
            workoutView.backgroundColor = [UIColor colorWithRed:0.682f green:0.604f blue:0.624f alpha:1.00f];
            workoutLabel.text = @"YOGA";
        }

    }
}

-(void)workoutColor:(NSMutableArray*)workouts{
    if([[workouts objectAtIndex:0] isEqualToString:@"hardcore"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.173f green:0.192f blue:0.208f alpha:1.00f].CGColor;
        _workout1View.backgroundColor = [UIColor colorWithRed:0.173f green:0.192f blue:0.208f alpha:1.00f];
        _workout1Label.text = @"HARD\nCORE";
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"hiit"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.204f green:0.196f blue:0.149f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"combat"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.204f green:0.169f blue:0.180f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"lift"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.243f green:0.275f blue:0.286f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"spin"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.349f green:0.341f blue:0.259f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"bootcamp"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.282f green:0.247f blue:0.259f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"equipment"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.349f green:0.384f blue:0.400f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"run"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.494f green:0.494f blue:0.373f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"team"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.400f green:0.353f blue:0.369f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"crossfit"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.424f green:0.467f blue:0.486f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"cardio"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.647f green:0.631f blue:0.482f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"dance"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.475f green:0.416f blue:0.439f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"bodyweight"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.502f green:0.573f blue:0.596f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"fatburn"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.796f green:0.792f blue:0.584f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"pilates"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.608f green:0.522f blue:0.553f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"free"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.600f green:0.659f blue:0.682f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"walk"]){
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.894f green:0.878f blue:0.659f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"yoga"]){
        
        _profileImage.layer.borderColor = [UIColor colorWithRed:0.682f green:0.604f blue:0.624f alpha:1.00f].CGColor;
    }
}

-(void)followOrUnfollowed{
   
    NSLog(@"Follow: %@", [_ownUserData objectForKey:@"followers" ]);
    if([[_ownUserData objectForKey:@"followers"] containsObject:[NSString stringWithFormat:@"%lu", [QBSession currentSession].currentUser.ID]]){
        [_followButton setImage:[UIImage imageNamed:@"PROFILE FOLLOWSELECTED.png"] forState:UIControlStateNormal];
        followed = YES;
    }else{
         [_followButton setImage:[UIImage imageNamed:@"PROFILE FOLLOW.png"] forState:UIControlStateNormal];
        followed = NO;
    }
    
}

-(void)powedOrUnpowed{
    if([[_ownUserData objectForKey:@"powpeople"] containsObject:[NSString stringWithFormat:@"%lu", [QBSession currentSession].currentUser.ID]]){
        [_powButton setImage:[UIImage imageNamed:@"PROFILE POW SELECTED.png"] forState:UIControlStateNormal];
        powed = YES;
    }else{
        [_powButton setImage:[UIImage imageNamed:@"PROFILE POW.png"] forState:UIControlStateNormal];
        powed = NO;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)profileImageToImageView:(UIImage*)image{
    [_profileImage setImage:image];
}

- (IBAction)rightSwipe:(id)sender {
  
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromLeft;
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (IBAction)profileImageTap:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Profile Photo" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [actionSheet dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    //    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    //
    //        // Distructive button tapped.
    //        [self dismissViewControllerAnimated:YES completion:^{
    //        }];
    //    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"From library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Open gallery.
        UIImagePickerController *ipc= [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            [self presentViewController:ipc animated:YES completion:nil];
        else
        {
           
        }
        [actionSheet dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Open Camera.
        UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
        UINavigationController *shootNavigationController = [cameraStoryboard instantiateViewControllerWithIdentifier:@"shootNavigation"];
        
        ShootViewController *shootViewController = [[shootNavigationController childViewControllers] objectAtIndex:0];
        shootViewController.profilePhoto = YES;

        [self showViewController:shootNavigationController sender:self];

        
        
        [actionSheet dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        
    }
    //self.image.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // self.image.image = chosenImage;
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [imagePath lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSLog(@"localFilePath.%@",localFilePath);
    
    
    
    [_profileImage setImage:chosenImage];
    [_ownUserDataObject.userData setObject:chosenImage forKey:@"userimage"];
    [self uploadNewProfileImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
   // [self prepareUploadTokenImage:imageData];
    // Upload new image to Quickblox
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uploadNewProfileImage:(UIImage*)image{
    QBCOFile *file = [QBCOFile file];
    file.name = @"profilePic";
    file.contentType = @"image/jpg";
    file.data =  UIImageJPEGRepresentation(image, 1.0);;
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"ProfilePics" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        QBCOCustomObject *userObject = [objects objectAtIndex:0];
       
        [QBRequest uploadFile:file className:@"ProfilePics" objectID:userObject.ID fileFieldName:@"pic" successBlock:^(QBResponse * _Nonnull response, QBCOFileUploadInfo * _Nullable info) {
            //
            NSLog(@"Pic was uploaded");
            NSLog(@"Info: %@", info);
        } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
            //
            NSLog(@"Status %f", status.percentOfCompletion);
        } errorBlock:^(QBResponse * _Nonnull response) {
            //
            NSLog(@"Error: %@", [response.error description]);
        }];

        
            } errorBlock:^(QBResponse *response) {
        // If no profile pic for current user: create new profile pic
        NSLog(@"Response error: %@", [response.error description]);

        
    }];

}

-(void)openWorkouts{
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
    UIViewController *workoutsVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"workoutsVC"];
    [self.navigationController pushViewController:workoutsVC animated:YES];
}

- (IBAction)plus:(id)sender {
  
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)profileSettingsTap:(id)sender {
    [self openEditProfile];
}
- (IBAction)profileSettingsTap2:(id)sender {
    [self openEditProfile];
}
-(void)openEditProfile{
    EditProfileViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editProfile"];
    [self.navigationController pushViewController:editVC animated:YES];
    editVC.image = _profileImage.image;
    editVC.mainWorkoutColor = _profileImage.layer.borderColor;
    editVC.color1 = _workout1View.backgroundColor;
    editVC.color2 = _workout2View.backgroundColor;
    editVC.color3 = _workout3View.backgroundColor;
    editVC.color4 = _workout4View.backgroundColor;
    editVC.color5 = _workout5View.backgroundColor;
    editVC.color6 = _workout6View.backgroundColor;
    
    editVC.workout1 = _workout1Label.text;
    editVC.workout2 = _workout2Label.text;
    editVC.workout3 = _workout3Label.text;
    editVC.workout4 = _workout4Label.text;
    editVC.workout5 = _workout5Label.text;
    editVC.workout6 = _workout6Label.text;
    
    
    editVC.username = [_ownUserData objectForKey:@"gymdername"];
    editVC.age = [_ownUserData objectForKey:@"age"];
    editVC.gym = [_ownUserData objectForKey:@"gym"];
    editVC.info = [[_ownUserData objectForKey:@"info"] objectAtIndex:0];
    editVC.email = [_ownUserData objectForKey:@"email"];
    editVC.phone = [_ownUserData objectForKey:@"phone"];
    NSLog(@"Gender: %@", [_ownUserData objectForKey:@"gender"]);
    editVC.gender = [_ownUserData objectForKey:@"gender"];
    editVC.workouts = [_ownUserData objectForKey:@"workouts"];
    
    editVC.navigationVCs = _navigationVCs;
}

-(void)powOrUnpow{
    if(powed){
        [_powButton setSelected:NO];
        [_powButton setImage:[UIImage imageNamed:@"PROFILE POW.png"] forState:UIControlStateNormal];
        [self updatePowing:0];
    }else{
        [_powButton setSelected:YES];
        [_powButton setImage:[UIImage imageNamed:@"PROFILE POW SELECTED.png"] forState:UIControlStateNormal];
        [self updatePowing:1];
        //[ptVC addFollowToActivity];
    }
}

-(void)updatePowing:(int)action{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[_ownUserData objectForKey:@"user_id"] forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        
        QBCOCustomObject *object = [objects objectAtIndex:0];
        NSMutableArray *powpeople = [object.fields mutableArrayValueForKey:@"powpeople"];
        [self updatePowing:powpeople withID:object.ID andAction:action];
       
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
   
}

-(void)updatePowing:(NSMutableArray*)toUpdate withID:(NSString *)objectID andAction:(int)action{
    
    QBCOCustomObject *updateObject = [QBCOCustomObject customObject];
    updateObject.className = @"UserProperties";
    updateObject.ID = objectID;
    
    if(action == 1){
        [toUpdate addObject:[NSString stringWithFormat:@"%lu", [QBSession currentSession].currentUser.ID]];
        powed = YES;
        [_powButton setImage:[UIImage imageNamed:@"PROFILE POW SELECTED.png"] forState:UIControlStateNormal];

    }else{
        [toUpdate removeObject:[NSString stringWithFormat:@"%lu", [QBSession currentSession].currentUser.ID]];
        powed = NO;
        [_powButton setImage:[UIImage imageNamed:@"PROFILE POW.png"] forState:UIControlStateNormal];
    }
    
    [updateObject.fields setObject:toUpdate forKey:@"powpeople"];
    
    [QBRequest updateObject:updateObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
        // do something when object is successfully created on a server
        NSLog(@"Updated powing");
        if(powed){
            _pows.text = [NSString stringWithFormat:@"%d%@", power += 1, @" POWs"];
        }else{
            _pows.text = [NSString stringWithFormat:@"%d%@", power -= 1, @" POWs"];
        }
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}



-(void)followOrUnfollow{
    if(followed){
        [self.followButton setSelected:NO];
        [self deleteIAmFollowing];
        [self deleteFollowingMe];
        [_followButton setImage:[UIImage imageNamed:@"PROFILE FOLLOW.png"] forState:UIControlStateNormal];
    }else{
        [self.followButton setSelected:YES];
        [self addIAmFollowing];
        [self addFollowingMe];
        [_followButton setImage:[UIImage imageNamed:@"PROFILE FOLLOWSELECTED.png"] forState:UIControlStateNormal];
        //[ptVC addFollowToActivity];
    }
}

-(void)addIAmFollowing{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        
            QBCOCustomObject *object = [objects objectAtIndex:0];
            if(object.userID == [QBSession currentSession].currentUser.ID){
                NSMutableDictionary *fields = object.fields;
                
                NSMutableArray *iAmFollowing = [fields mutableArrayValueForKey:@"iamfollowing"];
                //                NSLog(@"I am following before %@", iAmFollowing);
                [iAmFollowing addObject:[_ownUserData objectForKey:@"user_id"]];
                NSLog(@"I am following %@", iAmFollowing);
                [self updateIAmFollowing:iAmFollowing withID:object.ID];
                followed = YES;
                
            }
        
        
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}



-(void)addFollowingMe{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *object = [objects objectAtIndex:i];
            if(object.userID == [[_ownUserData objectForKey:@"user_id"] intValue]){
                NSMutableDictionary *fields = object.fields;
                
                NSMutableArray *followingMe = [fields mutableArrayValueForKey:@"followingme"];
                
                //                NSLog(@"I am following before %@", iAmFollowing);
                [followingMe addObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID]];
                NSLog(@"Following Me %@", followingMe);
                [self updateFollowingMe:followingMe withID:object.ID];
                
            }
        }
        
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    
}

-(void)deleteFollowingMe{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *object = [objects objectAtIndex:i];
            if(object.userID == [[_ownUserData objectForKey:@"user_id"] intValue]){
                NSMutableDictionary *fields = object.fields;
                
                NSMutableArray *followingMe = [fields mutableArrayValueForKey:@"followingme"];
                // NSLog(@"Following Me before %@", followingMe);
                NSString *toDelete;
                for(int i = 0; i < [followingMe count]; i++){
                    toDelete = [followingMe objectAtIndex:i];
                    if([toDelete isEqualToString:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID]]){
                        [followingMe removeObjectAtIndex:i];
                        
                    }
                }
                // NSLog(@"Following me %@", followingMe);
                [self updateFollowingMe:followingMe withID:object.ID];
                
            }
        }
        
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)deleteIAmFollowing{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"User ID"];
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *object = [objects objectAtIndex:i];
            if(object.userID == [QBSession currentSession].currentUser.ID){
                NSMutableDictionary *fields = object.fields;
                
                NSMutableArray *iAmFollowing = [fields mutableArrayValueForKey:@"iamfollowing"];
                NSLog(@"I am following before %@", iAmFollowing);
                NSString *toDelete;
                for(int i = 0; i < [iAmFollowing count]; i++){
                    toDelete = [iAmFollowing objectAtIndex:i];
                    if([toDelete isEqualToString:[_ownUserData objectForKey:@"user_id"]]){
                        [iAmFollowing removeObjectAtIndex:i];
                        
                    }
                }
                NSLog(@"I am following %@", iAmFollowing);
                [self updateIAmFollowing:iAmFollowing withID:object.ID];
                [self insertEmptyIfNull];
                followed = NO;

                
            }
        }
        
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)updateFollowingMe:(NSMutableArray*)toUpdate withID:(NSString *)objectID{
    NSLog(@"Update following me");
    QBCOCustomObject *updateObject = [QBCOCustomObject customObject];
    updateObject.className = @"Follow";
    [updateObject.fields setObject:toUpdate forKey:@"followingme"];
    updateObject.ID = objectID;
    
    
    [QBRequest updateObject:updateObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
        // do something when object is successfully created on a server
        NSLog(@"Updated following me");
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)updateIAmFollowing:(NSMutableArray*)toUpdate withID:(NSString *)objectID{
    QBCOCustomObject *updateObject = [QBCOCustomObject customObject];
    updateObject.className = @"Follow";
    [updateObject.fields setObject:toUpdate forKey:@"iamfollowing"];
    updateObject.ID = objectID;
    
    
    [QBRequest updateObject:updateObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
        // do something when object is successfully created on a server
        NSLog(@"Updated you are following");
        if(followed){
            _followers.text = [NSString stringWithFormat:@"%d%@", follower += 1, @" Follower"];
        }else{
            _followers.text = [NSString stringWithFormat:@"%d%@", follower -= 1, @" Follower"];
        }
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)insertEmptyIfNull{
    NSLog(@"Insert empty if null");
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing

            QBCOCustomObject *object = [objects objectAtIndex:0];
            if(object.userID == [QBSession currentSession].currentUser.ID){
                NSMutableDictionary *fields = object.fields;
                
                
                if([fields mutableArrayValueForKey:@"iamfollowing"] == nil){
                    NSMutableArray *iAmFollowing = [[NSMutableArray alloc]init];
                    [iAmFollowing addObject:@" "];
                    [self updateIAmFollowing:iAmFollowing withID:object.ID];
                }
                
                
            }
        
        
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)updateTotalPows:(NSUInteger)userID{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:@(userID) forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        QBCOCustomObject *powsCountObject = [objects objectAtIndex:0];
        int count = [[powsCountObject.fields objectForKey:@"pows"] intValue];
        count += 1;
        [powsCountObject.fields setValue:@(count) forKey:@"pows"];
        [QBRequest updateObject:powsCountObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated, update pows count in User Properties
           // [self addPowToActivity];
            
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error pows: %@", [response.error description]);
        }];
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error pows: %@", [response.error description]);
    }];
    
}


- (IBAction)chatTap:(id)sender {
}
- (IBAction)followTap:(id)sender {
}

- (IBAction)chat:(id)sender {
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatViewController *chat = [cameraStoryboard instantiateViewControllerWithIdentifier:@"chat"];
    [self getUserByID:[[_ownUserData objectForKey:@"user_id"] integerValue] forChatVC:chat];
    
}

-(void)getUserByID:(NSInteger)userID forChatVC:(ChatViewController*)chatVC{
    [QBRequest userWithID:userID successBlock:^(QBResponse *response, QBUUser *user) {
        // Successful response with user
        chatVC.chatPartner = user;
        chatVC.chatPartnerID = user.ID;
        chatVC.chatPartnerImage = _image;
        chatVC.chatPartnerGymderName = label.text;
        [self.navigationController pushViewController:chatVC animated:YES];
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];
}

- (IBAction)follow:(id)sender {
    [self followOrUnfollow];
}

- (IBAction)pow:(id)sender {
    if(powed){
        [self updatePowing:0];
    }else{
        [self updatePowing:1];
    }
}
@end
