//
//  SceneController.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#ifndef SceneController_hpp
#define SceneController_hpp

#include "CommonHead.h"

enum SceneType{
    SceneType_NULL=0,
    SceneType_WORLD,
    SceneType_HOURSE
};

class SceneInfo
{
public:
    SceneInfo():m_sceneType(SceneType_NULL)
    {};
    ~SceneInfo(){};
    
    SceneType m_sceneType;
    Point m_showPoint;
};

class SceneController:public Ref
{
public:
    static SceneController* getInstance();
    SceneController();
    ~SceneController();
    
    Scene* getSceneByType(SceneType type);
    void replaceSceneByType(SceneType type);
    void replaceSceneBySceneInfo(SceneInfo sceneInfo);
private:
};

#endif /* SceneController_hpp */
