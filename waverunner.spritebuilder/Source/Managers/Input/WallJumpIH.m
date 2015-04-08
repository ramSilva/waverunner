//
//  WallJumpIH.m
//  waverunner
//
//  Created by Student on 06/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WallJumpIH.h"

@implementation WallJumpIH

-(void) initialize: (Player*) player{
    [super initialize:player];
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    touchLocationBegan = [touch locationInWorld];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    touchLocationEnded = [touch locationInWorld];
    CGPoint diff = ccpSub(touchLocationEnded, touchLocationBegan);
    if (CGPointEqualToPoint(diff, ccp(0, 0))) {
        return;
    }
    CGPoint launchDirection = ccpNormalize(diff);
    CGPoint force = ccpMult(launchDirection, 20000);

    [_player wallJump:force];
    
    //printf("LOL: %f, %f\n", diff.x, diff.y);
}


@end