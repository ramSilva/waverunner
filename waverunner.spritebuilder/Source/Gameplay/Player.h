//
//  Player.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class CCSprite;
@class GameManager;
@class GameplayScene;

#define BASE_SPEED 200.0f
#define BASE_JUMP 350.0f
#define SPEED_TO_ANIMATION 0.004f

@interface Player : CCSprite<CCPhysicsCollisionDelegate>{
    CGPoint _runSpeed, _initialSpeed;
    CGFloat _jumpHeight;
    BOOL _airborne;
    BOOL _doubleJump;
    BOOL _hit;
    CCPhysicsJoint *_wallJoint;
    BOOL _jumpingRight;
    GameplayScene *_GS;
    float hitTimer;
    float l_a_s_t_S_c_r_o_l_l_U_p_d_a_t_e;
    
}

@property (nonatomic, readonly) BOOL airborne;
@property (nonatomic, readwrite) CGPoint runSpeed;
@property (nonatomic, readonly) CGPoint initialSpeed;
@property (nonatomic, readwrite) GameplayScene *GS;


- (void)jump;
- (void)land;
- (void)hit;
- (void)changeRunSpeed:(CGPoint)changeAmount;
-(void)wallJump:(CGPoint)jumpForce;

@end
