//
//  ShootViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 17.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ShootViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *image;
- (IBAction)shoot:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *container;

- (IBAction)closeCam:(id)sender;
- (IBAction)gallery:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *captureFrame;
@property (weak, nonatomic) IBOutlet UIView *capture;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UILabel *pushLabel;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
- (IBAction)flash:(id)sender;
-(void)setUpCamera;

- (IBAction)rotateCamera:(id)sender;

@property (nonatomic) BOOL hideBars;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;

- (IBAction)longPress:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *navigationButton;

-(void)removeAllSubviewsFromViews;

@property (strong, nonatomic) UINavigationController *oldNavController;

@property (nonatomic) BOOL profilePhoto;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneTapGesture;

@end
