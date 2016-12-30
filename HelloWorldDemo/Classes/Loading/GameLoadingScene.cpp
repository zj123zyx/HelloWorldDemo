#include "GameLoadingScene.h"
#include "SimpleAudioEngine.h"
#include "SceneController.hpp"

USING_NS_CC;

Scene* GameLoadingScene::createScene()
{
    auto scene = Scene::create();
    auto layer = GameLoadingScene::create();
    scene->addChild(layer);
    return scene;
}

bool GameLoadingScene::init()
{
    if ( !Layer::init() ){
        return false;
    }
    //加载图片
    SpriteFrameCache::getInstance()->addSpriteFramesWithFile("Common/Common_1.plist");
    
//    Size wSize = Director::getInstance()->getWinSize();
//    auto sprite = Sprite::create("HelloWorld.png");//HelloWorld.png
//    sprite->setAnchorPoint(Vec2(0.5, 0.5));
//    sprite->setPosition(Vec2(wSize.width/2, wSize.height/2));
//    this->addChild(sprite, 0);
    
    CCBLoadFile("MainScene",this,this);
    
    m_btn->setVisible(false);
//    helloLabel->setString("loading");
//    m_btn->setTitleForState("btn", Control::State::NORMAL);
//    m_btn->setTitleColorForState({255,255,255}, Control::State::HIGH_LIGHTED);
    return true;
}

void GameLoadingScene::onEnter(){
    this->scheduleOnce(schedule_selector(GameLoadingScene::gotoWorldScene), 0.5);
    Node::onEnter();
    
}
void GameLoadingScene::onExit(){
    Node::onExit();
}

void GameLoadingScene::gotoWorldScene(float dt){
//    Director::getInstance()->purgeCachedData();
    SceneController::getInstance()->replaceSceneByType(SceneType_WORLD);
//    Scene *worldScene = SceneController::getInstance()->getSceneByType(SceneType_WORLD); //WorldScene::createScene();
//    Director::getInstance()->replaceScene(worldScene);
}

bool GameLoadingScene::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "helloLabel", Label*, helloLabel);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn", ControlButton*, m_btn);
    return false;
}
cocos2d::extension::Control::Handler GameLoadingScene::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtnClick", GameLoadingScene::onBtnClick);
    return NULL;
}

void GameLoadingScene::onBtnClick(Ref* pSender, Control::EventType event){
    CCLOG("onBtnClick");
}
