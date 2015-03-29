//
//  Ground.m
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Ground.h"

@implementation Ground

- (void)didLoadFromCCB{
    self.physicsBody.collisionType = @"ground";
}

@end
