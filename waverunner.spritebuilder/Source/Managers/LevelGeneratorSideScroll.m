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
#import "Obstacle.h"


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
    _wallNode.position = ccp(-500, -500);
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
    if(prev_ground.number_obstacles > 0 && pos_x == first_x && !prev_ground.any_moving_obstacles) {
        CCNode* last_obs_g_before = [prev_ground getLastStaticObstacle];
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
    bool gap = ground.ground_gap;
    
    if(drand48() < CHANCE_OBSTACLES && !gap) {
        if(drand48() < CHANCE_MOVING_OBSTACLES) {
            [self insertMovingObstacles:ground :index];
        } else {
            [self insertStaticObstacles :ground :index];
        }
    }
}

- (Obstacle*) selectStaticObstacle {
    Obstacle *obs;
    int obs_type = (arc4random() % 4);
    
    switch(obs_type) {
        case 0:
            obs = (Obstacle*)[CCBReader load:@"Obstacle_Garbage_G"];
            obs.type = @"garbage";
            obs.color = @"green";
            break;
        case 1:
            obs = (Obstacle*)[CCBReader load:@"Obstacle_Garbage_B"];
            obs.type = @"garbage";
            obs.color = @"blue";
            break;
        case 2:
            obs = (Obstacle*)[CCBReader load:@"Obstacle_Car_R"];
            obs.type = @"car";
            obs.color = @"red";
            break;
        case 3:
            obs = (Obstacle*)[CCBReader load:@"Obstacle_Car_B"];
            obs.type = @"car";
            obs.color = @"blue";
            break;
    }
    
    return obs;
}

- (void) insertStaticObstacles:(Ground*)ground :(int)index {
    float first_x = ground.position.x;
    float last_x = first_x + ground.boundingBox.size.width - DISTANCE_FROM_GROUND_OBSTACLES;
    int count_obstacles = 0;
    int count_obstacles_added = 0;
    int number_obstacles_together = (arc4random() % MAX_OBSTACLES_TOGETHER) + 1;
    bool space_between_obstacles = false;
    
    for(float x = first_x; x < last_x; ) {
        Obstacle* obstacle = [self selectStaticObstacle];//(Obstacle*)[CCBReader load:@"Obstacle_Garbage_B"];
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
            if(count_obstacles_added == [ground numberOfStaticObstaclesInArray]) {
                pos_x = [self calculateObstaclePositionX :first_x :pos_x :index :obstacle];
                
                obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2));
                
                [_physicsNode addChild:obstacle];
                [ground addStaticObstacle:obstacle];
            } else {
                Obstacle* temp_obstacle = (Obstacle*)[ground getFirstStaticObstacle :obstacle.type :obstacle.color];
                
                if(temp_obstacle != nil) {
                    obstacle = temp_obstacle;
                }
                
                pos_x = [self calculateObstaclePositionX :first_x :pos_x :index :obstacle];
                
                obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2));
                
                if(temp_obstacle != nil) {
                    [ground updateStaticObstaclePosition :obstacle];
                } else {
                    [_physicsNode addChild:obstacle];
                    [ground addStaticObstacle:obstacle];	
                }
                
            }
            
            count_obstacles_added++;
        }
        
        x = pos_x + (obstacle.boundingBox.size.width / 2) + 1.0f;
    }
    
    ground.number_obstacles = count_obstacles_added;
}

- (void)insertMovingObstacles:(Ground*)ground :(int)index {
    float first_x = ground.position.x;
    float last_x = first_x + ground.boundingBox.size.width;
    int count_obstacles_added = 0;
    Obstacle* obstacle = (Obstacle*)[CCBReader load:@"Moving_Obstacle"];
    float pos_x = first_x + ground.boundingBox.size.width - 1.0f;
    
    if(pos_x < last_x) {
        if(count_obstacles_added == [ground numberOfMovingObstaclesInArray]) {
            obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2));
            
            [_physicsNode addChild:obstacle];
            [ground addMovingObstacle:obstacle];
        } else {
            obstacle = (Obstacle*)[ground getFirstMovingObstacle];
            
            obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2));
            
            [ground updateMovingObstaclePosition :obstacle];
        }
        
        count_obstacles_added++;
    }
    
    ground.number_obstacles = count_obstacles_added;
}

