//
//  LevelGenerator.m
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelGenerator.h"
#import "GameManager.h"

@implementation LevelGenerator

@synthesize chance_moving_coins;
@synthesize chance_moving_obstacles;
@synthesize staticObjectsOnly;
@synthesize countGroundsUpdatedStaticOnly;

- (void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn {
    _grounds = [g copy];
    _grounds_cracked = [gc copy];
    _player = p;
    _physicsNode = pn;
    chance_moving_obstacles = CHANCE_MOVING_OBSTACLES;
    chance_moving_coins = CHANCE_MOVING_COINS;
    staticObjectsOnly = false;
    countGroundsUpdatedStaticOnly = 0;
    _gameManager = [GameManager sharedGameManager];
    
}
- (void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn : (CCNode*) wn {
    [self initializeLevel:g :gc :p :pn];
    _wallNode = wn;
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
