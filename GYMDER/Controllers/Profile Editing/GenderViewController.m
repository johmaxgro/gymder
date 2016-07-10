//
//  GenderViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "GenderViewController.h"
#import "EditProfileViewController.h"
@import Quickblox;

@interface GenderViewController (){
    UILabel *label;
    BOOL male;
    BOOL female;
}

@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view;
    [_maleLabel addGestureRecognizer:_maleTap];
    [_femaleLabel addGestureRecognizer:_femaleTap];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width/2, 44);
    label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"YOUR GENDER";
    label.font=[label.font fontWithSize:20];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:20];
    self.navigationItem.titleView = label;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem=newBackButton;

}

-(void)viewDidLayoutSubviews{
    _maleLabel.frame = CGRectMake(_maleLabel.frame.origin.x, _maleLabel.frame.origin.y, _maleLabel.frame.size.width, _maleLabel.frame.size.height+40);
     _femaleLabel.frame = CGRectMake(_femaleLabel.frame.origin.x, _femaleLabel.frame.origin.y, _femaleLabel.frame.size.width, _femaleLabel.frame.size.height+40);
    if([_currentGender isEqualToString:@"male"]){
        [self activateMale];
    }
    if([_currentGender isEqualToString:@"female"]){
        [self activateFemale];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

- (IBAction)tappedMale:(id)sender {
    [self activateMale];
    [self rightBarBarButtonItem];
}

- (IBAction)tappedFemale:(id)sender {
    [self activateFemale];
    [self rightBarBarButtonItem];
}

-(void)activateMale{
    _maleLabel.backgroundColor = [UIColor whiteColor];
    _femaleLabel.backgroundColor = [UIColor clearColor];
    _femaleLabel.textColor = [UIColor whiteColor];
    _maleLabel.textColor = [UIColor colorWithRed:0.337f green:0.337f blue:0.337f alpha:1.00f];
    male = YES;
}

-(void)activateFemale{
    _femaleLabel.backgroundColor = [UIColor whiteColor];
    _femaleLabel.textColor = [UIColor colorWithRed:0.337f green:0.337f blue:0.337f alpha:1.00f];
    _maleLabel.backgroundColor = [UIColor clearColor];
    _maleLabel.textColor = [UIColor whiteColor];
    female = YES;
}

-(void)ready{
    if(male){
        [self updateUserproperty:@"male" withType:@"gender"];
    }
    if(female){
        [self updateUserproperty:@"female" withType:@"gender"];
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
                    if(male){
                        editVC.gender = @"male";
                        [editVC.ownUserDataObject setValue:@"male" forKey:@"gender"];
                    }
                    if(female){
                        editVC.gender = @"female";
                        [editVC.ownUserDataObject setValue:@"female" forKey:@"gender"];
                    }
                   
                    [editVC updateGender];
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


@end
