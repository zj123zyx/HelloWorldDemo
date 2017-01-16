//
//  Building.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/16.
//
//

#include "Building.hpp"

Building* Building::create()
{
    Building *pRet = new(std::nothrow) Building();
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

bool Building::init(){
    bool ret = false;
    if(Role::init()){
        ret = true;
        m_roleType = RoleType_Building;
        m_buildingType = BuildingType_Building;
        m_width=64;//自身宽度
        m_height=64;//自身高度
        m_selfValue.m_name="Building";
        m_selfValue.m_sticky=true;
        
        m_sceneInfo=SceneInfo();
    }
    return ret;
}

Building* Building::createWithBuildingId(string id){
    Building *pRet = new(std::nothrow) Building();
    if (pRet && pRet->initWithBuildingId(id))
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

bool Building::initWithBuildingId(string id){
    bool ret = false;
    if(Role::init()){
        ret = true;
        m_roleType = RoleType_Building;
        m_buildingType = BuildingType_Building;
        
        string nameStr = CommonUtils::getPropById(id,"name");
        string description = CommonUtils::getPropById(id,"description");
        string icon = CommonUtils::getPropById(id,"icon");
        int width = atoi(CommonUtils::getPropById(id, "width").c_str());
        int height = atoi(CommonUtils::getPropById(id, "height").c_str());
        //属性
        m_selfValue.m_XMLId=id;
        m_selfValue.m_name=nameStr;
        m_selfValue.m_description=description;
        m_width=width;//自身宽度
        m_height=height;//自身高度
        m_selfValue.m_sticky=false;
        m_sceneInfo=SceneInfo();
        //frame
        setRoleSpriteFrame(icon);
        m_roleSprite = Sprite::createWithSpriteFrame(m_roleSpriteFrame);
//        CommonUtils::setSpriteMaxSize(m_roleSprite,height);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
    }
    return ret;
}

void Building::onEnter(){
    Role::onEnter();
}
void Building::onExit(){
    Role::onExit();
}

void Building::showDescription(bool show){
    Role::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s",m_selfValue.m_name.c_str())->getCString();
        m_upLabel->setString(str);
    }
}

void Building::setTileXY(int tx,int ty,bool setOccupy/* = true*/){//设置XY
    Role::setTileXY(tx, ty, setOccupy);
}

void Building::doAction(Role* sender){//处理事件
    CCLOG("BuildingL::doAction()");
    if(m_sceneInfo.m_sceneType!=SceneType_NULL){
        SceneController::getInstance()->replaceSceneBySceneInfo(m_sceneInfo);
    }
}








