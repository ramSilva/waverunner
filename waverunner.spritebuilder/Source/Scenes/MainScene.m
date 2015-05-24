#import "MainScene.h"
#import "GameManager.h"
@implementation MainScene

- (void)didLoadFromCCB{
    _gameManager = [GameManager sharedGameManager];
    [_gameManager save];
    
    [_gameManager updateCoinLabel];
    CCNode* p = _coinLabel.parent;
    _coinLabel = [_gameManager coinLabel];
    [_coinLabel removeFromParent];
    [p addChild:_coinLabel];
    
    p = _highscoreLabel.parent;
    _highscoreLabel = [_gameManager highscoreLabel];
    [_highscoreLabel removeFromParent];
    [p addChild:_highscoreLabel];
    _highscoreLabel.string = [NSString stringWithFormat:@"High Score: %ld", (long)_gameManager.highscore];
    
    [_gameManager writeLog];
    [_gameManager loadLog];
    
}

- (void)play{
    _gameManager.runningMode = true;
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameplayScene"]];
}

- (void)shop{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Shop"]];
}

- (void)reset{
    [[GameManager sharedGameManager] deleteDocument];
}

@end
