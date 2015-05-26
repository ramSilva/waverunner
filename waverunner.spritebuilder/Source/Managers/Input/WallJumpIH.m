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
    touchLocationEnded = [touch locationInWorld];
    CGPoint diff = ccpSub(touchLocationEnded, [_player.parent convertToWorldSpace:_player.position]);
    
    if (CGPointEqualToPoint(diff, ccp(0, 0))) {
        return;
    }
    CGPoint launchDirection = ccpNormalize(diff);
    CGFloat angle = atan2(launchDirection.y - diff.y, launchDirection.x-diff.x);
    
    angle = CC_RADIANS_TO_DEGREES(angle) + 180.0f;
    
    //printf("angle: %f\n", angle);
    
    if(_player.jumpingRight){
        if(angle < 90.0f || angle > 270.0f){
            return;
        }
        else if (angle > 90.0f && angle < 135.0f){
            launchDirection = ccpNormalize(ccp(-1.0f, 1.0f));
        }
        else if (angle > 225.0f && angle < 270.0f){
            launchDirection = ccpNormalize(ccp(-1.0f, -1.0f));
        }
    }
    else{
        if(angle > 90.0f && angle < 270.0f){
            return;
        }
        else if (angle > 45.0f && angle < 90.0f){
            launchDirection = ccpNormalize(ccp(1.0f, 1.0f));
        }
        else if (angle > 270.0f && angle < 315.0f){
            launchDirection = ccpNormalize(ccp(1.0f, -1.0f));
        }
    }
    
    printf("touch direction: %f, %f, %f\n", angle, launchDirection.x, launchDirection.y);
    CGPoint force = ccpMult(launchDirection, 8000);
    
    [_player wallJump:force];
    
    //touchLocationBegan = [touch locationInWorld];
}

@end
