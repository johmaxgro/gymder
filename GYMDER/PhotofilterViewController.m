//
//  PhotofilterViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 18.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "PhotofilterViewController.h"
#import "ShootViewController.h"
#import "Filters.h"
@import Quickblox;

@interface PhotofilterViewController (){
    CGFloat screenWidth;
    CGFloat screenHeight;
    UIVisualEffectView *blurEffectViewTop;
    UIVisualEffectView *blurEffectViewLeft;
    UIVisualEffectView *blurEffectViewRight;
    UIVisualEffectView *blurEffectViewBottom;
    UIVisualEffectView *blurEffectView;
    UIImageOrientation originalOrientationOfTakenImage;
    Filters *filters;
    int currentFilterNumber;
    int LIMIT_FOR_SHARES;

}

@end

@implementation PhotofilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    originalOrientationOfTakenImage = _image.imageOrientation;
    
    filters = [[Filters alloc]init];
 
    CGRect frame = CGRectMake(0, 0, screenWidth/2, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SHOOT";
        label.textColor = [UIColor whiteColor];
    label.font=[label.font fontWithSize:20];
    
    _filterLabel.text = @"NO FILTER";
//
//    self.navigationController.navigationItem.titleView = label;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=newBackButton;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    NSLog(@"Nav Title: %@", self.navigationItem.title);
    [self.navigationItem setTitle:@"SHOOT"];
    [self.navigationItem setTitleView:label];
    
    [self blurredFilterForBackground];
    [self.view bringSubviewToFront:_squareImage];
    [self.view bringSubviewToFront:_shareButton];
    [self.view bringSubviewToFront:_commentButton];
    [self.view bringSubviewToFront:_facebookButton];
    [self.view bringSubviewToFront:_navigationButton];
    
    _menuView.hidden = YES;
    
    NSLog(@"Profile Photo: %d", _profilePhoto ? YES:NO);
    if(_profilePhoto){
        [_shareButton setTitle:@"OK" forState:UIControlStateNormal];
        _facebookButton.hidden = YES;
        _commentButton.hidden = YES;
    }else{
        [_shareButton setTitle:@"SHARE" forState:UIControlStateNormal];
        _facebookButton.hidden = NO;
        _commentButton.hidden = NO;
    }
    
    [_navigationButton addGestureRecognizer:_longPressGesture];
    [_navigationButton setHidden:YES];
    [self.view addGestureRecognizer:_oneTapGesture];
    
    [_photoImageview addGestureRecognizer:_panGesture];
    
    [self.view addGestureRecognizer:_rightSwipeGesture];
    [self.view addGestureRecognizer:_leftSwipeGesture];
    
    LIMIT_FOR_SHARES = 9;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];


}

-(void)viewDidLayoutSubviews{
    _commentField.frame = CGRectMake(_commentField.frame.origin.x, screenHeight*0.6, _commentField.frame.size.width, _commentField.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    _photoImageview.image = _image;
    _commentField.hidden = YES;
    _commentText.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)blurredFilterAway{
    blurEffectView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    _menuView.hidden = YES;
}

-(void) presentModalView:(UIViewController *)controller {
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
    [self showViewController:controller sender:self];
}

-(void)back{

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)blurredFilterForBackground{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        
        // Top
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectViewTop = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectViewTop.frame = _topBlurr.bounds;
        blurEffectViewTop.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_topBlurr addSubview:blurEffectViewTop];
        
        // Left
        
        UIBlurEffect *blurEffect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectViewLeft = [[UIVisualEffectView alloc] initWithEffect:blurEffect1];
        blurEffectViewLeft.frame = _leftBlurr.bounds;
        blurEffectViewLeft.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_leftBlurr addSubview:blurEffectViewLeft];
        
        // Right
        
        UIBlurEffect *blurEffect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectViewRight = [[UIVisualEffectView alloc] initWithEffect:blurEffect2];
        blurEffectViewRight.frame = _rightBlurr.bounds;
        blurEffectViewRight.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [_rightBlurr addSubview:blurEffectViewRight];
        
        // Bottom
        
        UIBlurEffect *blurEffect3 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectViewBottom = [[UIVisualEffectView alloc] initWithEffect:blurEffect3];
        blurEffectViewBottom.frame = _bottomBlurr.bounds;
        blurEffectViewBottom.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_bottomBlurr addSubview:blurEffectViewBottom];

    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
}

