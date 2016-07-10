//
//  ArenaViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 22.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ArenaViewController.h"
#import "ProfileSexyViewController.h"
#import "ExploreViewController.h"
#import "RadarViewController.h"
#import "ShootViewController.h"
#import "ProfileViewController.h"
#import "OtherUserData.h"
@import Quickblox;

@interface ArenaViewController (){
    UIVisualEffectView *blurEffectView;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSMutableArray *objectsDescending;
    NSMutableArray *contentHolders;
    ProfileViewController *profileVC;
    OtherUserData *otherUserData;
    UINavigationController *profileNav;
}

@end

@implementation ArenaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    otherUserData = [[OtherUserData alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherUserData:) name:@"OtherUserDataArena" object:nil];
    
    objectsDescending = [NSMutableArray new];
    contentHolders = [NSMutableArray new];
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self.view addGestureRecognizer:_leftSwipe];
    [self.view addGestureRecognizer:_rightSwipe];
    [self.view addGestureRecognizer:_tapBeside];
    [_navigationButton addGestureRecognizer:_longPress];
    
    [_radarMenuIcon addGestureRecognizer:_tapRadar];
    [_profileMenuIcon addGestureRecognizer:_tapProfile];
    [_exploreMenuIcon addGestureRecognizer:_tapExplore];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    _menuView.hidden = YES;
    
    [_upSwipeArea addGestureRecognizer:_upSwipe];
    
    self.navigationController.navigationItem.title = @"";
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [self contentHoldersToArray];
    [self getTopTenUsers];
}

