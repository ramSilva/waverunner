//
//  GameplayScene.h
//  waverunner
//
//  Created by Waverunner on 25/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCScene.h"

#define  SCROLL_SPEED 180.0f
#define BACKGROUND1_MULT 0.20f
#define BACKGROUND2_MULT 0.05f

@interface GameplayScene : CCScene{
    CCNode *_contentNode;
    CCPhysicsNode *_physicsNode;
    CCNode *_player;
    
    /*parallax related variables*/
    CCNode *_backgrounds1node, *_backgrounds2node;
    NSArray *_backgrounds1, *_backgrounds2, *_grounds;
    CCNode *_background1_1, *_background1_2, *_background1_3;
    CCNode *_background2_1, *_background2_2, *_background2_3;
    CCNode *_ground1, *_ground2, *_ground3, *_ground4;
    /*******************************/
}

@end
