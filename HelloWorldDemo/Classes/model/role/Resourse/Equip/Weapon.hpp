//
//  Weapon.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#ifndef Weapon_hpp
#define Weapon_hpp

#include "Equip.hpp"

class Weapon:public Equip
{
public:
    
    static Weapon* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    static Weapon* createWithWeaponId(string weaponId);
    virtual bool initWithWeaponId(string weaponId);
    
    void initCommonData();
protected:
    void onEnter();
    void onExit();
};

#endif /* Weapon_hpp */
