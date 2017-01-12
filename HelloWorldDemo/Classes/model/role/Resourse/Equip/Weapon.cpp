//
//  Weapon.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#include "Weapon.hpp"

Weapon* Weapon::createWithPicName(string pic_name)
{
    Weapon *pRet = new(std::nothrow) Weapon();
    if (pRet && pRet->initWithPicName(pic_name))
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

bool Weapon::initWithPicName(string pic_name){
    bool ret = false;
    if(Equip::initWithPicName(pic_name)){
        ret = true;
    }
    return ret;
}

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
    m_equipType=EquipType_Weapon;
//    m_fightValue.m_useType=1;
    m_useType=UseType_EquipInUI;
}

void Weapon::onEnter(){
    Equip::onEnter();
}
void Weapon::onExit(){
    Equip::onExit();
}