- (IBAction)longPressed:(UILongPressGestureRecognizer*)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.navigationController.navigationBar.hidden = YES;
        [self totalBlurredFilterForBackground];
        _menuView.hidden = NO;
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

-(void)totalBlurredFilterForBackground{
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

- (IBAction)tappedBeside:(id)sender {
    [self blurredFilterAway];
    [_commentField endEditing:YES];
//    [self commentFieldDown];
    _commentField.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint translation = [recognizer translationInView:_photoImageview];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:_photoImageview];
}

- (IBAction)rightSwipe:(id)sender {
    switch (currentFilterNumber) {
        case 0:
            //
            break;
        case 1:
            _squareImage.image = nil;
            _photoImageview.image = _image;
            _filterLabel.text = @"NO FILTER";
            currentFilterNumber -= 1;
            //
            break;
        case 2:
            //
            _squareImage.image = nil;
            _filterLabel.text = @"BEAST";
            [filters beastFilter:_image toImageView:_photoImageview andWaterMarkIV:_squareImage];
            currentFilterNumber -= 1;
            break;
        case 3:
            // oiled filter...
            break;
        case 4:
            // tanned filter...
            break;
        case 5:
            // 
            break;
            
        default:
            break;
    }

}
- (IBAction)leftSwipe:(id)sender {
    switch (currentFilterNumber) {
        case 0:
            //
            _squareImage.image = nil;
            _filterLabel.text = @"BEAST";
            [filters beastFilter:_image toImageView:_photoImageview andWaterMarkIV:_squareImage];
            currentFilterNumber += 1;
            break;
        case 1:
            //
            _squareImage.image = nil;
            _filterLabel.text = @"ANGEL";
            [filters angelFilter:_image toImageView:_photoImageview andWaterMarkIV:_squareImage];
            currentFilterNumber += 1;
            break;
        case 2:
            //
            break;
        case 3:
            //
            break;
        case 4:
            //
            break;
        case 5:
            //
            break;
            
        default:
            break;
    }
   
}

- (IBAction)share:(id)sender {
    [self deleteOldIfNeedeed];
    [self loadUpFeed];
}

- (IBAction)comment:(id)sender {
    [_commentField becomeFirstResponder];
    CGRect frameOrigin = _commentField.frame;
    _commentField.frame = CGRectMake(0, screenHeight, screenWidth, 0);
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        
        [_commentField setAlpha:1.0f];
        _commentField.hidden = NO;
        [_commentField setFrame:frameOrigin];
        //        [_commentField becomeFirstResponder];
        
    } completion:^(BOOL finished) {
        
        //            //fade out
        //            [UIView animateWithDuration:2.0f animations:^{
        //
        //                [_label setAlpha:0.0f];
        //
        //            } completion:nil];
        
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"Keyboard: %f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    
   
}

-(void)commentFieldDown{
    CGRect frameOrigin = CGRectMake(0, screenHeight+100, screenWidth, 0);

    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        
        [_commentField setAlpha:1.0f];
        _commentField.hidden = NO;
        [_commentField setFrame:frameOrigin];
        
    } completion:^(BOOL finished) {
        
        
    }];

}

