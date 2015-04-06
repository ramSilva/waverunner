//
//  Player.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class CCSprite;

#define BASE_SPEED 200.0f
#define BASE_JUMP 250.0f
#define SPEED_TO_ANIMATION 0.004f

@interface Player : CCSprite<CCPhysicsCollisionDelegate>{
    CGPoint _runSpeed;
    CGFloat _jumpHeight;
    BOOL _airborne;
    BOOL _doubleJump;
    BOOL _hit;
}

@property (nonatomic, readonly) CGPoint runSpeed;

- (void)jump;
- (void)land;
- (void)hit;
- (void)changeRunSpeed:(CGPoint)changeAmount;

@end
