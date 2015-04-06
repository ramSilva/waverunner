//
//  Player.m
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Player.h"
#import "CCSprite.h"

@implementation Player
@synthesize runSpeed = _runSpeed;

- (void)didLoadFromCCB{
    _runSpeed = BASE_SPEED;//*[[GameManager sharedGameManager] speedLevel];
    _jumpHeight = BASE_JUMP;//*[[GameManager sharedGameManager] jumpLevel];
    self.physicsBody.collisionType = @"player";
    
    _airborne = FALSE;
    _doubleJump = FALSE;
    
    CCAnimationManager *animationManager = self.animationManager;
    [animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed];
}

- (void)update:(CCTime)delta{

}

- (void)jump{
    if(!_airborne){
        [self.animationManager runAnimationsForSequenceNamed:@"Jump"];
        [self.animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed];
        [self.physicsBody setVelocity:ccp(0.0f, _jumpHeight)];
        _airborne = TRUE;
    }
    else if(!_doubleJump){
        [self.animationManager runAnimationsForSequenceNamed:@"DoubleJump"];
        [self.animationManager setPlaybackSpeed:0.5f];
        [self.physicsBody setVelocity:ccp(0.0f, _jumpHeight)];
        _doubleJump = TRUE;
    }
}

- (void)land{
    if(_airborne){
        [self.animationManager runAnimationsForSequenceNamed:@"Run"];
        [self.animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed];
        _airborne = FALSE;
        _doubleJump = FALSE;
    }
}

- (void)hit{
    [self changeRunSpeed:-5.0f];
    
    [self.animationManager runAnimationsForSequenceNamed:@"Hit"];
    CCActionMoveBy *action = [CCActionMoveBy actionWithDuration:0.7f position:ccp(-7.0f, 0.0f)];
    [self scheduleOnce:@selector(resetAnimation) delay:0.7f];
    [self runAction:action];
}

- (void)resetAnimation{
    [self.animationManager runAnimationsForSequenceNamed:@"Run"];
}

- (void)changeRunSpeed:(CGFloat)changeAmount{
    _runSpeed += changeAmount;
    printf("speed: %f\n", _runSpeed);
    CCAnimationManager *animationManager = self.animationManager;
    [animationManager setPlaybackSpeed:SPEED_TO_ANIMATION*_runSpeed];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA player:(CCNode *)nodeB{
    [self land];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair gameOver:(CCNode *)nodeA player:(CCNode *)nodeB{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair coin:(CCNode *)nodeA player:(CCNode *)nodeB{
    nodeA.visible = NO;
    //[nodeA.parent removeChild:nodeA];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair obstacle:(CCNode *)nodeA player:(CCNode *)nodeB{
    [self hit];
    //[nodeA.parent removeChild:nodeA];
    return TRUE;
}

@end
