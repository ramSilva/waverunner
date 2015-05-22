//
//  LevelGeneratorWallJump.h
//  waverunner
//
//  Created by vieira on 19/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelGenerator.h"

@class Ground;
@class Player;
@class Obstacle;

static int const MIN_NUMBER_WALLS = 4;
//2 * MAX_MULT_WALLS = MAX_NUMBER_WALLS
static int const MAX_MULT_WALLS = 5;
static int const MIN_DISTANCE_WALLS = 200.0f;
static int const MAX_DISTANCE_WALLS = 300.0f;
static int const MAX_CHALLENGE_ITEMS = 3;

@interface LevelGeneratorWallJump : LevelGenerator {
    bool wallBuilt;
    CCNode* wallJumpEnd;
    CCNode* wave_wj;
    NSMutableArray *walls;
    NSMutableArray *spawners;
    NSMutableArray *obstacles;
    CGFloat fallingObstacleDelay;
}

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn :(CCNode*) _wn;
- (void)insertSpawner:(float)posx :(float)posy :(float)dimx :(bool)right;
- (void)spawnObstacles;
- (void)insertChallengeItems :(float)posx :(float)posy :(float)dimy :(bool)right;
- (void)moveObstacles;
- (void)updateLevel:(CCTime)delta;


@end
