//
//  ShootViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 17.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ShootViewController.h"
#import "PhotofilterViewController.h"
@import Quickblox;

@interface ShootViewController (){
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOuteput;
    CGFloat screenWidth;
    CGFloat screenHeight;
    UIVisualEffectView *blurEffectView;
    AVCaptureDeviceInput *frontFacingCameraDeviceInput;
    AVCaptureDeviceInput *backFacingCameraDeviceInput;
}

@end

@implementation ShootViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Your device has no camera"
                                      preferredStyle:UIAlertControllerStyleAlert];
        alert.view.tintColor = [UIColor blackColor];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        // [self openCamera];
    }
    [self setUpCamera];
    
//    if(_oldNavController != nil){
//        [_oldNavController dismissViewControllerAnimated:NO completion:nil];
//    }
    [_navigationButton addGestureRecognizer:_longPressGesture];
    [_navigationButton setHidden:YES];
    [self.view addGestureRecognizer:_oneTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"SHOOOOOOOT childs: %@", [self.navigationController childViewControllers]);
    
    self.previewLayer = nil;
    [self styleBars];
    
    [session startRunning
     ];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)removeAllSubviewsFromViews{
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
}


-(void)setUpCamera{
    NSLog(@"Set up Camera");
    
    CGRect realCapture = CGRectMake(self.capture.frame.origin.x
                                    , self.capture.frame.origin.y, self.capture.frame.size.width, self.capture.frame.size.width);
    
    //[self.capture setFrame:realCapture];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect captureView = CGRectMake(0, 0, screenWidth, screenHeight);
    CGRect frame = captureView;
    
    NSLog(@"Capture Frame width:%f", frame.size.width);
    NSLog(@"Capture Frame height:%f", frame.size.height);
    
    [self.previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:self.previewLayer atIndex:0];
    
    stillImageOuteput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey,nil];
    [stillImageOuteput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOuteput];
    
    
    
    [self addVideoInput];
}

- (void)addVideoInput {
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    
    if (!error) {
        if ([session canAddInput:frontFacingCameraDeviceInput]){
            [session addInput:frontFacingCameraDeviceInput];
            [self.previewLayer setSession:session];
        }
        else {
            NSLog(@"Couldn't add front facing video input");
        }
    }
}

- (IBAction)rotateCamera:(id)sender {
    
    if([[[session inputs] objectAtIndex:0] isEqual:frontFacingCameraDeviceInput]){
        [session removeInput:frontFacingCameraDeviceInput];
        [session addInput:backFacingCameraDeviceInput];
    }
    else{
        [session removeInput:backFacingCameraDeviceInput];
        [session addInput:frontFacingCameraDeviceInput];
    }
}

// Camera shoot

-(IBAction)shoot:(id)sender {
    NSLog(@"Camera");
    
    AVCaptureConnection *videoConnection = nil;
    
    for(AVCaptureConnection *connection in stillImageOuteput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if([[port mediaType] isEqual:AVMediaTypeVideo]){
                videoConnection = connection;
                break;
            }
        }
        if(videoConnection){
            break;
        }
    }
    [stillImageOuteput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer != NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *pic = [UIImage imageWithData:imageData];
            
            UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
            PhotofilterViewController *photofilterViewController = [cameraStoryboard instantiateViewControllerWithIdentifier:@"photofilter"];
            photofilterViewController.photoImageview.image = pic;
            photofilterViewController.image = pic;
            photofilterViewController.profilePhoto = _profilePhoto;
            NSLog(@"BOOL test: %d", _profilePhoto ? YES:NO);
            
            [self.navigationController  pushViewController:photofilterViewController animated:YES];
            
            
        }
    }];
}

