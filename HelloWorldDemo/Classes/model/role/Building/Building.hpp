//
//  Building.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/16.
//
//

#ifndef Building_hpp
#define Building_hpp

#include "Role.hpp"
#include "SceneController.hpp"

enum BuildingType{
    BuildingType_Building=0,
    BuildingType_House,
    BuildingType_HomeBuilding,
    BuildingType_End
};

class Building:public Role
{
public:
    
    static Building* create();
    virtual bool init();
    
    static Building* createWithBuildingId(string id);
    virtual bool initWithBuildingId(string id);
    
    virtual void showDescription(bool show);//显示简介
    void setTileXY(int tx,int ty,bool setOccupy = true);//设置XY
    
    
    virtual void doAction(Role* sender);//处理事件
protected:
    void onEnter();
    void onExit();
    
    SceneInfo m_sceneInfo;
    BuildingType m_buildingType;
};

#endif /* Building_hpp */