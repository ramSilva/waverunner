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
#import "GameplayScene.h"
#import "Player.h"
#import "LevelGenerator.h"

@implementation TutorialManager


- (void)didLoadFromCCB{
    //[[[CCDirector sharedDirector] scheduler]setTimeScale:0.0f];
    _tutorialRunning.visible = _tutorialDoubleJump.visible = _tutorialPreWallJump.visible = _tutorialWallJump.visible = _tutorialSecondWallJump.visible = false;
    _gm = [GameManager sharedGameManager];
    _gm.tutorialManager = self;
}

-(void)startTutorial{
    self.useTutorial = true;
    [[[CCDirector sharedDirector] scheduler]setTimeScale:0.1f];
    //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 0.1f];
    //[self removeChild:_tutorialRequest cleanup:true];
    _tutorialRequest.visible = false;
    [GameManager sharedGameManager].useTutorial = true;
    _tutorialRunning.visible = true;
    _part1Tutorial = true;
}

-(void)skipTutorial{
    self.useTutorial = false;
    [[[CCDirector sharedDirector] scheduler]setTimeScale:1.0f];
    //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 1.0f];
    [self removeChild:_tutorialRequest cleanup:true];
    [GameManager sharedGameManager].useTutorial = false;
}

-(void)touchDetected{
    if (!_useTutorial)return;
    
    if (_part1Tutorial) {
        if(_tutorialRunning.visible){
            _tutorialRunning.visible = false;
            [[[CCDirector sharedDirector] scheduler]setTimeScale:0.5f];
           // [[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 0.5f];
        }
    }
    else{
        if (_tutorialWallJump.visible) {
            //_tutorialWallJump.visible = false;
            [[CCDirector sharedDirector] resume];
            [[[CCDirector sharedDirector] scheduler]setTimeScale:1];
            //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 1.0f];
        }
        else if (_tutorialSecondWallJump.visible){
            [[[CCDirector sharedDirector] scheduler]setTimeScale:1];
            //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 1.0f];
            _tutorialSecondWallJump.visible = false;
            _useTutorial = false;
        }
    }
}

- (void)touchedGroundPart1 {
    if (!_useTutorial)return;

    if(!_tutorialRunning.visible && !_tutorialRequest.visible){
        _tutorialDoubleJump.visible = true;
        [[[CCDirector sharedDirector] scheduler]setTimeScale:0.1f];
        //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 0.1f];
    }
}

-(void)touchedGround{
    if (!_useTutorial)return;

    if (_part1Tutorial) {
        [self touchedGroundPart1];
    }
}

- (void)doubleJumpPart1 {
    if (!_useTutorial)return;

        if(_tutorialDoubleJump.visible){
            _tutorialDoubleJump.visible = false;
            [[[CCDirector sharedDirector] scheduler]setTimeScale:0.5f];
            //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 0.5f];
            _part1Tutorial = false;
            [_gm.player.GS wallMode];
            _tutorialPreWallJump.visible = true;
        }
}

-(void)doubleJump{
    if (!_useTutorial)return;

    if (_part1Tutorial) {
        [self doubleJumpPart1];
    }
}

-(void)wallCollision{
    if (!_useTutorial)return;

    if (!_tutorialWallJump.visible) {
        /*[[[CCDirector sharedDirector] scheduler]setTimeScale:0.01f];
        //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 0.01f];*/
        //[[CCDirector sharedDirector] pause];
        _tutorialWallJump.visible = true;
        _tutorialPreWallJump.visible = false;
    }
    else{
        [[[CCDirector sharedDirector] scheduler]setTimeScale:0.5f];
        //[[[CCDirector sharedDirector] scheduler]setFixedUpdateInterval: _gm.player.fixedUpdateTimer * 0.2f];
        _tutorialWallJump.visible = false;
        _tutorialSecondWallJump.visible = true;
    }
    
}

@end
