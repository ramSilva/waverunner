//
//  GameManager.m
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameManager.h"

static GameManager *sharedInstance;
static NSString *const GameManagerHighscoreKey = @"highscore";
static NSString *const GameManagerCoinsKey = @"coins";
static NSString *const GameManagerSpeedLevelKey = @"speedLevel";
static NSString *const GameManagerJumpLevelKey = @"jumpLevel";
static NSString *const GameManagerCoinMultiplier = @"coinmultiplier";

@implementation GameManager

@synthesize jumpLevel = _jumpLevel;
@synthesize jumpLevelMax = _jumpLevelMax;
@synthesize speedLevel = _speedLevel;
@synthesize speedLevelMax = _speedLevelMax;
@synthesize coins = _coins;
@synthesize highscore = _highscore;
@synthesize coinLabel = _coinLabel;
@synthesize scrollSpeed = _scrollSpeed;
@synthesize runningMode = _runningMode;
@synthesize coinMultiplier = _coinMultiplier;
@synthesize coinMultiplierMax = _coinMultiplierMax;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:_highscore forKey:GameManagerHighscoreKey];
    [aCoder encodeInteger:_coins forKey:GameManagerCoinsKey];
    [aCoder encodeInteger:_speedLevel forKey:GameManagerSpeedLevelKey];
    [aCoder encodeInteger:_jumpLevel forKey:GameManagerJumpLevelKey];
    [aCoder encodeInteger:_coinMultiplier forKey:GameManagerCoinMultiplier];
}

+ (NSString*)filePath{
    static NSString *filePath = nil;
    if(!filePath){
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+ (id)loadInstance{
    NSData *decodedData = [NSData dataWithContentsOfFile: [GameManager filePath]];
    if(decodedData){
        GameManager *gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    return [[self alloc] init];
}

- (void)save{
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[GameManager filePath] atomically:YES];
}

- (void)resetData{
    _speedLevel = 1;
    _jumpLevel = 1;
    _jumpLevelMax = 10;
    _speedLevelMax = 10;
    _coinMultiplierMax = 10;
    _coins = 0;
    _highscore = 0;
    _coinMultiplier = 1;
    _runningMode = true;
}

- (void)deleteDocument{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[GameManager filePath] error:&error];
    if(!success){
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    [self resetData];
    [self updateCoinLabel];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _jumpLevelMax = 10;
        _speedLevelMax = 10;
        _coinMultiplierMax = 10;
        _coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins: %ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_coinLabel setPositionType:CCPositionTypeNormalized];
        _coinLabel.position = ccp(0.75f, 0.90f);
        [_coinLabel setFontColor: [CCColor whiteColor]];
        
        _highscoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins: %ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_highscoreLabel setPositionType:CCPositionTypeNormalized];
        _highscoreLabel.position = ccp(0.25f, 0.90f);
        [_highscoreLabel setFontColor: [CCColor whiteColor]];
                
        _highscore = [aDecoder decodeIntegerForKey:GameManagerHighscoreKey];
        _coins = [aDecoder decodeIntegerForKey:GameManagerCoinsKey];
        _speedLevel = [aDecoder decodeIntegerForKey:GameManagerSpeedLevelKey];
        _jumpLevel = [aDecoder decodeIntegerForKey:GameManagerJumpLevelKey];
        _coinMultiplier = [aDecoder decodeIntegerForKey:GameManagerCoinMultiplier];

        
        _runningMode = true;
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        _speedLevel = 1;
        _jumpLevel = 1;
        _jumpLevelMax = 10;
        _speedLevelMax = 10;
        _coins = 0;
        _highscore = 0;
        _coinMultiplier =1;
        _coinMultiplierMax = 10;
        
        _coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins: %ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_coinLabel setPositionType:CCPositionTypeNormalized];
        _coinLabel.position = ccp(0.75f, 0.90f);
        [_coinLabel setFontColor: [CCColor whiteColor]];
        
        _highscoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins: %ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_highscoreLabel setPositionType:CCPositionTypeNormalized];
        _highscoreLabel.position = ccp(0.25f, 0.90f);
        [_highscoreLabel setFontColor: [CCColor whiteColor]];
        
        _runningMode = true;
        //sharedInstance = self;
    }
    return self;
}

- (void)dealloc{
    
}

+ (GameManager*)sharedGameManager{
    static GameManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    return sharedInstance;
}

- (NSInteger)changeCoins:(NSInteger)ammount{
    _coins += (ammount);
    return _coins;
}

- (void)setHighscore:(NSInteger)score{
    if(_highscore < score){
        _highscore = score;
    }
}

- (NSInteger)upgradeJumpLevel{
    _jumpLevel++;
    return _jumpLevel;
}

- (NSInteger)upgradeSpeedLevel{
    _speedLevel++;
    return _speedLevel;
}

-(NSInteger)upgradeMultiplierLevel{
    _coinMultiplier++;
    return _coinMultiplier;
}

- (void)updateCoinLabel{
    _coinLabel.string = [NSString stringWithFormat:@"Coins: %ld", (long)_coins];
}




@end
