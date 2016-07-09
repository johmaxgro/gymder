//
//  TextinputViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "TextinputViewController.h"
#import "EditProfileViewController.h"
#import "ProfileViewController.h"
@import Quickblox;

@interface TextinputViewController (){
    UILabel *label;
}

@end

@implementation TextinputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width/2, 44);
    label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [[NSString stringWithFormat:@"%@%@", @"Edit your ", _navigationTitle]uppercaseString];
    label.font=[label.font fontWithSize:20];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:20];
    self.navigationItem.titleView = label;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem=newBackButton;

    [_textfield becomeFirstResponder];
    _textfield.placeholder = [[NSString stringWithFormat:@"%@%@", @"YOUR ", _navigationTitle]uppercaseString];
    if([_navigationTitle isEqualToString:@"email"]){
        _textfield.keyboardType = UIKeyboardTypeEmailAddress;
    }
    if([_navigationTitle isEqualToString:@"phone"]){
        _textfield.keyboardType = UIKeyboardTypePhonePad;
        label.text = [[NSString stringWithFormat:@"%@%@%@", @"EDIT YOUR ", _navigationTitle, @" NUMBER"]uppercaseString];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    _textfield.placeholder = [[NSString stringWithFormat:@"%@%@", @"Your ", _navigationTitle]uppercaseString];
    [_textfield becomeFirstResponder];
    if([_navigationTitle isEqualToString:@"email"]){
        _textfield.keyboardType = UIKeyboardTypeEmailAddress;
    }
    if([_navigationTitle isEqualToString:@"phone"]){
        _textfield.keyboardType = UIKeyboardTypePhonePad;
        label.text = [[NSString stringWithFormat:@"%@%@%@", @"Edit your ", _navigationTitle, @" number"] uppercaseString];
    }
}

-(void)viewDidLayoutSubviews{
    _textfield.frame = CGRectMake(_textfield.frame.origin.x, _textfield.frame.origin.y-(self.view.frame.size.height/4), _textfield.frame.size.width, _textfield.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightBarBarButtonItem{
    UIBarButtonItem *readyButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Tick"] style:UIBarButtonItemStyleDone target:self action:@selector(ready)];
    self.navigationItem.rightBarButtonItem=readyButton;
}

-(void)noRightBarButtonItem{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)ready{
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView];
    
    if([_navigationTitle isEqualToString:@"username"]){
        [self updateUserproperty:_textfield.text withType:@"gymdername"];
    }
    if([_navigationTitle isEqualToString:@"info"]){
        [self updateUserproperty:_textfield.text withType:@"info"];
    }
    if([_navigationTitle isEqualToString:@"phone"]){
        [self updateUserproperty:_textfield.text withType:@"phone"];
    }
    if([_navigationTitle isEqualToString:@"email"]){
        [self updateUserproperty:_textfield.text withType:@"email"];
    }
}

-(void)updateUserproperty:(NSString*)property withType:(NSString*)type{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *userObject = [objects objectAtIndex:i];
            if(userObject.userID == [QBSession currentSession].currentUser.ID){
            
                [userObject.fields setObject:property forKey:type];
    
               
                [QBRequest updateObject:userObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                    // object updated
                    EditProfileViewController *editVC = [[self.navigationController childViewControllers] objectAtIndex:1];
                    ProfileViewController *profileVC = [[self.navigationController childViewControllers] objectAtIndex:0];
                    
                    if([type isEqualToString:@"gymdername"]){
                        editVC.username = _textfield.text;
                        [editVC.ownUserDataObject setValue:_textfield.text forKey:@"gymdername"];
                        [profileVC.ownUserData setValue:_textfield.text forKey:@"gymdername"];
                        [editVC updateUsername];
                    }
                    if([type isEqualToString:@"info"]){
                        editVC.info = _textfield.text;
                        [editVC updateInfo];
                        [profileVC.ownUserData setValue:_textfield.text forKey:@"info"];
                    }
                    if([type isEqualToString:@"phone"]){
                        editVC.phone = _textfield.text;
                        [editVC updatePhone];
                        [profileVC.ownUserData setValue:_textfield.text forKey:@"phone"];
                    }
                    if([type isEqualToString:@"email"]){
                        editVC.email = _textfield.text;
                        [editVC updateEmail];
                        [profileVC.ownUserData setValue:_textfield.text forKey:@"email"];
                    }
                
                    [self.navigationController popViewControllerAnimated:YES];
                } errorBlock:^(QBResponse *response) {
                    // error handling
                    NSLog(@"Response error: %@", [response.error description]);
                }];
            }}
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
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

- (IBAction)textinputEdit:(id)sender {
    if([_textfield.text isEqualToString:@""]){
        [self noRightBarButtonItem];
    }else{
        [self rightBarBarButtonItem];
    }
}
@end