- (void) insertCoins:(Ground*)ground :(int)index {
    if(drand48() < CHANCE_COINS) {
        if(drand48() < CHANCE_MOVING_COINS) {
            [self insertMovingCoins :ground :index];
        } else {
            [self insertStaticCoins :ground :index];
        }
    }
}

- (void) insertStaticCoins:(Ground*)ground :(int)index {
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
            } else if(ground_number_obstacles == 1 && ground.any_moving_obstacles) {
                pos_y = (ground_height + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
            } else {
                NSMutableArray *obstacles = [g getStaticObstacles];
                pos_y = ground_height + (drand48() * MAX_HEIGHT_COINS);
                float min_y = 0.0f;
                
                for(int i = 0; i < ground_number_obstacles; i++) {
                    CCNode* obs = [obstacles objectAtIndex:(obstacles.count - 1 - i)];
                    float obs_pos_x_min = obs.position.x - (obs.boundingBox.size.width / 2);
                    float obs_pos_x_max = obs.position.x + (obs.boundingBox.size.width / 2);
                    float coin_pos_x_min = pos_x - (coin.boundingBox.size.width / 2);
                    float coin_pos_x_max = pos_x + (coin.boundingBox.size.width / 2);
                    
                    //If coin collides with obstacle
                    if((coin_pos_x_max >= obs_pos_x_min && coin_pos_x_max <= obs_pos_x_max)
                       || (coin_pos_x_min <= obs_pos_x_max && coin_pos_x_min >= obs_pos_x_min)) {
                        
                        if(obs.position.y + (obs.boundingBox.size.height / 2) + 1.0f > min_y) {
                            min_y = obs.position.y + (obs.boundingBox.size.height / 2);
                        }
                        
                        pos_y = (min_y + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
                    }
                }
            }
            
            if(count_coins_added == [g numberOfStaticCoinsInArray]) {
                pos_x = pos_x + (coin.boundingBox.size.width / 2);
                
                coin.position = ccp(pos_x, pos_y);
                
                [_physicsNode addChild:coin];
                [g addStaticCoin:coin];
            } else {
                coin = [g getFirstStaticCoin];
                
                pos_x = pos_x + (coin.boundingBox.size.width / 2);
                
                coin.position = ccp(pos_x, pos_y);
                
                [g updateStaticCoinPosition :coin];
            }
            
            count_coins_added++;
        }
        
        x = pos_x + (coin.boundingBox.size.width / 2) + SPACE_NEXT_COIN;
    }
    
    g.number_coins = count_coins_added;
}

