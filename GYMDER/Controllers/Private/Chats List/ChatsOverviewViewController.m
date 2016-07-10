//
//  ChatsOverviewViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 04.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ChatsOverviewViewController.h"

@interface ChatsOverviewViewController (){
    CGFloat screenWidth;
    UILabel *titleLabel;
    QBChatDialog *chatDialog;
}

@end

@implementation ChatsOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    _chatDialogs = [NSMutableArray new];
    
    [self.navigationController.navigationBar setHidden:NO];

    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem=newBackButton;
    
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"Back Button"];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 0, screenWidth/2, 44);
    titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setText:@"LOADING CHATS..."];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font=[titleLabel.font fontWithSize:20];
    self.navigationItem.titleView = titleLabel;
    
    _containerView.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    self.view.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    
    [self.navigationController.navigationItem setHidesBackButton:NO];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatsLoaded:) name:@"ChatsLoaded" object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)chatsLoaded:(NSNotification*)notification{
    [self titleLabel];
}

-(void)titleLabel{
    CGRect frame = CGRectMake(0, 0, screenWidth/2, 44);
    titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ClanOffcPro-Ultra" size:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setText:@"CHATS"];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font=[titleLabel.font fontWithSize:20];
    self.navigationItem.titleView = titleLabel;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
