//
//  HomeBuilding.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/16.
//
//

#include "HomeBuilding.hpp"
#include "PlayerController.hpp"

HomeBuilding* HomeBuilding::createWithHomeBuildingId(string id)
{
    HomeBuilding *pRet = new(std::nothrow) HomeBuilding();
    if (pRet && pRet->initWithHomeBuildingId(id))
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

bool HomeBuilding::initWithHomeBuildingId(string id){
    bool ret = false;
    if(Building::initWithBuildingId(id)){
        ret = true;
        m_buildingType = BuildingType_HomeBuilding;
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

void HomeBuilding::onEnter(){
    Building::onEnter();
}
void HomeBuilding::onExit(){
    Building::onExit();
}

void HomeBuilding::setDataByVirtualBuild(VirtualBuild* vb){
    Player* player = PlayerController::getInstance()->player;
    int ptx = player->m_tileX;
    int pty = player->m_tileY;
    Building::setTileXY(ptx, pty-1);//设置player前面的位置为锚点
//    m_actionPoint=Vec2(m_tileX,m_tileY);//设置player前面的位置为事件点
    map<Vec2,Sprite*>::iterator it = vb->m_sprMap.begin();
    for (; it!=vb->m_sprMap.end(); it++) {
        if(it->first.x!=0 || it->first.y!=0){//不能是player所在点
            Vec2 sprPoint = Vec2(ptx+it->first.x, pty-it->first.y);
            m_occupy.push_back(sprPoint);
        }
    }
    m_buildingState=BuildingState_StartBuild;
    m_buildProgress=1;
}

void HomeBuilding::showDescription(bool show){
    Role::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s,%.f,%u",m_selfValue.m_name.c_str(),m_buildProgress,m_buildingState)->getCString();
        m_upLabel->setString(str);
    }
}

void HomeBuilding::buildFinish(){
    Building::buildFinish();
    
    m_actionPoint=Vec2(m_tileX,m_tileY);
    m_sceneInfo.m_sceneType=SceneType_HOURSE55;
    m_sceneInfo.m_showPoint=Vec2(2,3);
}




