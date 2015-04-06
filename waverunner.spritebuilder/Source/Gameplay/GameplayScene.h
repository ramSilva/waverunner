//
//  GameplayScene.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#define SCROLL_SPEED 180.0f
#define BACKGROUND1_MULT 0.10f
#define BACKGROUND2_MULT 0.03f
#define BACKGROUND3_MULT 10.0f
#define MOON_MULT 0.005f


@class CCScene;
@class Player;
@class Ground;
@class LevelGenerator;
@class Coin;

@interface GameplayScene : CCScene{
    CCNode *_contentNode;
    CCNode *_gameOverNode;
    CCPhysicsNode *_physicsNode;
    Player *_player;
    LevelGenerator *_lg;
    
    CCNode *_wave;
    
    /*parallax related variables*/
    CCNode *_backgrounds1node, *_backgrounds2node,*_backgrounds3node;
    NSArray *_backgrounds1, *_backgrounds2, *_grounds, *_grounds_cracked;
    //NSMutableArray *_grounds_cracked;
    CCNode *_bg1_1, *_bg1_2, *_bg1_3, *_bg1_4;
    CCNode *_bg2_1, *_bg2_2, *_bg2_3, *_bg2_4;
    CCNode *_bg3_1;
    CCNode *_moon;
    Ground *_g1, *_g2, *_g3, *_g4;
    /*******************************/
}

@end