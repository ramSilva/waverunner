//
//  LevelGenerator.h
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class Ground;
@class Player;
@class GameManager;

static float const DISTANCE_FROM_GROUND_OBSTACLES = 100.0f;
static float const DISTANCE_FROM_NEXT_GROUND_COINS = 50.0f;
static float const DISTANCE_BETWEEN_OBSTACLES = 170.0f;
static float const DISTANCE_BETWEEN_COINS = 100.0f;
static float const SPACE_NEXT_COIN = 5.0f;
static float const MIN_DISTANCE_COIN_FROM_OBSTACLE = 30.0f;
static float const MAX_HEIGHT_COINS = 125.0f;
static float const MIN_HEIGHT_COINS = 30.0f;
static float const MIN_HEIGHT_MOVING_COINS = 100.0f;
static int const MAX_OBSTACLES_TOGETHER = 1;
static int const MAX_COINS_TOGETHER = 3;
static int const MAX_MOVING_COINS = 3;
static float const CHANCE_OBSTACLES = 0.5f;
static float const CHANCE_MOVING_OBSTACLES = 0.0f;
static float const CHANCE_MOVING_COINS = 0.0f;
static float const CHANCE_COINS = 0.5f;
static float const DIFFICULTY_TIMER = 5.0f;

@interface LevelGenerator : CCNode {
    NSArray *_grounds, *_grounds_cracked;
    Player *_player;
    CCPhysicsNode *_physicsNode;
    bool transitionIncoming;
    CCNode *_wallNode;
    int _nextGroundIndex;
    GameManager *_gameManager;
    float timer;
    float change_difficulty_timer;
    int difficulty;
}

@property(nonatomic, readwrite) float chance_coins;
@property(nonatomic, readwrite) float chance_obstacles;
@property(nonatomic, readwrite) float chance_moving_coins;
@property(nonatomic, readwrite) float chance_moving_obstacles;
@property(nonatomic, readwrite) float distance_between_obstacles;
@property(nonatomic, readwrite) bool noObstacles;
@property(nonatomic, readwrite) int countGroundsUpdatedStaticOnly;
@property(nonatomic, readwrite) int difficulty;
@property(nonatomic, readwrite) float timer;
@property(nonatomic, readonly) float change_difficulty_timer;

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn;
- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn :(CCNode*) _wn;
- (void)initContent;
- (void)insertObstacles:(Ground*)ground;
- (void)insertCoins:(Ground*)ground :(int)index;
- (void)updateGround;
- (void)updateContent;
- (void)updateLevel:(CCTime)delta;
- (void)setWallMode;
- (void)setScrollMode;
- (void)setClimbMode;
-(CCNode*) getWallNode;
- (void)updateDifficulty;
- (void)setChances;

@end
