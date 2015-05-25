//
//  InputHandler.h
//  waverunner
//
//  Created by Student on 06/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class GameManager;

#import "Player.h"

@interface InputHandler : CCNode {

    Player *_player;
    
}

-(void) initialize:(Player*)player;

@end
