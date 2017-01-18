//
//  BodyEquip.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#ifndef BodyEquip_hpp
#define BodyEquip_hpp

#include "Equip.hpp"

class BodyEquip:public Equip
{
public:    
    static BodyEquip* createWithBodyEquipId(string BodyEquipId);
    virtual bool initWithBodyEquipId(string BodyEquipId);
    
    void initCommonData();
protected:
    void onEnter();
    void onExit();
};

#endif /* BodyEquip_hpp */
