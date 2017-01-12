//
//  Equip.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#include "Equip.hpp"

Equip* Equip::createWithPicName(string pic_name)
{
    Equip *pRet = new(std::nothrow) Equip();
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

bool Equip::initWithPicName(string pic_name){
    bool ret = false;
    if(Resourse::initWithPicName(pic_name)){
        ret = true;
        initCommonData();
        m_selfValue.m_name="装备";
        //frame
        //m_roleSpriteFrame = CommonUtils::createSpriteFrame(pic_name);//"Equip0_1.png"在Resourse里设置了
        m_roleSprite = Sprite::createWithSpriteFrame(m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(m_roleSprite,64);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
    }
    return ret;
}

Equip* Equip::createWithEquipId(string EquipId){
    Equip *pRet = new(std::nothrow) Equip();
    if (pRet && pRet->initWithEquipId(EquipId))
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
bool Equip::initWithEquipId(string EquipId){
    bool ret = false;
    if(Resourse::init()){
        ret = true;
        initCommonData();
        
        string nameStr = CommonUtils::getPropById(EquipId,"name");
        string description = CommonUtils::getPropById(EquipId,"description");
        string icon = CommonUtils::getPropById(EquipId,"icon");
        int level = atoi(CommonUtils::getPropById(EquipId, "level").c_str());
        int health = atoi(CommonUtils::getPropById(EquipId, "health").c_str());
        int defense = atoi(CommonUtils::getPropById(EquipId, "defense").c_str());
        int attack = atoi(CommonUtils::getPropById(EquipId, "attack").c_str());
        int attackCD = atoi(CommonUtils::getPropById(EquipId, "attackCD").c_str());
        int attackRange = atoi(CommonUtils::getPropById(EquipId, "attackRange").c_str());
        float moveSpeed = atof(CommonUtils::getPropById(EquipId, "moveSpeed").c_str());
        //属性
        m_selfValue.m_XMLId=EquipId;
        m_selfValue.m_name=nameStr;
        m_selfValue.m_description=description;
        m_fightValue.m_health=health;
        m_fightValue.m_defense=defense;
        m_fightValue.m_attack=attack;
        m_fightValue.m_attackCD=attackCD;
        m_fightValue.m_attackRange=attackRange;
        m_fightValue.m_moveSpeed=moveSpeed;
        m_selfValue.m_level=level;
        //frame
        setRoleSpriteFrame(icon);
        m_roleSprite = Sprite::createWithSpriteFrame(m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(m_roleSprite,64);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
    }
    return ret;
}

void Equip::initCommonData(){
    m_width=64;//自身宽度
    m_height=64;//自身高度
    m_equipType=EquipType_NULL;
    m_resourceType=ResourceType_Equip;
    m_upLabel = Label::createWithSystemFont(".", "", 14);
    m_upLabel->setAnchorPoint(Vec2(0.5, 0));
    m_upLabel->setPositionY(4);
    if(m_upLabel){
        m_desNode->addChild(m_upLabel);
    }
}

void Equip::onEnter(){
    Resourse::onEnter();
}
void Equip::onExit(){
    Resourse::onExit();
}

void Equip::showDescription(bool show){
    Resourse::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s",m_selfValue.m_name.c_str())->getCString();
        m_upLabel->setString(str);
    }
}
