//
//  Obstacle.h
//  waverunner
//
//  Created by Alexandre Freitas on 12/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class CCSprite;

@interface Obstacle : CCSprite {
    NSString* dir;
    float original_y;
    float inc_x;
    float inc_y;
    float max_y;
}

@property(nonatomic,readwrite) NSString* type;
@property(nonatomic,readwrite) NSString* color;

-(void)move:(int)movement;
-(void)moveLeft;

@end
