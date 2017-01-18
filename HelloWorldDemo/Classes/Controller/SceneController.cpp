//
//  SceneController.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#include "SceneController.hpp"
#include "WorldScene.h"
#include "PlayerController.hpp"
#include "RolesController.hpp"

#include "TestHouseScene.hpp"


static SceneController* sceneController = NULL;

SceneController* SceneController::getInstance(){
    if (!sceneController){
        sceneController = new SceneController();
    }
    return sceneController;
}

SceneController::SceneController(){

}

SceneController::~SceneController(){
    
}

Scene* SceneController::getSceneByType(SceneType type){
    Scene* retScene = nullptr;
    switch (type) {
        case SceneType_WORLD:
        {
            if(m_sceneMap.find(SceneType_WORLD)==m_sceneMap.end()){
                m_sceneMap[SceneType_WORLD] = WorldScene::createScene();
            }
            retScene = m_sceneMap[SceneType_WORLD];
            break;
        }
        case SceneType_HOURSE:
        {
            if(m_sceneMap.find(SceneType_HOURSE)==m_sceneMap.end()){
                m_sceneMap[SceneType_HOURSE] = TestHouseScene::createScene();
            }
            retScene = m_sceneMap[SceneType_HOURSE];
            break;
        }
        default:
            break;
    }
    if(retScene->getReferenceCount()<=1){
        retScene->retain();
    }
    return retScene;
}

void SceneController::replaceSceneByType(SceneType type){
    RolesController::getInstance()->clearRoleMap();
    Scene *scene = getSceneByType(type);
    Director::getInstance()->replaceScene(scene);
}

void SceneController::replaceSceneBySceneInfo(SceneInfo sceneInfo){
    RolesController::getInstance()->clearRoleMap();
    PlayerController::getInstance()->player->setTileXY(sceneInfo.m_showPoint.x, sceneInfo.m_showPoint.y,false);//设置角色出现位置
    Scene *scene = getSceneByType(sceneInfo.m_sceneType);
    Director::getInstance()->replaceScene(scene);
}




