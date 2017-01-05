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
    if(Resourse::initWithPicName(pic_name)){
        ret = true;
        m_width=64;//自身宽度
        m_height=64;//自身高度
        m_selfValue.m_name="武器";
        m_resourceType=ResourceType_Weapon;
        m_fightValue.m_enabled=true;
        //战斗属性
        m_fightValue.m_attack=5;
        m_fightValue.m_attackCD=1;
        m_fightValue.m_attackRange=1;
        
        m_roleSpriteFrame = CommonUtils::createSpriteFrame(pic_name);//"Equip0_1.png"
        m_roleSprite = Sprite::createWithSpriteFrame(m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(m_roleSprite,64);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        m_upLabel = Label::createWithSystemFont(".", "", 14);
        m_upLabel->setAnchorPoint(Vec2(0.5, 0));
        m_upLabel->setPositionY(4);
        if(m_upLabel){
            m_desNode->addChild(m_upLabel);
        }
        
    }
    return ret;
}

void Weapon::onEnter(){
    Resourse::onEnter();
}
void Weapon::onExit(){
    Resourse::onExit();
}

void Weapon::showDescription(bool show){
    Resourse::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s",m_selfValue.m_name.c_str())->getCString();
        m_upLabel->setString(str);
    }
}
