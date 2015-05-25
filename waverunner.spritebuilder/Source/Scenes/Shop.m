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
    _coinLabel.position = ccp(0.835f, 0.90f);
    
    [self updateCostLabels];
    
    _resistanceLabel.string = [NSString stringWithFormat:@"%ld/%ld", (long)[[GameManager sharedGameManager] resistanceLevel], (long)[[GameManager sharedGameManager] resistanceMax]];
    
    if([_gameManager resistanceLevel] == [_gameManager resistanceMax]) {
        _resistanceButton.title = [NSString stringWithFormat:@"MAXED"];
        [_resistanceButton setEnabled:false];
        _resistanceCostLabel.string = [NSString stringWithFormat:@""];
        _resCoin.visible = false;
    }
    
    _powerUpDurationLabel.string = [NSString stringWithFormat:@"%ld/%ld", (long)[[GameManager sharedGameManager] powerUpDurationLevel], (long)[[GameManager sharedGameManager] powerUpDurationMax]];
    
    if([_gameManager powerUpDurationLevel] == [_gameManager powerUpDurationMax]) {
        _powerupsButton.title = [NSString stringWithFormat:@"MAXED"];
        [_powerupsButton setEnabled:false];
         _powerUpDurationCostLabel.string = [NSString stringWithFormat:@""];
        _powerupsCoin.visible = false;
    }
    
    _multiplierLabel.string = [NSString stringWithFormat:@"%ld/%ld", (long)[[GameManager sharedGameManager] coinMultiplier], (long)[[GameManager sharedGameManager] coinMultiplierMax]];
    
    if([_gameManager coinMultiplier] == [_gameManager coinMultiplierMax]) {
        _coinmultButton.title = [NSString stringWithFormat:@"MAXED"];
        [_coinmultButton setEnabled:false];
        _multiplierCostLabel.string = [NSString stringWithFormat:@""];
        _coinmultCoin.visible = false;
    }
    
    float screen_width = [[UIScreen mainScreen] bounds].size.width;
    float screen_height = [[UIScreen mainScreen] bounds].size.height;
    
    float bg_width = _shop_bg.contentSize.width;
    float bg_height = _shop_bg.contentSize.height;
    
    _shop_bg.scaleX = screen_width / bg_width;
    _shop_bg.scaleY = screen_height / bg_height;
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
        _resistanceLabel.string = [NSString stringWithFormat:@"%ld/10", (long)[gm upgradeResistanceLevel]];
        //[self updateCostLabels];
        _resistanceCostLabel.string = [NSString stringWithFormat:@"x%ld", gm.resistanceLevel*10];
        if([gm resistanceLevel] == [gm resistanceMax]) {
            _resistanceButton.title = [NSString stringWithFormat:@"MAXED"];
            [_resistanceButton setEnabled:false];
            _resistanceCostLabel.string = [NSString stringWithFormat:@""];
            _resCoin.visible = false;
        }
    }
}

- (void)upgradePowerUpDuration{
    GameManager *gm = [GameManager sharedGameManager];
    NSInteger upgradeCost = gm.powerUpDurationLevel*10;
    if([gm coins] >= upgradeCost && [gm powerUpDurationLevel] < [gm powerUpDurationMax]){
        [gm changeCoins:-upgradeCost];
        [[GameManager sharedGameManager] updateCoinLabel];
        _powerUpDurationLabel.string = [NSString stringWithFormat:@"%ld/10", (long)[gm upgradePowerUpDurationLevel]];
        //[self updateCostLabels];
        _powerUpDurationCostLabel.string = [NSString stringWithFormat:@"x%ld", gm.powerUpDurationLevel*10];
        if([gm powerUpDurationLevel] == [gm powerUpDurationMax]) {
            _powerupsButton.title = [NSString stringWithFormat:@"MAXED"];
            [_powerupsButton setEnabled:false];
            _powerUpDurationCostLabel.string = [NSString stringWithFormat:@""];
            _powerupsCoin.visible = false;
        }
    }
}

-(void)upgradeMultiplier{
    //CCLOG(@	"Entrei no upgrade multiplier");
    GameManager *gm = [GameManager sharedGameManager];
    NSInteger upgradeCost = gm.coinMultiplier*10;
    if([gm coins] >= upgradeCost && [gm coinMultiplier] < [gm coinMultiplierMax]){
        [gm changeCoins:-upgradeCost];
        [[GameManager sharedGameManager] updateCoinLabel];
        _multiplierLabel.string = [NSString stringWithFormat:@"%ld/10", (long)[gm upgradeMultiplierLevel]];
        //[self updateCostLabels];
        _multiplierCostLabel.string = [NSString stringWithFormat:@"x%ld", gm.coinMultiplier*10];
        if([gm coinMultiplier] == [gm coinMultiplierMax]) {
            _coinmultButton.title = [NSString stringWithFormat:@"MAXED"];
            [_coinmultButton setEnabled:false];
            _multiplierCostLabel.string = [NSString stringWithFormat:@""];
            _coinmultCoin.visible = false;
        }
    }
}

@end