//-(void)beastFilter:(UIImage *)imageToFilter toImageView:(UIImageView*)iv{
//    
//    
//    
//    UIImageOrientation originalOrientation = iv.image.imageOrientation;
//    //    CIImage *bgnImage = [[CIImage alloc] initWithCGImage:[imageToFilter CGImage]];
//    
////    UIImage *fixedImage = [self scaleAndRotateImage:imageToFilter];
//    UIImage *fixedImage =imageToFilter;
//
//    CIImage *bgnImage = [CIImage imageWithCGImage:fixedImage.CGImage];
//    
//    CIFilter *saturation = [CIFilter filterWithName:@"CIVibrance"];
//    [saturation setDefaults];
//    [saturation setValue: bgnImage forKey: @"inputImage"];
//    [saturation setValue: [NSNumber numberWithFloat:0.6f]
//                  forKey:@"inputAmount"];
//    
//    CIImage *outputImage = [saturation valueForKey:@"outputImage"];
//    
//    CIFilter *imgFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, outputImage, @"inputIntensity", [NSNumber numberWithFloat:1.0], nil];
//    outputImage = [imgFilter outputImage];
//    
//    CIFilter *brightnesContrastFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
//    [brightnesContrastFilter setDefaults];
//    [brightnesContrastFilter setValue: outputImage forKey: @"inputImage"];
//    [brightnesContrastFilter setValue: [NSNumber numberWithFloat:5.0]
//                               forKey:@"inputPower"];
//    outputImage = [brightnesContrastFilter valueForKey: @"outputImage"];
//    
//    // Beats Mask Filter
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]]; // 10
//    
//    // Draw the image in screen
//    UIImage* backgroundImage = [[UIImage alloc] initWithCGImage:cgimg scale:1.0 orientation:originalOrientationOfTakenImage];
//    
//    UIImage *watermarkImage = [UIImage imageNamed:@"BEAST-MASK.png"];
//    
//    UIGraphicsBeginImageContext(backgroundImage.size);
//    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
//    [watermarkImage drawInRect:CGRectMake(_photoImageview.frame.origin.x, _photoImageview.frame.origin.y, 0, backgroundImage.size.height)];
//    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImage *imageToDisplay =
//    [UIImage imageWithCGImage:[result CGImage]
//                        scale:[result scale]
//                  orientation: originalOrientationOfTakenImage];
//    
//    [iv setImage:result];
//}
//
//- (UIImage *)scaleAndRotateImage:(UIImage *)image {
//    int kMaxResolution = 640; // Or whatever
//    
//    CGImageRef imgRef = image.CGImage;
//    
//    CGFloat width = CGImageGetWidth(imgRef);
//    CGFloat height = CGImageGetHeight(imgRef);
//    
//    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    CGRect bounds = CGRectMake(0, 0, width, height);
//    if (width > kMaxResolution || height > kMaxResolution) {
//        CGFloat ratio = width/height;
//        if (ratio > 1) {
//            bounds.size.width = kMaxResolution;
//            bounds.size.height = roundf(bounds.size.width / ratio);
//        }
//        else {
//            bounds.size.height = kMaxResolution;
//            bounds.size.width = roundf(bounds.size.height * ratio);
//        }
//    }
//    
//    CGFloat scaleRatio = bounds.size.width / width;
//    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
//    CGFloat boundHeight;
//    UIImageOrientation orient = image.imageOrientation;
//    switch(orient) {
//            
//        case UIImageOrientationUp: //EXIF = 1
//            transform = CGAffineTransformIdentity;
//            break;
//            
//        case UIImageOrientationUpMirrored: //EXIF = 2
//            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            break;
//            
//        case UIImageOrientationDown: //EXIF = 3
//            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationDownMirrored: //EXIF = 4
//            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
//            transform = CGAffineTransformScale(transform, 1.0, -1.0);
//            break;
//            
//        case UIImageOrientationLeftMirrored: //EXIF = 5
//            boundHeight = bounds.size.height;
//            bounds.size.height = bounds.size.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationLeft: //EXIF = 6
//            boundHeight = bounds.size.height;
//            bounds.size.height = bounds.size.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
//            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationRightMirrored: //EXIF = 7
//            boundHeight = bounds.size.height;
//            bounds.size.height = bounds.size.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransformMakeScale(-1.0, 1.0);
//            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationRight: //EXIF = 8
//            boundHeight = bounds.size.height;
//            bounds.size.height = bounds.size.width;
//            bounds.size.width = boundHeight;
//            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
//            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//            break;
//            
//        default:
//            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
//            
//    }
//    
//    UIGraphicsBeginImageContext(bounds.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
//        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
//        CGContextTranslateCTM(context, -height, 0);
//    }
//    else {
//        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
//        CGContextTranslateCTM(context, 0, -height);
//    }
//    
//    CGContextConcatCTM(context, transform);
//    
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
//    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return imageCopy;
//}

