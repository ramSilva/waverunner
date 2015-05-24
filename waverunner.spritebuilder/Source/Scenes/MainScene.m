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
    _coinLabel.position = ccp(0.465f, 0.68f);
    
    p = _highscoreLabel.parent;
    _highscoreLabel = [_gameManager highscoreLabel];
    [_highscoreLabel removeFromParent];
    [p addChild:_highscoreLabel];
    _highscoreLabel.string = [NSString stringWithFormat:@"High Score: %ld", (long)_gameManager.highscore];
    [_highscoreLabel setOutlineColor:[CCColor blackColor]];
    _highscoreLabel.anchorPoint = ccp(0.0f, 0.5f);
    
    [_gameManager writeLog];
    [_gameManager loadLog];
    
    float screen_width = [[UIScreen mainScreen] bounds].size.width;
    float screen_height = [[UIScreen mainScreen] bounds].size.height;
    
    float bg_width = _background.contentSize.width;
    float bg_height = _background.contentSize.height;
    
    _background.scaleX = screen_width / bg_width;
    _background.scaleY = screen_height / bg_height;
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
