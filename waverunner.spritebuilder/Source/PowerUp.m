//
//  PowerUp.m
//  waverunner
//
//  Created by Waverunner on 13/05/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PowerUp.h"

@implementation PowerUp

- (void)didLoadFromCCB{
    _shieldButton.visible = _slowMotionButton.visible = false;
    
}

-(void)enablePowerButton:(BOOL)value :(NSInteger)powerUpType{
    if (value) {
        if (powerUpType == 0) {
            //CCLOG(@"slowmo button\n");
            _slowMotionButton.visible = true;
            _shieldButton.visible = false;
        }
        else if (powerUpType == 1){
            //CCLOG(@"shield button\n");
            _slowMotionButton.visible = false;
            _shieldButton.visible = true;
        }
    }
    else{
        //CCLOG(@"turn off 2 buttons\n");
        _slowMotionButton.visible = false;
        _shieldButton.visible = false;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //CCLOG(@"Animation did stop");
}

-(void) activatePowerUp{
    //CCLOG(@"LOLOLOLOL");
    [_GS activatePowerUp];
}

-(void)setGameplayScene:(GameplayScene*)gs{
    _GS = gs;
}
@end
