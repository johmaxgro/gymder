//
//  BubblesViewController.h
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bubble.h"
#import "BubbleContent.h"
@class BubbleContent;

@interface BubblesViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet Bubble *bubble;


@property (strong, nonatomic) NSMutableDictionary *bubbles;

@property (strong, nonatomic) NSMutableDictionary *allBubbles;

-(void)newBubble:(NSMutableDictionary*)newBubble withKey:(NSString*)userID;

-(BubbleContent*)getBubbleContent;

-(void)addNewBubbleToUniverse:(NSMutableDictionary*)bubbleContent;

-(void)test;

-(void)bubbleReady:(NSNotification*)notification;

@end