-(void)viewDidLayoutSubviews{
    _firstImage.layer.cornerRadius = _firstImage.frame.size.width/2;
    _firstImage.layer.borderWidth = 3;
    [_firstImage addGestureRecognizer:_firstImageTap];
    _secondImage.layer.cornerRadius = _secondImage.frame.size.width/2;
    _secondImage.layer.borderWidth = 3;
    [_secondImage addGestureRecognizer:_secondImageTap];
    _thirdImage.layer.cornerRadius = _thirdImage.frame.size.width/2;
    _thirdImage.layer.borderWidth = 3;
    [_thirdImage addGestureRecognizer:_thirdImageTap];
    _fourthImage.layer.cornerRadius = _fourthImage.frame.size.width/2;
    _fourthImage.layer.borderWidth = 3;
    [_fourthImage addGestureRecognizer:_fourthImageTap];
    _fifthImage.layer.cornerRadius = _fifthImage.frame.size.width/2;
    _fifthImage.layer.borderWidth = 3;
    [_fifthImage addGestureRecognizer:_fifthImageTap];
    _sixthImage.layer.cornerRadius = _sixthImage.frame.size.width/2;
    _sixthImage.layer.borderWidth = 3;
    [_sixthImage addGestureRecognizer:_sixthImageTap];
    _seventhImage.layer.cornerRadius = _seventhImage.frame.size.width/2;
    _seventhImage.layer.borderWidth = 3;
    [_seventhImage addGestureRecognizer:_seventhImageTap];
    _eigthImage.layer.cornerRadius = _eigthImage.frame.size.width/2;
    _eigthImage.layer.borderWidth = 3;
    [_eigthImage addGestureRecognizer:_eighthImageTap];
    _ninethImage.layer.cornerRadius = _ninethImage.frame.size.width/2;
    _ninethImage.layer.borderWidth = 3;
    [_ninethImage addGestureRecognizer:_ninethImageTap];
    _tenthImage.layer.cornerRadius = _tenthImage.frame.size.width/2;
    _tenthImage.layer.borderWidth = 3;
    [_tenthImage addGestureRecognizer:_tenthImageTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)contentHoldersToArray{
    NSMutableDictionary *content1 = [NSMutableDictionary new];
    [content1 setObject:_firstImage forKey:@"image"];
    [content1 setObject:_firstName forKey:@"name"];
    [content1 setObject:_firstPows forKey:@"pows"];
    
    NSMutableDictionary *content2 = [NSMutableDictionary new];
    [content2 setObject:_secondImage forKey:@"image"];
    [content2 setObject:_secondName forKey:@"name"];
    [content2 setObject:_secondPows forKey:@"pows"];
    
    NSMutableDictionary *content3 = [NSMutableDictionary new];
    [content3 setObject:_thirdImage forKey:@"image"];
    [content3 setObject:_thirdName forKey:@"name"];
    [content3 setObject:_thirdPows forKey:@"pows"];
    
    NSMutableDictionary *content4 = [NSMutableDictionary new];
    [content4 setObject:_fourthImage forKey:@"image"];
    [content4 setObject:_fourthName forKey:@"name"];
    [content4 setObject:_fourthPows forKey:@"pows"];
    
    NSMutableDictionary *content5 = [NSMutableDictionary new];
    [content5 setObject:_fifthImage forKey:@"image"];
    [content5 setObject:_fifthName forKey:@"name"];
    [content5 setObject:_fifthPows forKey:@"pows"];
    
    NSMutableDictionary *content6 = [NSMutableDictionary new];
    [content6 setObject:_sixthImage forKey:@"image"];
    [content6 setObject:_sixthName forKey:@"name"];
    [content6 setObject:_sixthPows forKey:@"pows"];
    
    NSMutableDictionary *content7 = [NSMutableDictionary new];
    [content7 setObject:_seventhImage forKey:@"image"];
    [content7 setObject:_seventhName forKey:@"name"];
    [content7 setObject:_seventhPows forKey:@"pows"];
    
    NSMutableDictionary *content8 = [NSMutableDictionary new];
    [content8 setObject:_eigthImage forKey:@"image"];
    [content8 setObject:_eigthName forKey:@"name"];
    [content8 setObject:_eigthPows forKey:@"pows"];
    
    NSMutableDictionary *content9 = [NSMutableDictionary new];
    [content9 setObject:_ninethImage forKey:@"image"];
    [content9 setObject:_ninethName forKey:@"name"];
    [content9 setObject:_ninethPows forKey:@"pows"];
    
    NSMutableDictionary *content10 = [NSMutableDictionary new];
    [content10 setObject:_tenthImage forKey:@"image"];
    [content10 setObject:_tenthName forKey:@"name"];
    [content10 setObject:_tenthPows forKey:@"pows"];
    
    [contentHolders addObject:content1];
    [contentHolders addObject:content2];
    [contentHolders addObject:content3];
    [contentHolders addObject:content4];
    [contentHolders addObject:content5];
    [contentHolders addObject:content6];
    [contentHolders addObject:content7];
    [contentHolders addObject:content8];
    [contentHolders addObject:content9];
    [contentHolders addObject:content10];

}

-(void)workoutColor:(NSString*)workout toImageView:(UIImageView*)imageView{
    if([workout isEqualToString:@"hardcore"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.173f green:0.192f blue:0.208f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"hiit"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.204f green:0.196f blue:0.149f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"combat"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.204f green:0.169f blue:0.180f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"lift"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.243f green:0.275f blue:0.286f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"spin"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.349f green:0.341f blue:0.259f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"bootcamp"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.282f green:0.247f blue:0.259f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"equipment"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.349f green:0.384f blue:0.400f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"run"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.494f green:0.494f blue:0.373f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"team"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.400f green:0.353f blue:0.369f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"crossfit"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.424f green:0.467f blue:0.486f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"cardio"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.647f green:0.631f blue:0.482f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"dance"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.475f green:0.416f blue:0.439f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"bodyweight"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.502f green:0.573f blue:0.596f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"fatburn"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.796f green:0.792f blue:0.584f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"pilates"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.608f green:0.522f blue:0.553f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"free"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.600f green:0.659f blue:0.682f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"walk"]){
        imageView.layer.borderColor = [UIColor colorWithRed:0.894f green:0.878f blue:0.659f alpha:1.00f].CGColor;
    }
    else if([workout isEqualToString:@"yoga"]){
        
        imageView.layer.borderColor = [UIColor colorWithRed:0.682f green:0.604f blue:0.624f alpha:1.00f].CGColor;
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

- (IBAction)rightSwipe:(id)sender {
    
}
- (IBAction)leftSwipe:(id)sender {
    NSLog(@"(Arena) Navigation children: %@", [self.navigationController childViewControllers]);
    __block NSInteger foundIndex = NSNotFound;
    __block NSInteger foundIndex2 = NSNotFound;
    NSLog(@"Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ExploreViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        if(![self.navigationController.topViewController isKindOfClass:[ExploreViewController class]]){
            NSLog(@"Show Explore");
            [[self.navigationController childViewControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[ExploreViewController class]]) {
                    foundIndex2 = idx;
                    if (foundIndex2 != NSNotFound) {
                        NSMutableArray *copy = [[self.navigationController childViewControllers] mutableCopy];
                        [copy removeObject:[copy objectAtIndex:foundIndex2]];
                        [self.navigationController setViewControllers:copy];
                    }
                    // stop the enumeration
                    *stop = YES;
                }
            }];
            
            [self.navigationController showViewController:[_navigationVCs objectAtIndex:foundIndex] sender:self];
            
        }
        
    }else{
        NSLog(@"New Arena: %@", [self.navigationController childViewControllers]);
        UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"ArenaExplore" bundle:nil];
        ExploreViewController *explore = [cameraStoryboard instantiateViewControllerWithIdentifier:@"explore"];
        [explore setNavigationVCs:_navigationVCs];

        [self.navigationController showViewController:explore sender:self];
    }

}

