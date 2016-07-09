//
//  OtherUserData.h
//  GYMDER
//
//  Created by Johannes Groschopp on 22.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherUserData : NSObject

@property (nonatomic, strong) NSMutableDictionary *userData;
@property (strong, nonatomic) NSMutableArray *userDataArray;
@property (nonatomic) NSInteger userID;

@property (nonatomic) BOOL fromRadar;
@property (nonatomic) BOOL fromArena;
@property (nonatomic) BOOL fromFollower;

-(void)getOtherUserData;


@end
