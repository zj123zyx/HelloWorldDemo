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
        m_width=30;//32;//自身宽度
        m_height=30;//32;//自身高度
        m_target=nullptr;
        m_moveSpeed = 2;
        
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
//        m_upLabel = Label::createWithSystemFont(".", "", 12);
//        m_upLabel->setAnchorPoint(Vec2(0.5, 0.5));
//        m_upLabel->setPositionY(20);
//        if(m_upLabel){
//            this->addChild(m_upLabel);
//        }
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
    Point faceToPoint = getFaceToTilePoint();
    Role* role = RolesController::getInstance()->getRoleByTile(faceToPoint);
    if (role) {
        setTarget(role);
    }else{
        removeTarget();
    }
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

void Player::setTarget(Role* target){
    m_target = target;
    target->showDescription(true);
}

void Player::removeTarget(){
    if(m_target){
        m_target->showDescription(false);
        m_target = nullptr;
    }
}
