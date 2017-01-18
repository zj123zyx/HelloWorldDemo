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

enum SceneType{
    SceneType_NULL=0,
    SceneType_WORLD,
    SceneType_HOURSE
};

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
    
    SceneType m_sceneType;
protected:
    //delegate method
    virtual void OnTouchUIRelease(Ref *target,SEL_CallFunc func){};
    
    virtual void addRoles();
    TMXTiledMap* _map;
    map<int,Role*> m_RoleMap;
};

#endif /* SceneModel_hpp */
