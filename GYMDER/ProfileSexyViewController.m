//
//  ProfileSexyViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 18.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ProfileSexyViewController.h"
#import "ProfileViewController.h"
#import "ShootViewController.h"
#import "RadarViewController.h"
#import "ExploreViewController.h"
#import "NotificationsViewController.h"
#import "ChatsOverviewViewController.h"
#import "FollowerViewController.h"

@interface ProfileSexyViewController (){
    UIVisualEffectView *blurEffectView;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@end

@implementation ProfileSexyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    _ownImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _ownImage.layer.borderWidth = 3;
    _ownImage.clipsToBounds = YES;
    _ownImage.image = _ownProfileImage;
    
    if([self iPhone6PlusDevice]){
        _ownImage.layer.cornerRadius = _ownImage.layer.frame.size.width*0.35;
    }else{
        _ownImage.layer.cornerRadius = _ownImage.layer.frame.size.width*0.27;
    }
  
    
    [_mainView addGestureRecognizer:_rightSwipeGesture];
    
    [_exploreMenuIcon addGestureRecognizer:_tapExplore];
    [_radarMenuIcon addGestureRecognizer:_tapRadar];
    [_arenaMenuIcon addGestureRecognizer:_tapArena];
    
    @try {
        [self workoutColor:[[_ownUserDataObject.userDataArray objectAtIndex:0] objectForKey:@"workouts"]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {

    }
    
//    if([_ownUserDataObject.userDataArray objectAtIndex:0] != nil){
//    NSMutableDictionary *ownUserdata = [_ownUserDataObject.userDataArray objectAtIndex:0];
//    [self workoutColor:[[_ownUserDataObject.userDataArray objectAtIndex:0] objectForKey:@"workouts"]];
//    }
    
    [_mainView addGestureRecognizer:_tapBeside];
    [_navigationButton addGestureRecognizer:_longPressGesture];
    
    [_upSwipeArea addGestureRecognizer:_upSwipe];
    
    [_notificationsView addGestureRecognizer:_notificationsTap];
    [_chatView addGestureRecognizer:_chatTap];
    [_followView addGestureRecognizer:_followTap];
    
    
    [self.navigationController.navigationBar setHidden:YES];
    
    NSLog(@"My workouts: %@", [[_ownUserDataObject.userDataArray objectAtIndex:0] objectForKey:@"workouts"]);
    if([[[_ownUserDataObject.userDataArray objectAtIndex:0] objectForKey:@"workouts"] count] == 0){
        NSLog(@"Get workouts again");
        [_ownUserDataObject getWorkouts];
    }
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=newBackButton;

}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    NSLog(@"Data available: %@", _ownUserDataObject);
}

#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

-(BOOL)iPhone6PlusDevice{
    if (!IS_PHONE) return NO;
    if ([UIScreen mainScreen].scale > 2.9) return YES;   // Scale is only 3 when not in scaled mode for iPhone 6 Plus
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
//    [_ownUserDataObject objectAtIndex:0]
    _menuView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)workoutColor:(NSMutableArray*)workouts{
    if([[workouts objectAtIndex:0] isEqualToString:@"hardcore"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.173f green:0.192f blue:0.208f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"hiit"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.204f green:0.196f blue:0.149f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"combat"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.204f green:0.169f blue:0.180f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"lift"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.243f green:0.275f blue:0.286f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"spin"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.349f green:0.341f blue:0.259f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"bootcamp"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.282f green:0.247f blue:0.259f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"equipment"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.349f green:0.384f blue:0.400f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"run"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.494f green:0.494f blue:0.373f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"team"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.400f green:0.353f blue:0.369f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"crossfit"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.424f green:0.467f blue:0.486f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"cardio"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.647f green:0.631f blue:0.482f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"dance"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.475f green:0.416f blue:0.439f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"bodyweight"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.502f green:0.573f blue:0.596f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"fatburn"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.796f green:0.792f blue:0.584f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"pilates"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.608f green:0.522f blue:0.553f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"free"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.600f green:0.659f blue:0.682f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"walk"]){
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.894f green:0.878f blue:0.659f alpha:1.00f].CGColor;
    }
    else if([[workouts objectAtIndex:0] isEqualToString:@"yoga"]){
        
        _ownImage.layer.borderColor = [UIColor colorWithRed:0.682f green:0.604f blue:0.624f alpha:1.00f].CGColor;
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
- (IBAction)settings:(id)sender {

    UINavigationController *profileNav = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
    NSLog(@"[profileNav childViewControllers] objectAtIndex:0] %@", [[profileNav childViewControllers] objectAtIndex:0]);
    ProfileViewController *profileVC = [[profileNav childViewControllers] objectAtIndex:0];
    [profileVC setImage:_ownProfileImage];
    [profileVC setOwnUserDataObject:_ownUserDataObject];
    [profileVC setOwnUserData:[_ownUserDataObject.userDataArray objectAtIndex:0]];
    [profileVC setOwnProfile:YES];
    [profileVC setNavigationVCs:_navigationVCs];

    [self presentViewController:profileNav animated:NO completion:nil];
    
}

- (IBAction)longPressed:(UILongPressGestureRecognizer*)sender {
    NSLog(@"Long Press in ProfileSexy");
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.navigationController.navigationBar.hidden = YES;
        [self blurredFilterForBackground];
        [self fadeNavigationMenuIn];
        [self.view bringSubviewToFront:_menuView];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        //blurEffectView.hidden = YES;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        //        blurEffectView.hidden = YES;
        //        self.navigationController.navigationBar.hidden = NO;
        //        _menuView.hidden = YES;
    }
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
        
        //            //fade out
        //            [UIView animateWithDuration:2.0f animations:^{
        //
        //                [_label setAlpha:0.0f];
        //
        //            } completion:nil];
        
    }];
}

