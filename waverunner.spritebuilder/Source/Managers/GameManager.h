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
}

@property (readonly, nonatomic) NSInteger jumpLevel;
@property (readonly, nonatomic) NSInteger jumpLevelMax;
@property (readonly, nonatomic) NSInteger speedLevel;
@property (readonly, nonatomic) NSInteger speedLevelMax;
@property (readonly, nonatomic) NSInteger coins;
@property (readonly, nonatomic) CCLabelTTF *coinLabel;
@property (readwrite,nonatomic) CGPoint scrollSpeed;


+ (GameManager*) sharedGameManager;

- (NSInteger)changeCoins:(NSInteger)ammount;
- (NSInteger)upgradeSpeedLevel;
- (NSInteger)upgradeJumpLevel;
- (void)save;
- (void)updateCoinLabel;
- (void)deleteDocument;

@end