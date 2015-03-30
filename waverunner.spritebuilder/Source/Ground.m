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
    ground_gap = false;
    number_obstacles = 0;
    number_coins = 0;
    original_y = self.position.y;
    ready_for_content = false;
    obstacles = [[NSMutableArray alloc] init];
    coins = [[NSMutableArray alloc] init];
}

- (bool) hasGap {
    return ground_gap;
}

- (bool) isReadyForContent {
    return ready_for_content;
}

- (void) setReadyForContent:(bool)state {
    ready_for_content = state;
}

- (int) numberOfObstaclesInArray {
    return (int)obstacles.count;
}

- (int) numberOfCoinsInArray {
    return (int)coins.count;
}

- (void) setNumberOfObstacles:(int)number {
    number_obstacles = number;
}

- (void) setNumberOfCoins:(int)number {
    number_coins = number;
}

- (int) numberOfObstacles {
    return number_obstacles;
}

- (int) numberOfCoins {
    return number_coins;
}

- (void) addObstacle:(CCNode*)obs {
    [obstacles insertObject:obs atIndex:obstacles.count];
}

- (CCNode*) getFirstObstacle {
    return [obstacles objectAtIndex:0];
}

- (void) updateObstaclePosition:(CCNode*)obs {
    [obstacles removeObjectAtIndex:0];
    [self addObstacle :obs];
}

- (void) addCoin:(CCNode*)coin {
    [coins insertObject:coin atIndex:coins.count];
}

- (CCNode*) getFirstCoin {
    return [coins objectAtIndex:0];
}

- (void) updateCoinPosition:(CCNode*)coin {
    [coins removeObjectAtIndex:0];
    [self addCoin :coin];
}

- (NSMutableArray*) getObstacles {
    return obstacles;
}

- (void) insertGap:(Ground*)cracked {
    ground_gap = false;
    
    if (drand48() < CHANCE_GAP) {
        cracked.position = ccp(self.position.x, self.position.y);
        self.position = ccp(self.position.x, self.position.y - NOT_VISIBLE_IN_SCREEN);
        ground_gap = true;
    }
}

- (void) updatePosition:(CCNode*)player :(Ground*)node2 :(Ground*)cracked{
    float player_x = player.position.x;
    float x = self.position.x;
    float width = self.boundingBox.size.width;
    float node2_x = node2.position.x;
    float node2_width = node2.boundingBox.size.width;
    
    if(player_x > (x + (GROUND_BLOCKS_DISTANCE * width))) {
        self.position = ccp(node2_x + node2_width - 1, original_y);
        [self insertGap :cracked];
        ready_for_content = true;
    }
}

@end