-(void)blurredFilterForBackground{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:blurEffectView];
        
        [blurEffectView setAlpha:0.0f];
        
        //fade in
        [UIView animateWithDuration:0.6f animations:^{
            
            [blurEffectView setAlpha:1.0f];
            
        } completion:^(BOOL finished) {
            
//            //fade out
//            [UIView animateWithDuration:2.0f animations:^{
//                
//                [_label setAlpha:0.0f];
//                
//            } completion:nil];
            
        }];
        
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
}


-(void)blurredFilterAway{
    blurEffectView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    _menuView.hidden = YES;
}

- (IBAction)tappedBeside:(id)sender {
    [self blurredFilterAway];
    [self.navigationController.navigationBar setHidden:YES];
    
}


- (IBAction)upSwipe:(id)sender {
    // Open Camera.
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
    UINavigationController *shootNavigationController = [cameraStoryboard instantiateViewControllerWithIdentifier:@"shootNavigation"];
    
    ShootViewController *shootViewController = [[shootNavigationController childViewControllers] objectAtIndex:0];
    shootViewController.profilePhoto = NO;
    
    [self showViewController:shootNavigationController sender:self];

    
}
- (IBAction)tapRadar:(id)sender {
    [self blurredFilterAway];
    NSLog(@"(ProfileSexy) Navigation children real: %@", [self.navigationController childViewControllers]);
    if(![_navigationVCs containsObject:self]){
        [_navigationVCs addObject:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    __block NSInteger foundIndex = NSNotFound;
//    __block NSInteger foundIndex2 = NSNotFound;
//    NSLog(@"(ProfileSexy) Navigation child views: %@", _navigationVCs);
//    
//    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[RadarViewController class]]) {
//            foundIndex = idx;
//            // stop the enumeration
//            *stop = YES;
//        }
//    }];
//    
//    if (foundIndex != NSNotFound) {
//        // You've found the first object of that class in the array
//        if(![self.navigationController.topViewController isKindOfClass:[RadarViewController class]]){
//            NSLog(@"Show radar");
//            [[self.navigationController childViewControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                if ([obj isKindOfClass:[RadarViewController class]]) {
//                    foundIndex2 = idx;
//                    if (foundIndex2 != NSNotFound) {
//                        NSMutableArray *copy = [[self.navigationController childViewControllers] mutableCopy];
//                        [copy removeObject:[copy objectAtIndex:foundIndex2]];
//                        [self.navigationController setViewControllers:copy];
//                    }
//                    // stop the enumeration
//                    *stop = YES;
//                }
//            }];
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }
//        //        [self.navigationController showViewController:[_navigationVCs objectAtIndex:foundIndex] sender:self];
//    }

}
- (IBAction)tapArena:(id)sender {
    if(![_navigationVCs containsObject:self]){
        [_navigationVCs addObject:self];
    }
    [self blurredFilterAway];
    [self openArenaViewController];
}
- (IBAction)tapExplore:(id)sender {
    if(![_navigationVCs containsObject:self]){
        [_navigationVCs addObject:self];
    }
    [self blurredFilterAway];
    [self openExploreViewController];
}

-(void)openExploreViewController{
    __block NSInteger foundIndex = NSNotFound;
    NSLog(@"(Radar) Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ExploreViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        NSLog(@"(Radar) Navigation child views: %@", _navigationVCs);
        //        [self.navigationController showViewController:[_navigationVCs objectAtIndex:foundIndex] sender:self];
        [self.navigationController setViewControllers:_navigationVCs animated:NO];
        [self.navigationController popToViewController:[_navigationVCs objectAtIndex:foundIndex] animated:YES];
        
        
    }else{
        UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"ArenaExplore" bundle:nil];
        ExploreViewController *explore = [cameraStoryboard instantiateViewControllerWithIdentifier:@"explore"];
        NSMutableArray *vcs =  [[self.navigationController childViewControllers] mutableCopy];
        [vcs insertObject:explore atIndex:[vcs count]-1];
        [_navigationVCs addObject:explore];
        [explore setNavigationVCs:vcs];
        //[_navigationVCs removeObject:self];
        [self.navigationController setViewControllers:_navigationVCs animated:NO];
        [self.navigationController popToViewController:explore animated:YES];
    }
}

