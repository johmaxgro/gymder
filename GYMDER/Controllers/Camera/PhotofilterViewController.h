//
//  PhotofilterViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 18.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotofilterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoImageview;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *squareImage;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *topBlurr;
@property (weak, nonatomic) IBOutlet UIView *leftBlurr;
@property (weak, nonatomic) IBOutlet UIView *rightBlurr;
@property (weak, nonatomic) IBOutlet UIView *bottomBlurr;
@property (nonatomic) BOOL profilePhoto;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (weak, nonatomic) IBOutlet UIImageView *navigationButton;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneTapGesture;
- (IBAction)handlePan:(id)sender;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeGesture;
- (IBAction)rightSwipe:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeGesture;
- (IBAction)leftSwipe:(id)sender;

- (IBAction)share:(id)sender;
- (IBAction)comment:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
- (IBAction)editingChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *commentText;
- (IBAction)facebook:(id)sender;

@end
