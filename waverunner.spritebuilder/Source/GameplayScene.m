//
//  GameplayScene.m
//  waverunner
//
//  Created by Waverunner on 25/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameplayScene.h"

@implementation GameplayScene

- (void)didLoadFromCCB{
    _backgrounds1 = @[_background1_1, _background1_2, _background1_3];
    _backgrounds2 = @[_background2_1, _background2_2, _background2_3];
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    
    [_player.animationManager setPlaybackSpeed:0.75f];
}

- (void)update:(CCTime)delta{
    _player.position = ccp(_player.position.x + delta*SCROLL_SPEED, _player.position.y);
    _contentNode.position = ccp(_contentNode.position.x - delta*SCROLL_SPEED, _contentNode.position.y);
    _backgrounds1node.position = ccp(_backgrounds1node.position.x - delta*SCROLL_SPEED*BACKGROUND1_MULT, _backgrounds1node.position.y);
    _backgrounds2node.position = ccp(_backgrounds2node.position.x - delta*SCROLL_SPEED*BACKGROUND2_MULT, _backgrounds2node.position.y);
    
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
            currentSprite.position = ccp((currentSprite.position.x + [array count] * currentSprite.contentSize.width)-4, currentSprite.position.y);//minus 4 needed to adjust a black pixel on the sprites
        }
    }
}


@end
