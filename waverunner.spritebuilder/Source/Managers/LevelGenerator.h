//
//  LevelGenerator.h
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class Ground;
@class Player;

static float const DISTANCE_FROM_GROUND_OBSTACLES = 50.0f;
static float const DISTANCE_FROM_NEXT_GROUND_COINS = 50.0f;
static float const DISTANCE_BETWEEN_OBSTACLES = 150.0f;
static float const DISTANCE_BETWEEN_COINS = 50.0f;
static float const MIN_DISTANCE_COIN_FROM_OBSTACLE = 5.0f;
static float const MAX_HEIGHT_COINS = 150.0f;
static float const MIN_HEIGHT_COINS = 50.0f;
static int const MAX_OBSTACLES_TOGETHER = 3;
static int const MAX_COINS_TOGETHER = 3;
static float const CHANCE_OBSTACLES = 0.5f;
static float const CHANCE_COINS = 0.5f;

@interface LevelGenerator : NSObject {
    NSArray *_grounds, *_grounds_cracked;
    Player *_player;
    CCPhysicsNode *_physicsNode;
}

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn;
- (void)initContent;
- (void)insertObstacles:(Ground*)ground;
- (void)insertCoins:(Ground*)ground :(int)index;
- (void)updateGround;
- (void)updateContent;
- (void)updateLevel;

@end
