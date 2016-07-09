//
//  ChatsTableViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 04.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ChatsTableViewController.h"
#import "ChatNotificationTableViewCell.h"
#import "ChatViewController.h"
@import  Quickblox;

@interface ChatsTableViewController (){
    QBChatDialog *chatDialog;
    UILabel *titleLabel;
    CGFloat screenWidth;
}

@end

@implementation ChatsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    _chatDialogs = [NSMutableArray new];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
}

-(void)viewDidAppear:(BOOL)animated{
    _currentUser = [QBSession currentSession].currentUser;
    if(![[QBChat instance] isConnected]){
        [self setUpConnection];
    }else{
        [self retrieveChatDialogs];
    }
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

    return [_chatDialogs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatNotificationCell" forIndexPath:indexPath];
    // Configure the cell...
    QBChatDialog *currentChatDialog = [_chatDialogs objectAtIndex:indexPath.row];
    cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width/2;
    cell.messageLabel.text = currentChatDialog.lastMessageText;
 
    cell.time.text = [self messageAge:currentChatDialog.lastMessageDate];
    

    
    cell.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    
    [self getUserImage:[self partnerOccupantID:[currentChatDialog.occupantIDs mutableCopy]] andAddToImageView:cell.userImage];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatNotificationCell" forIndexPath:indexPath];
    QBChatDialog *currentChatDialog = [_chatDialogs objectAtIndex:indexPath.row];
    [self openChatByDialog:currentChatDialog fromCell:cell];
}

-(NSString*)messageAge:(NSDate*)messageDate{
    NSDate *startDate = messageDate;
    NSDate *endDate = [NSDate date];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitSecond;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:messageDate];
    
    if([components month] >= 1){
        return [NSString stringWithFormat:@"%ld%@%ld%@%ld", (long)[components2 day], @".", (long)[components2 month], @".", (long)[components2 year]];
    }
    else if (([components month] <= 1) && ([components day] >= 1)){
        return [NSString stringWithFormat:@"%ld%@",  (long)[components day], @" d"];
    }
    else if (([components month] <= 1) && ([components day] < 1) ){
        return [NSString stringWithFormat:@"%ld%@", (long)[components hour], @" h"];
    }else if(([components month] <= 1) && ([components day] < 1) && ([components hour] < 1)){
        return [NSString stringWithFormat:@"%ld%@", (long)[components minute], @" m"];
    }else{
        return [NSString stringWithFormat:@"%ld%@", (long)[components second], @" s"];
    }
 
}


-(NSUInteger)partnerOccupantID:(NSMutableArray*)occupants{
    for(int i = 0; i < 3; i++){
        if([[occupants objectAtIndex:i] integerValue] != _currentUser.ID){
            return [[occupants objectAtIndex:i] integerValue];
        }
    }
    return 0;
}

- (void)openChatByDialog:(QBChatDialog*)dialog fromCell:(ChatNotificationTableViewCell*)cell{
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatViewController *chat = [cameraStoryboard instantiateViewControllerWithIdentifier:@"chat"];
    [QBRequest userWithID:[self partnerOccupantID:[dialog.occupantIDs mutableCopy]] successBlock:^(QBResponse *response, QBUUser *user) {
        // Successful response with user
        chat.chatPartner = user;
        chat.chatPartnerID = user.ID;
        chat.chatPartnerImage = cell.userImage.image;
        
        NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
        
        [getRequest setObject:[NSString stringWithFormat:@"%lu", (unsigned long)user.ID]forKey:@"user_id"];
        
        [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
            // response processing
            QBCOCustomObject *chatPartnerRecord = [objects objectAtIndex:0];
            chat.chatPartnerGymderName = [chatPartnerRecord.fields objectForKey:@"gymdername"];
            [self.navigationController pushViewController:chat animated:YES];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];

    
    
    
}



-(void)setUpConnection{
    NSLog(@"Set up Chat connection");
    [QBSettings setAutoReconnectEnabled:YES];
    
    //  currentUser.ID = 56;
    _currentUser.password = [QBSession currentSession].sessionDetails.token;
    
    // connect to Chat
    [[QBChat instance] connectWithUser:_currentUser completion:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error);
        [self retrieveChatDialogs];
        
    }];
    
}

-(void)retrieveChatDialogs{
    NSLog(@"Retrieving Chat Dialogs");
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:100 skip:0];
    NSMutableDictionary *extendedRequest = [NSMutableDictionary dictionary];
    extendedRequest[@"occupants_ids[in]"] = [NSString stringWithFormat:@"%lu", (unsigned long)_currentUser.ID];
    extendedRequest[@"sort_desc"] = @"last_message_date_sent";
    
    
    [QBRequest dialogsForPage:page extendedRequest:extendedRequest successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
        NSLog(@"Dialogs: %@", dialogObjects);
        _chatDialogs = [dialogObjects mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatsLoaded" object:self];
        [self.tableView reloadData];
        if([dialogObjects count] == 0){
            
        }else{
            [chatDialog joinWithCompletionBlock:^(NSError * _Nullable error) {
                //
            }];
            //  [self getChatHistory];
        }
        
    } errorBlock:^(QBResponse *response) {
    }];
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
