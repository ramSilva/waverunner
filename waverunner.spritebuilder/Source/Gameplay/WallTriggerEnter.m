//
//  WallTrigger.m
//  waverunner
//
//  Created by vieira on 07/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WallTriggerEnter.h"

@implementation WallTriggerEnter

- (void)didLoadFromCCB{
    self.physicsBody.collisionMask = @[@"player"];
    self.physicsBody.collisionType = @"walltriggerenter";
    self.physicsBody.sensor = TRUE;
}

@end