-(void)openArenaViewController{
    __block NSInteger foundIndex = NSNotFound;
    NSLog(@"(Radar) Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ArenaViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        NSLog(@"(Radar) Navigation child views: %@", _navigationVCs);
        //        [self.navigationController showViewController:[_navigationVCs objectAtIndex:foundIndex] sender:self];
        [self.navigationController setViewControllers:_navigationVCs animated:NO];
        [self.navigationController popToViewController:[_navigationVCs objectAtIndex:foundIndex] animated:YES];
        
        
    }else{
        NSLog(@"New Arena: %@", [self.navigationController childViewControllers]);
        UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"ArenaExplore" bundle:nil];
        ArenaViewController *arena = [cameraStoryboard instantiateViewControllerWithIdentifier:@"arena"];
        
        NSMutableArray *vcs =  [[self.navigationController childViewControllers] mutableCopy];
        [vcs insertObject:arena atIndex:[vcs count]-1];
        [_navigationVCs addObject:arena];
        [arena setNavigationVCs:_navigationVCs];
        [_navigationVCs removeObject:self];
        [self.navigationController setViewControllers:vcs animated:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)notificationsTap:(id)sender {
    UIStoryboard *privateStoryboard = [UIStoryboard storyboardWithName:@"Private" bundle:nil];
    NotificationsViewController *notificationsViewController = [privateStoryboard instantiateViewControllerWithIdentifier:@"notifications"];
    
//       [self showViewController:notificationsViewController sender:self];
    [self.navigationController pushViewController:notificationsViewController animated:YES];

}
- (IBAction)chatTap:(id)sender {
    UIStoryboard *privateStoryboard = [UIStoryboard storyboardWithName:@"Private" bundle:nil];
    ChatsOverviewViewController *chatsOverViewVC = [privateStoryboard instantiateViewControllerWithIdentifier:@"chatsOverview"];

    //       [self showViewController:notificationsViewController sender:self];
    [self.navigationController pushViewController:chatsOverViewVC animated:YES];
}
- (IBAction)followTap:(id)sender {
    UIStoryboard *privateStoryboard = [UIStoryboard storyboardWithName:@"Private" bundle:nil];
    FollowerViewController *followerOverViewVC = [privateStoryboard instantiateViewControllerWithIdentifier:@"follower"];
    
    //       [self showViewController:notificationsViewController sender:self];
    [self.navigationController pushViewController:followerOverViewVC animated:YES];
}
@end
