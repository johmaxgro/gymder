//
//  GymEditViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface GymEditViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) NSString *mainGym;

@property (strong, nonatomic) GMSPlacesClient *placesClient;
@property (weak, nonatomic) IBOutlet UIView *tableContainer;
@property (strong, nonatomic) NSString *fitnessClub;

-(void)rightBarBarButtonItem;
@end
