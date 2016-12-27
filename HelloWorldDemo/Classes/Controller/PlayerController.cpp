//
//  PlayerController.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "PlayerController.hpp"

static PlayerController* playerController = NULL;

PlayerController* PlayerController::getInstance()
{
    if (!playerController)
    {
        playerController = new PlayerController();
    }
    return playerController;
}

PlayerController::PlayerController(){
    player = Player::createWithPicName("res/Roles/assassin1a.png");
    player->m_tileX = 11;
    player->m_tileY = 91;
}
PlayerController::~PlayerController(){
    
}

void PlayerController::OnUIScrollLeft(Point scrollPoint){
    float distance = scrollPoint.getLength();
    CCLOG("scrollPoint.x=%f,scrollPoint.y=%f,distance=%f",scrollPoint.x,scrollPoint.y,distance);
    
    player->move(scrollPoint);
}

void PlayerController::OnUIStopScrollLeft(Point scrollPoint){
    player->stopMove(scrollPoint);
}

void PlayerController::OnUIStartScrollLeft(Point scrollPoint){
    player->startMove(scrollPoint);
}

void PlayerController::playerMoveTo(Point point){
    player->moveTo(point);
}

void PlayerController::getItem(Role* role){//获得物品
    if (role->m_roleType==RoleType_Resource) {
        CCLOG("player get %s:%d",role->m_selfValue.m_name.c_str(),role->m_resourceValue.m_value);
    }
}
