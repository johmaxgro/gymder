//
//  ExploreViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 22.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ExploreViewController.h"
#import "ProfileSexyViewController.h"
#import "ViewControllerManager.h"
#import "ArenaViewController.h"
#import "ShootViewController.h"
#import "ExploreWaterFallViewController.h"

@interface ExploreViewController (){
    UIVisualEffectView *blurEffectView;
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGRect searchViewHidden;
    CGRect searchViewShown;
    CGRect containerFull;
    CGRect containerNotFull;
    UITextField *searchBarTextField;
}
@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    _menuView.hidden = YES;
    
    [self.view addGestureRecognizer:_leftSwipe];
    [self.view addGestureRecognizer:_rightSwipe];
    [self.view addGestureRecognizer:_tapBeside];
    
    [_navigationButton addGestureRecognizer:_longPress];
    
    [_arenaMenuIcon addGestureRecognizer:_tapArena];
    [_radarMenuIcon addGestureRecognizer:_tapRadar];
    [_profileMenuIcon addGestureRecognizer:_tapProfile];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [_upSwipeArea addGestureRecognizer:_upSwipe];
    [_swipeDownArea addGestureRecognizer:_swipeDown];

    NSLog(@"Childs: %@", self.childViewControllers);
    ExploreWaterFallViewController *exploreWaterfall = [self.childViewControllers objectAtIndex:0];
    exploreWaterfall.exploreVC = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    _searchBar.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    _searchView.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    [self searchBarTextFieldColor];
    _searchView.hidden = YES;
    searchViewShown = _searchView.frame;
    searchViewHidden = CGRectMake(0, 0 -_searchView.frame.size.height, _searchView.frame.size.width, _searchView.frame.size.height);
    containerFull = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    containerNotFull = _exploreContainer.frame;
    [self searchViewHidden];
}

-(void)viewDidLayoutSubviews{
//    [self initialSearchViewPosition];
    _exploreContainer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)initialSearchViewPosition{
    _searchView.frame = CGRectMake(0, 0 -_searchView.frame.size.height, _searchView.frame.size.width, _searchView.frame.size.height);
    _exploreContainer.frame = containerFull;
}

-(void)searchViewShow{
    _swipeDownArea.hidden = YES;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [_searchView setFrame:searchViewShown];
                         [_exploreContainer setFrame:containerNotFull];
                     }
                     completion:nil];
    
}

-(void)searchViewHidden{
    _swipeDownArea.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_searchView setFrame:searchViewHidden];
                         [_exploreContainer setFrame:containerFull];
                     }
                     completion:nil];
}

-(void)searchBarTextFieldColor{
    for (UIView *subView in self.searchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                searchBarTextField = (UITextField *)secondLevelSubview;
                
                //set font color here
                searchBarTextField.textColor = [UIColor whiteColor];
                
                break;
            }
        }
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
    [self openArenaViewController];
}


- (IBAction)leftSwipe:(id)sender {
    [self openRadarViewController];
}

-(void)removeOwnViewControllerFromArray{
    for (int i = 0; i < [_navigationVCs count]; i++){
        if([_navigationVCs objectAtIndex:i] == self){
            [_navigationVCs removeObject:self];
        }
    }
}

// Animation for ViewController: Coming from Right
-(void)showView:(UIViewController *)controller {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self showViewController:controller sender:self];
}

// Animation for View Controller: Coming from Left
-(void)showView1:(UIViewController *)controller {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self showViewController:controller sender:self];
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
        //blurEffectView.hidden = YES;
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

-(void)blurredFilterAway{
    blurEffectView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    _menuView.hidden = YES;
}

-(void)openArenaViewController{
    __block NSInteger foundIndex = NSNotFound;
    NSLog(@"(Explore) Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ArenaViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (foundIndex != NSNotFound) {
        // You've found the first object of that class in the array
        if(![self.navigationController.topViewController isKindOfClass:[ArenaViewController class]]){
            NSLog(@"Show Arena");
            
            if(![_navigationVCs containsObject:self]){
                [_navigationVCs addObject:self];
            }
            [self.navigationController setViewControllers:_navigationVCs animated:NO];
            [self.navigationController popToViewController:[_navigationVCs objectAtIndex:foundIndex] animated:YES];
            
        }
        
    }else{
        NSLog(@"New Arena: %@", [self.navigationController childViewControllers]);
        UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"ArenaExplore" bundle:nil];
        ArenaViewController *arena = [cameraStoryboard instantiateViewControllerWithIdentifier:@"arena"];
        
        NSMutableArray *vcs =  [[self.navigationController childViewControllers] mutableCopy];
        [vcs insertObject:arena atIndex:[vcs count]-1];
        [_navigationVCs addObject:arena];
        [arena setNavigationVCs:_navigationVCs];
        //[_navigationVCs removeObject:self];
        [self.navigationController setViewControllers:vcs animated:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

// Profile Overview View Controller: Mentally right from radar view

-(void)openProfileSexyViewController{
    __block NSInteger foundIndex = NSNotFound;
    __block NSInteger foundIndex2 = NSNotFound;
    __block NSInteger radarIndex = NSNotFound;
    NSLog(@"(Explore) Navigation child views: %@", _navigationVCs);
    
    [_navigationVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[RadarViewController class]]) {
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    
    if (radarIndex != NSNotFound) {
        
    }
    
    
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
    NSLog(@"(Explore) Navigation children real: %@", [self.navigationController childViewControllers]);
    __block NSInteger foundIndex = NSNotFound;
    __block NSInteger foundIndex2 = NSNotFound;
    NSLog(@"(Explore) Navigation child views: %@", _navigationVCs);
    
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

- (IBAction)upSwipe:(id)sender {
    // Open Camera.
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
    UINavigationController *shootNavigationController = [cameraStoryboard instantiateViewControllerWithIdentifier:@"shootNavigation"];
    
    ShootViewController *shootViewController = [[shootNavigationController childViewControllers] objectAtIndex:0];
    shootViewController.profilePhoto = NO;
    
    [self showViewController:shootNavigationController sender:self];
}

- (IBAction)tapArena:(id)sender {
    [self blurredFilterAway];
    [self openArenaViewController];
}

- (IBAction)tapRadar:(id)sender {
    [self blurredFilterAway];
    [self openRadarViewController];
}

- (IBAction)tapProfile:(id)sender {
    [self blurredFilterAway];
    [self openProfileSexyViewController];

}
- (IBAction)tapBeside:(id)sender {
    [self blurredFilterAway];
    [self.navigationController.navigationBar setHidden:YES];
//    _searchBar.hidden = YES;
}

-(void)keyBoardAway{
    [searchBarTextField resignFirstResponder];

}

- (IBAction)swipeDown:(id)sender {
    NSLog(@"Swipe down");
    _searchView.hidden = NO;
    [self searchViewShow];
}
@end
