//
//  GameManager.h
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@interface GameManager : CCNode <NSCoding>{
    NSInteger _jumpLevel;
    NSInteger _speedLevel;
    NSInteger _jumpLevelMax;
    NSInteger _speedLevelMax;
    NSInteger _coins;
    CGPoint _scrollSpeed;
    CCLabelTTF *_coinLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highscoreLabel;
    NSInteger _highscore;
    bool _runningMode;
    NSInteger _coinMultiplier;
    NSInteger _coinMultiplierMax;
}

@property (readonly, nonatomic) NSInteger jumpLevel;
@property (readonly, nonatomic) NSInteger jumpLevelMax;
@property (readonly, nonatomic) NSInteger speedLevel;
@property (readonly, nonatomic) NSInteger speedLevelMax;
@property (readonly, nonatomic) NSInteger coins;
@property (readonly, nonatomic) NSInteger highscore;
@property (readonly, nonatomic) NSInteger coinMultiplier;
@property (readonly, nonatomic) NSInteger coinMultiplierMax;
@property (readonly, nonatomic) CCLabelTTF *coinLabel;
@property (readonly, nonatomic) CCLabelTTF *highscoreLabel;
@property (readwrite,nonatomic) CGPoint scrollSpeed;
@property (readwrite,nonatomic) bool runningMode;



+ (GameManager*) sharedGameManager;

- (NSInteger)changeCoins:(NSInteger)ammount;
- (NSInteger)upgradeSpeedLevel;
- (NSInteger)upgradeJumpLevel;
- (NSInteger)upgradeMultiplierLevel;
- (void)save;
- (void)updateCoinLabel;
- (void)deleteDocument;
- (void)setHighscore:(NSInteger)score;

@end