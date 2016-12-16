#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__

#include "CommonHead.h"
#include "TouchDelegateView.hpp"

class HelloWorld :
public cocos2d::Layer,
public TouchDelegate
{
public:
    static cocos2d::Scene* createScene();

    virtual bool init();
    
    // a selector callback
    void menuCloseCallback(cocos2d::Ref* pSender);
    
    // implement the "static create()" method manually
    CREATE_FUNC(HelloWorld);
    
    void onEnter();
    void onExit();
    
//    bool onTouchBegan(Touch *touch, Event *unused_event);
//    void onTouchMoved(Touch *touch, Event *unused_event);
//    void onTouchEnded(Touch *touch, Event *unused_event);
    
    void TapView(Touch* pTouch);
private:
    TMXTiledMap* _map;
    
    TouchDelegateView* m_touchDelegateView;
};

#endif // __HELLOWORLD_SCENE_H__
