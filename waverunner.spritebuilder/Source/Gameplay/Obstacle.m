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
    //[self.physicsBody applyTorque:10000.0f];
    type = @"";
    color = @"";
    dir = @"up";
    original_y = self.position.y;
    inc_x = 5.0f;
    inc_y = 5.0f;
    max_y = 75.0f;
}

- (void)move:(int)movement {
    switch(movement) {
        case 0:
            [self moveLeft];
            break;
        /*case 1:
            [self bounce];
            break;*/
    }
}

- (void)moveLeft {
    self.position = ccp(self.position.x - inc_x, self.position.y);
}

- (void)moveUp {
    if(self.position.y + inc_y < max_y) {
        self.position = ccp(self.position.x, self.position.y + inc_y);
        dir = @"up";
    } else {
        self.position = ccp(self.position.x, max_y);
        dir = @"down";
    }
}

- (void)moveDown {
    if(self.position.y - inc_y > original_y) {
        self.position = ccp(self.position.x, self.position.y - inc_y);
        dir = @"down";
    } else {
        self.position = ccp(self.position.x, original_y);
        dir = @"up";
    }
}

- (void)bounce {
    /*if([dir isEqualToString:@"up"]) {
        [self moveUp];
    } else if([dir isEqualToString:@"down"]) {
        [self moveDown];
    }
    
    [self moveLeft];*/
    [self.physicsBody applyAngularImpulse:135.0];
}

/*- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA obstacle:(CCNode *)nodeB{
    [self bounce];
    return TRUE;
}*/

@end
