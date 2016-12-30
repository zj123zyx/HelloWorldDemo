//
//  TestHouseScene.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#include "TestHouseScene.hpp"
#include "SimpleAudioEngine.h"
#include "PlayerController.hpp"
#include "RolesController.hpp"
#include "Role.hpp"
#include "Wood.hpp"
#include "ActionRole.hpp"

USING_NS_CC;

TestHouseScene::TestHouseScene(){
    
}
TestHouseScene::~TestHouseScene(){
    RolesController::getInstance()->clearRoleMap();
}

Scene* TestHouseScene::createScene()
{
    auto scene = Scene::create();
    auto layer = TestHouseScene::create();
    scene->addChild(layer);
    return scene;
}

bool TestHouseScene::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    _map = TMXTiledMap::create("image/tiled_house1.tmx");//tiled_test3
    this->addChild(_map);
    //ui
//    TouchUI* touchUI = TouchUI::create();
//    touchUI->m_btn2->setEnabled(false);
//    touchUI->setUiDelegate(this);
//    this->addChild(touchUI);    
    TouchUI::getInstance()->setUiDelegate(this);
    TouchUI::getInstance()->addToLayer(this);
    TouchUI::getInstance()->m_btn2->setEnabled(false);
    
    Size mapSize = _map->getContentSize();
    Size tileSize = _map->getTileSize();
    //add player
    Player *m_player = PlayerController::getInstance()->getPlayer();
    m_player->setContainer(_map);
    int py = mapSize.height - (m_player->m_tileY*tileSize.height+tileSize.height/2);
    int px = m_player->m_tileX*tileSize.width+tileSize.width/2;
    m_player->setPosition(Vec2(px, py));
    _map->addChild(m_player,3);
    
    return true;
}

void TestHouseScene::onEnter(){
    Node::onEnter();
    
    //add tree house
    RolesController::getInstance()->setTiledMap(_map);
    Wood* wood = Wood::createWithPicName("res/Roles/assassin1a.png");
    wood->setTileXY(5,5);
    RolesController::getInstance()->addControllerRole(wood,true);
    ActionRole* actionRole = ActionRole::createWithPicName("res/Roles/assassin1a.png");
    actionRole->setTileXY(10,11);
    RolesController::getInstance()->addControllerRole(actionRole,true);
    m_RoleMap = RolesController::getInstance()->m_RoleMap;
    
}
void TestHouseScene::onExit(){
    RolesController::getInstance()->clearRoleMap();
    Node::onExit();
}










