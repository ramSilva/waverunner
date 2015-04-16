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
#import "Coin.h"

@implementation Ground

@synthesize chance_gap;
@synthesize ground_gap;
@synthesize ready_for_content;
@synthesize number_coins;
@synthesize number_obstacles;
@synthesize next_ground;
@synthesize any_moving_obstacles;
@synthesize any_moving_coins;

- (void)didLoadFromCCB{
    self.physicsBody.collisionType = @"ground";
    chance_gap = 0.1f;
    ground_gap = false;
    number_obstacles = 0;
    number_coins = 0;
    any_moving_obstacles = false;
    any_moving_coins = false;
    original_y = self.position.y;
    ready_for_content = false;
    static_obstacles = [[NSMutableArray alloc] init];
    moving_obstacles = [[NSMutableArray alloc] init];
    static_coins = [[NSMutableArray alloc] init];
    moving_coins = [[NSMutableArray alloc] init];
    next_ground = false;
    matching_obs_index = -1;
    coin_pattern = (arc4random() % 2);
    obs_pattern = (arc4random() % 1);
}

- (int) numberOfStaticObstaclesInArray {
    return (int)static_obstacles.count;
}

- (int) numberOfMovingObstaclesInArray {
    return (int)moving_obstacles.count;
}

- (int) numberOfStaticCoinsInArray {
    return (int)static_coins.count;
}

- (int) numberOfMovingCoinsInArray {
    return (int)moving_coins.count;
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

- (void) addStaticCoin:(CCNode*)coin {
    any_moving_coins = false;
    [static_coins insertObject:coin atIndex:static_coins.count];
}

- (CCNode*) getFirstStaticCoin {
    CCNode* c = [static_coins objectAtIndex:0];
    
    c.visible = YES;
    
    return c;
}

- (void) updateStaticCoinPosition:(CCNode*)coin {
    [static_coins removeObjectAtIndex:0];
    [self addStaticCoin :coin];
}

- (void) addMovingCoin:(Coin*)coin {
    any_moving_coins = true;
    [coin setMaxX :coin.position.x];
    [moving_coins insertObject:coin atIndex:moving_coins.count];
}

- (Coin*) getFirstMovingCoin {
    Coin* c = [moving_coins objectAtIndex:0];
    
    c.visible = YES;
    
    return c;
}

- (void) updateMovingCoinPosition:(CCNode*)coin {
    [moving_coins removeObjectAtIndex:0];
    [self addMovingCoin :coin];
}

- (NSMutableArray*) getStaticObstacles {
    return static_obstacles;
}

- (NSMutableArray*) getMovingObstacles {
    return moving_obstacles;
}

- (void) insertGap:(Ground*)cracked {
    ground_gap = false;
    
    if (drand48() < chance_gap) {
        cracked.position = ccp(self.position.x, self.position.y);
        self.position = ccp(self.position.x, self.position.y - NOT_VISIBLE_IN_SCREEN);
        ground_gap = true;
        number_obstacles = 0;
    }
}

- (void) updatePosition:(CCNode*)player :(int)num_grounds :(Ground*)cracked {
    // get the world position of the ground
    CGPoint groundWorldPosition = [self.parent convertToWorldSpace:self.position];
    
    if (groundWorldPosition.x <= (-1 * self.contentSize.width)) {
        self.position = ccp(self.position.x + (num_grounds * self.contentSize.width) - num_grounds, original_y);
        [self insertGap :cracked];
        ready_for_content = true;
        coin_pattern = (arc4random() % 2);
        obs_pattern = (arc4random() % 1);
        next_ground = true;
    }
}

- (void) moveAllObstacles {
    if(any_moving_obstacles) {
        for(int i = ((int)moving_obstacles.count - number_obstacles); i < moving_obstacles.count; i++) {
            Obstacle* obs = [moving_obstacles objectAtIndex:i];
            
            if(obs.position.x > self.position.x - self.boundingBox.size.width) {
                [obs move :obs_pattern];
            }
        }
    }
}

- (void) moveAllCoins {
    if(any_moving_coins) {
        for(int i = ((int)moving_coins.count - number_coins); i < moving_coins.count; i++) {
            Coin* coin = [moving_coins objectAtIndex:i];
            
            //If not visible, coin doesn't move
            if(coin.visible == YES && coin.position.x > self.position.x - self.boundingBox.size.width) {
                [coin move :coin_pattern];
            }
        }
    }
}

@end

