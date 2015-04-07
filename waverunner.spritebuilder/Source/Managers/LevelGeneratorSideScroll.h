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

@interface LevelGeneratorSideScroll : LevelGenerator

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn;
- (void)initContent;
- (float)calculateObstaclePositionX:(float)first_x :(float)posx :(int)index :(CCNode*)obstacle;
- (void)insertObstacles:(Ground*)ground :(int)index;
- (void)insertCoins:(Ground*)ground :(int)index;
- (void)updateGround;
- (void)updateContent;
- (void)updateLevel;
- (Ground*)getNextGround;

@end
