#ifndef __WorldScene_H__
#define __WorldScene_H__

#include "CommonHead.h"
#include "TouchDelegateView.hpp"
#include "TouchUI.h"
#include "Player.hpp"

class WorldScene :public cocos2d::Layer
,public TouchDelegate
,public UIDelegate
{
public:
    WorldScene();
    ~WorldScene();
    static cocos2d::Scene* createScene();
    virtual bool init();
    
    // implement the "static create()" method manually
    CREATE_FUNC(WorldScene);
    
    void onEnter();
    void onExit();
protected:
    //delegate method
    void TapView(Touch* pTouch);
    void OnTouchUIRelease(Ref *target,SEL_CallFunc func);
private:
    TMXTiledMap* _map;
    map<int,Role*> m_RoleMap;
    TouchDelegateView* m_touchDelegateView;
};

#endif // __WorldScene_H__
