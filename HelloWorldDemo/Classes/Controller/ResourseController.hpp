//
//  ResourseController.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/30.
//
//

#ifndef ResourseController_hpp
#define ResourseController_hpp

#include "CommonHead.h"
#include "Equip.hpp"

class ResourseController:public Ref
{
public:
    static ResourseController* getInstance();
    
    ResourseController();
    ~ResourseController();
    
    bool mergeResourse(Resourse* resourse);//合并物品
    int getBagPosition();//获得背包空位
    bool getItem(Resourse* resourse);//获得物品
    Resourse* getEquipedResInUI();//获得ui中装备的物品
    void setEquipedResInUIByPos(int pos);//设置UI中装备的物品
    void abandonResourse(Resourse* resourse);//丢弃物品
    void equipResourse(Equip* equip);//装备物品
    void unwieldResourse(Equip* equip);//卸下装备
    void costResourse(Resourse* resourse,int costValue);//消耗物品
    void deleteZeroValueResourse();//删除m_resourceValue=0的物品
    
    map<int, Resourse*> m_resourseMap;
    map<int, Equip*> m_equipMap;
};

#endif /* ResourseController_hpp */
