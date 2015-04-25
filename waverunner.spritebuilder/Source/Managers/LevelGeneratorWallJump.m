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
        } else {
            CCNode* last_wall = [walls objectAtIndex:walls.count - 1];

            if(walls.count % 2 == 0) {
                wall.position = ccp(last_wall.position.x - distance_between_walls, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
            } else {
                wall.position = ccp(last_wall.position.x + distance_between_walls, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
            }
        }
        
        [_wallNode addChild:wall];
        [walls insertObject:wall atIndex:walls.count];
    }
    
    [self insertLastWallJump];
}

- (void) updateLevel {
     if (!wallBuilt) {
        [self buildWallJump];
        wallBuilt = true;
    }
}

-(void)setScrollMode {
    
    _player.physicsBody.velocity = ccp(0, 0);
    
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