-(void)styleBars{
    CGRect frame = CGRectMake(0, 0, screenWidth/2, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SHOOT";
//    label.textColor = [UIColor colorWithRed:0.773f green:0.824f blue:0.125f alpha:1.00f];
    label.font=[label.font fontWithSize:20];
    
    self.navItem.titleView = label;
    
    if(self.hideBars){
        [self.tabBarController.tabBar setHidden:YES];
    }

    
    
    // Bottom bar
    [self.pushLabel setText:@"Push to take picture"];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        
    }
    self.image.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // self.image.image = chosenImage;
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [imagePath lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSLog(@"localFilePath.%@",localFilePath);
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    
    //    NSData* data = UIImagePNGRepresentation(chosenImage);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self prepareUploadTokenImage:imageData];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareUploadTokenImage:(NSData *)image{
    // Create file for profile pic
    QBCOFile *file = [QBCOFile file];
    file.name = @"profilePic";
    file.contentType = @"image/jpg";
    file.data = image;
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"User ID"];
    [QBRequest objectsWithClassName:@"ProfilePics" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // If already user profile pic in databse: update profile pic
        if([objects count] > 0){
            if([self userHasAlreadyProfilePic:objects]){
                NSLog(@"User has already Profile Picture.");
                // User already has profilePic: update
                for(int i = 0; i < [objects count]; i++){
                    QBCOCustomObject *object = [objects objectAtIndex:i];
                    if(object.userID == [QBSession currentSession].currentUser.ID){
                        [self uploadTokenImage:file withObjectId:object.ID];
                    }
                }
                
                
            }else{
                // User hasn't got profilePic: create
                [self createNewObjectWithFile:file];
            }
        }else{
            [self createNewObjectWithFile:file];
        }
    } errorBlock:^(QBResponse *response) {
        // If no profile pic for current user: create new profile pic
        NSLog(@"Response error: %@", [response.error description]);
        [self createNewObjectWithFile:file];
        
    }];
    
}

-(BOOL)userHasAlreadyProfilePic:(NSArray *)objects{
    BOOL userHas = false;
    for(int i = 0; i < [objects count]; i++){
        QBCOCustomObject *object = [objects objectAtIndex:i];
        if(object.userID == [QBSession currentSession].currentUser.ID){
            userHas = true;
        }
    }
    return userHas;
}

-(void)createNewObjectWithFile:(QBCOFile *)file{
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = @"ProfilePics"; // your Class name
    [object setID:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID]];
    [object setUserID:[QBSession currentSession].currentUser.ID];
    
    [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
        // do something when object is successfully created on a server
        NSLog(@"Created Object for user proile picture, ID: %@", object.ID);
        [self uploadTokenImage:file withObjectId:object.ID];
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)uploadTokenImage:(QBCOFile *)file withObjectId:(NSString *)objectID{
    [QBRequest uploadFile:file className:@"ProfilePics" objectID:objectID fileFieldName:@"pic" successBlock:^(QBResponse * _Nonnull response, QBCOFileUploadInfo * _Nullable info) {
        //
        NSLog(@"Pic was uploaded");
        NSLog(@"Info: %@", info);
    } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
        //
        NSLog(@"Status %f", status.percentOfCompletion);
    } errorBlock:^(QBResponse * _Nonnull response) {
        //
        NSLog(@"Error: %@", [response.error description]);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

// Standard iPhone Camera
-(void)openCamera{
    NSLog(@"Camera");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void) presentModalView:(UIViewController *)controller {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:controller animated:NO];
}

-(void) presentModalViewFromLeft:(UIViewController *)controller {
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

- (IBAction)closeCam:(id)sender {
    NSLog(@"Shoot children: %@", [self.navigationController childViewControllers]);
//    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *profileNav = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNav"];
//    [self prepareForSegue:[UIStoryboardSegue segueWithIdentifier:@"profileSeg" source:self destination:profileNav performHandler:^{
//        //
//    }] sender:self];
//    
//    [self presentModalView:profileNav];
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gallery:(id)sender {
    UIImagePickerController *ipc= [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [self presentViewController:ipc animated:YES completion:nil];
    else
    {
        //        popover=[[UIPopoverController alloc]initWithContentViewController:ipc];
        //        [popover presentPopoverFromRect:.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}
- (IBAction)flash:(id)sender {
}

- (IBAction)longPress:(id)sender {
  
        self.navigationController.navigationBar.hidden = YES;
        [self totalBlurredFilterForBackground];
//        _menuView.hidden = NO;
//        [self.view bringSubviewToFront:_menuView];


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
    NSLog(@"Tap beside");
    [self blurredFilterAway];
}

-(void)blurredFilterAway{
    blurEffectView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
 //   _menuView.hidden = YES;
}

@end

