//
//  Coin.h
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

static float const INC_X = 7.5f;
static float const INC_Y = 5.0f;
static float const MIN_Y = 100.0f;
static float const MAX_Y = 250.0f;

@interface Coin : CCSprite {
    NSString* dir;
    float max_x;
}

-(void)move:(int)movement;
-(void)moveUpAndDown;
-(void)moveLeft;
-(void)moveUp;
-(void)moveDown;
-(void)setMaxX:(float)x;

@end
