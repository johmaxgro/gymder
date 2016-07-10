//
//  ChatsOverviewViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 04.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
@import  Quickblox;

@interface ChatsOverviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) QBUUser *currentUser;
@property (strong, nonatomic) NSMutableArray *chatDialogs;

@end
