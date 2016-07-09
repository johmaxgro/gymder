//
//  Bubble.m
//  GYMDER
//
//  Created by Johannes Groschopp on 05.06.16.
//  Copyright © 2016 GYMDER. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

-(id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    [self.layer setCornerRadius:10];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        [[NSBundle mainBundle] loadNibNamed:@"Bubble" owner:self options:nil];
        
        [self addSubview:self.view];
    }
    
    
    
    return self;
}

-(id) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    
    self = [super initWithImage:highlightedImage];
    
    return self;
    
}

@end
