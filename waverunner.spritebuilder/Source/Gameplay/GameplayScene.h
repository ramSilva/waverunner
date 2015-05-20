//
//  GameplayScene.h
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#define BACKGROUND1_MULT 1.0f
#define BACKGROUND2_MULT 0.25f
#define BACKGROUND3_MULT 100.0f
#define MOON_MULT 0.05f
static float const CHANCE_WALLJUMP = 0.25f;
static float const TIMER_WALLJUMP = 10.0f;

#import "CCPhysics+ObjectiveChipmunk.h"

@class CCScene;
@class Player;
@class Ground;
@class LevelGenerator;
@class Coin;
@class InputHandler;
@class GameManager;
@class PowerUp;

@interface GameplayScene : CCScene<CCPhysicsCollisionDelegate>{
    GameManager *_gameManager;
    InputHandler * _inputHandler;

    CCLabelTTF* _coinLabel;
    CCLabelTTF* _scoreLabel;
    NSInteger _currentScore;
    
    CCNode *_contentNode;
    CCNode *_gameOverNode;
    CCPhysicsNode *_physicsNode;
    Player *_player;
    LevelGenerator *_lg;
    //CCNode *_wallJumpTrigger;
    
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
    
    CCNode *_wavesNode;
    CCNode *_exclamationMark;

    CGPoint _previousPhysicsPosition;
    CGPoint _previousPlayerPosition;
    
    float timer;
    BOOL useTimer;
    
    CCNode* _wallNode;
    
    //CCNode* _timeButton, *_shieldButton;
    PowerUp *_powerUpNode;
}

@property (readonly, nonatomic) NSInteger currentScore;

-(void) resetGameOver;
-(void) runMode;
-(void) wallModeIH;
-(void) lastChance:(BOOL)isLastChance;
-(void) enablePowerButton:(BOOL)value :(NSInteger)powerUpType;
-(void) activatePowerUp;
@end
