//
//  GameManager.m
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameManager.h"

static GameManager *sharedInstance;
static NSString *const GameManagerCoinsKey = @"coins";
static NSString *const GameManagerSpeedLevelKey = @"speedLevel";
static NSString *const GameManagerJumpLevelKey = @"jumpLevel";

@implementation GameManager

@synthesize jumpLevel = _jumpLevel;
@synthesize jumpLevelMax = _jumpLevelMax;
@synthesize speedLevel = _speedLevel;
@synthesize speedLevelMax = _speedLevelMax;
@synthesize coins = _coins;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:_coins forKey:GameManagerCoinsKey];
    [aCoder encodeInteger:_speedLevel forKey:GameManagerSpeedLevelKey];
    [aCoder encodeInteger:_jumpLevel forKey:GameManagerJumpLevelKey];
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
    _coins = 0;
}

- (void)deleteDocument{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[GameManager filePath] error:&error];
    if(!success){
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    [self resetData];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _jumpLevelMax = 10;
        _speedLevelMax = 10;
        _coins = [aDecoder decodeIntegerForKey:GameManagerCoinsKey];
        _speedLevel = [aDecoder decodeIntegerForKey:GameManagerSpeedLevelKey];
        _jumpLevel = [aDecoder decodeIntegerForKey:GameManagerJumpLevelKey];
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
    _coins += ammount;
    return _coins;
}

- (NSInteger)upgradeJumpLevel{
    _jumpLevel++;
    return _jumpLevel;
}

- (NSInteger)upgradeSpeedLevel{
    _speedLevel++;
    return _speedLevel;
}

- (void)updateCoinLabel:(CCLabelTTF *)coinLabel{
    coinLabel.string = [NSString stringWithFormat:@"Coins: %ld", _coins];
}

@end
