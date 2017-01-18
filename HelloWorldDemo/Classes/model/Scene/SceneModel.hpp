//
//  SceneModel.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/18.
//
//

#ifndef SceneModel_hpp
#define SceneModel_hpp

#include "CommonHead.h"
#include "TouchUI.h"
#include "Player.hpp"

class SceneModel :public cocos2d::Layer
,public UIDelegate
{
public:
    SceneModel(){};
    ~SceneModel(){};
    
    static cocos2d::Scene* createScene();
    virtual bool initWithTiledName(string tiledName);
    SceneModel* createWithTiledName(string tiledName);
    
    virtual void onEnter();
    virtual void onExit();
protected:
    //delegate method
    virtual void OnTouchUIRelease(Ref *target,SEL_CallFunc func){};
    TMXTiledMap* _map;
    map<int,Role*> m_RoleMap;
};

#endif /* SceneModel_hpp */