-(void)loadUpFeed{
    NSLog(@"Load up feed -- with image");
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = @"Share"; // your Class name
    object.userID = [QBSession currentSession].currentUser.ID;
    [object.fields setObject:@0 forKey:@"pows"];
    [object.fields setObject:_commentField.text forKey:@"comment"];
    
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        if([objects count] != 0){
        
            QBCOCustomObject *userProperties = [objects objectAtIndex:0];
            [object.fields setObject:[userProperties.fields objectForKey:@"gymdername"] forKey:@"gymdername"];
            
            [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                // do something when object is successfully created on a server
                // upload the pic after object created...
                QBCOFile *file = [QBCOFile file];
                file.name = @"image";
                file.contentType = @"image/jpg";
                file.data = UIImageJPEGRepresentation(_image, 0.8);
                [self uploadImage:file withObjectId:object.ID];
                
            } errorBlock:^(QBResponse *response) {
                // error handling
                NSLog(@"Response error: %@", [response.error description]);
            }];

            
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];

    
    
}

-(void)uploadImage:(QBCOFile *)file withObjectId:(NSString *)objectID{
    NSLog(@"Load up image");
    [QBRequest uploadFile:file className:@"Share" objectID:objectID fileFieldName:@"image" successBlock:^(QBResponse * _Nonnull response, QBCOFileUploadInfo * _Nullable info) {
        //
        NSLog(@"Pic was uploaded");
        NSLog(@"Info: %@", info);
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    
    } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
        //
        NSLog(@"Status %f", status.percentOfCompletion);
    } errorBlock:^(QBResponse * _Nonnull response) {
        //
        NSLog(@"Error: %@", [response.error description]);
    }];
}

-(void)deleteOldIfNeedeed{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", [QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    
    [QBRequest objectsWithClassName:@"Share" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        if([objects count] >= LIMIT_FOR_SHARES){
            int dif = (int)([objects count] - LIMIT_FOR_SHARES);
            for(int i = 0; i < dif; i++){
                QBCOCustomObject *toDelete = [objects objectAtIndex:i];
                [QBRequest deleteObjectWithID:toDelete.ID className:@"Share" successBlock:^(QBResponse *response) {
                    // object deleted
                } errorBlock:^(QBResponse *error) {
                    // error handling
                    NSLog(@"Response error: %@", [response.error description]);
                }];
            }
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
}

- (IBAction)editingChanged:(id)sender {
    [self rightBarButtonItem];
}

-(void)rightBarButtonItem{
    UIBarButtonItem *readyItem = [[UIBarButtonItem alloc] initWithTitle:@"Ready" style:UIBarButtonItemStyleDone target:self action:@selector(ready)];
    
    self.navigationItem.rightBarButtonItem=readyItem;
}

-(void)noRightBarButtonItem{
    self.navigationItem.rightBarButtonItem=nil;

}

-(void)ready{
    [_commentField endEditing:YES];
    [self commentFieldDown];
    [self noRightBarButtonItem];
    _commentText.text = _commentField.text;
    _commentText.hidden = NO;
    _commentField.hidden = YES;
     [_commentButton setImage:[UIImage imageNamed:@"PROFILE CHAT SELECTED.png.png"] forState:UIControlStateNormal];
}

- (IBAction)facebook:(id)sender {
    if(_facebookButton.selected){
        [_facebookButton setImage:[UIImage imageNamed:@"FACEBOOK ICON.png"] forState:UIControlStateNormal];
        _facebookButton.selected = NO;
    }else{
        [_facebookButton setImage:[UIImage imageNamed:@"FACEBOOK SELECTED.png"] forState:UIControlStateNormal];
        _facebookButton.selected = YES;

    }
}
@end
