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
#import "CCDirector_Private.h"

@implementation Player

@synthesize airborne = _airborne;
@synthesize runSpeed = _runSpeed;
@synthesize jumpingRight = _jumpingRight;
@synthesize GS = _GS;
@synthesize initialSpeed = _initialSpeed;
@synthesize num_obstacles_collision;
@synthesize canDoubleJump = _canDoubleJump;
@synthesize incomingWallJump = _incomingWallJump;


- (void)didLoadFromCCB{
    _fixedUpdateTimer =  [[[CCDirector sharedDirector] scheduler] fixedUpdateInterval];
    
    [[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _fixedUpdateTimer * 1.0f];
    [[[CCDirector sharedDirector] scheduler]setTimeScale:1.0f];
    
    _jumpingRight = true;
    _runSpeed = _initialSpeed = ccp(BASE_SPEED, 0.0f);
    GameManager *_gm = [GameManager sharedGameManager];
    _gm.scrollSpeed = _runSpeed;
    _jumpHeight = BASE_JUMP;
    self.physicsBody.collisionType = @"player";
    
    _airborne = FALSE;
    _doubleJump = FALSE;
    _hit = FALSE;
    _lastChance = true;
    _canDoubleJump =  true;
    CCAnimationManager *animationManager = self.animationManager;
    [animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed.x];
    hitTimer =  _lastScrollUpdate = 0;
    num_obstacles_collision = 0;
    
    [self clearChallengeLabel];
    _shieldOn = _slowmotionOn = false;
    _shieldField.visible =  false;
    
    _incomingWallJump = false;
}

- (void)jump{
    if(!_hit){
        if(!_airborne){
            [self.animationManager runAnimationsForSequenceNamed:@"Jump"];
            [self.animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed.x];
            [self.physicsBody setVelocity:ccp(0.0f, _jumpHeight)];
            _airborne = TRUE;
        }
        else if(!_doubleJump && _canDoubleJump){
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
    [self scheduleOnce:@selector(resetAnimation) delay:0.7f];
    if(_shieldOn) return;
    _hit = TRUE;
    [self changeRunSpeed:ccp(-20.0f+[GameManager sharedGameManager].resistanceLevel, 0)];
    [self.animationManager runAnimationsForSequenceNamed:@"Hit"];
    //CCActionMoveBy *action = [CCActionMoveBy actionWithDuration:1.4f position:ccp(-10.0f, 0.0f)];
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
    if (!_incomingWallJump) {
        self.physicsBody.collisionMask = nil;
    }
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
    CCLOG(@"Coin item caught");

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
     _canDoubleJump = false;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.collisionMask = nil;
    _incomingWallJump = false;
    _gm.scrollSpeed = ccp(0, 100);
    _runSpeed = ccp(0, 0);
    [self.physicsBody applyForce:ccp(10000, 0)];
    [self updateChallengeLabel];
    return true;
}



-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(CCNode *)nodeA wall:(CCNode *)nodeB{
    //CCLOG(@"colision detected");
    
    
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
    [_GS resetGameOver];
    self.physicsBody.collisionMask = @[@"ground"];
    self.physicsBody.affectedByGravity = YES;
    return true;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(CCNode *)nodeA fallingObstacle:(CCNode *)nodeB{
    if (_airborne && !_shieldOn) {
        self.physicsBody.affectedByGravity = true;
    }
    return true;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair challenge:(CCNode *)nodeA player:(CCNode *)nodeB{
    //nodeA.visible = NO;
    [self incrementChallengeCount];
    [self updateChallengeLabel];
    
    [nodeA.parent removeChild:nodeA];
    //[[GameManager sharedGameManager] changeCoins:1*[GameManager sharedGameManager].coinMultiplier];
    //[[GameManager sharedGameManager] updateCoinLabel];
    
    CCLOG(@"Challenge item caught");
    
    return TRUE;
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
    if (_shieldOn || _slowmotionOn) {
        if (_powerUpTimeCounter >= (POWERUP_TIME_LIMIT * [[CCDirector sharedDirector] scheduler].timeScale)) {
            CCLOG(@"POWERUP END \n");
            _powerUpTimeCounter = 0;
            [self enablePowerButton:false];
            
        }
        else{
            _powerUpTimeCounter += delta;
        }
    }
    
    if (![GameManager sharedGameManager].runningMode) return;
    
    if (hitTimer>5 ) {
        [self changeRunSpeed:ccp(10, 0)];
        hitTimer = 0;
    }
    if ([self.parent convertToWorldSpace:self.position].x < 300.0f){
        hitTimer += delta;
    }
    else if(!_hit){
        _runSpeed = [GameManager sharedGameManager].scrollSpeed;
    }
    
    if (_lastScrollUpdate > 5) {
        _lastScrollUpdate = 0;
        _runSpeed = ccpAdd(_runSpeed, ccp(10, 0));
        [GameManager sharedGameManager].scrollSpeed = ccpAdd([GameManager sharedGameManager].scrollSpeed, ccp(10, 0));
    }
    _lastScrollUpdate += delta;
    
    //printf("player.x: %f\n", [self.parent convertToWorldSpace:self.position].x);

    if (_lastChance ) {
        CGPoint _pos = [self.parent convertToWorldSpace:self.position];
        if (_pos.x <= 100) {
            [_GS lastChance:true];
            CCLOG(@"LAST CHANCE");
            self.position = [self.parent convertToNodeSpace:ccp(100, _pos.y)];
            _lastHit = true;
        }
        else if(_pos.x >= 150){
            _lastHit = false;
            [_GS lastChance:false];
        }
    }
    //printf("playbackspeed: %f\n", self.animationManager.playbackSpeed);
}


-(void)clearChallengeLabel{
    _challengeLabel.string = @"";
    _challengeCounter = -1;
}

-(void) updateChallengeLabel{
    if (_challengeCounter<0) {
        [self clearChallengeLabel];
    }
    else{
        _challengeLabel.string = [NSString stringWithFormat:@"✩: %d/3", _challengeCounter];
        if (_challengeCounter == 3) {
            [self enablePowerButton:true];
        }
    }
}

-(void)setChallengeCount:(NSInteger)quantity{
    _challengeCounter = quantity;
}

-(void)incrementChallengeCount{
    _challengeCounter++;
}

-(void)activatePowerUp{
    if (_enabledPowerup == 0) {
        CCLOG(@"enable slowmotion\n");
        _shieldOn = FALSE;
        _slowmotionOn = true;
        [[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _fixedUpdateTimer * 0.5f];
        [[[CCDirector sharedDirector] scheduler]setTimeScale:0.5f];
        _powerUpTimeCounter = 0;
    }
    else if (_enabledPowerup == 1){
        CCLOG(@"enable shield\n");
        _shieldOn = true;
        _slowmotionOn = false;
        _powerUpTimeCounter = 0;
        [self setOpacity:0.5f];
        _shieldField.visible = true;
    }
    else {
        _shieldOn = false;
        _slowmotionOn = false;
        return;
    }
    
}

-(void)enablePowerButton:(BOOL)value{
    [self choosePowerUp :value];
    [_GS enablePowerButton:value :_enabledPowerup];
}

-(void) choosePowerUp:(BOOL) value{
    if (!value) {
        _enabledPowerup = -1;
        _shieldOn = _slowmotionOn = false;
        [[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _fixedUpdateTimer * 1.0f];
        [[[CCDirector sharedDirector] scheduler]setTimeScale:1.0f];
        [self setOpacity:1.0f];
        _shieldField.visible = false;
        return;
    }
    _enabledPowerup = (arc4random() % 2);
    printf("Enable powerup number: %d\n", _enabledPowerup);
}
@end
