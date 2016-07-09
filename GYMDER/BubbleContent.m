//
//  BubbleContent.m
//  GYMDER
//
//  Created by Johannes Groschopp on 08.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "BubbleContent.h"
@import Quickblox;

@implementation BubbleContent{
    NSMutableDictionary *bubble;
    int downloadCounter;
}

-(void)createBubble{
    NSLog(@"Creating new Bubble.");
    if(_bubbles == nil){
        
    }
    bubble = [NSMutableDictionary new];
    
    
//    [bubble setObject:_gymderName forKey:@"gymdername"];
//    [bubble setObject:_age forKey:@"age"];
//    [bubble setObject:_gym forKey:@"gym"];
//    [bubble setObject:_info forKey:@"info"];
    [bubble setObject:[NSNumber numberWithFloat:_physicalDistance] forKey:@"physicaldistance"];
//    [bubble setObject:_direction forKey:@"direction_to_user"];
    [bubble setObject:_userLocation forKey:@"userlocation"];
    
    [self getProfileImageByUserID:_userID andAddToDictionary:bubble];
    //... alle weiteren infos...
    
}

-(void)setLocationDirection:(NSNumber*)direction{
    NSLog(@"Direction to user: %@", direction);
    [bubble setObject:direction forKey:@"direction_to_user"];
}

// Quickblox

-(void)getProfileImageByUserID:(NSUInteger)userID andAddToDictionary:(NSMutableDictionary*)toAdd{
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSString stringWithFormat:@"%lu",(unsigned long)userID] forKey:@"user_id"];
    NSLog(@"Profile Image Download with user_id: %lu", (unsigned long)_userID);
    
    [QBRequest objectsWithClassName:@"ProfilePics" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        QBCOCustomObject *userObject = [objects objectAtIndex:0];
        [QBRequest downloadFileFromClassName:@"ProfilePics" objectID:userObject.ID fileFieldName:@"pic"
                                successBlock:^(QBResponse *response, NSData *loadedData) {
                                    // file downloaded
                                    
                                    NSLog(@"Profile image downloaded: %lu", (unsigned long)_userID);
                                    NSLog(@"Counter: %d", downloadCounter+=1);
                                    
                                    if(loadedData != nil){
                                        
                                        UIImage *profileImage = [UIImage imageWithData:loadedData];
                                        
                                        if(profileImage != nil){
                                            [toAdd setObject:profileImage forKey:@"profileimage"];
                                            [self getUserInfoByUserID:_userID andAddToDictionary:toAdd];
                                           
                                        }
                                        
                                    }
                                } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                                    // handle progress
                                    NSLog(@"Process: %f", status.percentOfCompletion);
                                } errorBlock:^(QBResponse *error) {
                                    // error handling
                                    NSLog(@"Response error download: %@", [error description]);
                                }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error download: %@", [response.error description]);
    }];

}

-(void)getUserInfoByUserID:(NSUInteger)userID andAddToDictionary:(NSMutableDictionary*)toAdd{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)userID] forKey:@"user_id"];
    [toAdd setObject:[NSString stringWithFormat:@"%lu", (unsigned long)userID] forKey:@"user_id"];
    
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        NSLog(@"Number of found UserProperties objects: %lu", (unsigned long)[objects count]);
        QBCOCustomObject *object = [objects objectAtIndex:0];
        
        @try {
            [toAdd setObject:[object.fields objectForKey:@"gymdername"] forKey:@"gymdername"];
            [toAdd setObject:[[object.fields objectForKey:@"fitnessclub"] objectAtIndex:0] forKey:@"gym"];
            [toAdd setObject:[object.fields objectForKey:@"age"] forKey:@"age"];
            [toAdd setObject:[object.fields objectForKey:@"workout"] forKey:@"workouts"];
            [toAdd setObject:[object.fields objectForKey:@"info"] forKey:@"info"];
            [toAdd setObject:[object.fields objectForKey:@"gender"] forKey:@"gender"];
            
            if([object.fields objectForKey:@"pows"] == nil){
                [toAdd setObject:@"0" forKey:@"pows"];
            }else{
                [toAdd setObject:[object.fields objectForKey:@"pows"] forKey:@"pows"];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error with user properties...");
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleContent" object:self userInfo:toAdd];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    

}



@end
