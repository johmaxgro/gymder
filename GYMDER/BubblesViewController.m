//
//  BubblesViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "BubblesViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GeoManager.h"
@import Quickblox;
@class GeoManager;

#define RAD_TO_DEG(r) ((r) * (180 / M_PI))

@interface BubblesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) BubbleContent *bubbleContent;
@property (strong, nonatomic) GeoManager *geoManager;
@property (strong, nonatomic) NSMutableArray *alreadyFound;
@end

@implementation BubblesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bubbles = [NSMutableDictionary new];
    _bubbleContent = [[BubbleContent alloc] init];
    _bubbleContent.bubbles = [NSMutableDictionary new];
    _alreadyFound = [NSMutableArray new];
    
    _allBubbles = [NSMutableDictionary new];
//    [_bubbleContent setBvc:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usersAroundFound) name:@"Geodata" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bubbleReady:) name:@"BubbleContent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ownGeodataUpdate:) name:@"OwnGeodata" object:nil];
    
    _geoManager = [[GeoManager alloc] init];
    
    [self styleFacebookButton];
    [self styleBubble];
   // [self severalBubbles];
}

-(void)test{
    NSLog(@"Test");
}

-(void)viewWillAppear:(BOOL)animated{
  //  [self removeAllBubbles];
}

-(void)viewDidAppear:(BOOL)animated{
   // [self removeAllBubbles];
    NSLog(@"BubbleView appeared");
    [_geoManager.allGeoObjects removeAllObjects];
    [_geoManager startLocationUpdate];
    
    // [_geoManager.locationManager startUpdatingLocation];
}

