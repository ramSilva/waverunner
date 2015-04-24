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

@interface LevelGeneratorWallJump : LevelGenerator {
    bool wallBuilt;
    CCNode* wallJumpEnd;
    NSMutableArray *walls;
}

- (void)initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn :(CCNode*) _wn;


@end
