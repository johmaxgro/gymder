//
//  ChatViewController.m
//  GYMDER
//
//  Created by Johannes Groschopp on 03.07.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewController.h"
@import Quickblox;

@interface ChatViewController (){
    CGFloat screenWidth;
    CGFloat screenHeight;
    QBChatDialog *chatDialog;
    UILabel *titleLabel;
    BOOL isConnecting;
    ChatTableViewController *chatTable;
    NSString *ownGymderName;

}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Chat-Partner ID: %lu", (unsigned long)_chatPartnerID);
    NSLog(@"Chat-Partner: %@", _chatPartner);

    NSLog(@"Self childviews: %@", [self childViewControllers ]);
    chatTable = [[self childViewControllers ]objectAtIndex:0];
    
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;

    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    
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
    
    [self.navigationItem setTitleView:titleLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
  
    
    [self.view addGestureRecognizer:_tapBeside];

}

-(void)viewDidAppear:(BOOL)animated{
    _currentUser = [QBSession currentSession].currentUser;
    if(![[QBChat instance] isConnected]){
        [self setUpConnection];
    }else{
        [self retrieveChatDialogs];
    }
    _messageField.backgroundColor = [UIColor colorWithRed:0.333f green:0.337f blue:0.341f alpha:1.00f];
    self.navigationItem.hidesBackButton = NO;
    [self rightBarButtonItem];
    [self ownGymderName];
}

-(void)rightBarButtonItem{
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView];
}

-(void)noRightBarButtonItem{
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    if(![self.messageField.text isEqualToString:@""]){
        //    [self.commentButton setHidden:YES];
        
    }
    [UIView animateWithDuration:0.02 animations:^
     {
         CGRect newFrame = CGRectMake(self.messageInputView.frame.origin.x, screenHeight/2-(self.messageInputView.frame.size.height/2), self.messageInputView.frame.size.width, self.messageInputView.frame.size.height);
         // tweak here to adjust the moving position
         [self.messageInputView setFrame:newFrame];
         
     }completion:^(BOOL finished)
     {
         
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)retrieveChatDialogs{
    NSLog(@"Retrieving Chat Dialogs");
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:100 skip:0];
    NSMutableDictionary *extendedRequest = [NSMutableDictionary dictionary];
    NSMutableDictionary *extendedRequest2 = [NSMutableDictionary dictionary];
    extendedRequest[@"name"] = [NSString stringWithFormat:@"Chat between %lu%@%lu", (unsigned long)_currentUser.ID, @" and ", (unsigned long)_chatPartnerID];
    extendedRequest2[@"name"] = [NSString stringWithFormat:@"Chat between %lu%@%lu", (unsigned long)_chatPartnerID, @" and ", (unsigned long)_currentUser.ID];
    //  extendedRequest[@"_id"] = @"57446b8ca0eb47cdd7000016";
    
    [QBRequest dialogsForPage:page extendedRequest:extendedRequest successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
        NSLog(@"Dialogs: %@", dialogObjects);
        if([dialogObjects count] == 0){
            [QBRequest dialogsForPage:page extendedRequest:extendedRequest2 successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
                NSLog(@"Dialogs: %@", dialogObjects);
                if([dialogObjects count] == 0){
                    [self createChatDialog];
                }else{
                    chatDialog = [dialogObjects objectAtIndex:0];
                    [chatDialog joinWithCompletionBlock:^(NSError * _Nullable error) {
                        //
                    }];
                    [self getChatHistory];
                }
                
            } errorBlock:^(QBResponse *response) {
                [self createChatDialog];
            }];
            
            
        }else{
            chatDialog = [dialogObjects objectAtIndex:0];
            [chatDialog joinWithCompletionBlock:^(NSError * _Nullable error) {
                //
            }];
            [self getChatHistory];
        }
        
    } errorBlock:^(QBResponse *response) {
        //        [self createChatDialog];
    }];
}

-(void)createChatDialog{
    [titleLabel setText:self.chatPartnerGymderName];
    QBChatDialog *dialog = [[QBChatDialog alloc] initWithDialogID:NULL type:QBChatDialogTypeGroup];
    dialog.name = [NSString stringWithFormat:@"Chat between %lu%@%lu", (unsigned long)_currentUser.ID, @" and ", (unsigned long)_chatPartnerID];
    dialog.occupantIDs = @[@(_currentUser.ID), @(_chatPartnerID)];
    
    [QBRequest createDialog:dialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
        NSLog(@"Chat dialog created");
        chatDialog = createdDialog;
        [chatDialog joinWithCompletionBlock:^(NSError * _Nullable error) {
            //
        }];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Chat dialog couldn't be created");
    }];
}

