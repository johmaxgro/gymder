//
//  RadarUserTableViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 19.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "RadarUserTableViewController.h"
#import "RadarUserTableViewCell.h"
#import "ProfileViewController.h"
#import "OtherUserData.h"

@interface RadarUserTableViewController (){
    OtherUserData *otherUserData;
    ProfileViewController *profileVC;
    UINavigationController *profileNav;
}

@end

@implementation RadarUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    otherUserData = [[OtherUserData alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherUserData:) name:@"OtherUserData" object:nil];
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_radarUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadarUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radarUserCell" forIndexPath:indexPath];
    NSDictionary *current = [_radarUsers objectAtIndex:indexPath.row];
    
    cell.radarUserName.text = [NSString stringWithFormat:@"%@%@%@", [current objectForKey:@"gymdername"], @", ",[current objectForKey:@"age"]];
    cell.radarUserImage.image = [current objectForKey:@"userimage"];
    cell.radarUserImage.layer.cornerRadius = 22;
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *selected = [_radarUsers objectAtIndex:indexPath.row];
    
    // Display Alert Message
    NSLog(@"Select: %@", selected);
    profileNav = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
    NSLog(@"[profileNav childViewControllers] objectAtIndex:0] %@", [[profileNav childViewControllers] objectAtIndex:0]);
    profileVC = [[profileNav childViewControllers] objectAtIndex:0];
    [profileVC setImage:[selected objectForKey:@"userimage"]];
    [profileVC setOwnProfile:NO];
    NSString *userID = [selected objectForKey:@"user_id"];
    otherUserData.fromRadar = YES;
    otherUserData.userID = [userID integerValue];
    [otherUserData getOtherUserData];
//    [profileVC setOwnUserDataObject:_ownUserDataObject];
//    [profileVC setOwnUserData:[_ownUserDataObject.userDataArray objectAtIndex:0]];
//    
//    
//    [self presentViewController:profileNav animated:NO completion:nil];

    
}

-(void)otherUserData:(NSNotification*)notification{
    NSLog(@"Visited User Data: %@", notification.userInfo);
    [profileVC setOwnUserDataObject:[notification.userInfo mutableCopy]];
    [profileVC setOwnUserData:[notification.userInfo mutableCopy]];
    //    [profileVC setOwnUserData:[_ownUserDataObject.userDataArray objectAtIndex:0]];
    [self presentViewController:profileNav animated:NO completion:nil];
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
