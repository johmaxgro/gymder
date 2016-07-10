//
//  TextinputViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 29.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextinputViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (strong, nonatomic) NSString *navigationTitle;
- (IBAction)textinputEdit:(id)sender;
 
@end
