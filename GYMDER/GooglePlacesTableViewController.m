//
//  GooglePlacesTableViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "GooglePlacesTableViewController.h"
#import "GymEditViewController.h"
@import GoogleMaps;

@interface GooglePlacesTableViewController (){
    
}

@end

@implementation GooglePlacesTableViewController
@synthesize gymEditVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleTableCell"];
    //    chooseFC = [self.navigationController.childViewControllers objectAtIndex:0];
    
    NSLog(@"Child views %@", self.parentViewController);
    self.repository = [[NSMutableArray alloc]init];
    self.placesIDs = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Repo count %lu", (unsigned long)[_repository count]);
    return [_repository count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.tintColor = [UIColor colorWithRed:1.000f green:1.000f blue:1.000f alpha:1.00f];
    [cell.textLabel setTextColor:[UIColor colorWithRed:1.000f green:1.000f blue:1.000f alpha:1.00f]];
    //    [cell setTextColor:[UIColor colorWithRed:1.000f green:1.000f blue:1.000f alpha:1.00f]];
    GMSAutocompletePrediction* result = [_repository objectAtIndex:indexPath.row];
    cell.textLabel.text = result.attributedFullText.string;
    // cell.textLabel.text = @"Text";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row %ld", (long)indexPath.row);
    NSLog(@"Selected Fitness Club: %@", [self.repository objectAtIndex:indexPath.row]);
    NSLog(@"%@", gymEditVC.inputField.text);
    GMSAutocompletePrediction* result = [self.repository objectAtIndex:indexPath.row];
    
    [self getLocationByPlaceID:result.placeID];
    
    
     NSArray *myArray = [result.attributedFullText.string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    [gymEditVC.inputField setText:[myArray objectAtIndex:0]];
    [gymEditVC setMainGym:[myArray objectAtIndex:0]];
    [gymEditVC.view endEditing:YES];
    [gymEditVC rightBarBarButtonItem];
   
//    gymEditVC.added = YES;
//    [gymEditVC.addButton setEnabled:YES];
//    [gymEditVC.addButton setTitleColor:[UIColor colorWithRed:0.773f green:0.824f blue:0.129f alpha:1.00f] forState:UIControlStateNormal];
//    [gymEditVC.fitnessClub1 setText:[myArray objectAtIndex:0]];
    //    [chooseFC.fitnessClub1 setTextColor:[UIColor colorWithRed:0.773f green:0.824f blue:0.129f alpha:1.00f]];
//    [gymEditVC.gymIcon setHidden:NO];
    //[self.tableView setHidden:YES];
    
    //    userDetailController.lastName = [self.data objectAtIndex:indexPath.row];
    //    [self presentViewController:userDetailController animated:YES completion:^{
    //        //
    //    }];
}

-(void)getLocationByPlaceID:(NSString*)placeID{
    self.placesClient = [[GMSPlacesClient alloc]init];
    NSLog(@"Lookup place for id: %@", placeID);
    [self.placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
           // [chooseFC setGymInput:place];
            
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place placeID %@", place.placeID);
            NSLog(@"Place attributions %@", place.attributions);
            NSLog(@"Place coordinates: %f%@%f", place.coordinate.latitude, @" / ", place.coordinate.longitude);
        } else {
            NSLog(@"No place details for %@", placeID);
        }
    }];
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
