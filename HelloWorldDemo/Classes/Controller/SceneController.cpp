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
            retScene = WorldScene::createScene();
            break;
        case SceneType_HOURSE:
            retScene = TestHouseScene::createScene();
            break;
        default:
            break;
    }
    
    return retScene;
}

void SceneController::replaceSceneByType(SceneType type){
    Scene *scene = getSceneByType(type);
    Director::getInstance()->replaceScene(scene);
}

void SceneController::replaceSceneBySceneInfo(SceneInfo sceneInfo){
    PlayerController::getInstance()->player->setTileXY(sceneInfo.m_showPoint.x, sceneInfo.m_showPoint.y,false);//设置角色出现位置
    Scene *scene = getSceneByType(sceneInfo.m_sceneType);
    Director::getInstance()->replaceScene(scene);
}




