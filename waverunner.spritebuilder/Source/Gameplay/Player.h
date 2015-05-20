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
#define BASE_JUMP 600.0f
#define SPEED_TO_ANIMATION 0.004f
#define POWERUP_TIME_LIMIT 10.0f

@interface Player : CCSprite<CCPhysicsCollisionDelegate>{
    CCTime _fixedUpdateTimer;
    CGPoint _runSpeed, _initialSpeed;
    CGFloat _jumpHeight;
    BOOL _airborne;
    BOOL _doubleJump, _canDoubleJump;
    BOOL _hit;
    CCPhysicsJoint *_wallJoint;
    BOOL _jumpingRight;
    GameplayScene *_GS;
    float hitTimer;
    float _lastScrollUpdate;
    BOOL _lastChance;
    bool _lastHit;
    CCLabelTTF *_challengeLabel;
    NSInteger _challengeCounter;
    NSInteger _enabledPowerup;
    BOOL _shieldOn, _slowmotionOn;
    CGFloat _powerUpTimeCounter;
    CCNode *_shieldField;
    BOOL _incomingWallJump;
}

@property (nonatomic, readwrite) BOOL airborne;
@property (nonatomic, readonly) BOOL jumpingRight;
@property (nonatomic, readwrite) BOOL canDoubleJump;
@property (nonatomic, readwrite) int num_obstacles_collision;
@property (nonatomic, readwrite) CGPoint runSpeed;
@property (nonatomic, readonly) CGPoint initialSpeed;
@property (nonatomic, readwrite) GameplayScene *GS;
@property (nonatomic, readwrite) BOOL incomingWallJump;


- (void)jump;
- (void)land;
- (void)hit;
- (void)changeRunSpeed:(CGPoint)changeAmount;
-(void)wallJump:(CGPoint)jumpForce;
-(void)clearChallengeLabel;
- (void)setChallengeCount:(NSInteger)quantity;
-(void)incrementChallengeCount;
-(void)updateChallengeLabel;
-(void)activatePowerUp;

@end
