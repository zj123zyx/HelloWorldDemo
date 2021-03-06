//
//  House.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#include "House.hpp"

House* House::createWithPicName(string pic_name)
{
    House *pRet = new(std::nothrow) House();
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

bool House::initWithPicName(string pic_name){
    bool ret = false;
    if(Building::init()){
        ret = true;
        m_width=192;//自身宽度
        m_height=192;//自身高度
        m_selfValue.m_name="房子";
        m_selfValue.m_sticky=false;
        
        m_sceneInfo.m_sceneType=SceneType_HOURSE;
        m_sceneInfo.m_showPoint=Vec2(10,10);
        
        m_buildingType = BuildingType_House;
        //frame
        setRoleSpriteFrame(pic_name);
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        m_roleSprite->setScale(6);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        //label
        m_upLabel = Label::createWithSystemFont(".", "", 16);
        m_upLabel->setAnchorPoint(Vec2(0.5, 0));
        m_upLabel->setPositionY(80);
        if(m_upLabel){
            m_desNode->addChild(m_upLabel);
        }
    }
    return ret;
}

void House::onEnter(){
    Building::onEnter();
}
void House::onExit(){
    Building::onExit();
}

void House::setTileXY(int tx,int ty,bool setOccupy/* = true*/){//设置XY
    Building::setTileXY(tx, ty, setOccupy);
    m_occupy.push_back(Vec2(m_tileX,m_tileY+1));
    m_occupy.push_back(Vec2(m_tileX,m_tileY-1));
    m_occupy.push_back(Vec2(m_tileX+1,m_tileY));
    m_occupy.push_back(Vec2(m_tileX+1,m_tileY+1));
    m_occupy.push_back(Vec2(m_tileX+1,m_tileY-1));
    m_occupy.push_back(Vec2(m_tileX-1,m_tileY));
    m_occupy.push_back(Vec2(m_tileX-1,m_tileY+1));
    m_occupy.push_back(Vec2(m_tileX-1,m_tileY-1));
    m_actionPoint=Vec2(m_tileX,m_tileY+1);
//    m_actionShowPoint=Vec2(10,10);
}

void House::doAction(Role* sender){//处理事件
    Building::doAction(sender);
}








