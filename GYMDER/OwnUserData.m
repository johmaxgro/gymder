//
//  OwnUserData.m
//  GYMDER
//
//  Created by Johannes Groschopp on 11.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "OwnUserData.h"
@import Quickblox;

@implementation OwnUserData

-(void)getOwnUserData{
    
    _userDataArray = [NSMutableArray new];
    _userData = [NSMutableDictionary new];
        NSMutableDictionary *request = [NSMutableDictionary dictionary];
        [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
        
        [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
            // response processing
            if([objects count] != 0){
            
            QBCOCustomObject *object = [objects objectAtIndex:0];
           
            
                [_userData setObject:[object.fields objectForKey:@"gymdername"] forKey:@"gymdername"];
//            [_userData setObject:[[object.fields objectForKey:@"fitnessclub"] objectAtIndex:0] forKey:@"gym"];
                [_userData setObject:[object.fields objectForKey:@"mainfitnessclub"] forKey:@"gym"];
                [_userData setObject:[object.fields objectForKey:@"age"] forKey:@"age"];
                [_userData setObject:[object.fields objectForKey:@"workout"] forKey:@"workouts"];
                [_userData setObject:[object.fields objectForKey:@"info"] forKey:@"info"];
                if([object.fields objectForKey:@"phone"] != nil){
                    [_userData setObject:[object.fields objectForKey:@"phone"] forKey:@"phone"];
                }else{
                    [_userData setObject:@"Phone Number" forKey:@"phone"];
                }
                if([object.fields objectForKey:@"email"] != nil){
                    [_userData setObject:[object.fields objectForKey:@"email"] forKey:@"email"];
                }else{
                    [_userData setObject:@"Email" forKey:@"email"];
                }
                [_userData setObject:[object.fields objectForKey:@"gender"] forKey:@"gender"];
                [_userData setObject:[NSString stringWithFormat:@"%lu", (unsigned long)object.userID] forKey:@"user_id"];
            
            if([object.fields objectForKey:@"pows"] == nil){
                [_userData setObject:@"0" forKey:@"pows"];
            }else{
                [_userData setObject:[object.fields objectForKey:@"pows"] forKey:@"pows"];
            }
            
                [self getFollowersInfo];
//            [_userDataArray addObject:_userData];
 
            }
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
       // NSLog(@"Own user properties: %@", [_userDataArray objectAtIndex:0]);

}

-(void)updateUsername{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        if([objects count] != 0){
            
            QBCOCustomObject *object = [objects objectAtIndex:0];
        
            [_userData setObject:[object.fields objectForKey:@"gymdername"] forKey:@"gymdername"];
            
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];

}

-(void)getWorkouts{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    
    [QBRequest objectsWithClassName:@"UserProperties" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        if([objects count] != 0){
            
            QBCOCustomObject *object = [objects objectAtIndex:0];
  
            [_userData setObject:[object.fields objectForKey:@"workout"] forKey:@"workouts"];
            
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];

}

-(void)getFollowersInfo{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[QBSession currentSession].currentUser.ID] forKey:@"user_id"];
    
    
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        if([objects count] != 0){
            
            QBCOCustomObject *object = [objects objectAtIndex:0];
            
            [_userData setObject:[object.fields objectForKey:@"followingme"] forKey:@"followers"];
            
            [_userData setObject:[object.fields objectForKey:@"iamfollowing"] forKey:@"following"];
            
            [_userDataArray addObject:_userData];
            
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];

}

@end
