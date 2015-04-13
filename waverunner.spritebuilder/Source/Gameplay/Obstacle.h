//
//  Obstacle.h
//  waverunner
//
//  Created by Alexandre Freitas on 12/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class CCSprite;

@interface Obstacle : CCSprite

@property(nonatomic,readwrite) NSString* type;
@property(nonatomic,readwrite) NSString* color;

-(void)move;

@end
