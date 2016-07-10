//
//  ChatTableViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 03.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *chatMessages;

-(void)scrollToLastMessage;

@end