- (IBAction)longPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.navigationController.navigationBar.hidden = YES;
        [self blurredFilterForBackground];
        [self.view bringSubviewToFront:_menuView];
        [self fadeNavigationMenuIn];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {

    }
}

-(void)blurredFilterForBackground{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:blurEffectView];
        
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
}


// Profile Overview View Controller: Mentally right from radar view

-(void)openProfileSexyViewController{
    __block NSInteger foundIndex = NSNotFound;
    __block NSInteger foundIndex2 = NSNotFound;
    NSLog(@"(Arena) Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ProfileSexyViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        if(![self.navigationController.topViewController isKindOfClass:[ProfileSexyViewController class]]){
            NSLog(@"Show Profile Overview");
            [[self.navigationController childViewControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[ProfileSexyViewController class]]) {
                    foundIndex2 = idx;
                    if (foundIndex2 != NSNotFound) {
                        NSMutableArray *copy = [[self.navigationController childViewControllers] mutableCopy];
                        [copy removeObject:[copy objectAtIndex:foundIndex2]];
                        [self.navigationController setViewControllers:copy];
                    }
                    // stop the enumeration
                    *stop = YES;
                }
            }];
            
            [self.navigationController showViewController:[_navigationVCs objectAtIndex:foundIndex] sender:self];
            
        }
        
    }else{
        NSLog(@"New Profile Overview: %@", [self.navigationController childViewControllers]);
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ProfileSexyViewController *profileSexy = [mainStoryboard instantiateViewControllerWithIdentifier:@"profilesexy"];
        //        [profileSexy setOwnProfileImage:ownProfileImage];
        //
        //        [profileSexy setOwnUserDataObject:_ownUserData];
        
        NSMutableArray *vcs =  [[self.navigationController childViewControllers] mutableCopy];
        [vcs insertObject:profileSexy atIndex:[vcs count]-1];
        [_navigationVCs addObject:profileSexy];
        [profileSexy setNavigationVCs:_navigationVCs];
        //[_navigationVCs removeObject:self];
        
        [self.navigationController pushViewController:profileSexy animated:YES];
    }
}

-(void)openRadarViewController{
    NSLog(@"(Arena) Navigation children real: %@", [self.navigationController childViewControllers]);
    __block NSInteger foundIndex = NSNotFound;
    __block NSInteger foundIndex2 = NSNotFound;
    NSLog(@"(Arena) Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[RadarViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        if(![self.navigationController.topViewController isKindOfClass:[RadarViewController class]]){
            NSLog(@"Show radar");
            [[self.navigationController childViewControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[RadarViewController class]]) {
                    foundIndex2 = idx;
                    if (foundIndex2 != NSNotFound) {
                        NSMutableArray *copy = [[self.navigationController childViewControllers] mutableCopy];
                        [copy removeObject:[copy objectAtIndex:foundIndex2]];
                        [self.navigationController setViewControllers:copy];
                    }
                    // stop the enumeration
                    *stop = YES;
                }
            }];
            
            [self.navigationController showViewController:[_navigationVCs objectAtIndex:foundIndex] sender:self];
            
        }
        
    }
    
}

