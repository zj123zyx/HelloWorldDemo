//
//  SceneModel.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/18.
//
//

#include "SceneModel.hpp"
#include "SimpleAudioEngine.h"


#include "Role.hpp"
#include "UsedRes.hpp"
#include "Weapon.hpp"
#include "BodyEquip.hpp"
#include "ActionRole.hpp"

USING_NS_CC;

Scene* SceneModel::createScene()
{
    auto scene = Scene::create();
    auto layer = SceneModel::create();
    layer->setTag(1);
    scene->addChild(layer);
    return scene;
}

SceneModel* SceneModel::createWithTiledName(string tiledName)
{
    SceneModel *pRet = new(std::nothrow) SceneModel();
    if (pRet && pRet->initWithTiledName(tiledName))
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

bool SceneModel::initWithTiledName(string tiledName)
{
    if ( !Layer::init() )
    {
        return false;
    }
    _map = TMXTiledMap::create(tiledName);//tiled_test3
    this->addChild(_map);
    addRoles();
    
    m_sceneType=SceneType_NULL;
    return true;
}

void SceneModel::onEnter(){
    Node::onEnter();
    TouchUI::getInstance()->setUiDelegate(this);
    TouchUI::getInstance()->addToLayer(this);
    RolesController::getInstance()->setTiledMap(_map);
    RolesController::getInstance()->m_RoleMap = m_RoleMap;
}
void SceneModel::onExit(){
//    m_RoleMap = RolesController::getInstance()->m_RoleMap;
    
    Player* player = PlayerController::getInstance()->player;
    if(player->getReferenceCount()<=1){
        player->retain();
    }
    player->m_target=nullptr;
    Node::onExit();
}

void SceneModel::addRoles(){
    RolesController::getInstance()->setTiledMap(_map);
}
