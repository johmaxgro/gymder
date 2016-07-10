//
//  ChatViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 03.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Quickblox;

@interface ChatViewController : UIViewController <QBChatDelegate>

@property (strong, nonatomic) QBUUser *chatPartner;
@property (strong, nonatomic) QBUUser *currentUser;
@property (nonatomic) NSUInteger chatPartnerID;
@property (strong, nonatomic) UIImage *chatPartnerImage;
@property (strong, nonatomic) NSString *chatPartnerGymderName;

@property (weak, nonatomic) IBOutlet UIView *messageInputView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapBeside;
- (IBAction)tapBeside:(id)sender;

@end
