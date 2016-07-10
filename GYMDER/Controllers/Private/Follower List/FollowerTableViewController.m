//
//  FollowerTableViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 05.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "FollowerTableViewController.h"
#import "FollowerTableViewCell.h"
#import "ProfileViewController.h"
@import Quickblox;

@interface FollowerTableViewController (){
    ProfileViewController *profileVC;
    OtherUserData *otherUserData;
    UINavigationController *profileNav;
}

@property (strong, nonatomic) NSMutableArray *follower;
@property (strong, nonatomic) NSMutableArray *followerProperties;


@end


@implementation FollowerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _follower = [NSMutableArray new];
    _followerProperties = [NSMutableArray new];
    
    otherUserData = [[OtherUserData alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherUserData:) name:@"OtherUserDataFollower" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self getFollower];
    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_follower removeAllObjects];
    [_followerProperties removeAllObjects];
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
    return [_follower count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CELL");
    FollowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"followerCell" forIndexPath:indexPath];
    cell.image.layer.cornerRadius = cell.image.frame.size.width/2;
    cell.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    QBCOCustomObject *followerObject;
    @try {
        followerObject = [_followerProperties objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        
    }
    
    NSLog(@"followerObject: %@", followerObject);
    cell.userName.text = [followerObject.fields objectForKey:@"gymdername"];
    [self getUserImage:followerObject.userID andAddToImageView:cell.image];
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    QBCOCustomObject *userPropertiesObject = [_followerProperties objectAtIndex:indexPath.row];
    [self openProfileFromUser:cell.image.image andUserID:[NSString stringWithFormat:@"%lu", (unsigned long)userPropertiesObject.userID]];
}

-(void)otherUserData:(NSNotification*)notification{
    NSLog(@"Visited User Data: %@", notification.userInfo);
    [profileVC setOwnUserDataObject:[notification.userInfo mutableCopy]];
    [profileVC setOwnUserData:[notification.userInfo mutableCopy]];
    //    [profileVC setOwnUserData:[_ownUserDataObject.userDataArray objectAtIndex:0]];
    [self presentViewController:profileNav animated:NO completion:nil];
}

-(void)openProfileFromUser:(UIImage*)image andUserID:(NSString*)userID{
    profileNav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileNav"];
    NSLog(@"[profileNav childViewControllers] objectAtIndex:0] %@", [[profileNav childViewControllers] objectAtIndex:0]);
    profileVC = [[profileNav childViewControllers] objectAtIndex:0];
    [profileVC setImage:image];
    [profileVC setOwnProfile:NO];
    otherUserData.userID = [userID integerValue];
    otherUserData.fromRadar = NO;
    otherUserData.fromFollower = YES;
    otherUserData.fromArena = NO;
    [otherUserData getOtherUserData];
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

-(void)getFollower{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        if([objects count] != 0){
            
            QBCOCustomObject *object = [objects objectAtIndex:0];
            
            _follower = [[object.fields objectForKey:@"followingme"] mutableCopy];
            
            [self getUserInfosForFollower];
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

-(void)getUserInfosForFollower{
    NSLog(@"getUserInfosForFollower ");
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    for(int i = 0; i < [_follower count]; i++){
        
        [getRequest setObject:[_follower objectAtIndex:i] forKey:@"user_id"];
    
        [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
            // response processing
    
            NSLog(@"Response object: %@", [objects objectAtIndex:0]);
            [_followerProperties addObject: [objects objectAtIndex:0]];
            
            if(i == [_follower count]-1){
                NSLog(@"follower properties: %@", _followerProperties);
                [self.tableView reloadData];
            }
        
        } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
        }];
    }
   
}

-(void)getUserImage:(NSUInteger)userID andAddToImageView:(UIImageView*)iV{
    NSLog(@"USERIMAGE");
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)userID] forKey:@"user_id"];
    NSLog(@"getUserImage for %lu", (unsigned long)userID);
    [QBRequest objectsWithClassName:@"ProfilePics" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        
        if([objects count] != 0){
            QBCOCustomObject *current = [objects objectAtIndex:0];
            [QBRequest downloadFileFromClassName:@"ProfilePics" objectID:current.ID fileFieldName:@"pic"
                                    successBlock:^(QBResponse *response, NSData *loadedData) {
                                        // file downloaded
                                        
                                        if(loadedData != nil){
                                            
                                            UIImage *profileImage = [UIImage imageWithData:loadedData];
                                            
                                            if(profileImage != nil){
                                                [iV setImage:profileImage];
                                            }
                                            
                                        }
                                    } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                                        // handle progress
                                        NSLog(@"Process Profile Pic: %f", status.percentOfCompletion);
                                        
                                    } errorBlock:^(QBResponse *error) {
                                        // error handling
                                        NSLog(@"Response error download: %@", [error description]);
                                    }];
            
            
        }
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    
    
}



@end
