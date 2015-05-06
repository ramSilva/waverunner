//
//  Player.m
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Player.h"
#import "CCSprite.h"
#import "GameManager.h"
#import "GameplayScene.h"

@implementation Player

@synthesize airborne = _airborne;
@synthesize runSpeed = _runSpeed;
@synthesize GS = _GS;
@synthesize initialSpeed = _initialSpeed;
@synthesize num_obstacles_collision;


- (void)didLoadFromCCB{
    _runSpeed = _initialSpeed = ccp(BASE_SPEED*[[GameManager sharedGameManager] speedLevel], 0.0f);
    GameManager *_gm = [GameManager sharedGameManager];
    _gm.scrollSpeed = _runSpeed;
    _jumpHeight = BASE_JUMP*[[GameManager sharedGameManager] jumpLevel];
    self.physicsBody.collisionType = @"player";
    
    _airborne = FALSE;
    _doubleJump = FALSE;
    _hit = FALSE;
    _lastChance = true;
    
    CCAnimationManager *animationManager = self.animationManager;
    [animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed.x];
    hitTimer =  _lastScrollUpdate = 0;
    num_obstacles_collision = 0;
}

- (void)jump{
    if(!_hit){
        if(!_airborne){
            [self.animationManager runAnimationsForSequenceNamed:@"Jump"];
            [self.animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed.x];
            [self.physicsBody setVelocity:ccp(0.0f, _jumpHeight)];
            _airborne = TRUE;
        }
        else if(!_doubleJump){
            [self.animationManager runAnimationsForSequenceNamed:@"DoubleJump"];
            [self.animationManager setPlaybackSpeed:0.9f];
            [self.physicsBody setVelocity:ccp(0.0f, _jumpHeight)];
            _doubleJump = TRUE;
        }
    }
}

- (void)land{
    if(_airborne){
        if(!_hit){
            [self.animationManager runAnimationsForSequenceNamed:@"Run"];
            [self.animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed.x];
        }
        _airborne = FALSE;
        _doubleJump = FALSE;
    }
}

- (void)hit{
    _hit = TRUE;
    [self changeRunSpeed:ccp(-10.0f, 0)];
    [self.animationManager runAnimationsForSequenceNamed:@"Hit"];
    //CCActionMoveBy *action = [CCActionMoveBy actionWithDuration:1.4f position:ccp(-10.0f, 0.0f)];
    [self scheduleOnce:@selector(resetAnimation) delay:0.7f];
    //[self runAction:action];
    hitTimer = 0;
    num_obstacles_collision += 1;
    if (_lastHit) {
        _lastChance = false;
    }
}

- (void)resetAnimation{
    _hit = FALSE;
    [self.animationManager runAnimationsForSequenceNamed:@"Run"];
}

- (void)changeRunSpeed:(CGPoint)changeAmount{
    _runSpeed.x += changeAmount.x;
    _runSpeed.y += changeAmount.y;
    
    GameManager *_gm = [GameManager sharedGameManager];
    _gm.scrollSpeed = ccp(_gm.scrollSpeed.x, _runSpeed.y);
    
    //_previousSpeed = _runSpeed;
    
    CCAnimationManager *animationManager = self.animationManager;
    [animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed.x];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA player:(CCNode *)nodeB{
    [self land];
    [_GS resetGameOver];
    self.physicsBody.collisionMask = nil;
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair gameOver:(CCNode *)nodeA player:(CCNode *)nodeB{
    [[GameManager sharedGameManager] setHighscore:_GS.currentScore];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair coin:(CCNode *)nodeA player:(CCNode *)nodeB{
    nodeA.visible = NO;
    [[GameManager sharedGameManager] changeCoins:1*[GameManager sharedGameManager].coinMultiplier];
    [[GameManager sharedGameManager] updateCoinLabel];
    //[nodeA.parent removeChild:nodeA];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair obstacle:(CCNode *)nodeA player:(CCNode *)nodeB{
    [self hit];
    //[nodeA.parent removeChild:nodeA];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair walltriggerenter:(CCNode *)nodeA player:(CCNode *)nodeB{

    GameManager *_gm = [GameManager sharedGameManager];
    self.physicsBody.affectedByGravity = NO;
    _gm.scrollSpeed = ccp(0, 100);
    _runSpeed = ccp(0, 0);
    [self.physicsBody applyForce:ccp(10000, 0)];
    
    return true;
}



-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(CCNode *)nodeA wall:(CCNode *)nodeB{
    CCLOG(@"colision detected");
    
    
    self.physicsBody.affectedByGravity = false;
    
    //_wallJoint = [CCPhysicsJoint connectedDistanceJointWithBodyA:nodeA.physicsBody bodyB:nodeB.physicsBody anchorA:nodeA.anchorPointInPoints anchorB:nodeB.anchorPointInPoints minDistance:10 maxDistance:10];
    if(_wallJoint == nil){
        
        [_GS wallModeIH];
        _airborne = false;
        _doubleJump = false;
        
        
        _wallJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:nodeA.physicsBody bodyB:nodeB.physicsBody anchorA:nodeA.anchorPointInPoints];
        [self.animationManager runAnimationsForSequenceNamed:@"Wall"];
        _airborne = false;
    }
    
    return true;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair walltriggerexit:(CCNode *)nodeA player:(CCNode *)nodeB{
    [_GS runMode];
    self.physicsBody.collisionMask = @[@"ground"];
    self.physicsBody.affectedByGravity = YES;
    return true;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(CCNode *)nodeA fallingObstacle:(CCNode *)nodeB{
    if (!_airborne) {
        self.physicsBody.affectedByGravity = true;
    }
    return true;
}

-(void)wallJump:(CGPoint)jumpForce{
    
    _runSpeed = ccp(0,0);
    
    if (_airborne) return;
    
    [_wallJoint invalidate];
    _wallJoint = nil;
    [self.physicsBody applyForce:jumpForce];
    _airborne = true;
    if (jumpForce.x>0) {
        _jumpingRight = true;
        self.flipX = false;

    } else {
        _jumpingRight = false;
        self.flipX = true;
    }
    [self.animationManager runAnimationsForSequenceNamed:@"Jump"];

}

-(void)update:(CCTime)delta{
    if (![GameManager sharedGameManager].runningMode) return;
    
    if (hitTimer>5) {
        [self changeRunSpeed:ccp(10, 0)];
        hitTimer = 0;
    }
    if ([self.parent convertToWorldSpace:self.position].x < 350.0f){
        hitTimer += delta;
    }
    else{
        _runSpeed = _initialSpeed;
    }
    
    if (_lastScrollUpdate > 20) {
        _lastScrollUpdate = 0;
        _runSpeed =
        [GameManager sharedGameManager].scrollSpeed = ccpAdd([GameManager sharedGameManager].scrollSpeed, ccp(10, 0));
    }
    _lastScrollUpdate += delta;
    
    printf("player.x: %f\n", [self.parent convertToWorldSpace:self.position].x);

    if (_lastChance ) {
        CGPoint _pos = [self.parent convertToWorldSpace:self.position];
        if (_pos.x <= 100) {
            CCLOG(@"LAST CHANCE");
            self.position = [self.parent convertToNodeSpace:ccp(100, _pos.y)];
            _lastHit = true;
        }
        else{
            _lastHit = false;
        }
    }
    
    //printf("playbackspeed: %f\n", self.animationManager.playbackSpeed);
}
@end
