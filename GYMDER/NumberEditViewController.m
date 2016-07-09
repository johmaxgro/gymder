//
//  NumberEditViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "NumberEditViewController.h"
#import "EditProfileViewController.h"
#import "ProfileViewController.h"
@import Quickblox;

@interface NumberEditViewController (){
    NSMutableArray *pickerData;
    NSString *selectedValue;
}

@end

@implementation NumberEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pickerData = [NSMutableArray new];
    
    for(int i = 15; i < 100; i++){
        [pickerData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    // Connect data
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    _pickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width/2, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"EDIT YOUR AGE";
    label.font=[label.font fontWithSize:20];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:20];
    self.navigationItem.titleView = label;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem=newBackButton;

    [_pickerView selectRow:[_currentAge integerValue] inComponent:0 animated:YES];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
     _pickerView.frame = CGRectMake(_pickerView.frame.origin.x, _pickerView.frame.origin.y-(self.view.frame.size.height/4), _pickerView.frame.size.width, _pickerView.frame.size.height);
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"Picker row data: %@", [pickerData objectAtIndex:row]);
    NSString *title = [pickerData objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return [attString string];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString *rowItem = [pickerData objectAtIndex: row];
    UILabel *lblRow = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView bounds].size.width, 44.0f)];
    [lblRow setText:rowItem];
    [lblRow setTextAlignment:NSTextAlignmentCenter];
    [lblRow setTextColor: [UIColor whiteColor]];
    [lblRow.layer setBorderColor:[UIColor whiteColor].CGColor];
    return lblRow;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
        NSString *rowItem = [pickerData objectAtIndex: row];
        UILabel *lblRow = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView bounds].size.width, 44.0f)];
        [lblRow setText:rowItem];
        [lblRow setTextAlignment:NSTextAlignmentCenter];
        [lblRow setTextColor: [UIColor colorWithRed:0.337f green:0.337f blue:0.337f alpha:1.00f]];
        [lblRow setBackgroundColor:[UIColor whiteColor]];
    selectedValue = rowItem;
    [self rightBarBarButtonItem];
}

-(void)rightBarBarButtonItem{
    UIBarButtonItem *readyButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Tick"] style:UIBarButtonItemStyleDone target:self action:@selector(ready)];
    self.navigationItem.rightBarButtonItem=readyButton;
}

-(void)noRightBarButtonItem{
    self.navigationItem.rightBarButtonItem = nil;
}


-(void)ready{
    [self updateUserproperty:selectedValue withType:@"age"];
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
                    
                    editVC.age = property;
                    [editVC.ownUserDataObject setValue:property forKey:@"age"];
                    [profileVC.ownUserData setValue:property forKey:@"age"];
                    [editVC updateUsername];
                    
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

@end
