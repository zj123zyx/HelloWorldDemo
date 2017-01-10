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
#include "Weapon.hpp"
#include "Shoes.hpp"
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
    
    
    RolesController::getInstance()->setTiledMap(_map);
    //add tree
    Wood* wood = Wood::createWithPicName();
    wood->setTileXY(5,5);
    RolesController::getInstance()->addControllerRole(wood,true);
    
    Wood* wood2 = Wood::createWithPicName();
    wood2->setTileXY(6,5);
    RolesController::getInstance()->addControllerRole(wood2,true);
    
    Wood* wood3 = Wood::createWithPicName();
    wood3->setTileXY(7,5);
    RolesController::getInstance()->addControllerRole(wood3,true);
    
    ActionRole* actionRole = ActionRole::createWithPicName("res/Roles/assassin1a.png");
    actionRole->setTileXY(10,11);
    RolesController::getInstance()->addControllerRole(actionRole,true);
    
    Weapon* weapon = Weapon::createWithPicName("Equip0_1.png");
    weapon->setTileXY(10,5);
    RolesController::getInstance()->addControllerRole(weapon,true);
    
    Weapon* weapon1 = Weapon::createWithWeaponId("100000001");
    weapon1->setTileXY(11,5);
    RolesController::getInstance()->addControllerRole(weapon1,true);
    
    Shoes* shoes = Shoes::createWithShoesId("100040001");
    shoes->setTileXY(12,5);
    RolesController::getInstance()->addControllerRole(shoes,true);
    
    m_RoleMap = RolesController::getInstance()->m_RoleMap;
    
}
void TestHouseScene::onExit(){
    RolesController::getInstance()->clearRoleMap();
    Node::onExit();
}










