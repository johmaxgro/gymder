//
//  ChatTableViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 03.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatTableViewCell.h"
@import Quickblox;

@interface ChatTableViewController ()

@end

@implementation ChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f]];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f]];
    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
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
    NSLog(@"Number of cell rows: %lu", (unsigned long)[self.chatMessages count]);
    return  [self.chatMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Height for row depending on size of message...
    
    QBChatMessage *currentMessage = [self.chatMessages objectAtIndex:indexPath.row];
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGSize stringsize = [currentMessage.text sizeWithAttributes:attr];
    
    if(stringsize.height > 40){
        return stringsize.height+10;
    }else{
        return 40;
    }
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell *cell;
    
    QBChatMessage *currentMessage = [self.chatMessages objectAtIndex:indexPath.row];
    NSString *messageText = currentMessage.text;
    
    if(currentMessage.senderID == [QBSession currentSession].currentUser.ID){
        cell = [tableView dequeueReusableCellWithIdentifier:@"chatTableCellOwn" forIndexPath:indexPath];
        NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:8]};
        CGSize stringsize = [messageText sizeWithAttributes:attr];
        [cell.ownTextView setBackgroundColor:[UIColor colorWithRed:0.612f green:0.702f blue:0.757f alpha:1.00f]];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
        
        //[cell.ownProfileImage setImage:self.ownImage];
        [cell.ownTextView setText:messageText];
        [cell.ownTextView setFrame:CGRectMake(cell.ownTextView.frame.origin.x, cell.frame.origin.y, stringsize.width, stringsize.height)];
        
        NSDictionary *attr1 = @{NSFontAttributeName: [UIFont systemFontOfSize:11]};
        CGSize stringsize1 = [@"hh:mm" sizeWithAttributes:attr1];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentMessage.dateSent];
        NSString *hour = [NSString stringWithFormat:@"%ld", [components hour]];
        NSString *minute = [NSString stringWithFormat:@"%ld", [components minute]];
        if(minute.length == 1){
            minute = [NSString stringWithFormat:@"%d%@", 0, minute];
        }
        if(hour.length == 1){
            hour = [NSString stringWithFormat:@"%d%@", 0, hour];
        }
        
        [cell.ownTime setText:[NSString stringWithFormat:@"%@%@%@", hour, @":", minute]];
        
        NSLog(@"Chat Text: %@", currentMessage.text);
        NSLog(@"Chat time: %@%@%@", hour, @".", minute);
        
        cell.ownTextView.rightView = cell.ownTimeView;
        cell.ownTextView.rightViewMode = UITextFieldViewModeAlways;
//        cell.ownTime.frame = CGRectOffset(cell.ownTime.frame, 0, 5);
        //  [cell.contentView addSubview:time];
    }else{
        // Table view cell for partner (left side speech bubble)...
        cell = [tableView dequeueReusableCellWithIdentifier:@"chatTableCellPartner" forIndexPath:indexPath];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentMessage.dateSent];
        NSString *hour = [NSString stringWithFormat:@"%ld", [components hour]];
        NSString *minute = [NSString stringWithFormat:@"%ld", [components minute]];
        if(minute.length == 1){
            minute = [NSString stringWithFormat:@"%d%@", 0, minute];
        }
        if(hour.length == 1){
            hour = [NSString stringWithFormat:@"%d%@", 0, hour];
        }
        [cell.chatPartnerTime setText:[NSString stringWithFormat:@"%@%@%@", hour, @":", minute]];
        
        NSLog(@"Chat Text: %@", currentMessage.text);
        NSLog(@"Chat time: %@%@%@", hour, @".", minute);
        
        cell.chatPartnerTextView.rightView = cell.chatPartnerTimeView;
        cell.chatPartnerTextView.rightViewMode = UITextFieldViewModeAlways;
//        cell.chatPartnerTime.frame = CGRectOffset(cell.chatPartnerTime.frame, 0, 5);
        [cell.chatPartnerTextView setBackgroundColor:[UIColor colorWithRed:0.749f green:0.749f blue:0.749f alpha:1.00f]];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
        [cell.chatPartnerTextView setText:messageText];
    }
    
    
    
    
    // Configure the cell...
    
    
    
    return cell;
}

-(void)scrollToLastMessage{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatMessages count]-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
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
