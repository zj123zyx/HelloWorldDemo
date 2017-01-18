//
//  SceneModel.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/18.
//
//

#include "SceneModel.hpp"
#include "SimpleAudioEngine.h"
#include "PlayerController.hpp"
#include "RolesController.hpp"
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
    TouchUI::getInstance()->setUiDelegate(this);
    TouchUI::getInstance()->addToLayer(this);
    return true;
}

void SceneModel::onEnter(){
    Node::onEnter();
    
}
void SceneModel::onExit(){
    Player* player = PlayerController::getInstance()->player;
    if(player->getReferenceCount()<=1){
        player->retain();
    }
    player->m_target=nullptr;
    Node::onExit();
}
