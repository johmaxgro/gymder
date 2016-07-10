//
//  ChatTableViewCell.h
//  GYMDER
//
//  Created by Johannes Groschopp on 03.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *chatPartnerTextView;
@property (weak, nonatomic) IBOutlet UILabel *chatPartnerLabel;
@property (weak, nonatomic) IBOutlet UITextField *ownTextView;
@property (weak, nonatomic) IBOutlet UILabel *ownLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownTime;
@property (weak, nonatomic) IBOutlet UIView *ownTimeView;
@property (weak, nonatomic) IBOutlet UIView *chatPartnerTimeView;
@property (weak, nonatomic) IBOutlet UILabel *chatPartnerTime;

@end