-(void)removeAllBubbles{
       
        [[self.view subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

-(void)styleFacebookButton{
    
    _facebookButton.layer.borderColor = _facebookButton.backgroundColor.CGColor;
    _facebookButton.layer.cornerRadius = 10;
    _facebookButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBubbleToUniverse:(CGRect)frame{
    UIImageView *bubbleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boys girls.jpg"]];
    [bubbleImage setFrame:frame];
    [bubbleImage setContentMode:UIViewContentModeScaleAspectFill];
    [bubbleImage.layer setCornerRadius:bubbleImage.frame.size.width/2];
    [bubbleImage setClipsToBounds:YES];
    [self.view addSubview:bubbleImage];
}

-(void)addNewBubbleToUniverse:(NSMutableDictionary*)bubbleContent{
//    NSUInteger x = arc4random_uniform(self.view.bounds.size.width-50) + 10;
//    NSUInteger y = arc4random_uniform(self.view.bounds.size.height) + 1;
    
    NSLog(@"Adding new Bubble: %@%@%f%@%f", [bubbleContent objectForKey:@"gymdername"], @", ", [[bubbleContent objectForKey:@"physicaldistance"] doubleValue], @", ", [[bubbleContent objectForKey:@"direction_to_user"] doubleValue]);
    
    CGPoint pointOfBubble = [self coordinateOfBubble:[self distanceToPixels:[[bubbleContent objectForKey:@"physicaldistance"] doubleValue]] andAngle:[[bubbleContent objectForKey:@"direction_to_user"] doubleValue] andOwnPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
   
    
//    NSUInteger diameter = arc4random_uniform(70) + 20;
    NSUInteger diameter = (([[bubbleContent objectForKey:@"pows"] intValue]/100) + 1) * 30;
    
    CGRect frame = CGRectMake(pointOfBubble.x, pointOfBubble.y, diameter, diameter);
    UIImageView *bubbleImage = [[UIImageView alloc] initWithImage:[bubbleContent objectForKey:@"profileimage"]];
    [bubbleImage setFrame:frame];
    [bubbleImage setContentMode:UIViewContentModeScaleAspectFill];
    [bubbleImage.layer setCornerRadius:bubbleImage.frame.size.width/2];
    [bubbleImage setClipsToBounds:YES];
    [bubbleImage setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [gestureRecognizer addTarget:self action:@selector(imgLongPressed:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.minimumPressDuration = 0.4;
    [bubbleImage addGestureRecognizer: gestureRecognizer];
    [self.view addSubview:bubbleImage];
}

-(double)distanceToPixels:(double)dist{
    NSLog(@"Screenwidth: %f", self.view.bounds.size.width);
    NSLog(@"km-Distance: %f%@", dist/1000, @" km");
    NSLog(@"Pixel-Distance: %f", (((self.view.bounds.size.width / 2) / 10000) * dist));
    return ((self.view.bounds.size.width / 10000) * dist);
}

-(CGPoint)coordinateOfBubble:(double)distance andAngle:(double)angle andOwnPoint:(CGPoint)point{
    
    float x = point.x - (distance * cosf(angle));
    
    float y = point.y + (distance * sinf(angle));
    
    NSLog(@"Point: %f%@%f", x, @"/", y);
    
    return CGPointMake(x, y);
}

- (void) imgLongPressed:(UILongPressGestureRecognizer*)sender
{
    NSLog(@"LOOOOOOONG Pressed");
    //[self removeAllBubbles];
   // UIImageView *view_ =(UIImageView*) sender.view;
//    CGPoint point = [sender locationInView:view_.superview];
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        
    }
    
}

-(void)severalBubbles{
    for (int i = 0; i < 30; i++) {
        NSUInteger x = arc4random_uniform(self.view.bounds.size.width-50) + 10;
        NSUInteger y = arc4random_uniform(self.view.bounds.size.height) + 1;
        
        NSUInteger diameter = arc4random_uniform(70) + 20;
        
        CGRect frame = CGRectMake(x, y, diameter, diameter);
        
        [self addBubbleToUniverse:frame];
    }
}

-(void)styleBubble{
    
    //    _bubble.layer.cornerRadius = 10;
    //   // [_bubble initWithImage:[UIImage imageNamed:@"boys girls.jpg"]];
    //
    //    [_bubble setImage:[UIImage imageNamed:@"boys girls.jpg"]];
    //    [_bubble setFrame:CGRectMake(0, 0, 100, 100)];
    //    [_bubble setContentMode:UIViewContentModeScaleAspectFit];
    //    [_bubble setClipsToBounds:YES];
}

-(BubbleContent*)getBubbleContent{
    return _bubbleContent;
}

-(void)newBubble:(NSMutableDictionary*)newBubble withKey:(NSString*)userID{
    [_bubbles setObject:newBubble forKey:userID];
}

-(void)usersAroundFound{
    NSLog(@"BubbleVC is notified");
    NSLog(@"How many Geo objects: %lu", (unsigned long)[_geoManager.allGeoObjects count]);
    NSLog(@"All Geo Objects: %@", _geoManager.allGeoObjects);
    
    
    int start = 0;
    for(int i = start; i < [_geoManager.allGeoObjects count]; i++){
        
        QBLGeoData *geoDataFromIndex = [_geoManager.allGeoObjects objectAtIndex:i];
    
        if(![_alreadyFound containsObject:[NSString stringWithFormat:@"%lu", (unsigned long)geoDataFromIndex.userID]]){
            
            [_alreadyFound addObject:[NSString stringWithFormat:@"%lu", (unsigned long)geoDataFromIndex.userID]];
            BubbleContent *newBubbleContent = [[BubbleContent alloc] init];
            [newBubbleContent setUserID:geoDataFromIndex.userID];
            [newBubbleContent setPhysicalDistance:[geoDataFromIndex.location distanceFromLocation:_geoManager.currentUserLocation]];
            [newBubbleContent setDirection:[NSNumber numberWithDouble:[self directionToLocation:geoDataFromIndex.location]]];
//            [newBubbleContent setLocationDirection:[NSNumber numberWithDouble:[self directionToLocation:geoDataFromIndex.location]]];
            [newBubbleContent createBubble];
            
        }
    }
}

-(CLLocationDirection)directionToLocation:(CLLocation *)location {
    
    CLLocationCoordinate2D coord1 = _geoManager.currentUserLocation.coordinate;
    CLLocationCoordinate2D coord2 = location.coordinate;
    
    CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
    CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
    CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
    
    CLLocationDegrees radians = atan2(yComponent, xComponent);
    CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
    
    NSLog(@"Direction: %f", fmod(degrees, 360));
    
    return fmod(degrees, 360);
}

-(void)bubbleReady:(NSNotification*)notification{
    NSLog(@"New Bubble ready prepared!");
    NSMutableDictionary* userInfo = [notification.userInfo mutableCopy];
    NSLog(@"Bubble: %@", userInfo);
    
    [_allBubbles setObject:userInfo forKey:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"user_id"]]];
    NSLog(@"All Bubbles: %@", _allBubbles);
    [self addNewBubbleToUniverse:userInfo];
}

-(void)ownGeodataUpdate:(NSNotification*)notification{
    
}

- (IBAction)facebook:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"user_friends", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             _facebookButton.hidden = YES;
         }
     }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
