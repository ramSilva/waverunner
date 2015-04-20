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
    
    //_nextGroundIndex = 3;
    
    //Initialize seed
    //srand48(arc4random());
    
    //[self initContent];
    //_wallNode.position = ccp(-500, -500);
    //[pn addChild:_wallNode];
}



-(void)setScrollMode{
    _player.physicsBody.velocity = ccp(0, 0);
    
    CCActionMoveBy *_moveby = [CCActionMoveBy actionWithDuration:0 position:ccp(-1800, 0)];
    [_wallNode runAction:_moveby];
    
    CCActionMoveTo *_movet = [CCActionMoveTo actionWithDuration:1.2 position:ccp(_physicsNode.position.x, 0)];
    [_physicsNode runAction:_movet];
    
    CGPoint nodeposition = [_physicsNode convertToNodeSpace:ccp(218,70)];
    CCActionMoveTo *_move2 = [CCActionMoveTo actionWithDuration:1 position:nodeposition];
    [_player runAction:_move2];
}

@end
