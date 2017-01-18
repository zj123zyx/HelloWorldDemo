//
//  HouseScene_55.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/18.
//
//

#ifndef HouseScene_55_hpp
#define HouseScene_55_hpp

#include "SceneModel.hpp"

class HouseScene_55 :public SceneModel
{
public:    
    static cocos2d::Scene* createScene();
    virtual bool init();
    CREATE_FUNC(HouseScene_55);
    
    virtual void onEnter();
    virtual void onExit();
protected:
    virtual void addRoles();
};

#endif /* HouseScene_55_hpp */
