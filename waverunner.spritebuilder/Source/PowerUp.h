//
//  PowerUp.h
//  waverunner
//
//  Created by Waverunner on 13/05/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "GameplayScene.h"

@interface PowerUp : CCSprite{
    CCNode *_shieldButton, *_slowMotionButton;
    GameplayScene *_GS;
}

-(void) enablePowerButton:(BOOL)value :(NSInteger)powerUpType;

-(void) setGameplayScene:(GameplayScene*) gs;
@end
