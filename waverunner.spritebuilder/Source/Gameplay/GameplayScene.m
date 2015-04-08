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
#import "RunIH.h"
#import "WallJumpIH.h"
#import "GameManager.h"

@implementation GameplayScene

- (void)didLoadFromCCB{
    _gameManager = [GameManager sharedGameManager];
    _backgrounds1 = @[_bg1_1, _bg1_2, _bg1_3, _bg1_4];
    _backgrounds2 = @[_bg2_1, _bg2_2, _bg2_3, _bg2_4];
    _grounds = @[_g1, _g2, _g3, _g4];
    
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
    
    _physicsNode.debugDraw = TRUE;
    
    _player.zOrder = 1;
    
    _lg = [[LevelGeneratorSideScroll alloc] init];
    
    [_lg initializeLevel:_grounds :_grounds_cracked :_player :_physicsNode];
    
    [self runMode];
}

- (void)update:(CCTime)delta{
    CGPoint playerSpeed = [_player runSpeed];
    CGPoint scrollSpeed = [_gameManager scrollSpeed];
    _player.position = ccp(_player.position.x + delta*playerSpeed.x, _player.position.y);
    _gameOverNode.position = ccp(_gameOverNode.position.x + delta*scrollSpeed.x, _gameOverNode.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - delta*scrollSpeed.x, _physicsNode.position.y - delta*scrollSpeed.y);
    _backgrounds1node.position = ccp(_backgrounds1node.position.x - delta*scrollSpeed.x*BACKGROUND1_MULT, _backgrounds1node.position.y - delta*scrollSpeed.y*BACKGROUND1_MULT);
    _backgrounds2node.position = ccp(_backgrounds2node.position.x - delta*scrollSpeed.x*BACKGROUND2_MULT, _backgrounds2node.position.y- delta*scrollSpeed.y*BACKGROUND2_MULT);
    _backgrounds3node.position = ccp(_backgrounds3node.position.x - delta*scrollSpeed.x*BACKGROUND3_MULT, _backgrounds3node.position.y- delta*scrollSpeed.y*BACKGROUND3_MULT);
    _moon.position = ccp(_moon.position.x - delta*scrollSpeed.x*MOON_MULT, _moon.position.y - delta*scrollSpeed.y*MOON_MULT);

    [self loopSprites:_backgrounds1];
    [self loopSprites:_backgrounds2];
    
    [_lg updateLevel];
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
            currentSprite.position = ccp((currentSprite.position.x + [array count] * currentSprite.contentSize.width)-4, currentSprite.position.y);//minus array count needed to adjust a black pixel on the sprites
        }
    }
}

- (void)menu{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

- (void)hit{
    [_player hit];
}

-(void) runMode{
    _inputHandler = [[RunIH alloc] init];
    [_inputHandler initialize:_player];
    _player.runSpeed = _player.previousSpeed;
    _gameManager.scrollSpeed = _player.runSpeed;
    [_lg setScrollMode];
}

-(void) climbMode{
    
}

-(void) wallMode{
    _player.previousSpeed = _player.runSpeed;
    _inputHandler = [[WallJumpIH alloc] init];
    [_inputHandler initialize:_player];
    
    [_lg setWallMode];
   
    CCActionMoveTo *_moveWaves = [CCActionMoveTo actionWithDuration:6 position:ccp(0, -200)];
    [_wavesNode runAction:_moveWaves];
    
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    [_inputHandler touchBegan:touch withEvent:event];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    [_inputHandler touchEnded:touch withEvent:event];
}

@end
