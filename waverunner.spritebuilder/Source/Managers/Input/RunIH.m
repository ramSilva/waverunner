//
//  RunIH.m
//  waverunner
//
//  Created by Student on 06/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "RunIH.h"

@implementation RunIH

-(void) initialize: (Player*) player{
    [super initialize:player];
}


-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    [_player jump];
}

@end
