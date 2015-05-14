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
#import "Coin.h"
#import "GameManager.h"


@implementation LevelGeneratorSideScroll

-(void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn :(CCNode*)wn{
    [super initializeLevel:g :gc :p :pn :wn];
    _nextGroundIndex = 3;
    
    if(wn.position.x != -500) {
        existedWallJump = true;
    } /*else {
       [self initContent];
    }*/
    
    //Initialize seed
    srand48(arc4random());    
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
        
        if(distance > super.distance_between_obstacles) {
            pos_x = posx + (obstacle.boundingBox.size.width / 2); //+random?
        } else {
            pos_x = posx + (obstacle.boundingBox.size.width / 2) + (super.distance_between_obstacles - distance);
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
    
    if(drand48() < super.chance_obstacles && !gap) {
        if(drand48() < super.chance_moving_obstacles) {
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

- (NSArray*) selectStaticCoinPattern:(float)y {
    NSMutableArray* y_pattern = [[NSMutableArray alloc] init];
    NSArray* ret_pattern;
    int max = MAX_COINS_TOGETHER;
    int pattern = (arc4random() % 2);
    
    switch(pattern) {
        case 0:
            for(int i = 0; i < max; i++) {
                [y_pattern addObject:[NSNumber numberWithFloat:y]];
            }
            break;
        case 1:
            for(int i = 0; i < max; i++) {
                float j = (i % 2);
                [y_pattern addObject:[NSNumber numberWithFloat:y + (j * 25.0f)]];
            }
            break;
    }
    
    ret_pattern = [y_pattern copy];
    
    return ret_pattern;
}

- (void) insertStaticObstacles:(Ground*)ground :(int)index {
    float first_x = ground.position.x;
    float last_x = first_x + ground.boundingBox.size.width - DISTANCE_FROM_GROUND_OBSTACLES;
    int count_obstacles = 0;
    int count_obstacles_added = 0;
    int number_obstacles_together = (arc4random() % MAX_OBSTACLES_TOGETHER) + 1;
    bool space_between_obstacles = false;
    
    for(float x = first_x; x < last_x; ) {
        Obstacle* obstacle = [self selectStaticObstacle];
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
            pos_x = pos_x + super.distance_between_obstacles;
        }
        
        if(pos_x + (obstacle.boundingBox.size.width / 2) < last_x) {
            if(count_obstacles_added == [ground numberOfStaticObstaclesInArray]) {
                pos_x = [self calculateObstaclePositionX :first_x :pos_x :index :obstacle];
                
                if(pos_x + (obstacle.boundingBox.size.width / 2) < last_x) {
                    obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2 - 10));
                    
                    [_physicsNode addChild:obstacle];
                    [ground addStaticObstacle:obstacle];
                    
                    count_obstacles_added++;
                }
            } else {
                Obstacle* temp_obstacle = (Obstacle*)[ground getFirstStaticObstacle :obstacle.type :obstacle.color];
                
                if(temp_obstacle != nil) {
                    obstacle = temp_obstacle;
                }
                
                pos_x = [self calculateObstaclePositionX :first_x :pos_x :index :obstacle];
                
                if(pos_x + (obstacle.boundingBox.size.width / 2) < last_x) {
                    obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2 - 10));
                    
                    if(temp_obstacle != nil) {
                        [ground updateStaticObstaclePosition :obstacle];
                    } else {
                        [_physicsNode addChild:obstacle];
                        [ground addStaticObstacle:obstacle];
                    }
                    
                    count_obstacles_added++;
                }
            }
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
            obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2 - 10));
            
            [_physicsNode addChild:obstacle];
            [ground addMovingObstacle:obstacle];
        } else {
            obstacle = (Obstacle*)[ground getFirstMovingObstacle];
            
            obstacle.position = ccp(pos_x, (ground.boundingBox.size.height / 2) + (obstacle.boundingBox.size.height / 2 - 10));
            
            [ground updateMovingObstaclePosition :obstacle];
        }
        
        count_obstacles_added++;
    }
    
    ground.number_obstacles = count_obstacles_added;
}

