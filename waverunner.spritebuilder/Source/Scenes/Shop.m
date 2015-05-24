//
//  Shop.m
//  PowerupsTest
//
//  Created by Waverunner on 19/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Shop.h"

@implementation Shop

- (void)didLoadFromCCB{
    GameManager *_gameManager = [GameManager sharedGameManager];
    [_gameManager updateCoinLabel];
    CCNode* p = _coinLabel.parent;
    _coinLabel = [_gameManager coinLabel];
    [_coinLabel removeFromParent];
    [p addChild:_coinLabel];
    
    [self updateCostLabels];
    
    _resistanceLabel.string = [NSString stringWithFormat:@"Resistance: %ld/%ld", (long)[[GameManager sharedGameManager] resistanceLevel], (long)[[GameManager sharedGameManager] resistanceMax]];
    _powerUpDurationLabel.string = [NSString stringWithFormat:@"Power ups\nduration: %ld/%ld", (long)[[GameManager sharedGameManager] powerUpDurationLevel], (long)[[GameManager sharedGameManager] powerUpDurationMax]];
    _multiplierLabel.string = [NSString stringWithFormat:@"Multiplier: %ld/%ld", (long)[[GameManager sharedGameManager] coinMultiplier], (long)[[GameManager sharedGameManager] coinMultiplierMax]];
}

- (void)updateCostLabels{
    GameManager *gm = [GameManager sharedGameManager];
    _resistanceCostLabel.string = [NSString stringWithFormat:@"x%d", gm.resistanceLevel*10];
    _powerUpDurationCostLabel.string = [NSString stringWithFormat:@"x%d", gm.powerUpDurationLevel*10];
    _multiplierCostLabel.string = [NSString stringWithFormat:@"x%d", gm.coinMultiplier*10];
}

- (void)menu{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

- (void)upgradeResistance{
    GameManager *gm = [GameManager sharedGameManager];
    NSInteger upgradeCost = gm.resistanceLevel*10;
    if([gm coins] >= upgradeCost && [gm resistanceLevel] < [gm resistanceMax] ){
        [gm changeCoins:-upgradeCost];
        [[GameManager sharedGameManager] updateCoinLabel];
        _resistanceLabel.string = [NSString stringWithFormat:@"Resistance: %ld/10", (long)[gm upgradeResistanceLevel]];
        [self updateCostLabels];
        
    }
}

- (void)upgradePowerUpDuration{
    GameManager *gm = [GameManager sharedGameManager];
    NSInteger upgradeCost = gm.powerUpDurationLevel*10;
    if([gm coins] >= upgradeCost && [gm powerUpDurationLevel] < [gm powerUpDurationMax]){
        [gm changeCoins:-upgradeCost];
        [[GameManager sharedGameManager] updateCoinLabel];
        _powerUpDurationLabel.string = [NSString stringWithFormat:@"Power ups\nduration: %ld/10", (long)[gm upgradePowerUpDurationLevel]];
        [self updateCostLabels];
    }
}

-(void)upgradeMultiplier{
    CCLOG(@	"Entrei no upgrade multiplier");
    GameManager *gm = [GameManager sharedGameManager];
    NSInteger upgradeCost = gm.coinMultiplier*10;
    if([gm coins] >= upgradeCost && [gm coinMultiplier] < [gm coinMultiplierMax]){
        [gm changeCoins:-upgradeCost];
        [[GameManager sharedGameManager] updateCoinLabel];
        _multiplierLabel.string = [NSString stringWithFormat:@"Multiplier: %ld/10", (long)[gm upgradeMultiplierLevel]];
        [self updateCostLabels];
    }
}

@end
