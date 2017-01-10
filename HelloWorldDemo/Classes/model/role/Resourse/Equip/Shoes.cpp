//
//  Shoes.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#include "Shoes.hpp"

Shoes* Shoes::createWithShoesId(string ShoesId){
    Shoes *pRet = new(std::nothrow) Shoes();
    if (pRet && pRet->initWithShoesId(ShoesId))
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
bool Shoes::initWithShoesId(string ShoesId){
    bool ret = false;
    if(Equip::initWithEquipId(ShoesId)){
        ret = true;
    }
    return ret;
}

void Shoes::initCommonData(){
    Equip::initCommonData();
    m_equipType=EquipType_Shoes;
    m_fightValue.m_useType=2;
}

void Shoes::onEnter(){
    Equip::onEnter();
}
void Shoes::onExit(){
    Equip::onExit();
}
