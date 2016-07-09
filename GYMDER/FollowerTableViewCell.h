//
//  FollowerTableViewCell.h
//  GYMDER
//
//  Created by Johannes Groschopp on 05.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
