//
//  LevelGenerator.h
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class Ground;
@class Player;

static float const DISTANCE_FROM_GROUND_OBSTACLES = 20.0f;
static float const DISTANCE_FROM_NEXT_GROUND_COINS = 50.0f;
static float const DISTANCE_BETWEEN_OBSTACLES = 170.0f;
static float const DISTANCE_BETWEEN_COINS = 100.0f;
static float const SPACE_NEXT_COIN = 10.0f;
static float const MIN_DISTANCE_COIN_FROM_OBSTACLE = 10.0f;
static float const MAX_HEIGHT_COINS = 125.0f;
static float const MIN_HEIGHT_COINS = 30.0f;
static float const MIN_HEIGHT_MOVING_COINS = 100.0f;
static int const MAX_OBSTACLES_TOGETHER = 1;
static int const MAX_COINS_TOGETHER = 3;
static int const MAX_MOVING_COINS = 3;
static float const CHANCE_OBSTACLES = 0.5f;
static float const CHANCE_MOVING_OBSTACLES = 0.3f;
static float const CHANCE_MOVING_COINS = 0.3f;
static float const CHANCE_COINS = 0.5f;

@interface LevelGenerator : NSObject {
    NSArray *_grounds, *_grounds_cracked;
    Player *_player;
    CCPhysicsNode *_physicsNode;
    bool transitionIncoming;
    CCNode *_wallNode;
    int _nextGroundIndex;
}

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn;
- (void)initContent;
- (void)insertObstacles:(Ground*)ground;
- (void)insertCoins:(Ground*)ground :(int)index;
- (void)updateGround;
- (void)updateContent;
- (void)updateLevel;
- (void)setWallMode;
- (void)setScrollMode;
- (void)setClimbMode;



@end
