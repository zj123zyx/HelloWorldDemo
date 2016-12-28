//
//  Player.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "Player.hpp"
#include "RolesController.hpp"

Player* Player::createWithPicName(string pic_name)
{
    Player *pRet = new(std::nothrow) Player();
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

bool Player::initWithPicName(string pic_name){
    bool ret = false;
    if(Role::initWithPicName(pic_name)){
        ret = true;
        m_roleType = RoleType_Player;
        m_width=64;//32;//自身宽度
        m_height=64;//32;//自身高度
        m_moveSpeed = 2;
        m_fightValue.m_health=10;
        m_fightValue.m_attack=2;
        m_fightValue.m_attackCD=3;
        m_fightValue.m_attackRange=1;
        
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        m_roleSprite->setScale(2);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
        m_upLabel = Label::createWithSystemFont(".", "", 12);
        m_upLabel->setAnchorPoint(Vec2(0.5, 0.5));
        if(m_upLabel){
            m_desNode->addChild(m_upLabel);
        }
        //设置动画
        setAnimation(ROLW_MOVE_DOWN,"res/Roles/assassin1a.png",0,2);
        setAnimation(ROLW_MOVE_LEFT,"res/Roles/assassin1a.png",3,5);
        setAnimation(ROLW_MOVE_RIGHT,"res/Roles/assassin1a.png",6,8);
        setAnimation(ROLW_MOVE_UP,"res/Roles/assassin1a.png",9,11);
    }
    return ret;
}

void Player::onEnter(){
    Role::onEnter();
}
void Player::onExit(){
    Role::onExit();
}

void Player::move(Point point){
    Role::move(point);
    m_container->setPosition(this->getPositionInScreen()-this->getPosition());
}

void Player::moveTo(Point point){
    Role::moveTo(point);
}

void Player::setPosition(const Vec2 &position){
    Node::setPosition(position);
    if(m_container){
        m_container->setPosition(this->getPositionInScreen()-this->getPosition());
    }
}

void Player::doAction(){
    if (m_target) {
        switch (m_target->m_roleType) {
            case RoleType_Tree:
                Role::roleAttackTarget(this);
                break;
            case RoleType_Resource:
                m_target->getThisItem(this);
                break;
                
            default:
                break;
        }
    }
}

void Player::setTarget(Role* target){
    Role::setTarget(target);
    if(m_target){
        m_target->showDescription(true);
    }
}

void Player::removeTarget(){
    if(m_target){
        m_target->showDescription(false);
    }
    Role::removeTarget();
}
