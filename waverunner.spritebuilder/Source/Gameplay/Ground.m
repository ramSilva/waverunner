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
#import "Obstacle.h"

@implementation Ground

@synthesize ground_gap;
@synthesize ready_for_content;
@synthesize number_coins;
@synthesize number_obstacles;
@synthesize next_ground;
@synthesize any_moving_obstacles;

- (void)didLoadFromCCB{
    self.physicsBody.collisionType = @"ground";
    ground_gap = false;
    number_obstacles = 0;
    number_coins = 0;
    any_moving_obstacles = false;
    original_y = self.position.y;
    ready_for_content = false;
    static_obstacles = [[NSMutableArray alloc] init];
    moving_obstacles = [[NSMutableArray alloc] init];
    coins = [[NSMutableArray alloc] init];
    next_ground = false;
    matching_obs_index = -1;
}

- (int) numberOfStaticObstaclesInArray {
    return (int)static_obstacles.count;
}

- (int) numberOfMovingObstaclesInArray {
    return (int)moving_obstacles.count;
}

- (int) numberOfCoinsInArray {
    return (int)coins.count;
}

- (void) addStaticObstacle:(CCNode*)obs {
    any_moving_obstacles = false;
    [static_obstacles insertObject:obs atIndex:static_obstacles.count];
}

- (CCNode*) getFirstStaticObstacle:(NSString*)type :(NSString*)color {
    matching_obs_index = -1;
    for(int i = 0; i < static_obstacles.count - 1; i++) {
        Obstacle* obs = [static_obstacles objectAtIndex:i];
        
        if([obs.type isEqualToString:type] && [obs.color isEqualToString:color]) {
            matching_obs_index = i;
            return obs;
        }
    }
    
    return nil;
}

- (CCNode*) getLastStaticObstacle {
    return [static_obstacles objectAtIndex:(static_obstacles.count - 1)];
}

- (void) updateStaticObstaclePosition:(CCNode*)obs {
    [static_obstacles removeObjectAtIndex:matching_obs_index];
    [self addStaticObstacle :obs];
}

- (void) addMovingObstacle:(CCNode*)obs {
    any_moving_obstacles = true;
    [moving_obstacles insertObject:obs atIndex:moving_obstacles.count];
}

- (CCNode*) getFirstMovingObstacle {
    return [moving_obstacles objectAtIndex:0];
}

- (CCNode*) getLastMovingObstacle {
    return [moving_obstacles objectAtIndex:(moving_obstacles.count - 1)];
}

- (void) updateMovingObstaclePosition:(CCNode*)obs {
    [moving_obstacles removeObjectAtIndex:0];
    [self addMovingObstacle :obs];
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

- (NSMutableArray*) getStaticObstacles {
    return static_obstacles;
}

- (NSMutableArray*) getMovingObstacles {
    return moving_obstacles;
}

- (void) insertGap:(Ground*)cracked {
    ground_gap = false;
    
    if (drand48() < CHANCE_GAP) {
        cracked.position = ccp(self.position.x, self.position.y);
        self.position = ccp(self.position.x, self.position.y - NOT_VISIBLE_IN_SCREEN);
        ground_gap = true;
        number_obstacles = 0;
    }
}

- (void) updatePosition:(CCNode*)player :(Ground*)node2 :(Ground*)cracked{
    float player_x = player.position.x;
    float x = self.position.x;
    float width = self.boundingBox.size.width;
    float node2_x = node2.position.x;
    float node2_width = node2.boundingBox.size.width;
    //next_ground = false;
    if(player_x > (x + width) + (GROUND_BLOCKS_DISTANCE * width)) {
        self.position = ccp(node2_x + node2_width - 1, original_y);
        [self insertGap :cracked];
        ready_for_content = true;
        next_ground = true;
    }
}

- (void)update:(CCTime)delta {
    for(int i = 0; i < moving_obstacles.count; i++) {
        Obstacle* obs = [moving_obstacles objectAtIndex:i];
        
        //Condition that prevents moving obstacle to keep moving infinitely
        if(obs.position.x > self.position.x - self.boundingBox.size.width) {
            [obs move];
        }
    }
}

@end

