//
//  Wood.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/27.
//
//

#include "Wood.hpp"

Wood* Wood::createWithPicName(string pic_name)
{
    Wood *pRet = new(std::nothrow) Wood();
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

bool Wood::initWithPicName(string pic_name){
    bool ret = false;
    if(Role::initWithPicName(pic_name)){
        ret = true;
        m_roleType = RoleType_Wood;
        m_width=32;//自身宽度
        m_height=32;//自身高度
        m_selfValue.m_name="木材";
        m_resourceValue.m_wood=10;
        
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
    }
    return ret;
}

void Wood::onEnter(){
    Role::onEnter();
}
void Wood::onExit(){
    Role::onExit();
}

void Wood::showDescription(bool show){
    Role::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s",m_selfValue.m_name.c_str())->getCString();
        m_upLabel->setString(str);
    }
}
