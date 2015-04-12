//
//  Ground.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class CCSprite;

static float const CHANCE_GAP = 0.1f;
static float const GROUND_BLOCKS_DISTANCE = 1.0f;
static float const NOT_VISIBLE_IN_SCREEN = 500.0f;

@interface Ground : CCSprite {
    int original_y;
    NSMutableArray *static_obstacles;
    NSMutableArray *moving_obstacles;
    NSMutableArray *coins;
    int matching_obs_index;
}

@property(nonatomic,readonly) bool ground_gap;
@property(nonatomic,readwrite) bool any_moving_obstacles;
@property(nonatomic,readwrite) bool ready_for_content;
@property(nonatomic,readwrite) int number_obstacles;
@property(nonatomic,readwrite) int number_coins;
@property(nonatomic,readwrite) bool next_ground;


- (int)numberOfStaticObstaclesInArray;
- (int)numberOfMovingObstaclesInArray;
- (int)numberOfCoinsInArray;
- (void)addStaticObstacle:(CCNode*)obs;
- (CCNode*)getLastStaticObstacle;
- (CCNode*)getFirstStaticObstacle:(NSString*)type :(NSString*)color;
- (void)updateStaticObstaclePosition:(CCNode*)obs;
- (void)addMovingObstacle:(CCNode*)obs;
- (CCNode*)getLastMovingObstacle;
- (CCNode*)getFirstMovingObstacle;
- (void)updateMovingObstaclePosition:(CCNode*)obs;
- (void)addCoin:(CCNode*)coin;
- (CCNode*)getFirstCoin;
- (void)updateCoinPosition:(CCNode*)coin;
- (NSMutableArray*)getStaticObstacles;
- (NSMutableArray*)getMovingObstacles;
- (void)insertGap:(Ground*)cracked;
- (void)updatePosition:(CCNode*)player :(Ground*)node2 :(Ground*)cracked;

@end
