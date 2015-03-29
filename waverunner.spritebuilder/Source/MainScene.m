#import "MainScene.h"

@implementation MainScene

- (void)play{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameplayScene"]];
}

@end
