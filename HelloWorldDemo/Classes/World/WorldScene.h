#ifndef __WorldScene_H__
#define __WorldScene_H__

#include "CommonHead.h"
#include "TouchDelegateView.hpp"

class WorldScene :
public cocos2d::Layer,
public TouchDelegate
{
public:
    static cocos2d::Scene* createScene();
    virtual bool init();
    
    // implement the "static create()" method manually
    CREATE_FUNC(WorldScene);
    
    void onEnter();
    void onExit();
    
    void TapView(Touch* pTouch);
private:
    TMXTiledMap* _map;
    
    TouchDelegateView* m_touchDelegateView;
};

#endif // __WorldScene_H__
