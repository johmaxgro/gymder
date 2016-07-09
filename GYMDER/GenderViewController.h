//
//  GenderViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *maleTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *femaleTap;
- (IBAction)tappedMale:(id)sender;
- (IBAction)tappedFemale:(id)sender;

@property (strong, nonatomic) NSString *navigationTitle;

@property (strong, nonatomic) NSString *currentGender;

@end
