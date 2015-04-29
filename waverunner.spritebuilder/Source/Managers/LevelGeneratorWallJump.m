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
    
    for(int i = 0; i < numberOfWalls; i++) {
        CCNode* wall = (CCNode*)[CCBReader load:@"WallJump/Wall"];
        float wall_pos_x = 0.0f;
        float wall_pos_y = 0.0f;
        float wall_height = 0.0f;
        float distance_between_walls;
        float spawn_posx;
        float spawn_posy;
        
        if(i % 2 == 0) {
            distance_between_walls = MIN_DISTANCE_WALLS + (drand48() * MAX_DISTANCE_WALLS / 2);
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
            spawn_posx = wall.position.x + 100.0f;
            spawn_posy = wall.position.y + (wall.boundingBox.size.height / 2);
            [self insertSpawner :spawn_posx :spawn_posy :distance_between_walls];
        } else {
            CCNode* last_wall = [walls objectAtIndex:walls.count - 1];

            if(walls.count % 2 == 0) {
                wall.position = ccp(last_wall.position.x - distance_between_walls, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
                spawn_posx = wall.position.x + 100.0f;
                spawn_posy = wall.position.y + (wall.boundingBox.size.height / 2);
            } else {
                wall.position = ccp(last_wall.position.x + distance_between_walls, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
                spawn_posx = wall.position.x - 100.0f;
                spawn_posy = wall.position.y + (wall.boundingBox.size.height / 2);
            }
            
            [self insertSpawner :spawn_posx :spawn_posy :distance_between_walls];
        }
        
        [_wallNode addChild:wall];
        [walls insertObject:wall atIndex:walls.count];
    }
    
    [self insertLastWallJump];
}

- (void) insertSpawner :(float)posx :(float)posy :(float)dimx {
    CCNode* spawner = (CCNode*)[CCBReader load:@"Falling_Obstacle"];
    //NSArray* spawner_pos = [NSArray arrayWithObjects: [NSNumber numberWithFloat:posx], [NSNumber numberWithFloat:posy], nil];
    
    spawner.position = ccp(posx, posy);
    [spawners addObject:spawner];
    //[_wallNode addChild:spawner];
}

- (void) updateLevel {
    if (!wallBuilt) {
        [self buildWallJump];
        wallBuilt = true;
    }
    
    if(spawners.count > 0) {
        CCNode* spawner = [spawners objectAtIndex:0];
        CGSize s = [CCDirector sharedDirector].viewSize;
        
        //printf("i: %d\n", i);
        //printf("pos_X: %f & pos_Y: %f\n", spawner.position.x, spawner.position.y);
        CGPoint spawnerWorldPosition = [_wallNode convertToWorldSpace:spawner.position];
        printf("Wpos_X: %f & Wpos_Y: %f\n", spawnerWorldPosition.x, spawnerWorldPosition.y);
        printf("Wpos_Y: %f - half screen: %f\n", spawnerWorldPosition.x, (s.height));
        if(spawnerWorldPosition.y > s.height && obstacles.count == 0) {
            CCNode* obs = (CCNode*)[CCBReader load:@"Falling_Obstacle"];
            
            obs.position = ccp(spawner.position.x, spawner.position.y);
            [obstacles addObject:obs];
            [_wallNode addChild:obs];
            
            printf("ADDED: %d\n", (int)obstacles.count);
        } else {
            if(spawnerWorldPosition.y < s.height) {
                [spawners removeObject:spawner];
            }
        }
        //CCNode* obs = [obstacles objectAtIndex:i];
        
        //obs.position = ccp(obs.position.x, obs.position.y - 1.0f);
    }
    
    if(obstacles.count > 0) {
        CCNode* obs = [obstacles objectAtIndex:0];
        
        obs.position = ccp(obs.position.x, obs.position.y - 3.0f);
        CGPoint obsWorldPosition = [_wallNode convertToWorldSpace:obs.position];
        
        if(obsWorldPosition.y < 0.0f) {
            [obstacles removeObject:obs];
        }
    }
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
