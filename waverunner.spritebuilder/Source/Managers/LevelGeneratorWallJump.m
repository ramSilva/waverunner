//
//  LevelGeneratorWallJump.m
//  waverunner
//
//  Created by vieira on 19/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelGeneratorWallJump.h"
#import "Ground.h"
#import "Player.h"
#import "Obstacle.h"
#import "Coin.h"

@implementation LevelGeneratorWallJump

-(void) initializeLevel:(NSArray*)g :(NSArray*)gc :(Player*)p :(CCPhysicsNode*)pn :(CCNode*) _wn{
    [super initializeLevel:g :gc :p :pn :_wn];
    
    wallBuilt = false;
    walls = [[NSMutableArray alloc] init];
    spawners = [[NSMutableArray alloc] init];
    obstacles = [[NSMutableArray alloc] init];
    wallJumpEnd = (CCNode*)[CCBReader load:@"WallJump/WallJumpTransitionEnd"];
}

- (void) insertLastWallJump {
    CCNode* last_wall = [walls objectAtIndex:walls.count - 1];
    
    wallJumpEnd.position = ccp(last_wall.position.x - MIN_DISTANCE_WALLS, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
    
    [_wallNode addChild:wallJumpEnd];
}

- (void) buildWallJump {
    int numberOfWalls = MIN_NUMBER_WALLS + 2 * (arc4random() % MAX_MULT_WALLS);
    NSMutableArray *indexes_citems = [[NSMutableArray alloc] init];
    
    //Select which walls are going to have challenge items
    if(numberOfWalls > 2) {
        NSMutableArray *all = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < numberOfWalls; i++) {
            [all addObject:[NSNumber numberWithInt:i]];
        }
        
        for (int i = 0; i < MAX_CHALLENGE_ITEMS; i++) {
            int all_index = arc4random() % (int)all.count;
            int citem_index = [[all objectAtIndex:all_index] intValue];
            
            [indexes_citems addObject:[NSNumber numberWithInt:citem_index]];
            [all removeObject:[NSNumber numberWithInt:citem_index]];
        }
    }
    
    for(int i = 0; i < numberOfWalls; i++) {
        CCNode* wall = (CCNode*)[CCBReader load:@"WallJump/Wall"];
        float wall_pos_x = 0.0f;
        float wall_pos_y = 0.0f;
        float wall_height = 0.0f;
        float distance_between_walls;
        float spawn_posx;
        float spawn_posy;
        float dist;
        
        if(i % 2 == 0) {
            distance_between_walls = MIN_DISTANCE_WALLS + (drand48() * (MAX_DISTANCE_WALLS - MIN_DISTANCE_WALLS));
        }
        
        wall.scaleX = -2.05;
        wall.scaleY = 19.82;
        
        if(walls.count == 0) {
            for(CCNode* childNode in _wallNode.children) {
                if([childNode.name isEqualToString:@"wall"]) {
                    wall_pos_x = childNode.position.x;
                    wall_pos_y = childNode.position.y;
                    wall_height = childNode.boundingBox.size.height;
                }
            }
            
            wall.position = ccp(wall_pos_x - distance_between_walls, wall_pos_y + (3 * wall_height / 4));
            spawn_posx = wall.position.x + wall.boundingBox.size.width / 2;
            spawn_posy = wall.position.y + (wall.boundingBox.size.height / 2);
            
            if (numberOfWalls > 2 && [indexes_citems containsObject:[NSNumber numberWithInt:i]]) {
                [self insertChallengeItems :spawn_posx :wall.position.y :wall.boundingBox.size.height :false];
            }
        } else {
            CCNode* last_wall = [walls objectAtIndex:walls.count - 1];

            if(walls.count % 2 == 0) {
                wall.position = ccp(last_wall.position.x - distance_between_walls, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
                spawn_posx = wall.position.x + wall.boundingBox.size.width / 2;
                spawn_posy = wall.position.y + (wall.boundingBox.size.height / 2);
                dist = distance_between_walls - wall.boundingBox.size.width;
                [self insertSpawner :spawn_posx :spawn_posy :dist :false];
                
                if (numberOfWalls > 2 && [indexes_citems containsObject:[NSNumber numberWithInt:i]]) {
                    [self insertChallengeItems :spawn_posx :wall.position.y :wall.boundingBox.size.height :false];
                }
            } else {
                wall.position = ccp(last_wall.position.x + distance_between_walls, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
                spawn_posx = wall.position.x - wall.boundingBox.size.width / 2;
                spawn_posy = wall.position.y + (wall.boundingBox.size.height / 2);
                dist = distance_between_walls - wall.boundingBox.size.width;
                [self insertSpawner :spawn_posx :spawn_posy :dist :true];
                
                if (numberOfWalls > 2 && [indexes_citems containsObject:[NSNumber numberWithInt:i]]) {
                    [self insertChallengeItems :spawn_posx :wall.position.y :wall.boundingBox.size.height :true];
                }
            }
        }
        
        [_wallNode addChild:wall];
        [walls insertObject:wall atIndex:walls.count];
    }
    
    [self insertLastWallJump];
}

- (void) insertSpawner :(float)posx :(float)posy :(float)dimx :(bool)right {
    CCNode* spawner = (CCNode*)[CCBReader load:@"Falling_Obstacle"];
    float x;
    float distance = dimx - spawner.boundingBox.size.width - 50.0f;
    
    if(right) {
        x = posx - (drand48() * distance);
    } else {
        x = posx + (drand48() * distance);
    }
    
    spawner.position = ccp(x , posy);
    [spawners addObject:spawner];
}

- (void) spawnObstacles {
    if(spawners.count > 0) {
        CCNode* spawner = [spawners objectAtIndex:0];
        CGSize s = [CCDirector sharedDirector].viewSize;
        
        CGPoint spawnerWorldPosition = [_wallNode convertToWorldSpace:spawner.position];

        if(spawnerWorldPosition.y > s.height && obstacles.count == 0) {
            CCNode* obs = (CCNode*)[CCBReader load:@"Falling_Obstacle"];
            
            obs.position = ccp(spawner.position.x, spawner.position.y);
            [obstacles addObject:obs];
            [_wallNode addChild:obs];
            
        } else {
            if(spawnerWorldPosition.y < s.height) {
                [spawners removeObject:spawner];
            }
        }
    }
}

- (void) insertChallengeItems :(float)posx :(float)posy :(float)dimy :(bool)right {
    CCNode* citem = (CCNode*)[CCBReader load:@"Challenge_Item"];
    float min_y = posy - (dimy / 2) + (citem.boundingBox.size.height / 2);
    float max_y = posy + (dimy / 2) - (citem.boundingBox.size.height / 2);
    float citem_posy = min_y + (drand48() * (max_y - min_y));
    float citem_posx;
    
    if(right) {
        citem_posx = posx - (citem.boundingBox.size.width / 2);
    } else {
        citem_posx = posx + (citem.boundingBox.size.width / 2);
    }
    
    citem.position = ccp(citem_posx, citem_posy);
    [_wallNode addChild:citem];
}

- (void) moveObstacles {
    if(obstacles.count > 0) {
        CCNode* obs = [obstacles objectAtIndex:0];
        
        obs.position = ccp(obs.position.x, obs.position.y - 3.0f);
        CGPoint obsWorldPosition = [_wallNode convertToWorldSpace:obs.position];
        
        if(obsWorldPosition.y < 0.0f) {
            [obstacles removeObject:obs];
        }
    }
}

- (void) updateLevel:(CCTime)delta {
    if (!wallBuilt) {
        [self buildWallJump];
        wallBuilt = true;
    }
    
    [self spawnObstacles];
    [self moveObstacles];
}

-(void)setScrollMode {
    [_player.physicsBody setVelocity:ccp(0, 0)];

    CCActionMoveBy *_moveby = [CCActionMoveBy actionWithDuration:0 position:ccp(-1800, 0)];
    [_wallNode runAction:_moveby];
    
    CCActionMoveTo *_movet = [CCActionMoveTo actionWithDuration:1.2 position:ccp(_physicsNode.position.x, 0)];
    [_physicsNode runAction:_movet];
    
    CGPoint nodeposition = [_physicsNode convertToNodeSpace:ccp(218,70)];
    CCActionMoveTo *_move2 = [CCActionMoveTo actionWithDuration:1 position:nodeposition];
    [_player runAction:_move2];
    
    //remove all objects except the 4 objects in WallTransitionStart
    for(int i = (int)_wallNode.children.count - 1; i > 4; i--) {
        CCNode* child = [_wallNode.children objectAtIndex:i];
        
        [_wallNode removeChild:child];
    }
}

@end
