//
//  TutorialManager.m
//  waverunner
//
//  Created by vieira on 24/05/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TutorialManager.h"
#import "CCDirector_Private.h"
#import "GameManager.h"

@implementation TutorialManager


- (void)didLoadFromCCB{
    //[[[CCDirector sharedDirector] scheduler]setTimeScale:0.0f];
}

-(void)startTutorial{
    self.useTutorial = true;
    [[[CCDirector sharedDirector] scheduler]setTimeScale:1.0f];
    [self removeChild:_tutorialRequest cleanup:true];
    [GameManager sharedGameManager].useTutorial = true;
}

-(void)skipTutorial{
    self.useTutorial = false;
    [[[CCDirector sharedDirector] scheduler]setTimeScale:1.0f];
    [self removeChild:_tutorialRequest cleanup:true];
    [GameManager sharedGameManager].useTutorial = false;
}
@end
