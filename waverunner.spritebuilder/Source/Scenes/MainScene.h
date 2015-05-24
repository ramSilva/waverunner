@class GameManager;

@interface MainScene : CCNode{
    CCLabelTTF* _coinLabel;
    CCLabelTTF* _highscoreLabel;
    GameManager *_gameManager;
    CCNode* _background;
}

@end
