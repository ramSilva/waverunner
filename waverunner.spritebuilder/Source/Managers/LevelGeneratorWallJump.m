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
    //_nextGroundIndex = 3;
    
    //Initialize seed
    //srand48(arc4random());
    
    //[self initContent];
    //_wallNode.position = ccp(-500, -500);
    //[pn addChild:_wallNode];
}

- (void) insertLastWallJump {
    CCNode* last_wall = [walls objectAtIndex:walls.count - 1];
    
    wallJumpEnd.position = ccp(last_wall.position.x - 200.0f, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
    
    [_physicsNode addChild:wallJumpEnd];
}

- (void) buildWallJump {
    int numberOfWalls = 2;
    
    for(int i = 0; i < numberOfWalls; i++) {
        CCNode* wall = (CCNode*)[CCBReader load:@"WallJump/Wall"];
        float wall_pos_x = 0.0f;
        float wall_pos_y = 0.0f;
        float wall_height = 0.0f;
        
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
            
            wall.position = ccp(_wallNode.position.x + (wall_pos_x - 200.0f), wall_pos_y + (3 * wall_height / 4));
        } else {
            CCNode* last_wall = [walls objectAtIndex:walls.count - 1];

            if(walls.count % 2 == 0) {
                wall.position = ccp(last_wall.position.x - 200.0f, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
            } else {
                wall.position = ccp(last_wall.position.x + 200.0f, last_wall.position.y + (3 * last_wall.boundingBox.size.height / 4));
            }
        }
        
        [_physicsNode addChild:wall];
        [walls insertObject:wall atIndex:walls.count];
    }
    
    [self insertLastWallJump];
}

- (void) updateLevel {
    /*if (!wallBuilt) {
        [self buildWallJump];
        wallBuilt = true;
    }*/
}

-(void)setScrollMode{
    _player.physicsBody.velocity = ccp(0, 0);
    
    CCActionMoveBy *_moveby = [CCActionMoveBy actionWithDuration:0 position:ccp(-1800, 0)];
    [_wallNode runAction:_moveby];
    
    /*for(int i = 0; i < walls.count; i++) {
        CCNode* w = [walls objectAtIndex:i];
        
        [w runAction:_moveby];
    }
    
    [wallJumpEnd runAction:_moveby];*/
    
    CCActionMoveTo *_movet = [CCActionMoveTo actionWithDuration:1.2 position:ccp(_physicsNode.position.x, 0)];
    [_physicsNode runAction:_movet];
    
    CGPoint nodeposition = [_physicsNode convertToNodeSpace:ccp(218,70)];
    CCActionMoveTo *_move2 = [CCActionMoveTo actionWithDuration:1 position:nodeposition];
    [_player runAction:_move2];
}

@end
