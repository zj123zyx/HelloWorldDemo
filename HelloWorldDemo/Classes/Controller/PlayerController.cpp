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

//void PlayerController::getItem(Resourse* resourse){//获得物品
//    if (resourse->m_roleType==RoleType_Resource) {
//        CCLOG("player get %s:%d",resourse->m_selfValue.m_name.c_str(),resourse->m_resourceValue);
//    }
//}

Player* PlayerController::getPlayer(){
    if(player->getParent()!=nullptr){
        player->retain();
        player->m_target=nullptr;
        player->removeFromParent();
    }
    if(player->m_tileX==0 && player->m_tileY==0){
        player->m_tileX = 11;
        player->m_tileY = 91;
    }
    return player;
}

int PlayerController::getBagValue(){
    int ret = 0;
    ret += player->m_bagValue;
    return ret;
}