-(void)getChatHistory{
    NSLog(@"Get Chat History for dialog: %@", chatDialog);
    QBResponsePage *resPage = [QBResponsePage responsePageWithLimit:20 skip:0];
    
    [QBRequest messagesWithDialogID:chatDialog.ID extendedRequest:nil forPage:resPage successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *responcePage) {
        isConnecting = NO;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font=[titleLabel.font fontWithSize:20];
        [titleLabel setText:[self.chatPartnerGymderName uppercaseString]];
        [self noRightBarButtonItem];
        
        NSLog(@"Chat history: %@", messages);
        [chatTable setChatMessages:messages];
        NSLog(@"chatTable chatMessages: %@", chatTable.chatMessages);
        [self markMessageAsRead:messages];
        [chatTable.tableView reloadData];
        [chatTable.tableView reloadData];
        [chatTable scrollToLastMessage];
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"error history: %@", response.error);
    }];
    
}

-(void)markMessageAsRead:(NSArray *)messages{
    for(int i = 0; i < [messages count]; i++){
        QBChatMessage *message = [messages objectAtIndex:i];
        if(!message.isRead){
            [self chatDidReceiveMessage:message];
        }
    }
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message
{
    
    // read message
    
    
    // sends 'read' status back
    if([message markable]){
        [[QBChat instance] readMessage:message completion:^(NSError * _Nullable error) {
            
        }];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)ownGymderName{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        for(int i = 0; i < [objects count]; i++){
            QBCOCustomObject *userObject = [objects objectAtIndex:i];
            if(userObject.userID == [QBSession currentSession].currentUser.ID){
                
                NSMutableDictionary *fields = userObject.fields;
                
                ownGymderName = [fields objectForKey:@"gymdername"];
                
                
            }
        }
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
}

- (IBAction)send:(id)sender {
    [[QBChat instance] addDelegate:self];
    NSLog(@"Send to chat dialog: %@", chatDialog);
    QBChatMessage *message = [QBChatMessage message];
    [message setText:self.messageField.text];
    message.senderID = [QBSession currentSession].currentUser.ID;
    //
    [self.messageField resignFirstResponder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    //
    [chatDialog sendMessage:message completionBlock:^(NSError * _Nullable error) {
        
        [self getChatHistory];
        
        
        [self sendPushNotificationWithMessage:message.text];
        
        if(error != nil){
            NSLog(@"Error sending message: %@", error);
        }else{
            _messageField.text = @"";
        }
    }];
}

-(void)sendPushNotificationWithMessage:(NSString*)message{
    
    QBMEvent *event = [QBMEvent event];
    event.notificationType = QBMNotificationTypePush;
    event.usersIDs = [NSString stringWithFormat:@"%lu", (unsigned long)_chatPartnerID];
    NSLog(@"Send Push notification to: %lu", (unsigned long)_chatPartnerID);
    event.type = QBMEventTypeOneShot;
    
    
    //
    NSMutableDictionary  *dictPush = [NSMutableDictionary  dictionary];
    [dictPush setObject:[NSString stringWithFormat:@"%@%@%@", ownGymderName, @": ", message] forKey:@"message"];
    //    [dictPush setObject:@"5" forKey:@"ios_badge"];
    [dictPush setObject:@"default" forKey:@"ios_sound"];
    [dictPush setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    [dictPush setObject:@"chat" forKey:@"type"];
    
    
    // custom params
    [dictPush setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    NSError *error = nil;
    NSData *sendData = [NSJSONSerialization dataWithJSONObject:dictPush options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
    //
    event.message = jsonString;
    
    [QBRequest createEvent:event successBlock:^(QBResponse * _Nonnull response, NSArray<QBMEvent *> * _Nullable events) {
        // Successful response with event
    } errorBlock:^(QBResponse * _Nonnull response) {
        // Handle error
    }];
    
}

- (IBAction)tapBeside:(id)sender {
    [_messageField endEditing:YES];
}
@end
