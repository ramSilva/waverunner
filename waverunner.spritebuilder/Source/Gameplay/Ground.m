//
//  Ground.m
//  waverunner
//
//  Created by Waverunner on 29/03/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

//Converter nsarray para ns mutable e vice versa - se possivel usar CCARRAY - melhor performance
//@class em vez de import "class.h"
//#pragma mark para dividir metodos por grupos
//properties para criar gets e sets
#import "Ground.h"
#import "CCSprite.h"

@implementation Ground

@synthesize ground_gap;
@synthesize ready_for_content;
@synthesize number_coins;
@synthesize number_obstacles;

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

- (int) numberOfObstaclesInArray {
    return (int)obstacles.count;
}

- (int) numberOfCoinsInArray {
    return (int)coins.count;
}

- (void) addObstacle:(CCNode*)obs {
    [obstacles insertObject:obs atIndex:obstacles.count];
}

- (CCNode*) getFirstObstacle {
    return [obstacles objectAtIndex:0];
}

- (CCNode*) getLastObstacle {
    return [obstacles objectAtIndex:(obstacles.count - 1)];
}

- (void) updateObstaclePosition:(CCNode*)obs {
    [obstacles removeObjectAtIndex:0];
    [self addObstacle :obs];
}

- (void) addCoin:(CCNode*)coin {
    [coins insertObject:coin atIndex:coins.count];
}

- (CCNode*) getFirstCoin {
    CCNode* c = [coins objectAtIndex:0];
    
    c.visible = YES;
    
    return c;
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
    
    if(player_x > (x + width) + (GROUND_BLOCKS_DISTANCE * width)) {
        self.position = ccp(node2_x + node2_width - 1, original_y);
        [self insertGap :cracked];
        ready_for_content = true;
    }
}

@end

