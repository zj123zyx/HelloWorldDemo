//
//  UsedRes.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/17.
//
//

#include "UsedRes.hpp"

UsedRes* UsedRes::createWithResId(string resId)
{
    UsedRes *pRet = new(std::nothrow) UsedRes();
    if (pRet && pRet->initWithResId(resId))
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

bool UsedRes::initWithResId(string resId){
    bool ret = false;
    if(Resourse::init()){
        ret = true;
        m_width=64;//自身宽度
        m_height=64;//自身高度
        
        string nameStr = CommonUtils::getPropById(resId,"name");
        string description = CommonUtils::getPropById(resId,"description");
        string icon = CommonUtils::getPropById(resId,"icon");
        int maxValue = atoi(CommonUtils::getPropById(resId, "maxValue").c_str());
        int resource_type = atoi(CommonUtils::getPropById(resId, "resource_type").c_str());
        //属性
        m_selfValue.m_XMLId=resId;
        m_selfValue.m_name=nameStr;
        m_selfValue.m_description=description;
        m_resourceMaxValue=maxValue;
        m_resourceType=(ResourceType)resource_type;
        m_resourceValue=1;//?
        //frame
        setRoleSpriteFrame(icon);
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

void UsedRes::onEnter(){
    Resourse::onEnter();
}
void UsedRes::onExit(){
    Resourse::onExit();
}

void UsedRes::showDescription(bool show){
    Resourse::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s",m_selfValue.m_name.c_str())->getCString();
        m_upLabel->setString(str);
    }
}
