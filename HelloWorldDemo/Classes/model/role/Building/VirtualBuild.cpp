//
//  VirtualBuild.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#include "VirtualBuild.hpp"
#include "Player.hpp"
#include "RolesController.hpp"

VirtualBuild* VirtualBuild::createWithBuildId(string buildId)
{
    VirtualBuild *pRet = new(std::nothrow) VirtualBuild();
    if (pRet && pRet->initWithBuildId(buildId))
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

bool VirtualBuild::initWithBuildId(string buildId){
    bool ret = false;
    if(Node::init()){
        ret = true;
        m_mainNode=Node::create();
        addPointToVec(Vec2(0, 0));
        
        string virtualBuild = CommonUtils::getPropById(buildId,"virtualBuild");
        vector<string> vec;
        CommonUtils::splitString(virtualBuild,"|",vec);
        for (int i=0; i<vec.size(); i++) {
            string tempStr = vec[i];
            vector<string> vec2;
            CommonUtils::splitString(tempStr,",",vec2);
            if(vec2.size()==2){
                float vx=atof(vec2[0].c_str());
                float vy=atof(vec2[1].c_str());
                addPointToVec(Vec2(vx, vy));
            }
        }
        this->addChild(m_mainNode);
    }
    return ret;
}

void VirtualBuild::onEnter(){
    Node::onEnter();
}
void VirtualBuild::onExit(){
    Node::onExit();
}

void VirtualBuild::addPointToVec(Vec2 point){
//    m_pointVec.push_back(point);
    Sprite* sprite = CommonUtils::createSprite("BlackFrame10X10.png");
    CommonUtils::setSpriteMaxSize(sprite, m_size, true);
    sprite->setPosition(point.x*m_size, point.y*m_size);
    sprite->setOpacity(100);
    m_sprMap[point] = sprite;
    m_mainNode->addChild(sprite);
}

void VirtualBuild::refreshPosition(Vec2 playerPoint){
    RolesController::getInstance()->refreshVirtualBuildPosition(playerPoint);
    map<Vec2,Sprite*>::iterator it = m_sprMap.begin();
    for (; it!=m_sprMap.end(); it++) {
        Vec2 sprPoint = Vec2(playerPoint.x+it->first.x, playerPoint.y-it->first.y);
        if (isVecCanPut(sprPoint)==false) {
            Sprite* sprite = CommonUtils::createSprite("RedFrame10X10.png");
            CommonUtils::setSpriteMaxSize(sprite, m_size, true);
            it->second->setSpriteFrame(sprite->getSpriteFrame());
        }else{
            Sprite* sprite = CommonUtils::createSprite("BlackFrame10X10.png");
            CommonUtils::setSpriteMaxSize(sprite, m_size, true);
            it->second->setSpriteFrame(sprite->getSpriteFrame());
        }
    }
}

bool VirtualBuild::isVecCanPut(Vec2 vec){
    int gid = RolesController::getInstance()->getLayerTileGIDAtPoint("layer_1",vec);
    string goThrough = RolesController::getInstance()->getPropertyByGIDAndNameToString(gid,"goThrough");
    if(goThrough=="1"){
        return false;
    }
    Role* role = RolesController::getInstance()->getRoleByTile(vec);
    if (role!=nullptr) {
        return false;
    }
    return true;
}






