//
//  TestHouseScene.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#ifndef TestHouseScene_hpp
#define TestHouseScene_hpp

#include "CommonHead.h"
#include "TouchUI.h"
#include "Player.hpp"

class TestHouseScene :public cocos2d::Layer
,public UIDelegate
{
public:
    TestHouseScene();
    ~TestHouseScene();
    
    static cocos2d::Scene* createScene();
    virtual bool init();
    CREATE_FUNC(TestHouseScene);
    
    void onEnter();
    void onExit();
protected:
    //delegate method
    void OnTouchUIRelease(Ref *target,SEL_CallFunc func){};
private:
    TMXTiledMap* _map;
//    map<int,Role*> m_RoleMap;
};

#endif /* TestHouseScene_hpp */
