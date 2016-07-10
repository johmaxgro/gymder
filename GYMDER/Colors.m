//
//  Colors.m
//  GYMDER
//
//  Created by Johannes Groschopp on 18.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//  NOT USED YET --- colors should used by using this object class

#import "Colors.h"
#import <UIKit/UIKit.h>

@implementation Colors

@synthesize colorsDict;

+ (id)colors {
    static Colors *colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = [[self alloc] init];
    });
    return colors;
}

- (id)init {
    if (self = [super init]) {
        [colorsDict setObject:[UIColor colorWithRed:0.173f green:0.192f blue:0.208f alpha:1.00f] forKey:@"HARDCORE_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.204f green:0.196f blue:0.149f alpha:1.00f] forKey:@"HIIT_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.204f green:0.169f blue:0.180f alpha:1.00f] forKey:@"COMBAT_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.243f green:0.275f blue:0.286f alpha:1.00f] forKey:@"LIFT_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.349f green:0.341f blue:0.259f alpha:1.00f] forKey:@"SPIN_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.282f green:0.247f blue:0.259f alpha:1.00f] forKey:@"BOOTCAMP_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.349f green:0.384f blue:0.400f alpha:1.00f] forKey:@"EQUIPMENT_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.494f green:0.494f blue:0.373f alpha:1.00f] forKey:@"RUN_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.400f green:0.353f blue:0.369f alpha:1.00f] forKey:@"TEAM_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.424f green:0.467f blue:0.486f alpha:1.00f] forKey:@"CROSSFIT_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.647f green:0.631f blue:0.482f alpha:1.00f] forKey:@"CARDIO_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.475f green:0.416f blue:0.439f alpha:1.00f] forKey:@"DANCE_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.502f green:0.573f blue:0.596f alpha:1.00f] forKey:@"BODYWEIGHT_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.796f green:0.792f blue:0.584f alpha:1.00f] forKey:@"FATBURN_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.608f green:0.522f blue:0.553f alpha:1.00f] forKey:@"PILATES_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.600f green:0.659f blue:0.682f alpha:1.00f] forKey:@"FREE_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.894f green:0.878f blue:0.659f alpha:1.00f] forKey:@"WALK_COLOR"];
        [colorsDict setObject:[UIColor colorWithRed:0.682f green:0.604f blue:0.624f alpha:1.00f] forKey:@"YOGA_COLOR"];
    }
    return self;
}

@end
