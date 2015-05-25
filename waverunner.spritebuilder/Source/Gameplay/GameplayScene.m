//
//  GameplayScene.m
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameplayScene.h"
#import "Coin.h"
#import "CCScene.h"
#import "Player.h"
#import "Ground.h"
#import "LevelGenerator.h"
#import "LevelGeneratorSideScroll.h"
#import "LevelGeneratorWallJump.h"
#import "RunIH.h"
#import "WallJumpIH.h"
#import "GameManager.h"
#import "PowerUp.h"
#import "CCDirector_Private.h"
#import "flurry.h"

@implementation GameplayScene

@synthesize currentScore = _currentScore;
@synthesize lg = _lg;

- (void)didLoadFromCCB{
    _currentScore = 0;
    
    _player.GS = self;
    _gameManager = [GameManager sharedGameManager];
    
    [_gameManager updateCoinLabel];
    CCNode* p = _coinLabel.parent;
    _coinLabel = [_gameManager coinLabel];
    [_coinLabel removeFromParent];
    [p addChild:_coinLabel];
    _coinLabel.position = ccp(0.725f, 0.90f);
    
    _backgrounds1 = @[_bg1_1, _bg1_2, _bg1_3, _bg1_4];
    _backgrounds2 = @[_bg2_1, _bg2_2, _bg2_3, _bg2_4];
    _grounds = @[_g1, _g2, _g3, _g4];
    timer = 0.0f;
    useTimer = true;
    
    NSMutableArray *_g_cracked = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < _grounds.count; i++) {
        Ground* cracked = (Ground*)[CCBReader load:@"Ground_Cracked"];
        cracked.position = ccp(0.0f, -100.0f);
        [_g_cracked insertObject:cracked atIndex:i];
        [_physicsNode addChild:cracked];
    }
    _grounds_cracked = [_g_cracked copy];
    
    _physicsNode.collisionDelegate = _player;
    
    self.userInteractionEnabled = TRUE;
    
    //_physicsNode.debugDraw = TRUE;
    
    _player.zOrder = 1;
    
    _wallNode =[CCBReader load:@"WallJump/WallJumpTransitionStart"];
    _wallNode.position = ccp(-500, -500);
    [_physicsNode addChild:_wallNode];
    
    _lg = [[LevelGeneratorSideScroll alloc] init];
    
    [_lg initializeLevel:_grounds :_grounds_cracked :_player :_physicsNode :_wallNode];
    
    _inputHandler = [[RunIH alloc] init];
    [_inputHandler initialize:_player];
    //_timeButton.visible = _shieldButton.visible = false;
    [_powerUpNode setGameplayScene:self];
    if (!_gameManager.useTutorial) {
        //[self removeChild:_tutorialNode cleanup:true];
        _tutorialNode.visible = false;
    }
    else{
        [[[CCDirector sharedDirector] scheduler]setTimeScale:0.0f];
        _tutorialNode.visible = true;
    }
}

- (void)update:(CCTime)delta{
    CGPoint physicsdelta = ccpSub(_previousPhysicsPosition,_physicsNode.position);
    _previousPhysicsPosition = _physicsNode.position;
    CGPoint playerSpeed = [_player runSpeed];
    CGPoint scrollSpeed = [_gameManager scrollSpeed];
    
    _currentScore += abs(physicsdelta.x + physicsdelta.y);
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %ld", (long)_currentScore];
    
    /*printf("player speed: %f\n", delta*playerSpeed.x);
    printf("scroll speed: %f\n", delta*scrollSpeed.x);*/
    _player.position = ccp(_player.position.x + delta*playerSpeed.x, _player.position.y);
    _gameOverNode.position = ccp(_gameOverNode.position.x + delta*scrollSpeed.x, _gameOverNode.position.y + delta*scrollSpeed.y);
    _physicsNode.position = ccp(_physicsNode.position.x - delta*scrollSpeed.x, _physicsNode.position.y - delta*scrollSpeed.y);
    _backgrounds1node.position = ccp(_backgrounds1node.position.x - delta*physicsdelta.x*BACKGROUND1_MULT, _backgrounds1node.position.y - delta*physicsdelta.y*BACKGROUND1_MULT*0.1f);
    _backgrounds2node.position = ccp(_backgrounds2node.position.x - delta*physicsdelta.x*BACKGROUND2_MULT, _backgrounds2node.position.y - delta*physicsdelta.y*BACKGROUND2_MULT);
    _backgrounds3node.position = ccp(_backgrounds3node.position.x - delta*physicsdelta.x*BACKGROUND3_MULT, _backgrounds3node.position.y - delta*physicsdelta.y*BACKGROUND3_MULT);
    _moon.position = ccp(_moon.position.x - delta*physicsdelta.x*MOON_MULT, _moon.position.y - delta*physicsdelta.y*MOON_MULT);
    
    
    CGPoint buildingWorldPosition = [_bg3_1.parent convertToWorldSpace:_bg3_1.position];
    // get the screen position of the ground
    CGPoint buildingScreenPosition = [self convertToNodeSpace:buildingWorldPosition];
    
    if(buildingScreenPosition.x < - _bg3_1.boundingBox.size.width / 2) {
        _backgrounds3node.position = ccp(_player.position.x + BACKGROUND3_MULT*100.0f, 0.0f);
    }

    [self loopSprites:_backgrounds1];
    [self loopSprites:_backgrounds2];
    
    if(useTimer) {
        timer = timer + delta;
    }
    
    if(timer >= TIMER_WALLJUMP && drand48() < CHANCE_WALLJUMP) {
        timer = 0.0f;
        useTimer = false;
        _lg.noObstacles = true;
    }
    
    [_lg updateLevel :delta];
    
    if(_lg.noObstacles && _lg.countGroundsUpdatedStaticOnly >= 4) {
        _lg.noObstacles = false;
        _lg.countGroundsUpdatedStaticOnly = 0;
        [self wallMode];
    }
    //printf("SPEED: %f\n", [GameManager sharedGameManager].scrollSpeed.x);
}

