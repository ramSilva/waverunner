//
//  Shop.h
//  PowerupsTest
//
//  Created by Waverunner on 19/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameManager.h"

@interface Shop : CCNode{
    CCLabelTTF *_coinLabel;
    CCLabelTTF *_powerUpDurationLabel;
    CCLabelTTF *_resistanceLabel;
    CCLabelTTF *_multiplierLabel;
    CCLabelTTF *_powerUpDurationCostLabel;
    CCLabelTTF *_resistanceCostLabel;
    CCLabelTTF *_multiplierCostLabel;
    CCNode *_shop_bg;
    CCButton *_resistanceButton;
    CCButton *_powerupsButton;
    CCButton *_coinmultButton;
    CCNode *_resCoin;
    CCNode *_powerupsCoin;
    CCNode *_coinmultCoin;
}

-(void)updateCostLabels;

@end