- (void) insertMovingCoins:(Ground*)ground :(int)index {
    Ground* g = ground;
    float first_x = ground.position.x + (ground.boundingBox.size.width / 2) - 1.0f - DISTANCE_FROM_NEXT_GROUND_COINS;
    int ground_number_obstacles = ground.number_obstacles;
    float last_x = ground.position.x + ground.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_COINS;
    int count_coins = 0;
    int count_coins_added = 0;
    int number_coins_together = (arc4random() % MAX_COINS_TOGETHER) + 1;
    bool space_between_coins = false;
    float pos_y = 0.0f;
    bool gap = ground.ground_gap;
    
    if(gap) {
        g = [_grounds_cracked objectAtIndex:index];
        first_x = g.position.x + (g.boundingBox.size.width / 2) - 1.0f - DISTANCE_FROM_NEXT_GROUND_COINS;
        ground_number_obstacles = g.number_obstacles;
        last_x = g.position.x + g.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_COINS;
    }
    
    for(float x = first_x; x < last_x && count_coins_added < MAX_MOVING_COINS; ) {
        CCNode* coin = [CCBReader load:@"Coin"];
        //float ground_height = (ground.boundingBox.size.height / 2) + (coin.boundingBox.size.height / 2);
        float pos_x = x - (coin.boundingBox.size.width / 2);
        
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
            //To move the coins independently just give a different pos_y for each coin
            
            //No obstacles, coins can be positioned on top of the ground or above the ground
            //If there is a gap, coins must be above of the gap
            /*if(ground_number_obstacles == 0) {
                if(gap) {
                    pos_y = (ground_height + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
                } else {
                    pos_y = ground_height + (drand48() * MAX_HEIGHT_COINS);
                }
                //If number of coins added is greater or equal than number of obstacles,
                //next coin can be on top of the ground, having an obstacle on its left, or above the ground
            } else if(ground_number_obstacles == 1 && ground.any_moving_obstacles) {
                pos_y = (ground_height + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
            } else {
                NSMutableArray *obstacles = [g getStaticObstacles];
                pos_y = ground_height + (drand48() * MAX_HEIGHT_COINS);
                float min_y = 0.0f;
                
                for(int i = 0; i < ground_number_obstacles; i++) {
                    CCNode* obs = [obstacles objectAtIndex:(obstacles.count - 1 - i)];
                    float obs_pos_x_min = obs.position.x - (obs.boundingBox.size.width / 2);
                    float obs_pos_x_max = obs.position.x + (obs.boundingBox.size.width / 2);
                    float coin_pos_x_min = pos_x - (coin.boundingBox.size.width / 2);
                    float coin_pos_x_max = pos_x + (coin.boundingBox.size.width / 2);
                    
                    //If coin collides with obstacle
                    if((coin_pos_x_max >= obs_pos_x_min && coin_pos_x_max <= obs_pos_x_max)
                       || (coin_pos_x_min <= obs_pos_x_max && coin_pos_x_min >= obs_pos_x_min)) {
                        
                        if(obs.position.y + (obs.boundingBox.size.height / 2) + 1.0f > min_y) {
                            min_y = obs.position.y + (obs.boundingBox.size.height / 2);
                        }
                        
                        pos_y = (min_y + MIN_HEIGHT_COINS) + (drand48() * MAX_HEIGHT_COINS);
                    }
                }
            }*/
            
            if(count_coins_added == [g numberOfMovingCoinsInArray]) {
                pos_x = pos_x + (coin.boundingBox.size.width / 2);
                pos_y = MIN_HEIGHT_MOVING_COINS;
                
                coin.position = ccp(pos_x, pos_y);
                
                [_physicsNode addChild:coin];
                [g addMovingCoin:coin];
            } else {
                coin = [g getFirstMovingCoin];
                
                pos_x = pos_x + (coin.boundingBox.size.width / 2);
                pos_y = MIN_HEIGHT_MOVING_COINS;
                
                coin.position = ccp(pos_x, pos_y);
                
                [g updateMovingCoinPosition :coin];
            }
            
            count_coins_added++;
        }
        
        x = pos_x + (coin.boundingBox.size.width / 2) + SPACE_NEXT_COIN;
    }
    
    g.number_coins = count_coins_added;
}


- (void) updateGround {
    for(int i = 0; i < _grounds.count; i++) {
        Ground *g = [_grounds objectAtIndex:i];
        Ground *g_cracked = [_grounds_cracked objectAtIndex:i];
      
        [g updatePosition :_player :_grounds.count :g_cracked];
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

-(void)setScrollMode{
    transitionIncoming = false;
    //Ground *_g = [_grounds objectAtIndex:_nextGroundIndex];
    _player.physicsBody.velocity = ccp(0, 0);
    /*CCActionFollow *_follow = [CCActionFollow actionWithTarget:_player];
    [_physicsNode runAction:_follow];*/
    
    CCActionMoveBy *_moveby = [CCActionMoveBy actionWithDuration:.5 position:ccp(-800, 0)];
    
    [_wallNode runAction:_moveby];
    
    CCActionMoveTo *_movet = [CCActionMoveTo actionWithDuration:1.5 position:ccp(_physicsNode.position.x, 0)];
    
    [_physicsNode runAction:_movet];
    
    CGPoint nodeposition = [_physicsNode convertToNodeSpace:ccp(218,70)];
    
    CCActionMoveTo *_move2 = [CCActionMoveTo actionWithDuration:2 position:nodeposition];
    [_player runAction:_move2];
    
    
    //_player.position = [_physicsNode convertToNodeSpace:ccp(218,70)];
}

@end
