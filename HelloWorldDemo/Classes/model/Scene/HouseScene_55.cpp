//
//  HouseScene_55.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/18.
//
//

#include "HouseScene_55.hpp"
#include "ActionRole.hpp"

Scene* HouseScene_55::createScene()
{
    auto scene = Scene::create();
    auto layer = HouseScene_55::create();
    layer->setTag(1);
    scene->addChild(layer);
    return scene;
}

bool HouseScene_55::init()
{
    if ( !SceneModel::initWithTiledName("image/tiled_house_5_5.tmx") )
    {
        return false;
    }
    
    m_sceneType=SceneType_HOURSE55;
    return true;
}

void HouseScene_55::onEnter(){
    SceneModel::onEnter();
    //ui
    TouchUI::getInstance()->m_btn2->setEnabled(false);
    //add player
    Player *m_player = PlayerController::getInstance()->getPlayer();
    m_player->setContainer(_map);//player位置由controller控制
    RolesController::getInstance()->addControllerRole(m_player,true);
}
void HouseScene_55::onExit(){
    SceneModel::onExit();
}

void HouseScene_55::addRoles(){
    SceneModel::addRoles();
 
    ActionRole* actionRole = ActionRole::createWithPicName("res/Roles/assassin1a.png");
    actionRole->setTileXY(2,4);
    RolesController::getInstance()->addControllerRole(actionRole,true);
    
    m_RoleMap = RolesController::getInstance()->m_RoleMap;
}
