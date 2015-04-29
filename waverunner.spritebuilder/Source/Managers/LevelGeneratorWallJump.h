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

static int const MIN_NUMBER_WALLS = 2;
//2 * MAX_MULT_WALLS = MAX_NUMBER_WALLS
static int const MAX_MULT_WALLS = 5;
static int const MIN_DISTANCE_WALLS = 200.0f;
static int const MAX_DISTANCE_WALLS = 350.0f;

@interface LevelGeneratorWallJump : LevelGenerator {
    bool wallBuilt;
    CCNode* wallJumpEnd;
    NSMutableArray *walls;
    NSMutableArray *spawners;
    NSMutableArray *obstacles;
}

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn :(CCNode*) _wn;
- (void)insertSpawner :(float)posx :(float)dimx;


@end
