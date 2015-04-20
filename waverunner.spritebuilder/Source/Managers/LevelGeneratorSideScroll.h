//
//  LevelGeneratorSideScroll.h
//  waverunner
//
//  Created by Alexandre Freitas on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelGenerator.h"
@class Ground;
@class Player;
@class Obstacle;

@interface LevelGeneratorSideScroll : LevelGenerator {
    bool existedWallJump;
}

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn :(CCNode*) _wn;
- (void)initContent;
- (float)calculateObstaclePositionX:(float)first_x :(float)posx :(int)index :(CCNode*)obstacle;
- (void)insertObstacles:(Ground*)ground :(int)index;
- (Obstacle*)selectStaticObstacle;
- (NSArray*)selectStaticCoinPattern:(float)y;
- (void)insertStaticObstacles:(Ground*)ground :(int)index;
- (void)insertMovingObstacles:(Ground*)ground :(int)index;
- (void)insertCoins:(Ground*)ground :(int)index;
- (void)insertStaticCoins:(Ground*)ground :(int)index;
- (void)updateGround;
- (void)updateContent;
- (void)updateLevel;

@end
