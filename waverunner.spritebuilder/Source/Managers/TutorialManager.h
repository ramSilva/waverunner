//
//  TutorialManager.h
//  waverunner
//
//  Created by vieira on 24/05/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class GameManager;
@class GameplayScene;
@class Player;
@class LevelGenerator;

#import "CCNode.h"

@interface TutorialManager : CCNode{
    BOOL _useTutorial, _part1Tutorial;
    
    CCNode *_tutorialRequest, *_tutorialRunning, *_tutorialDoubleJump, *_tutorialPreWallJump, *_tutorialWallJump, *_tutorialSecondWallJump;
    GameManager *_gm;
}

@property (nonatomic, readwrite) BOOL useTutorial;

-(void)touchDetected;
-(void)touchedGround;
-(void)doubleJump;
-(void)wallCollision;

@end
