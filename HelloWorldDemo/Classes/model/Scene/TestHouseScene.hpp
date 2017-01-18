//
//  TestHouseScene.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#ifndef TestHouseScene_hpp
#define TestHouseScene_hpp

#include "SceneModel.hpp"

class TestHouseScene :public SceneModel
{
public:
    TestHouseScene(){};
    ~TestHouseScene(){};
    
    static cocos2d::Scene* createScene();
    virtual bool init();
    CREATE_FUNC(TestHouseScene);
    
    virtual void onEnter();
    virtual void onExit();
protected:
    virtual void addRoles();
};

#endif /* TestHouseScene_hpp */
