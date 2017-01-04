//
//  Resourse.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/30.
//
//

#include "Resourse.hpp"
#include "RolesController.hpp"
//#include "PlayerController.hpp"
#include "ResourseController.hpp"

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

bool Resourse::initWithPicName(string pic_name){
    bool ret = false;
    if(Role::initWithPicName(pic_name)){
        ret = true;
        m_roleType = RoleType_Resource;
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
        }else{
            CCLOG("背包空位不足");
        }
    }
}