- (void) insertCoins:(Ground*)ground :(int)index {
    if(drand48() < super.chance_coins) {
        if(drand48() < super.chance_moving_coins) {
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
    NSMutableArray* all_pos_x;
    NSArray* all_pos_y;
    float max_y = 0.0f;
    float pos_x;
    CCNode* coin = [CCBReader load:@"Coin"];
    
    all_pos_x = [[NSMutableArray alloc] init];
    
    if(gap) {
        g = [_grounds_cracked objectAtIndex:index];
        first_x = g.position.x;
        ground_number_obstacles = g.number_obstacles;
        last_x = first_x + g.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_COINS;
    }
    
    for(float x = first_x; x < last_x; ) {
        float ground_height = (ground.boundingBox.size.height / 2) + (coin.boundingBox.size.height / 2);
        pos_x = x;
        
        if(count_coins < number_coins_together) {
            count_coins++;
            space_between_coins = false;
        } else {
            all_pos_y = [self selectStaticCoinPattern :max_y];
            
            for(int i = 0; i < count_coins; i++) {
                coin = [CCBReader load:@"Coin"];
                pos_y = [[all_pos_y objectAtIndex:i] floatValue];
                
                if(count_coins_added == [g numberOfStaticCoinsInArray]) {
                    pos_x = [[all_pos_x objectAtIndex:i] floatValue] + (coin.boundingBox.size.width / 2);
                    
                    coin.position = ccp(pos_x, pos_y);
                    
                    [_physicsNode addChild:coin];
                    [g addStaticCoin:coin];
                } else {
                    coin = [g getFirstStaticCoin];
                    
                    pos_x = [[all_pos_x objectAtIndex:i] floatValue] + (coin.boundingBox.size.width / 2);
                    
                    coin.position = ccp(pos_x, pos_y);
                    
                    [g updateStaticCoinPosition :coin];
                }
                
                count_coins_added++;
            }
            
            all_pos_x = [[NSMutableArray alloc] init];
            max_y = 0.0f;
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
                    float obs_pos_x_min = obs.position.x - (obs.boundingBox.size.width / 2) - MIN_DISTANCE_COIN_FROM_OBSTACLE;
                    float obs_pos_x_max = obs.position.x + (obs.boundingBox.size.width / 2) + MIN_DISTANCE_COIN_FROM_OBSTACLE;
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
            
            if(pos_y > max_y) {
                max_y = pos_y;
            }
            
            [all_pos_x addObject:[NSNumber numberWithFloat:pos_x]];
        }
        
        x = pos_x + coin.boundingBox.size.width + SPACE_NEXT_COIN;
    }
    
    g.number_coins = count_coins_added;
}

- (void) insertMovingCoins:(Ground*)ground :(int)index {
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
        Ground* g = [_grounds_cracked objectAtIndex:index];
        first_x = g.position.x + (g.boundingBox.size.width / 2) - 1.0f - DISTANCE_FROM_NEXT_GROUND_COINS;
        ground_number_obstacles = g.number_obstacles;
        last_x = g.position.x + g.boundingBox.size.width - DISTANCE_FROM_NEXT_GROUND_COINS;
    }
    
    for(float x = first_x; x < last_x && count_coins_added < MAX_MOVING_COINS; ) {
        Coin* coin = (Coin*)[CCBReader load:@"Coin"];
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
            if(count_coins_added == [ground numberOfMovingCoinsInArray]) {
                pos_y = MIN_HEIGHT_MOVING_COINS;
                
                coin.position = ccp(pos_x, pos_y);
                
                [_physicsNode addChild:coin];
                [ground addMovingCoin:coin];
            } else {
                coin = [ground getFirstMovingCoin];
                
                pos_y = MIN_HEIGHT_MOVING_COINS;
                
                coin.position = ccp(pos_x, pos_y);
                [coin initialDir];
                
                [ground updateMovingCoinPosition :coin];
            }
            
            count_coins_added++;
        }
        
        x = pos_x + coin.boundingBox.size.width + SPACE_NEXT_COIN;
    }
    
    ground.number_coins = count_coins_added;
}


- (void) updateGround {
    for(int i = 0; i < _grounds.count; i++) {
        Ground *g = [_grounds objectAtIndex:i];
        Ground *g_cracked = [_grounds_cracked objectAtIndex:i];
      
        [g updatePosition :_player :(int)_grounds.count :g_cracked];
        
        if (g.next_ground) {
            _nextGroundIndex = i;
            g.next_ground = false;
            
            if(super.noObstacles) {
                super.countGroundsUpdatedStaticOnly = super.countGroundsUpdatedStaticOnly + 1;
            }
        }
        
        if(existedWallJump) {
            g.ready_for_content = false;
        }
        
        g.chance_gap = 0.1f;
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
        
        [ground moveAllObstacles];
        [ground moveAllCoins];
    }
}

- (void) updateLevel:(CCTime)delta {    
    if (!transitionIncoming) {
        super.timer = super.timer + delta;
        
        [super updateDifficulty];
        
        if(super.noObstacles) {
            super.chance_moving_coins = 0.0f;
            super.chance_obstacles = 0.0f;
        } /*else {
            super.chance_moving_coins = CHANCE_MOVING_COINS;
            super.chance_moving_obstacles = CHANCE_MOVING_OBSTACLES;
        }*/
        
        [self updateGround];
        
        if(!existedWallJump) {
            [self updateContent];
        }
        
        if(existedWallJump && !_player.airborne) {
            existedWallJump = false;
        }
    }
}

- (void) setWallMode{
    transitionIncoming = true;
    super.timer = 0.0f;
    Ground *_g = [_grounds objectAtIndex:_nextGroundIndex];
    
    if(_g.ground_gap){
        _wallNode.position = ccp(_g.position.x + _g.boundingBox.size.width - 1, _g.original_y);
    }
    else{
        _wallNode.position = ccp(_g.position.x + _g.boundingBox.size.width - 1, _g.position.y);
    }
    
    int screenwidth = [CCDirector sharedDirector].viewSize.width;
    
    CGPoint nodeposition = [_physicsNode convertToNodeSpace:ccp(screenwidth/2, 70)];
    CCActionMoveTo *_move2 = [CCActionMoveTo actionWithDuration:3 position:nodeposition];
    [_player runAction:_move2];
    _player.runSpeed = _gameManager.scrollSpeed;
    _player.canDoubleJump = false;
    
}

@end
