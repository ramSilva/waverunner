//
//  Player.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

#define BASE_SPEED 200.0f
#define BASE_JUMP 250.0f
#define SPEED_TO_ANIMATION 0.004f

@interface Player : CCSprite<CCPhysicsCollisionDelegate>{
    CGFloat _runSpeed;
    CGFloat _jumpHeight;
    BOOL _airborne;
    BOOL _doubleJump;
}

@property (nonatomic, readonly) CGFloat runSpeed;

- (void)jump;
- (void)land;
- (void)hit;
- (void)changeRunSpeed:(CGFloat)changeAmount;

@end
