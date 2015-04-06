//
//  Coin.m
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Coin.h"

@implementation Coin

- (void)didLoadFromCCB{
    self.physicsBody.collisionMask = @[@"player"];
    //BUG: When player collides with a coin, the coin gets deleted and what we want is to make the coin disappear!
    self.physicsBody.collisionType = @"coin";
    self.physicsBody.sensor = TRUE;
}

@end
