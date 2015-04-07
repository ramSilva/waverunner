//
//  WallTrigger.m
//  waverunner
//
//  Created by vieira on 07/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WallTrigger.h"

@implementation WallTrigger

- (void)didLoadFromCCB{
    self.physicsBody.collisionMask = @[@"player"];
    self.physicsBody.collisionType = @"walltrigger";
    self.physicsBody.sensor = TRUE;
}

@end
