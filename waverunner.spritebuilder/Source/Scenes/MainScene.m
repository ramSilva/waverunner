#import "MainScene.h"
#import "GameManager.h"
@implementation MainScene

- (void)didLoadFromCCB{
    GameManager *_gameManager = [GameManager sharedGameManager];
    [_gameManager updateCoinLabel];
    CCNode* p = _coinLabel.parent;
    _coinLabel = [_gameManager coinLabel];
    [_coinLabel removeFromParent];
    [p addChild:_coinLabel];
    
}

- (void)play{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameplayScene"]];
}

- (void)shop{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Shop"]];
}

- (void)reset{
    [[GameManager sharedGameManager] deleteDocument];
}

@end
