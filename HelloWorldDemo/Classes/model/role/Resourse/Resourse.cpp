//
//  Resourse.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/30.
//
//

#include "Resourse.hpp"
#include "RolesController.hpp"
#include "ResourseController.hpp"
#include "TouchUI.h"

Resourse* Resourse::createWithPicName(string pic_name)
{
    Resourse *pRet = new(std::nothrow) Resourse();
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
Resourse* Resourse::create(){
    Resourse *pRet = new(std::nothrow) Resourse();
    if (pRet && pRet->init())
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
bool Resourse::initWithPicName(string pic_name){
    bool ret = false;
    if(init()){
        ret = true;
        setRoleSpriteFrame(pic_name);
    }
    return ret;
}
bool Resourse::init(){
    bool ret = false;
    if(Role::init()){
        ret = true;
        m_roleType = RoleType_Resource;
        m_selfValue.m_sticky=true;
    }
    return ret;
}

void Resourse::onEnter(){
    Role::onEnter();
}
void Resourse::onExit(){
    Role::onExit();
}

void Resourse::getThisItem(Role* role){//获得此物品
    if (role->m_roleType==RoleType_Player) {
        if(ResourseController::getInstance()->getItem(this)){
            this->removeFromParent();
            RolesController::getInstance()->removeRoleByTile(Vec2(m_tileX, m_tileY));//删除角色
            role->m_target=nullptr;
            //刷新UI通知 
            __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
        }else{
            CCLOG("背包空位不足");
            TouchUI::getInstance()->flyHint("背包空位不足");
        }
    }
}

void Resourse::showDescription(bool show){//显示简介
    Role::showDescription(show);
}
