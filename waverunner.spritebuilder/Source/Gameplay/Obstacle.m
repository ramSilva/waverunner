//
//  Obstacle.m
//  waverunner
//
//  Created by Alexandre Freitas on 12/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle

@synthesize type;
@synthesize color;

- (void)didLoadFromCCB {
    self.physicsBody.collisionMask = @[@"player"];
    self.physicsBody.collisionType = @"obstacle";
    self.physicsBody.sensor = TRUE;
    [self.physicsBody applyTorque:10000.0f];
    type = @"";
    color = @"";
}

- (void)move {
    self.position = ccp(self.position.x - 5.0f, self.position.y);
}

@end