-(void) loopSprites:(NSArray*)array{
    // loop the ground
    for (CCNode *currentSprite in array) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [currentSprite.parent convertToWorldSpace:currentSprite.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        
        if (groundScreenPosition.x <= (-1 * currentSprite.contentSize.width)) {
            currentSprite.position = ccp((currentSprite.position.x + [array count] * currentSprite.contentSize.width*currentSprite.scaleX)-4, currentSprite.position.y);//minus array count needed to adjust a black pixel on the sprites
        }
    }
}

- (void)menu{
    [[GameManager sharedGameManager] setHighscore:_currentScore];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

- (void)hit{
    [_player hit];
}

-(void) runMode{
    CCLOG(@"RUNMODE");
    _gameManager.runningMode = true;
    _inputHandler = [[RunIH alloc] init];
    [_inputHandler initialize:_player];
    
    _player.runSpeed = _player.previousSpeed;
    _gameManager.scrollSpeed = _player.previousSpeed;
    
    [_lg setScrollMode];
    int dif = _lg.difficulty;
    
    _lg = [[LevelGeneratorSideScroll alloc] init];
    [_lg initializeLevel:_grounds :_grounds_cracked :_player :_physicsNode :_wallNode];
    _lg.difficulty = dif;

    _g1.chance_gap = _g2.chance_gap = _g3.chance_gap = _g4.chance_gap = 0.0f;
    
    CCActionMoveTo *_moveWaves = [CCActionMoveTo actionWithDuration:6 position:ccp(0,0)];
    [_wavesNode runAction:_moveWaves];
    useTimer = true;
    [_player clearChallengeLabel];
}

-(void) climbMode{
    
}

-(void) wallMode {
    CCLOG(@"WALLMODE");
    _gameManager.runningMode = false;
    //_player.previousSpeed = _player.runSpeed;
    _gameOverNode.position = ccp(_gameOverNode.position.x-100.0f, 35.0f);
    
    [_lg setWallMode];
    
    int dif = _lg.difficulty;
    
     _lg = [[LevelGeneratorWallJump alloc] init];
    [_lg initializeLevel:_grounds :_grounds_cracked :_player :_physicsNode :_wallNode];
    _lg.difficulty = dif;
    [self lastChance:false];
    
    CCActionMoveTo *_moveWaves = [CCActionMoveTo actionWithDuration:6 position:ccp(-300, -300)];
    CCActionMoveTo *_moveWaves2 = [CCActionMoveTo actionWithDuration:1 position:ccp(-600, 0)];
    CCActionSequence *_seq = [CCActionSequence actionOne:_moveWaves two:_moveWaves2];
    [_wavesNode runAction:_seq];
    
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    [_inputHandler touchBegan:touch withEvent:event];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    [_inputHandler touchEnded:touch withEvent:event];
}

-(void) playerleft{
    _player.position = ccp(_player.position.x - 100, _player.position.y);
}

-(void) playerright{
    _player.position = ccp(_player.position.x + 100, _player.position.y);

}

-(void) wallModeIH{
    _inputHandler = [[WallJumpIH alloc] init];
    [_inputHandler initialize:_player];
    //_lg = [[LevelGeneratorWallJump alloc] init];
    //[_lg initializeLevel:_grounds :_grounds_cracked :_player :_physicsNode :_wallNode];

}

-(void) resetGameOver{
    [[_physicsNode space] addPostStepBlock:^{
        _gameOverNode.position = ccp(_gameOverNode.position.x + 100.0f, 35.0f);
    } key:_gameOverNode];
}

-(void) lastChance:(BOOL)isLastChance{
    if(isLastChance){
        _exclamationMark.visible = true;
    }
    else{
        _exclamationMark.visible = false;   
    }
}

-(void) activatePowerUp{
    [_player activatePowerUp];
    [self enablePowerButton:false :-1];
}

-(void)enablePowerButton:(BOOL)value :(NSInteger)powerUpType{
    /*if (value) {
        if (powerUpType == 0) {
            CCLOG(@"slowmo button\n");
            _timeButton.visible = true;
            _shieldButton.visible = false;
        }
        else if (powerUpType == 1){
            CCLOG(@"shield button\n");
            _timeButton.visible = false;
            _shieldButton.visible = true;
        }
    }
    else{
        CCLOG(@"turn off 2 buttons\n");
        _timeButton.visible = false;
        _shieldButton.visible = false;
    }*/
    
    if (value) {
        [_powerUpNode.animationManager runAnimationsForSequenceNamed:@"Random"];
        [_powerUpNode.userObject setCompletedAnimationCallbackBlock:^(id sender) {
            CCAnimationManager *animationManager = sender;
            if ([animationManager.lastCompletedSequenceName isEqualToString:@"Random"]) {
                //CCLOG(@"OVERRRRRRRR");
                [_powerUpNode enablePowerButton:value :powerUpType];
            }
        }];
    }
    else{
        [_powerUpNode enablePowerButton:value :powerUpType];
    }
    
}


-(void) _pause{
    [[[CCDirector sharedDirector] scheduler]setTimeScale:0];
}

-(void) _play{
    [[[CCDirector sharedDirector] scheduler]setTimeScale:1];
}
@end
