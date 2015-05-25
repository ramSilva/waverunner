//
//  GameManager.h
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//	

@class TutorialManager;
@class Player;


@interface GameManager : CCNode <NSCoding>{
    NSInteger _powerUpDurationLevel;
    NSInteger _resistanceLevel;
    NSInteger _powerUpDurationMax;
    NSInteger _resistanceMax;
    NSInteger _coins;
    CGPoint _scrollSpeed;
    CCNode *_coinIcon;
    CCLabelTTF *_coinLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highscoreLabel;
    NSInteger _highscore;
    bool _runningMode;
    NSInteger _coinMultiplier;
    NSInteger _coinMultiplierMax;
    NSInteger _challengeCounter;
    bool _useTutorial;
    CGFloat _xAverage;
    NSInteger _xAverageCount;
    CGPoint _diePos;
    TutorialManager *_tutorialManager;
    Player *_player;
}

@property (readonly, nonatomic) NSInteger powerUpDurationLevel;
@property (readonly, nonatomic) NSInteger powerUpDurationMax;
@property (readonly, nonatomic) NSInteger resistanceLevel;
@property (readonly, nonatomic) NSInteger resistanceMax;
@property (readonly, nonatomic) NSInteger coins;
@property (readonly, nonatomic) NSInteger highscore;
@property (readonly, nonatomic) NSInteger coinMultiplier;
@property (readonly, nonatomic) NSInteger coinMultiplierMax;
@property (readonly, nonatomic) CCLabelTTF *coinLabel;
@property (readonly, nonatomic) CCLabelTTF *highscoreLabel;
@property (readwrite,nonatomic) CGPoint scrollSpeed;
@property (readwrite,nonatomic) bool runningMode;
@property (readwrite,nonatomic) bool useTutorial;
@property (readwrite, nonatomic) TutorialManager *tutorialManager;
@property (readwrite, nonatomic) Player *player;



+ (GameManager*) sharedGameManager;

- (NSInteger)changeCoins:(NSInteger)ammount;
- (NSInteger)upgradeResistanceLevel;
- (NSInteger)upgradePowerUpDurationLevel;
- (NSInteger)upgradeMultiplierLevel;
- (void)save;
- (void)updateCoinLabel;
- (void)deleteDocument;
- (void)setHighscore:(NSInteger)score;
- (void)updateXAverage:(CGFloat)currentX;
- (void)writeLog;
- (void)setDiePos:(CGPoint)pos;
- (void)resetLogInfo;

- (void)tutorialTouch;
- (void)tutorialLanded;
- (void)tutorialDoubleJump;

@end