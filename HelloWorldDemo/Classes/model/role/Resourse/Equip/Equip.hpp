//
//  Equip.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#ifndef Equip_hpp
#define Equip_hpp

#include "Resourse.hpp"

enum EquipType{
    EquipType_NULL=-1,
    EquipType_Weapon,       //0
    EquipType_Hat,          //1
    EquipType_Jacket,       //2
    EquipType_Trousers,     //3
    EquipType_Shoes,        //4
    EquipType_Jewelry,      //5
    EquipType_Bag,          //6
    EquipType_End
};

class Equip:public Resourse
{
public:
    
    static Equip* createWithEquipId(string EquipId);
    virtual bool initWithEquipId(string EquipId);
    
    virtual void initCommonData();
    virtual void showDescription(bool show);//显示简介
    
    EquipType m_equipType;
protected:
    void onEnter();
    void onExit();
};

#endif /* Equip_hpp */
