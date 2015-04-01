//
//  GameOver.m
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "CCNode.h"

@implementation GameOver

- (void)didLoadFromCCB{
    self.physicsBody.collisionMask = @[@"player"];
    self.physicsBody.collisionType = @"gameOver";
    self.physicsBody.sensor = TRUE;
}

@end
