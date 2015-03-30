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
    _backgrounds2 = @[_bg2_1, _bg2_2, _bg2_3, _bg2_4];
    _grounds = @[_g1, _g2, _g3, _g4];
    
    _grounds_cracked = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < _grounds.count; i++) {
        Ground* cracked = (Ground*)[CCBReader load:@"Ground_Cracked"];
        cracked.position = ccp(0.0f, -100.0f);
        [_grounds_cracked insertObject:cracked atIndex:i];
        [_physicsNode addChild:cracked];
    }
    
    _physicsNode.collisionDelegate = self;
    
    self.userInteractionEnabled = TRUE;
    
    _physicsNode.debugDraw = TRUE;
    
    _player.zOrder = 1;
    
    //Initialize seed
    srand48(arc4random());
    
    [self initContent];
}

- (void)update:(CCTime)delta{
    CGFloat playerSpeed = [_player getSpeed];
    
    _player.position = ccp(_player.position.x + delta*playerSpeed, _player.position.y);
    _gameOverNode.position = ccp(_gameOverNode.position.x + delta*playerSpeed, _gameOverNode.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - delta*playerSpeed, _physicsNode.position.y);
    _backgrounds1node.position = ccp(_backgrounds1node.position.x - delta*playerSpeed*BACKGROUND1_MULT, _backgrounds1node.position.y);
    _backgrounds2node.position = ccp(_backgrounds2node.position.x - delta*playerSpeed*BACKGROUND2_MULT, _backgrounds2node.position.y);
    _backgrounds3node.position = ccp(_backgrounds3node.position.x - delta*playerSpeed*BACKGROUND3_MULT, _backgrounds3node.position.y);
    _moon.position = ccp(_moon.position.x - delta*playerSpeed*MOON_MULT, _moon.position.y);

    //[self loopSprites:_grounds];
    [self loopSprites:_backgrounds1];
    [self loopSprites:_backgrounds2];
    
    [self updateGround];
    
    [self updateContent];
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

- (void)hit{
    [_player hit];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA player:(CCNode *)nodeB{
    [_player land];
    return TRUE;
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair gameOver:(CCNode *)nodeA player:(CCNode *)nodeB{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    [_player jump];
}

- (void) updateGround {
    for(int i = 0; i < _grounds.count; i++) {
        Ground *g = [_grounds objectAtIndex:i];
        Ground *g2 = [_grounds objectAtIndex:(i + 3) % _grounds.count];
        Ground *g_cracked = [_grounds_cracked objectAtIndex:i];
        
        [g updatePosition :_player :g2 :g_cracked];
    }
}

- (void) initContent {
    for(int i = 2; i < _grounds.count; i++) {
        Ground* ground = [_grounds objectAtIndex:i];
        
        [self insertObstacles :ground];
        [self insertCoins :ground :i];
        [ground setReadyForContent :false];
        
    }
}

- (void) updateContent {
    for(int i = 0; i < _grounds.count; i++) {
        Ground* ground = [_grounds objectAtIndex:i];
        
        if([ground isReadyForContent]) {
            [self insertObstacles :ground];
            [self insertCoins :ground :i];
            [ground setReadyForContent :false];
        }
    }
}

- (void) insertObstacles:(Ground*)ground {
    float first_x = ground.position.x;
    float last_x = first_x + ground.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_OBSTACLES;
    int count_obstacles = 0;
    int count_obstacles_added = 0;
    int number_obstacles_together = (arc4random() % MAX_OBSTACLES_TOGETHER) + 1;
    bool space_between_obstacles = false;
    bool gap = [ground hasGap];
    
    if(drand48() < CHANCE_OBSTACLES && !gap) {
        for(float x = first_x; x < last_x; ) {
            CCNode* obstacle;
            float pos_x = x;
            
            if(count_obstacles < number_obstacles_together) {
                count_obstacles++;
                space_between_obstacles = false;
            } else {
                number_obstacles_together = (arc4random() % MAX_OBSTACLES_TOGETHER) + 1;
                count_obstacles = 1;
                space_between_obstacles = true;
            }
            
            if(space_between_obstacles) {
                pos_x = pos_x + (obstacle.boundingBox.size.width / 2) + DISTANCE_BETWEEN_OBSTACLES;
            }
            
            if(pos_x + (obstacle.boundingBox.size.width / 2) < last_x) {
                if(count_obstacles_added == [ground numberOfObstaclesInArray]) {
                    obstacle = [CCBReader load:@"Obstacles"];
                    
                    if(pos_x == first_x) {
                       pos_x = pos_x + (obstacle.boundingBox.size.width / 2);
                    }
                    
                    obstacle.position = ccp(pos_x, ground.boundingBox.size.height + 1.0f);
                    
                    [_physicsNode addChild:obstacle];
                    [ground addObstacle:obstacle];
                } else {
                    obstacle = [ground getFirstObstacle];
                    
                    if(pos_x == first_x) {
                        pos_x = pos_x + (obstacle.boundingBox.size.width / 2);
                    }
                    
                    obstacle.position = ccp(pos_x, ground.boundingBox.size.height + 1.0f);
                    
                    [ground updateObstaclePosition :obstacle];
                }
                
                count_obstacles_added++;
            }
            
            x = pos_x + obstacle.boundingBox.size.width + 1.0f;
        }
    }
    
    [ground setNumberOfObstacles :count_obstacles_added];
}


- (void) insertCoins:(Ground*)ground :(int)index{
    Ground* g = ground;
    float first_x = ground.position.x;
    int ground_number_obstacles = [ground numberOfObstacles];
    float last_x = first_x + ground.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_COINS;
    int count_coins = 0;
    int count_coins_added = 0;
    int number_coins_together = (arc4random() % MAX_COINS_TOGETHER) + 1;
    bool space_between_coins = false;
    float pos_y = 0.0f;
    bool gap = [ground hasGap];
    
    if(gap) {
        g = [_grounds_cracked objectAtIndex:index];
        first_x = g.position.x;
        ground_number_obstacles = [g numberOfObstacles];
        last_x = first_x + g.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_COINS;
    }
    
    if(drand48() < CHANCE_COINS) {
        for(float x = first_x; x < last_x; ) {
            CCNode* coin;
            float pos_x = x;
            
            if(count_coins < number_coins_together) {
                count_coins++;
                space_between_coins = false;
            } else {
                number_coins_together = (arc4random() % MAX_COINS_TOGETHER) + 1;
                count_coins = 1;
                space_between_coins = true;
            }
            
            if(space_between_coins) {
                pos_x = pos_x + (coin.boundingBox.size.width / 2) + DISTANCE_BETWEEN_COINS;
            }
            
            if(pos_x + (coin.boundingBox.size.width / 2) < last_x) {
                //No obstacles, coins can be positioned on top of the ground or above the ground
                //If there is a gap, coins must be above of the gap
                if(ground_number_obstacles == 0) {
                    if(gap) {
                        pos_y = (g.boundingBox.size.height + 1.0f + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
                    } else {
                        pos_y = g.boundingBox.size.height + 1.0f + (drand48() * MAX_HEIGHT_COINS);
                    }
                    //If number of coins added is greater or equal than number of obstacles,
                    //next coin can be on top of the ground, having an obstacle on its left, or above the ground
                } else if(count_coins_added >= ground_number_obstacles && ground_number_obstacles > 0) {
                    NSMutableArray *obstacles = [g getObstacles];
                    CCNode* last_obs = [obstacles objectAtIndex:(obstacles.count - 1)];
                    
                    pos_y = g.boundingBox.size.height + 1.0f + (drand48() * MAX_HEIGHT_COINS);
                    pos_x = pos_x + (last_obs.boundingBox.size.width / 2) + MIN_DISTANCE_COIN_FROM_OBSTACLE;
                    //Else get the minimum y position available for the coin
                } else {
                    NSMutableArray *obstacles = [g getObstacles];
                    float min_y = 0.0f;
                    
                    for(int i = 0; i < ground_number_obstacles; i++) {
                        CCNode* obs = [obstacles objectAtIndex:i];
                        
                        if(obs.position.y + (obs.boundingBox.size.height / 2) > min_y) {
                            min_y = obs.position.y + (obs.boundingBox.size.height / 2);
                        }
                    }
                    
                    pos_y = (min_y + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
                }
                
                if(count_coins_added == [g numberOfCoinsInArray]) {
                    coin = [CCBReader load:@"Coins"];
                    
                    if(pos_x == first_x) {
                        pos_x = pos_x + (coin.boundingBox.size.width / 2);
                    }
                    
                    coin.position = ccp(pos_x, pos_y);
                    
                    [_physicsNode addChild:coin];
                    [g addCoin:coin];
                } else {
                    coin = [g getFirstCoin];
                    
                    if(pos_x == first_x) {
                        pos_x = pos_x + (coin.boundingBox.size.width / 2);
                    }
                    
                    coin.position = ccp(pos_x, pos_y);
                    
                    [g updateCoinPosition :coin];
                }
                
                count_coins_added++;
            }
            
            x = pos_x + coin.boundingBox.size.width + 1.0f;
        }
    }
    
    [g setNumberOfCoins :count_coins_added];
}

@end
