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
    _nextGroundIndex = 3;
    
    //Initialize seed
    srand48(arc4random());
    
    [self initContent];
    _wallNode =[CCBReader load:@"WallJump/WallJumpTransition"];
    _wallNode.position = ccp(MAXFLOAT, MAXFLOAT);
    [pn addChild:_wallNode];
}

- (void) initContent {
    for(int i = 2; i < _grounds.count; i++) {
        Ground* ground = [_grounds objectAtIndex:i];
        
        [self insertObstacles :ground :i];
        [self insertCoins :ground :i];
        ground.ready_for_content = false;
        
    }
}

- (float) calculateObstaclePositionX:(float)first_x :(float)posx :(int)index :(CCNode*)obstacle {
    float pos_x = posx;
    Ground* prev_ground = [_grounds objectAtIndex:(index + 3) % _grounds.count];
    
    //If previous ground has obstacles then the first obstacle must be placed at least DISTANCE_BETWEEN_OBSTACLES away from the last object
    if(prev_ground.number_obstacles > 0 && pos_x == first_x) {
        CCNode* last_obs_g_before = [prev_ground getLastObstacle];
        float distance = (posx + (obstacle.boundingBox.size.width / 2)) - (last_obs_g_before.position.x + (last_obs_g_before.boundingBox.size.width / 2));
        
        if(distance > DISTANCE_BETWEEN_OBSTACLES) {
            pos_x = posx + (obstacle.boundingBox.size.width / 2); //+random?
        } else {
            pos_x = posx + (obstacle.boundingBox.size.width / 2) + (DISTANCE_BETWEEN_OBSTACLES - distance);
        }
        
    } else {
        //If previous ground has gap then the first obstacle must be placed a bit further so the player has the opportunity to jump
        if(prev_ground.ground_gap && pos_x == first_x) {
            pos_x = posx + (obstacle.boundingBox.size.width / 2) + DISTANCE_FROM_GROUND_OBSTACLES; //+random?;
        } else {
            pos_x = posx + (obstacle.boundingBox.size.width / 2); //+random?;
        }
    }
    
    return pos_x;
}

- (void) insertObstacles:(Ground*)ground :(int)index {
    float first_x = ground.position.x;
    float last_x = first_x + ground.boundingBox.size.width - DISTANCE_FROM_GROUND_OBSTACLES;
    int count_obstacles = 0;
    int count_obstacles_added = 0;
    int number_obstacles_together = (arc4random() % MAX_OBSTACLES_TOGETHER) + 1;
    bool space_between_obstacles = false;
    bool gap = ground.ground_gap;
    
    if(drand48() < CHANCE_OBSTACLES && !gap) {
        for(float x = first_x; x < last_x; ) {
            CCNode* obstacle = [CCBReader load:@"Obstacle"];
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
                pos_x = pos_x + DISTANCE_BETWEEN_OBSTACLES;
            }
            
            if(pos_x + (obstacle.boundingBox.size.width / 2) < last_x) {
                if(count_obstacles_added == [ground numberOfObstaclesInArray]) {
                    pos_x = [self calculateObstaclePositionX :first_x :pos_x :index :obstacle];
                    
                    obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2));
                    
                    [_physicsNode addChild:obstacle];
                    [ground addObstacle:obstacle];
                } else {
                    obstacle = [ground getFirstObstacle];
                    
                    pos_x = [self calculateObstaclePositionX :first_x :pos_x :index :obstacle];
                    
                    obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2));
                    
                    [ground updateObstaclePosition :obstacle];
                }
                
                count_obstacles_added++;
            }
            
            x = pos_x + (obstacle.boundingBox.size.width / 2) + 1.0f;
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
            CCNode* coin = [CCBReader load:@"Coin"];
            float ground_height = (ground.boundingBox.size.height / 2) + (coin.boundingBox.size.height / 2);
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
                pos_x = pos_x + DISTANCE_BETWEEN_COINS;
            }
            
            if(pos_x + (coin.boundingBox.size.width / 2) < last_x) {
                //No obstacles, coins can be positioned on top of the ground or above the ground
                //If there is a gap, coins must be above of the gap
                if(ground_number_obstacles == 0) {
                    if(gap) {
                        pos_y = (ground_height + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
                    } else {
                        pos_y = ground_height + (drand48() * MAX_HEIGHT_COINS);
                    }
                    //If number of coins added is greater or equal than number of obstacles,
                    //next coin can be on top of the ground, having an obstacle on its left, or above the ground
                } else if(count_coins_added >= ground_number_obstacles && ground_number_obstacles > 0) {
                    NSMutableArray *obstacles = [g getObstacles];
                    CCNode* last_obs = [obstacles objectAtIndex:(obstacles.count - 1)];
                    
                    pos_y = ground_height + (drand48() * MAX_HEIGHT_COINS);
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
                    pos_x = pos_x + (coin.boundingBox.size.width / 2);
                    
                    coin.position = ccp(pos_x, pos_y);
                    
                    [_physicsNode addChild:coin];
                    [g addCoin:coin];
                } else {
                    coin = [g getFirstCoin];
                    
                    pos_x = pos_x + (coin.boundingBox.size.width / 2);
                    
                    coin.position = ccp(pos_x, pos_y);
                    
                    [g updateCoinPosition :coin];
                }
                
                count_coins_added++;
            }
            
            x = pos_x + (coin.boundingBox.size.width / 2) + 1.0f;
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
        if (g.next_ground) {
            _nextGroundIndex = i;
            g.next_ground = false;
        }
    }
}

- (void) updateContent {
    for(int i = 0; i < _grounds.count; i++) {
        Ground* ground = [_grounds objectAtIndex:i];
        
        if(ground.ready_for_content) {
            [self insertObstacles :ground :i];
            [self insertCoins :ground :i];
            ground.ready_for_content = false;
        }
    }
}

- (void) updateLevel {
    if (!transitionIncoming) {
        [self updateGround];
        [self updateContent];
    }
    
}

-(void)setWallMode{
    transitionIncoming = true;
    Ground *_g = [_grounds objectAtIndex:_nextGroundIndex];
    _wallNode.position = ccp(_g.position.x + _g.boundingBox.size.width - 1, _g.position.y);
}

-(Ground *)getNextGround{
    for (Ground *_itemG in _grounds) {
        if (_itemG.next_ground) {
            return _itemG;
        }
    }
    return nil;
}

@end
