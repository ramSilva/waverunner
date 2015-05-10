//
//  ChallengeItem.m
//  waverunner
//
//  Created by vieira on 10/05/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ChallengeItem.h"

@implementation ChallengeItem

- (void)didLoadFromCCB{
    self.physicsBody.collisionMask = @[@"player"];
    self.physicsBody.collisionType = @"challenge";
    self.physicsBody.sensor = TRUE;
    //[self initialDir];
}

@end
