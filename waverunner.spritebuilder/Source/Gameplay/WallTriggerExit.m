//
//  WallTriggerExit.m
//  waverunner
//
//  Created by vieira on 13/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WallTriggerExit.h"

@implementation WallTriggerExit


- (void)didLoadFromCCB{
    self.physicsBody.collisionMask = @[@"player"];
    self.physicsBody.collisionType = @"walltriggerexit";
    self.physicsBody.sensor = TRUE;
}

@end
