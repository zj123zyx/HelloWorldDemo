//
//  ActionRole.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#include "ActionRole.hpp"

ActionRole* ActionRole::createWithPicName(string pic_name)
{
    ActionRole *pRet = new(std::nothrow) ActionRole();
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

bool ActionRole::initWithPicName(string pic_name){
    bool ret = false;
    if(Role::initWithPicName(pic_name)){
        ret = true;
        m_roleType = RoleType_Resource;
        m_width=64;//自身宽度
        m_height=64;//自身高度
        
        m_sceneInfo=SceneInfo();
        m_sceneInfo.m_sceneType=SceneType_WORLD;
        m_sceneInfo.m_showPoint=Vec2(20,82);
        
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        m_roleSprite->setScale(2);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }        
    }
    return ret;
}

void ActionRole::onEnter(){
    Role::onEnter();
}
void ActionRole::onExit(){
    Role::onExit();
}

void ActionRole::setTileXY(int tx,int ty,bool setOccupy/* = true*/){//设置XY
    Role::setTileXY(tx, ty, setOccupy);
    m_actionPoint=Vec2(m_tileX,m_tileY);
    
}

void ActionRole::doAction(Role* sender){//处理事件
    CCLOG("ActionRoleL::doAction()");
    SceneController::getInstance()->replaceSceneBySceneInfo(m_sceneInfo);
}
