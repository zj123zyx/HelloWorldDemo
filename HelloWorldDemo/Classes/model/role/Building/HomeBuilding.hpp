//
//  HomeBuilding.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/16.
//
//

#ifndef HomeBuilding_hpp
#define HomeBuilding_hpp

#include "Building.hpp"
#include "SceneController.hpp"
#include "VirtualBuild.hpp"

class HomeBuilding:public Building
{
public:
    
    static HomeBuilding* createWithHomeBuildingId(string id);
    virtual bool initWithHomeBuildingId(string id);
    
    void setDataByVirtualBuild(VirtualBuild* vb);
    void showDescription(bool show);
    
    virtual void buildFinish();
protected:
    void onEnter();
    void onExit();
    
};

#endif /* HomeBuilding_hpp */
