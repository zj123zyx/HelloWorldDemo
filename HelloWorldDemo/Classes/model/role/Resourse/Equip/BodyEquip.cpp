//
//  BodyEquip.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#include "BodyEquip.hpp"

BodyEquip* BodyEquip::createWithBodyEquipId(string BodyEquipId){
    BodyEquip *pRet = new(std::nothrow) BodyEquip();
    if (pRet && pRet->initWithBodyEquipId(BodyEquipId))
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
bool BodyEquip::initWithBodyEquipId(string BodyEquipId){
    bool ret = false;
    if(Equip::initWithEquipId(BodyEquipId)){
        ret = true;
    }
    return ret;
}

void BodyEquip::initCommonData(){
    Equip::initCommonData();

    m_useType=UseType_EquipInBag;
}

void BodyEquip::onEnter(){
    Equip::onEnter();
}
void BodyEquip::onExit(){
    Equip::onExit();
}
