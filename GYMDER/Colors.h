//
//  Colors.h
//  GYMDER
//
//  Created by Johannes Groschopp on 18.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject{
    NSMutableDictionary *colorsDict;
}

@property (strong, nonatomic) NSMutableDictionary *colorsDict;

+ (id)colors;

@end
