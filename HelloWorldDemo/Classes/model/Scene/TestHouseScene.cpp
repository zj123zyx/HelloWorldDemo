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
//#include "Wood.hpp"
#include "UsedRes.hpp"
#include "Weapon.hpp"
#include "ActionRole.hpp"
#include "Tree.hpp"
#include "House.hpp"
#include "BodyEquip.hpp"
#include "NPCRole.hpp"
#include "Book.hpp"

USING_NS_CC;

Scene* TestHouseScene::createScene()
{
    auto scene = Scene::create();
    auto layer = TestHouseScene::create();
    scene->addChild(layer);
    return scene;
}

bool TestHouseScene::init()
{
    if ( !SceneModel::initWithTiledName("image/tiled_house1.tmx") )//image/tiled_test5.tmx //image/tiled_house1.tmx
    {
        return false;
    }
    //ui 
    TouchUI::getInstance()->m_btn2->setEnabled(false);
    
    return true;
}

void TestHouseScene::onEnter(){
    SceneModel::onEnter();
    RolesController::getInstance()->setTiledMap(_map);
    //add player
    Player *m_player = PlayerController::getInstance()->getPlayer();
    m_player->setContainer(_map);//player位置由controller控制
    RolesController::getInstance()->addControllerRole(m_player,true);
    
    //add tree
    UsedRes* wood = UsedRes::createWithResId("400000001");
    wood->m_resourceValue=9;
    wood->setTileXY(5,5);
    RolesController::getInstance()->addControllerRole(wood,true);
    
    UsedRes* food = UsedRes::createWithResId("400000002");
    food->m_resourceValue=9;
    food->setTileXY(6,5);
    RolesController::getInstance()->addControllerRole(food,true);
    
    UsedRes* stone = UsedRes::createWithResId("400000003");
    stone->m_resourceValue=9;
    stone->setTileXY(7,5);
    RolesController::getInstance()->addControllerRole(stone,true);
    
    ActionRole* actionRole = ActionRole::createWithPicName("res/Roles/assassin1a.png");
    actionRole->setTileXY(10,11);
    RolesController::getInstance()->addControllerRole(actionRole,true);
    
    Weapon* weapon1 = Weapon::createWithWeaponId("100000001");
    weapon1->setTileXY(11,5);
    RolesController::getInstance()->addControllerRole(weapon1,true);
    
    BodyEquip* shoes = BodyEquip::createWithBodyEquipId("100040001");
    shoes->setTileXY(12,5);
    RolesController::getInstance()->addControllerRole(shoes,true);
    
    m_RoleMap = RolesController::getInstance()->m_RoleMap;
    
}
void TestHouseScene::onExit(){
    RolesController::getInstance()->clearRoleMap();
    SceneModel::onExit();
}










