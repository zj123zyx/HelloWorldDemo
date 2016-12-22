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
    player = Player::create();
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
