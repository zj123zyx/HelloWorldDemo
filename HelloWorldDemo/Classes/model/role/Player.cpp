//
//  Player.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "Player.hpp"

bool Player::init(){
    bool ret = false;
    if(Role::init()){
        ret = true;
        
        setAnimation("move","UI_time_",2);
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