-(void)openExploreViewController{
    NSLog(@"(Arena) Navigation children real: %@", [self.navigationController childViewControllers]);
    __block NSInteger foundIndex = NSNotFound;
    __block NSInteger foundIndex2 = NSNotFound;
    NSLog(@"(Arena) Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ExploreViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        if(![self.navigationController.topViewController isKindOfClass:[ExploreViewController class]]){
            NSLog(@"Show explore");
            [[self.navigationController childViewControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[ExploreViewController class]]) {
                    foundIndex2 = idx;
                    if (foundIndex2 != NSNotFound) {
                        NSMutableArray *copy = [[self.navigationController childViewControllers] mutableCopy];
                        [copy removeObject:[copy objectAtIndex:foundIndex2]];
                        [self.navigationController setViewControllers:copy];
                    }
                    // stop the enumeration
                    *stop = YES;
                }
            }];
            
            [self.navigationController showViewController:[_navigationVCs objectAtIndex:foundIndex] sender:self];
            
        }
        
    }else{
        UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"ArenaExplore" bundle:nil];
        ExploreViewController *explore = [cameraStoryboard instantiateViewControllerWithIdentifier:@"explore"];
        NSMutableArray *vcs =  [[self.navigationController childViewControllers] mutableCopy];
        [vcs insertObject:explore atIndex:[vcs count]-1];
        [_navigationVCs addObject:explore];
        [explore setNavigationVCs:_navigationVCs];

        [self.navigationController showViewController:explore sender:self];
    }
    
}


-(void)blurredFilterAway{
    blurEffectView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    _menuView.hidden = YES;
}

- (IBAction)tapRadar:(id)sender {
    [self blurredFilterAway];
    [self openRadarViewController];
}

- (IBAction)tapExplore:(id)sender {
    
    [self blurredFilterAway];
    [self openExploreViewController];
}


- (IBAction)tapProfile:(id)sender {
    [self blurredFilterAway];
    [self openProfileSexyViewController];
}



-(void) presentModalView:(UIViewController *)controller {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:controller animated:NO];
}

-(void) presentModalView1:(UIViewController *)controller {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:controller animated:NO];
}

-(void)fadeNavigationMenuIn{
    [_menuView setAlpha:0.0f];
    CGRect frameOrigin = _menuView.frame;
    _menuView.frame = CGRectMake(screenWidth, screenHeight, 0, 0);
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        
        [_menuView setAlpha:1.0f];
        _menuView.hidden = NO;
        [_menuView setFrame:frameOrigin];
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (IBAction)tapBeside:(id)sender {
    [self.navigationController.navigationBar setHidden:YES];
    [self blurredFilterAway];
}

- (IBAction)upSwipe:(id)sender {
    // Open Camera.
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
    UINavigationController *shootNavigationController = [cameraStoryboard instantiateViewControllerWithIdentifier:@"shootNavigation"];
    
    ShootViewController *shootViewController = [[shootNavigationController childViewControllers] objectAtIndex:0];
    shootViewController.profilePhoto = NO;
    
    [self showViewController:shootNavigationController sender:self];
}

// Backend API Code...

-(void)getTopTenUsers{
    [objectsDescending removeAllObjects];
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:@"pows" forKey:@"sort_desc"];
    [getRequest setObject:@"10" forKey:@"limit"];
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            objectsDescending = [objects mutableCopy];
        }
        
        NSLog(@"Top Ten Users: %lu", (unsigned long)[objectsDescending count]);
        [self fillContentWithTopTenUsers];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
}

