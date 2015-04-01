//
//  LevelGeneratorSideScroll.m
//  waverunner
//
//  Created by Alexandre Freitas on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelGeneratorSideScroll.h"
#import "Ground.h"
#import "Player.h"

@implementation LevelGeneratorSideScroll

-(void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn {
    _grounds = [g copy];
    _grounds_cracked = [gc copy];
    _player = p;
    _physicsNode = pn;
    
    //Initialize seed
    srand48(arc4random());
    
    [self initContent];
}

- (void) initContent {
    for(int i = 2; i < _grounds.count; i++) {
        Ground* ground = [_grounds objectAtIndex:i];
        
        [self insertObstacles :ground];
        [self insertCoins :ground :i];
        ground.ready_for_content = false;
        
    }
}

- (void) insertObstacles:(Ground*)ground {
    float first_x = ground.position.x;
    float last_x = first_x + ground.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_OBSTACLES;
    int count_obstacles = 0;
    int count_obstacles_added = 0;
    int number_obstacles_together = (arc4random() % MAX_OBSTACLES_TOGETHER) + 1;
    bool space_between_obstacles = false;
    bool gap = ground.ground_gap;
    
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
                    obstacle = [CCBReader load:@"Obstacle"];
                    
                    if(pos_x == first_x) {
                        pos_x = pos_x + (obstacle.boundingBox.size.width / 2);
                    }
                    
                    obstacle.position = ccp(pos_x, 80.0f);
                    
                    [_physicsNode addChild:obstacle];
                    [ground addObstacle:obstacle];
                } else {
                    obstacle = [ground getFirstObstacle];
                    
                    if(pos_x == first_x) {
                        pos_x = pos_x + (obstacle.boundingBox.size.width / 2);
                    }
                    
                    obstacle.position = ccp(pos_x, 80.0f);
                    
                    [ground updateObstaclePosition :obstacle];
                }
                
                count_obstacles_added++;
            }
            
            x = pos_x + obstacle.boundingBox.size.width + 1.0f;
        }
    }
    
    ground.number_obstacles = count_obstacles_added;
}


- (void) insertCoins:(Ground*)ground :(int)index {
    Ground* g = ground;
    float first_x = ground.position.x;
    int ground_number_obstacles = ground.number_obstacles;
    float last_x = first_x + ground.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_COINS;
    int count_coins = 0;
    int count_coins_added = 0;
    int number_coins_together = (arc4random() % MAX_COINS_TOGETHER) + 1;
    bool space_between_coins = false;
    float pos_y = 0.0f;
    bool gap = ground.ground_gap;
    
    if(gap) {
        g = [_grounds_cracked objectAtIndex:index];
        first_x = g.position.x;
        ground_number_obstacles = g.number_obstacles;
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
                        pos_y = (80.0f + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
                    } else {
                        pos_y = 80.0f + (drand48() * MAX_HEIGHT_COINS);
                    }
                    //If number of coins added is greater or equal than number of obstacles,
                    //next coin can be on top of the ground, having an obstacle on its left, or above the ground
                } else if(count_coins_added >= ground_number_obstacles && ground_number_obstacles > 0) {
                    NSMutableArray *obstacles = [g getObstacles];
                    CCNode* last_obs = [obstacles objectAtIndex:(obstacles.count - 1)];
                    
                    pos_y = _player.position.y + (drand48() * MAX_HEIGHT_COINS);
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
                    coin = [CCBReader load:@"Coin"];
                    
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
    
    g.number_coins = count_coins_added;
}

- (void) updateGround {
    for(int i = 0; i < _grounds.count; i++) {
        Ground *g = [_grounds objectAtIndex:i];
        Ground *g2 = [_grounds objectAtIndex:(i + 3) % _grounds.count];
        Ground *g_cracked = [_grounds_cracked objectAtIndex:i];
        
        [g updatePosition :_player :g2 :g_cracked];
    }
}

- (void) updateContent {
    for(int i = 0; i < _grounds.count; i++) {
        Ground* ground = [_grounds objectAtIndex:i];
        
        if(ground.ready_for_content) {
            [self insertObstacles :ground];
            [self insertCoins :ground :i];
            ground.ready_for_content = false;
        }
    }
}

- (void) updateLevel {
    [self updateGround];
    [self updateContent];
}

@end
