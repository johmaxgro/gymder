////
////  ViewController.m
////  GYMDER
////
////  Created by Johannes Groschopp on 05.06.16.
////  Copyright © 2016 GYMDER. All rights reserved.
////
//
//#import "BubbleViewController.h"
//#import "BubbleContent.h"
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <UIKit/UIKit.h>
//#import "GeoManager.h"
//@import Quickblox;
//
//@interface BubbleViewController ()
//@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
//@property (strong, nonatomic) BubbleContent *bubbleContent;
//@property (strong, nonatomic) GeoManager *geoManager;
//@end
//
//@implementation BubbleViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    _bubbles = [NSMutableDictionary new];
//    _bubbleContent = [BubbleContent new];
////    [_bubbleContent setBvc:self];
//   
//    
//    [self styleFacebookButton];
//    [self styleBubble];
//    [self severalBubbles];
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//    _geoManager = [GeoManager new];
////    [_geoManager setBvc:self];
//    [_geoManager startLocationUpdate];
//    if([QBSession currentSession] != nil){
//        if([QBSession currentSession].currentUser != nil){
//            NSLog(@"Quickblox User: %@", [QBSession currentSession].currentUser );
//            _facebookButton.hidden = YES;
//        }else{
//         
//            _facebookButton.hidden = NO;
//
//        }
//        
//    }
//
//   // [_geoManager.locationManager startUpdatingLocation];
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)styleFacebookButton{
//  
//    _facebookButton.layer.borderColor = _facebookButton.backgroundColor.CGColor;
//    _facebookButton.layer.cornerRadius = 10;
//    _facebookButton.clipsToBounds = YES;
//}
//
//-(void)addBubbleToUniverse:(CGRect)frame{
//    UIImageView *bubbleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boys girls.jpg"]];
//    [bubbleImage setFrame:frame];
//    [bubbleImage setContentMode:UIViewContentModeScaleAspectFill];
//    [bubbleImage.layer setCornerRadius:bubbleImage.frame.size.width/2];
//    [bubbleImage setClipsToBounds:YES];
//    [self.view addSubview:bubbleImage];
//}
//
//-(void)addNewBubbleToUniverse:(NSMutableDictionary*)bubbleContent{
//    NSUInteger x = arc4random_uniform(self.view.bounds.size.width-50) + 10;
//    NSUInteger y = arc4random_uniform(self.view.bounds.size.height) + 1;
//    
//    NSUInteger diameter = arc4random_uniform(70) + 20;
//    
//    CGRect frame = CGRectMake(x, y, diameter, diameter);
//    UIImageView *bubbleImage = [[UIImageView alloc] initWithImage:[bubbleContent objectForKey:@"profileimage"]];
//    [bubbleImage setFrame:frame];
//    [bubbleImage setContentMode:UIViewContentModeScaleAspectFill];
//    [bubbleImage.layer setCornerRadius:bubbleImage.frame.size.width/2];
//    [bubbleImage setClipsToBounds:YES];
//    [self.view addSubview:bubbleImage];
//}
//
//-(void)severalBubbles{
//    for (int i = 0; i < 30; i++) {
//        NSUInteger x = arc4random_uniform(self.view.bounds.size.width-50) + 10;
//        NSUInteger y = arc4random_uniform(self.view.bounds.size.height) + 1;
//        
//        NSUInteger diameter = arc4random_uniform(70) + 20;
//
//        CGRect frame = CGRectMake(x, y, diameter, diameter);
//        
//        [self addBubbleToUniverse:frame];
//    }
//}
//
//-(void)styleBubble{
//    
////    _bubble.layer.cornerRadius = 10;
////   // [_bubble initWithImage:[UIImage imageNamed:@"boys girls.jpg"]];
////    
////    [_bubble setImage:[UIImage imageNamed:@"boys girls.jpg"]];
////    [_bubble setFrame:CGRectMake(0, 0, 100, 100)];
////    [_bubble setContentMode:UIViewContentModeScaleAspectFit];
////    [_bubble setClipsToBounds:YES];
//}
//
//-(BubbleContent*)getBubbleContent{
//    return _bubbleContent;
//}
//
//-(void)newBubble:(NSMutableDictionary*)newBubble withKey:(NSString*)userID{
//    [_bubbles setObject:newBubble forKey:userID];
//}
//
//- (IBAction)facebook:(id)sender {
//    
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login
//     logInWithReadPermissions: @[@"public_profile", @"user_friends", @"email"]
//     fromViewController:self
//     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//         if (error) {
//             NSLog(@"Process error");
//         } else if (result.isCancelled) {
//             NSLog(@"Cancelled");
//         } else {
//             NSLog(@"Logged in");
//             _facebookButton.hidden = YES;
//         }
//     }];
//}
//
//@end