-(void)fillContentWithTopTenUsers{
    for(int i = 0; i < [objectsDescending count]; i++){
        QBCOCustomObject *currentContent = [objectsDescending objectAtIndex:i];
        NSMutableDictionary *currentContentHolder = [contentHolders objectAtIndex:i];
        UIImageView *imageView = [currentContentHolder objectForKey:@"image"];
        UILabel *name = [currentContentHolder objectForKey:@"name"];
        UILabel *pows = [currentContentHolder objectForKey:@"pows"];
        
        [self getUserImage:currentContent.userID andAddToImageView:imageView];
        name.text = [currentContent.fields objectForKey:@"gymdername"];
        if(![[NSString stringWithFormat:@"%@", [currentContent.fields objectForKey:@"pows"]] isEqualToString:@"(null)"]){
            pows.text = [NSString stringWithFormat:@"%@", [currentContent.fields objectForKey:@"pows"]];
        }else{
            pows.text = @"0";
        }
        [self workoutColor:[[currentContent.fields objectForKey:@"workout"] objectAtIndex:0] toImageView:imageView];
    }
}

-(void)getUserImage:(NSUInteger)userID andAddToImageView:(UIImageView*)iV{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)userID] forKey:@"user_id"];
    NSLog(@"getUserImage for %lu", (unsigned long)userID);
    [QBRequest objectsWithClassName:@"ProfilePics" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        
        if([objects count] != 0){
            QBCOCustomObject *current = [objects objectAtIndex:0];
            [QBRequest downloadFileFromClassName:@"ProfilePics" objectID:current.ID fileFieldName:@"pic"
                                    successBlock:^(QBResponse *response, NSData *loadedData) {
                                        // file downloaded
                                        
                                        if(loadedData != nil){
                                            
                                            UIImage *profileImage = [UIImage imageWithData:loadedData];
                                            
                                            if(profileImage != nil){
                                                [iV setImage:profileImage];
                                            }
                                            
                                        }
                                    } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                                        // handle progress
                                        NSLog(@"Process Profile Pic: %f", status.percentOfCompletion);
                                        
                                    } errorBlock:^(QBResponse *error) {
                                        // error handling
                                        NSLog(@"Response error download: %@", [error description]);
                                    }];
            
            
        }
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    
    
}



-(void)otherUserData:(NSNotification*)notification{
    NSLog(@"Visited User Data: %@", notification.userInfo);
    [profileVC setOwnUserDataObject:[notification.userInfo mutableCopy]];
    [profileVC setOwnUserData:[notification.userInfo mutableCopy]];
    [self presentViewController:profileNav animated:NO completion:nil];
}

-(void)openProfileFromUser:(UIImage*)image andUserID:(NSString*)userID{
    profileNav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileNav"];
    NSLog(@"[profileNav childViewControllers] objectAtIndex:0] %@", [[profileNav childViewControllers] objectAtIndex:0]);
    profileVC = [[profileNav childViewControllers] objectAtIndex:0];
    [profileVC setImage:image];
    [profileVC setOwnProfile:NO];
    otherUserData.userID = [userID integerValue];
    otherUserData.fromRadar = NO;
    otherUserData.fromFollower = NO;
    otherUserData.fromArena = YES;
    [otherUserData getOtherUserData];
}

- (IBAction)firstImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:0];
    [self openProfileFromUser:_firstImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)secondImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:1];
    [self openProfileFromUser:_secondImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)thirdImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:2];
    [self openProfileFromUser:_thirdImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)fourthImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:3];
    [self openProfileFromUser:_fourthImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)fifthImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:4];
    [self openProfileFromUser:_fifthImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)sixthImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:5];
    [self openProfileFromUser:_sixthImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)seventhImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:6];
    [self openProfileFromUser:_seventhImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)eighthImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:7];
    [self openProfileFromUser:_eigthImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)ninethImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:8];
    [self openProfileFromUser:_ninethImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
- (IBAction)tenthImageTap:(id)sender {
    QBCOCustomObject *contentObject = [objectsDescending objectAtIndex:9];
    [self openProfileFromUser:_tenthImage.image andUserID:[NSString stringWithFormat:@"%lu",(unsigned long)contentObject.userID]];
}
@end
