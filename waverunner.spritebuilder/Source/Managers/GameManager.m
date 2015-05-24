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

@synthesize powerUpDurationLevel = _powerUpDurationLevel;
@synthesize powerUpDurationMax = _powerUpDurationMax;
@synthesize resistanceLevel = _resistanceLevel;
@synthesize resistanceMax = _resistanceMax;
@synthesize coins = _coins;
@synthesize highscore = _highscore;
@synthesize coinLabel = _coinLabel;
@synthesize scrollSpeed = _scrollSpeed;
@synthesize runningMode = _runningMode;
@synthesize coinMultiplier = _coinMultiplier;
@synthesize coinMultiplierMax = _coinMultiplierMax;
@synthesize useTutorial = _useTutorial;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:_highscore forKey:GameManagerHighscoreKey];
    [aCoder encodeInteger:_coins forKey:GameManagerCoinsKey];
    [aCoder encodeInteger:_resistanceLevel forKey:GameManagerSpeedLevelKey];
    [aCoder encodeInteger:_powerUpDurationLevel forKey:GameManagerJumpLevelKey];
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
    _resistanceLevel = 1;
    _powerUpDurationLevel = 1;
    _powerUpDurationMax = 10;
    _resistanceMax = 10;
    _coinMultiplierMax = 10;
    _coins = 0;
    _highscore = 0;
    _coinMultiplier = 1;
    _runningMode = true;
    //_useTutorial = true;
}

- (void)deleteDocument{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[GameManager filePath] error:&error];
    if(!success){
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    [self resetData];
    [self updateCoinLabel];
    [self updateHighscoreLabel];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _powerUpDurationMax = 10;
        _resistanceMax = 10;
        _coinMultiplierMax = 10;
        _xAverage = 0.0f;
        _xAverageCount = 1;
        
         _coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_coinLabel setPositionType:CCPositionTypeNormalized];
        _coinLabel.position = ccp(0.725f, 0.90f);
        _coinLabel.anchorPoint = ccp(0.0f, 0.5f);
        [_coinLabel setFontColor: [CCColor whiteColor]];
        [_coinLabel setOutlineColor:[CCColor blackColor]];
        
        _highscoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Highscore: %ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_highscoreLabel setPositionType:CCPositionTypeNormalized];
        _highscoreLabel.position = ccp(0.25f, 0.90f);
        [_highscoreLabel setFontColor: [CCColor whiteColor]];
                
        _highscore = [aDecoder decodeIntegerForKey:GameManagerHighscoreKey];
        _coins = [aDecoder decodeIntegerForKey:GameManagerCoinsKey];
        _resistanceLevel = [aDecoder decodeIntegerForKey:GameManagerSpeedLevelKey];
        _powerUpDurationLevel = [aDecoder decodeIntegerForKey:GameManagerJumpLevelKey];
        _coinMultiplier = [aDecoder decodeIntegerForKey:GameManagerCoinMultiplier];

        
        _runningMode = true;
        //_useTutorial = true;
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        _xAverageCount = 1;
        _xAverage = 0.0f;
        _resistanceLevel = 1;
        _powerUpDurationLevel = 1;
        _powerUpDurationMax = 10;
        _resistanceMax = 10;
        _coins = 0;
        _highscore = 0;
        _coinMultiplier =1;
        _coinMultiplierMax = 10;
        
        _coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_coinLabel setPositionType:CCPositionTypeNormalized];
        _coinLabel.position = ccp(0.725f, 0.90f);
        _coinLabel.anchorPoint = ccp(0.0f, 0.5f);
        [_coinLabel setFontColor: [CCColor whiteColor]];
        [_coinLabel setOutlineColor:[CCColor blackColor]];
        
        _highscoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Highscore: %ld", (long)_coins] fontName:@"Helvetica" fontSize:20.0f];
        [_highscoreLabel setPositionType:CCPositionTypeNormalized];
        _highscoreLabel.position = ccp(0.25f, 0.90f);
        [_highscoreLabel setFontColor: [CCColor whiteColor]];
        
        _runningMode = true;
        _useTutorial = true;
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

- (NSInteger)upgradePowerUpDurationLevel{
    _powerUpDurationLevel++;
    return _powerUpDurationLevel;
}

- (NSInteger)upgradeResistanceLevel{
    _resistanceLevel++;
    return _resistanceLevel;
}

-(NSInteger)upgradeMultiplierLevel{
    _coinMultiplier++;
    return _coinMultiplier;
}

- (void)updateCoinLabel{
    _coinLabel.string = [NSString stringWithFormat:@"x%ld", (long)_coins];
}

- (void)updateHighscoreLabel{
    _highscoreLabel.string = [NSString stringWithFormat:@"Highscore: %ld", (long)_highscore];
}

- (void)updateXAverage:(CGFloat)currentX{
    _xAverage = (_xAverage + currentX);
    _xAverageCount++;
}

- (void)writeLog{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    NSLog(@"%@",filePath);
    NSString *str = @"hello world";
    
    [str writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
}

- (void)loadLog{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"%@",str);
    
    [[NSFileManager defaultManager] createFileAtPath:@"/Users/student/Documents/logs/log.txt" contents:nil attributes:nil];
    [str writeToFile:@"/Users/student/Documents/logs/log.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) //check error flag for file present or not
        NSLog(@"Error reading file: %@", error.localizedDescription);
}


@end
