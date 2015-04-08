//
//  Obstacle.m
//  waverunner
//
//  Created by Waverunner on 01/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle

@synthesize moving;

- (void)didLoadFromCCB{
    self.physicsBody.collisionMask = @[@"player"];
    self.physicsBody.collisionType = @"obstacle";
    self.physicsBody.sensor = TRUE;
    moving = false;
}

@end
