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
    self.physicsBody.collisionType = @"coin";
    self.physicsBody.sensor = TRUE;
    [self initialDir];
}

-(void)initialDir {
    if(self.position.y >= 150.0f) {
        dir = @"up";
    } else {
        dir = @"down";
    }
}

- (void)move:(int)movement {
    switch(movement) {
        case 0:
            [self moveUpAndDown];
            break;
        case 1:
            [self moveDiagonalUpAndDown];
            break;
    }
}

- (void)moveDiagonalUpAndDown {
    if([dir isEqualToString:@"up"]) {
        [self moveUpAndLeft];
    }
    
    if([dir isEqualToString:@"down"]) {
        [self moveDownAndRight];
    }
}

- (void)moveUpAndDown {
    if([dir isEqualToString:@"up"]) {
        [self moveUp];
    }
    
    if([dir isEqualToString:@"down"]) {
        [self moveDown];
    }
}

- (void)moveUpAndLeft {
    [self moveUp];
    [self moveLeft];
}

- (void)moveDownAndRight {
    [self moveDown];
    [self moveRight];
}

- (void)moveLeft {
    self.position = ccp(self.position.x - INC_X, self.position.y);
}

- (void)moveRight {
    if(self.position.x + INC_X < max_x) {
        self.position = ccp(self.position.x + INC_X, self.position.y);
    } else {
        self.position = ccp(max_x, self.position.y);
        
    }
}

- (void)moveUp {
    if(self.position.y + INC_Y < MAX_Y) {
        self.position = ccp(self.position.x, self.position.y + INC_Y);
        dir = @"up";
    } else {
        self.position = ccp(self.position.x, MAX_Y);
        dir = @"down";
    }
}

- (void)moveDown {
    if(self.position.y - INC_Y > MIN_Y) {
        self.position = ccp(self.position.x, self.position.y - INC_Y);
        dir = @"down";
    } else {
        self.position = ccp(self.position.x, MIN_Y);
        dir = @"up";
    }
}

- (void)setMaxX:(float)x {
    max_x = x;
}

@end
