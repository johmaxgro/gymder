//
//  OwnUserData.h
//  GYMDER
//
//  Created by Johannes Groschopp on 11.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnUserData : NSObject

@property (nonatomic, strong) NSMutableDictionary *userData;
@property (strong, nonatomic) NSMutableArray *userDataArray;

-(void)getOwnUserData;
-(void)getWorkouts;

-(void)updateUsername;

@end
