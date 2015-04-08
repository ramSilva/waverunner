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
    
    _speedLabel.string = [NSString stringWithFormat:@"Speed: %ld/%ld", [[GameManager sharedGameManager] speedLevel], [[GameManager sharedGameManager] speedLevelMax]];
    _jumpLabel.string = [NSString stringWithFormat:@"Jump: %ld/%ld", [[GameManager sharedGameManager] jumpLevel], [[GameManager sharedGameManager] jumpLevelMax]];
}

- (void)menu{
    [[GameManager sharedGameManager] save];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

- (void)upgradeSpeed{
    GameManager *gm = [GameManager sharedGameManager];
    NSInteger upgradeCost = 1;//[gm getSpeedLevel]*10;
    if([gm coins] >= upgradeCost && [gm speedLevel] < [gm speedLevelMax] ){
        [gm changeCoins:-upgradeCost];
        [[GameManager sharedGameManager] updateCoinLabel];
        _speedLabel.string = [NSString stringWithFormat:@"Speed: %ld/10", [gm upgradeSpeedLevel]];
        
    }
}

- (void)upgradeJump{
    GameManager *gm = [GameManager sharedGameManager];
    NSInteger upgradeCost = 1;//[gm getJumpLevel]*10;
    if([gm coins] >= upgradeCost && [gm jumpLevel] < [gm jumpLevelMax]){
        [gm changeCoins:-upgradeCost];
        [[GameManager sharedGameManager] updateCoinLabel];
        _jumpLabel.string = [NSString stringWithFormat:@"Jump: %ld/10", [gm upgradeJumpLevel]];
    }
}
@end
