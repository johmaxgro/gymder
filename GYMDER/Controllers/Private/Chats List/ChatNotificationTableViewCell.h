//
//  ChatNotificationTableViewCell.h
//  GYMDER
//
//  Created by Johannes Groschopp on 04.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;


@end
