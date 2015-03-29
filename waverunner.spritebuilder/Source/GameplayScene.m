//
//  GameplayScene.m
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameplayScene.h"

@implementation GameplayScene

- (void)didLoadFromCCB{
    _backgrounds1 = @[_bg1_1, _bg1_2, _bg1_3, _bg1_4];
    _backgrounds1 = @[_bg2_1, _bg2_2, _bg2_3, _bg2_4];
    _grounds = @[_g1, _g2, _g3, _g4];
    
    _physicsNode.collisionDelegate = self;
    
    self.userInteractionEnabled = TRUE;
}

- (void)update:(CCTime)delta{
    _player.position = ccp(_player.position.x + delta*SCROLL_SPEED, _player.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - delta*SCROLL_SPEED, _physicsNode.position.y);
    _backgrounds1node.position = ccp(_backgrounds1node.position.x - delta*SCROLL_SPEED*BACKGROUND1_MULT, _backgrounds1node.position.y);
    _backgrounds2node.position = ccp(_backgrounds2node.position.x - delta*SCROLL_SPEED*BACKGROUND2_MULT, _backgrounds2node.position.y);
    _backgrounds3node.position = ccp(_backgrounds3node.position.x - delta*SCROLL_SPEED*BACKGROUND3_MULT, _backgrounds3node.position.y);
    _moon.position = ccp(_moon.position.x - delta*SCROLL_SPEED*MOON_MULT, _moon.position.y);

    [self loopSprites:_grounds];
    [self loopSprites:_backgrounds1];
    [self loopSprites:_backgrounds2];
    
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
            currentSprite.position = ccp((currentSprite.position.x + [array count] * currentSprite.contentSize.width)-[array count], currentSprite.position.y);//minus array count needed to adjust a black pixel on the sprites
        }
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA player:(CCNode *)nodeB{
    [_player land];
    return TRUE;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    [_player jump];
}


@end
