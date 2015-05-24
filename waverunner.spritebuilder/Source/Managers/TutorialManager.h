//
//  TutorialManager.h
//  waverunner
//
//  Created by vieira on 24/05/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@class GameManager;

#import "CCNode.h"

@interface TutorialManager : CCNode{
    BOOL _useTutorial;
    
    CCNode *_tutorialRequest;
}

@property (nonatomic, readwrite) BOOL useTutorial;

@end
