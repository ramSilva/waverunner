//
//  GameplayScene.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCScene.h"
#import "Player.h"
#import "Ground.h"

#define SCROLL_SPEED 180.0f
#define BACKGROUND1_MULT 0.10f
#define BACKGROUND2_MULT 0.03f
#define BACKGROUND3_MULT 10.0f
#define MOON_MULT 0.005f
static float const DISTANCE_FROM_NEXT_GROUND_OBSTACLES = 100.0f;
static float const DISTANCE_FROM_NEXT_GROUND_COINS = 50.0f;
static float const DISTANCE_BETWEEN_OBSTACLES = 150.0f;
static float const DISTANCE_BETWEEN_COINS = 50.0f;
static float const MIN_DISTANCE_COIN_FROM_OBSTACLE = 5.0f;
static float const MAX_HEIGHT_COINS = 150.0f;
static float const MIN_HEIGHT_COINS = 50.0f;
static int const MAX_OBSTACLES_TOGETHER = 3;
static int const MAX_COINS_TOGETHER = 3;
static float const CHANCE_OBSTACLES = 0.5f;
static float const CHANCE_COINS = 0.5f;

@interface GameplayScene : CCScene <CCPhysicsCollisionDelegate>{
    CCNode *_contentNode, *_gameOverNode;
    CCPhysicsNode *_physicsNode;
    Player *_player;
    
    /*parallax related variables*/
    CCNode *_backgrounds1node, *_backgrounds2node,*_backgrounds3node;
    NSArray *_backgrounds1, *_backgrounds2, *_grounds;
    NSMutableArray *_grounds_cracked;
    CCNode *_bg1_1, *_bg1_2, *_bg1_3, *_bg1_4;
    CCNode *_bg2_1, *_bg2_2, *_bg2_3, *_bg2_4;
    CCNode *_bg3_1;
    CCNode *_moon;
    Ground *_g1, *_g2, *_g3, *_g4;
    /*******************************/
}

- (void)updateGround;
- (void)initContent;
- (void)updateContent;
- (void)insertObstacles:(Ground*)ground;
- (void)insertCoins:(Ground*)ground :(int)index;

@end
