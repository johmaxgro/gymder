//
//  OtherUserData.m
//  GYMDER
//
//  Created by Johannes Groschopp on 22.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "OtherUserData.h"
@import Quickblox;

@implementation OtherUserData

-(void)getOtherUserData{
    
    _userDataArray = [NSMutableArray new];
    _userData = [NSMutableDictionary new];
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)_userID] forKey:@"user_id"];
    
    
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
            [_userData setObject:[NSString stringWithFormat:@"%lu", (unsigned long)object.userID] forKey:@"user_id"];
            if([object.fields objectForKey:@"powpeople"] != nil){
                [_userData setObject:[object.fields objectForKey:@"powpeople"] forKey:@"powpeople"];
            }else{
                NSMutableArray *fill = [NSMutableArray new];
                [_userData setObject:fill forKey:@"powpeople"];
            }
        

            
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

-(void)getFollowersInfo{
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:[NSString stringWithFormat:@"%lu", (unsigned long)_userID] forKey:@"user_id"];
    
    
    [QBRequest objectsWithClassName:@"Follow" extendedRequest:request successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        if([objects count] != 0){
            
            QBCOCustomObject *object = [objects objectAtIndex:0];
            
            [_userData setObject:[object.fields objectForKey:@"followingme"] forKey:@"followers"];
            
            [_userData setObject:[object.fields objectForKey:@"iamfollowing"] forKey:@"following"];
            
            [_userDataArray addObject:_userData];
            
            if(_fromRadar){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherUserData" object:self userInfo:_userData];
            }else if(_fromArena){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherUserDataArena" object:self userInfo:_userData];
            }else if(_fromFollower){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherUserDataFollower" object:self userInfo:_userData];
            }

           
            
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    
}


@end
