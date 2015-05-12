//
//  LevelGenerator.m
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelGenerator.h"
#import "GameManager.h"
#import "Player.h"

@implementation LevelGenerator

@synthesize chance_coins;
@synthesize chance_obstacles;
@synthesize chance_moving_coins;
@synthesize chance_moving_obstacles;
@synthesize distance_between_obstacles;
@synthesize noObstacles;
@synthesize countGroundsUpdatedStaticOnly;
@synthesize timer;
@synthesize change_difficulty_timer;
@synthesize difficulty;

- (void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn {
    _grounds = [g copy];
    _grounds_cracked = [gc copy];
    _player = p;
    _physicsNode = pn;
    noObstacles = false;
    countGroundsUpdatedStaticOnly = 0;
    _gameManager = [GameManager sharedGameManager];
    difficulty = 1;
    change_difficulty_timer = difficulty * DIFFICULTY_TIMER;
    timer = 0.0f;
    [self setChances];
}

- (void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn : (CCNode*) wn {
    [self initializeLevel:g :gc :p :pn];
    _wallNode = wn;
}

- (void) initContent {}
- (void) insertObstacles:(Ground*)ground {}
- (void) insertCoins:(Ground*)ground :(int)index {}
- (void) updateGround {}
- (void) updateContent {}
- (void) updateLevel {}

-(CCNode *)getWallNode{
    return _wallNode;
}

- (void) updateDifficulty {
    if(timer > change_difficulty_timer) {
        printf("num_col: %d\n", _player.num_obstacles_collision);
        if(_player.num_obstacles_collision == 0) {
            if(difficulty < 5) {
                difficulty += 1;
            }
        } /*else if(_player.num_obstacles_collision >= 3) {
            if(difficulty > 1) {
                difficulty -= 1;
            }
        }*/
        
        _player.num_obstacles_collision = 0;
        printf("difficulty: %d ", difficulty);
        change_difficulty_timer = difficulty * DIFFICULTY_TIMER;
        printf("new_timer: %f\n", change_difficulty_timer);
        timer = 0.0f;
        [self setChances];
    }    
}

- (void) setChances {
    chance_obstacles = difficulty * 0.1 + 0.2f;
    chance_coins = difficulty * 0.1 + 0.2f;
    chance_moving_obstacles = (difficulty - 1) * 0.07 + 0.16f;
    chance_moving_coins = (difficulty - 1) * 0.07 + 0.16f;
    distance_between_obstacles = 290.0f - ((difficulty - 1) * 30.0f);
}

@end
