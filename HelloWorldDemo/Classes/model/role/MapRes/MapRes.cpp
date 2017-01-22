//
//  MapRes.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/22.
//
//

#include "MapRes.hpp"
#include "Wood.hpp"
#include "RolesController.hpp"

MapRes* MapRes::createWithMapResId(string mrId){
    MapRes *pRet = new(std::nothrow) MapRes();
    if (pRet && pRet->initWithMapResId(mrId))
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

bool MapRes::initWithMapResId(string mrId){
    bool ret = false;
    if(Role::init()){
        ret = true;
        m_selfValue.m_XMLId=mrId;
        m_roleType = RoleType_MapRes;
        
        string nameStr = CommonUtils::getPropById(mrId,"name");
        string description = CommonUtils::getPropById(mrId,"description");
        string icon = CommonUtils::getPropById(mrId,"icon");
        int health = atoi(CommonUtils::getPropById(mrId, "health").c_str());
        int width = atoi(CommonUtils::getPropById(mrId, "width").c_str());
        int height = atoi(CommonUtils::getPropById(mrId, "height").c_str());
        int sticky = atoi(CommonUtils::getPropById(mrId, "sticky").c_str());

        m_width=width;//自身宽度
        m_height=height;//自身高度
        m_selfValue.m_name=nameStr;
        m_selfValue.m_sticky=(sticky>0);
        totalHealth = health;
        m_fightValue.m_health=totalHealth;
        
        float percentX=MAX((m_width*1.0/64.0-1.0),0)*64;
        float percentY=MAX((m_height*1.0/64.0-1.0),0)*64;
        
        setRoleSpriteFrame(icon);
        m_roleSprite = Sprite::createWithSpriteFrame(m_roleSpriteFrame);
        CommonUtils::setSpriteWHSize(m_roleSprite,m_width,m_height);
        m_roleSprite->setPosition(percentX/2, percentY/2);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
        m_healthBg = Scale9Sprite::createWithSpriteFrame(CommonUtils::createSpriteFrame("BlackFrame10X10.png"));
        m_healthBg->setContentSize(Size(68, 14));
        m_healthBg->setAnchorPoint(Vec2(0.5, 0));
        m_healthBg->setPosition(percentX,4+percentY);
        m_desNode->addChild(m_healthBg);
        
        m_healthBar = Scale9Sprite::createWithSpriteFrame(CommonUtils::createSpriteFrame("RedFrame10X10.png"));
        m_healthBar->setContentSize(Size(64, 10));
        m_healthBar->setAnchorPoint(Vec2(0, 0));
        m_healthBar->setPosition(-32+percentX, 6+percentY);
        m_desNode->addChild(m_healthBar);
        
        m_upLabel = Label::createWithSystemFont(".", "", 12);
        m_upLabel->setPosition(percentX,18+percentY);
        m_upLabel->setAnchorPoint(Vec2(0.5, 0));
        m_desNode->addChild(m_upLabel);
    }
    return ret;
}

void MapRes::onEnter(){
    Role::onEnter();
}
void MapRes::onExit(){
    Role::onExit();
}

void MapRes::showDescription(bool show){
    Role::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s:%d",m_selfValue.m_name.c_str(),m_fightValue.m_health)->getCString();
        m_upLabel->setString(str);
    }
}

int MapRes::beAttackedByRole(Role* selfRole,int hurt){//被攻击 返回生命值
    int saveX = m_tileX;
    int saveY = m_tileY;
    int ret = Role::beAttackedByRole(selfRole,hurt);
    if(m_fightValue.m_health<=0){//如果生命为0就变为木材
        Wood* wood = Wood::createWithPicName();
        wood->setTileXY(saveX, saveY);
        RolesController::getInstance()->addControllerRole(wood,true);
        selfRole->setTarget(wood);
    }else{
        float healthPercent = (m_fightValue.m_health*1.0)/(totalHealth*1.0);
        m_healthBar->setScaleX(healthPercent);
    }
    return ret;
}

void MapRes::setTileXY(int tx,int ty,bool setOccupy/* = true*/){//设置XY
    Role::setTileXY(tx, ty, setOccupy);
    
    string occupy = CommonUtils::getPropById(m_selfValue.m_XMLId,"occupy");
    vector<string> vec;
    CommonUtils::splitString(occupy, "|", vec);
    for(int i=0;i<vec.size();i++){
        vector<string> vec2;
        CommonUtils::splitString(vec[i], ",", vec2);
        if(vec2.size()==2){
            int dx = atoi(vec2[0].c_str());
            int dy = -atoi(vec2[1].c_str());
            m_occupy.push_back(Vec2(m_tileX+dx,m_tileY+dy));
        }
    }
}









