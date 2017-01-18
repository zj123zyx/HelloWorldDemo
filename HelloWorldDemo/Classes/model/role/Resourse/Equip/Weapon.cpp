//
//  Weapon.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#include "Weapon.hpp"

Weapon* Weapon::createWithWeaponId(string weaponId){
    Weapon *pRet = new(std::nothrow) Weapon();
    if (pRet && pRet->initWithWeaponId(weaponId))
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        delete pRet;
        pRet = nullptr;
        return nullptr;
    }
}
bool Weapon::initWithWeaponId(string weaponId){
    bool ret = false;
    if(Equip::initWithEquipId(weaponId)){
        ret = true;
    }
    return ret;
}

void Weapon::initCommonData(){
    Equip::initCommonData();

    m_useType=UseType_EquipInUI;
}

void Weapon::onEnter(){
    Equip::onEnter();
}
void Weapon::onExit(){
    Equip::onExit();
}
