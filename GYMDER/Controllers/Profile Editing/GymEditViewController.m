//
//  GymEditViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "GymEditViewController.h"
#import "GooglePlacesTableViewController.h"
#import "EditProfileViewController.h"
@import Quickblox;

@interface GymEditViewController (){
    UILabel *label;
    GooglePlacesTableViewController *gptvc;
    EditProfileViewController *editVC;
}

@end

@implementation GymEditViewController

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
    label.text = @"YOUR GYM";
    label.font=[label.font fontWithSize:20];
    label.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:20];
    self.navigationItem.titleView = label;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    _inputField.text = _mainGym;
    
    gptvc.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [_inputField setDelegate:self];
    
    
    
    gptvc = [self.childViewControllers objectAtIndex:0];
    gptvc.gymEditVC = self;
    editVC = [[self.navigationController childViewControllers]objectAtIndex:[[self.navigationController childViewControllers]count]-2];
    
    _tableContainer.backgroundColor = [UIColor clearColor];

}

-(void)viewDidAppear:(BOOL)animated{
    [_inputField becomeFirstResponder];
}

-(void)rightBarBarButtonItem{
    UIBarButtonItem *readyButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Tick"] style:UIBarButtonItemStyleDone target:self action:@selector(ready)];
    self.navigationItem.rightBarButtonItem=readyButton;
}

-(void)noRightBarButtonItem{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)ready{
    editVC.gym = _mainGym;
    [self loadUpFitnessClub:_mainGym];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self.tableContainer setHidden:NO];
    [self placeAutocomplete:substring];
    NSLog(@"Substring: %@", substring);
    return YES;
}

// Google Maps autocomplete method
- (void)placeAutocomplete:(NSString *)current {
    NSLog(@"Google Places");
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    self.placesClient = [[GMSPlacesClient alloc]init];
    //  filter.type = kGMSPlaceTypeGym;
    [filter setType:kGMSPlacesAutocompleteTypeFilterEstablishment];
    
    
    
    
    [self.placesClient autocompleteQuery:current
                                  bounds:nil
                                  filter:filter
                                callback:^(NSArray *results, NSError *error) {
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        return;
                                    }
                                    [gptvc.repository removeAllObjects];
                                    for (GMSAutocompletePrediction* result in results) {
                                        NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                        NSLog(@"Result 2: %@", result.attributedSecondaryText);
                                        //                                        [self getLocationByPlaceID:result.placeID];
                                        [gptvc.repository addObject:result];
                                        [gptvc.placesIDs addObject:result.placeID];
                                        
                                        [gptvc.tableView reloadData];
                                        //                                    [self contentToTableView:result.attributedFullText.string];
                                    }
                                }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)loadUpFitnessClub:(NSString *)fitnessClub{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"User ID"];
    NSArray *myArray = [fitnessClub componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    NSString *shortFitnessClub = [myArray objectAtIndex:0];
    
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *userObject = [objects objectAtIndex:i];
            if(userObject.userID == [QBSession currentSession].currentUser.ID){
                
                //        QBCOCustomObject *object = [QBCOCustomObject customObject];
                //        object.className = @"UserProperties";
                [userObject.fields setObject:shortFitnessClub forKey:@"mainfitnessclub"];
                //        object.ID = object.ID;
                NSLog(@"Loading up fintess club %@", shortFitnessClub);
                
                [QBRequest updateObject:userObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                    // object updated
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
