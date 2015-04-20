//
//  LevelGenerator.m
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelGenerator.h"

@implementation LevelGenerator

- (void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn {
    _grounds = [g copy];
    _grounds_cracked = [gc copy];
    _player = p;
    _physicsNode = pn;
}
- (void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn : (CCNode*) wn {
    //[self initializeLevel:g :gc :p :pn];
    _wallNode = wn;
    _grounds = [g copy];
    _grounds_cracked = [gc copy];
    _player = p;
    _physicsNode = pn;
}

- (void) initContent {}
- (void) insertObstacles:(Ground*)ground {}
- (void) insertCoins:(Ground*)ground :(int)index {}
- (void) updateGround {}
- (void) updateContent {}
- (void) updateLevel {}


-(CCNode *)getWallNode{
    return _wallNode;
}

@end
