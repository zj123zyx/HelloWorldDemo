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
    if(Resourse::initWithPicName(pic_name)){
        ret = true;
        m_width=64;//自身宽度
        m_height=64;//自身高度
        m_selfValue.m_name="木材";
        m_resourceType=ResourceType_Wood;
        m_resourceValue=9;
        m_resourceMaxValue=20;
        
        m_roleSpriteFrame = CommonUtils::createSpriteFrame(pic_name);//"Res_wood.png"
        m_roleSprite = Sprite::createWithSpriteFrame(m_roleSpriteFrame);
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

void Wood::onEnter(){
    Resourse::onEnter();
}
void Wood::onExit(){
    Resourse::onExit();
}

void Wood::showDescription(bool show){
    Resourse::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s",m_selfValue.m_name.c_str())->getCString();
        m_upLabel->setString(str);
    }
}
