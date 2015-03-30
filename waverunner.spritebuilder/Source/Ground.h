//
//  Ground.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

static float const CHANCE_GAP = 0.1f;
static float const GROUND_BLOCKS_DISTANCE = 2.0f;
static float const NOT_VISIBLE_IN_SCREEN = 500.0f;

@interface Ground : CCSprite {
    bool ground_gap;
    int number_obstacles;
    int number_coins;
    int original_y;
    bool ready_for_content;
    NSMutableArray *obstacles;
    NSMutableArray *coins;
}

- (bool)hasGap;
- (bool)isReadyForContent;
- (void)setReadyForContent:(bool)state;
- (int)numberOfObstaclesInArray;
- (int)numberOfCoinsInArray;
- (void)setNumberOfObstacles:(int)number;
- (void)setNumberOfCoins:(int)number;
- (int)numberOfObstacles;
- (int)numberOfCoins;
- (void)addObstacle:(CCNode*)obs;
- (CCNode*)getFirstObstacle;
- (void)updateObstaclePosition:(CCNode*)obs;
- (void)addCoin:(CCNode*)coin;
- (CCNode*)getFirstCoin;
- (void)updateCoinPosition:(CCNode*)coin;
- (NSMutableArray*)getObstacles;
- (void)insertGap:(Ground*)cracked;
- (void)updatePosition:(CCNode*)player :(Ground*)node2 :(Ground*)cracked;

@end
