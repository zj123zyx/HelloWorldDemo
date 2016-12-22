//
//  Role.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "Role.hpp"

Role::Role(){
    
}
Role::~Role(){
    map<string, Animation*>::iterator it = m_aniMap.begin();
    for (; it!=m_aniMap.end(); it++) {
        it->second->release();
    }
}

bool Role::init(){
    bool ret = false;
    if(Node::init()){
        ret = true;
        m_moveSpeed = 1.0;
        m_container = nullptr;
        m_roleSprite = CommonUtils::createSprite("UI_time_1.png");
        m_roleSprite->setAnchorPoint(Vec2(0.5, 0.5));
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
    }
    return ret;
}

void Role::onEnter(){
    Node::onEnter();
}
void Role::onExit(){
    Node::onExit();
}

void Role::startMove(Point point){
    if (m_aniMap.find("move")!=m_aniMap.end()) {
        Animation* moveAni = m_aniMap["move"];
        Action* moveAct = RepeatForever::create(Animate::create(moveAni));
        moveAct->setTag(1);
        m_roleSprite->stopActionByTag(1);
        m_roleSprite->runAction(moveAct);
    }
}

void Role::move(Point point){
    
}

void Role::stopMove(Point point){
    m_roleSprite->stopActionByTag(1);
}

Point Role::getPositionInScreen(){
    Size wSize = Director::getInstance()->getWinSize();
    return Vec2(wSize.width/2, wSize.height/2);
}

void Role::setContainer(TMXTiledMap* container){
    m_container = container;
}

void Role::setAnimation(const char* aniName,string frameName,int frameCount,float dTime){
    Vector<SpriteFrame *> array;
    for (int i=0; i<frameCount; i++) {
        string tempName = __String::createWithFormat("%s%d.png",frameName.c_str(),i)->getCString();
        SpriteFrame* frame = CommonUtils::createSpriteFrame(tempName);
        if(frame){
            array.pushBack(frame);
        }
    }
    if (array.size()>0) {
        if (m_aniMap.find(aniName)!=m_aniMap.end()) {
            Animation* ani = m_aniMap[aniName];
            if(ani){
                ani->release();
            }
        }
        auto animation = Animation::createWithSpriteFrames(array, dTime);
        animation->retain();
        m_aniMap[aniName]=animation;
    }
}










