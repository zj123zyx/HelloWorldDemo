#include "TouchUI.h"
#include "PlayerController.hpp"
#include "EquipView.hpp"
#include "ResourseController.hpp"
#include "Goods.hpp"
#include "RolesController.hpp"

USING_NS_CC;

static const float MAX_DISTANCE=100;

static const float EquipBagCellW = 75.0;
#pragma mark UIEquipCell
UIEquipCell* UIEquipCell::create(int pos,int sum){
    UIEquipCell *pRet = new(std::nothrow) UIEquipCell();
    if (pRet && pRet->init(pos,sum)){
        pRet->autorelease();
        return pRet;
    }else{
        delete pRet;
        pRet = nullptr;
        return nullptr;
    }
}

bool UIEquipCell::init(int pos,int sum){
    if ( !Node::init() ){
        return false;
    }
    auto node = CCBLoadFile("UIEquipCell",this,this);
    this->setContentSize(node->getContentSize());
    
    m_touchMove=false;
    m_pos = pos;
    m_sum = sum;
    float px = (m_pos-(sum)/2.0)*EquipBagCellW;
    float py = 0;
    this->setPosition(px, py);
    
    setData(m_pos,m_sum);
    
    return true;
}

void UIEquipCell::setData(int pos,int sum){
    m_pos = pos;
    m_sum = sum;
    m_iconNode->removeAllChildren();
    m_numNode->setVisible(false);
    if(ResourseController::getInstance()->m_resourseMap.find(pos)!=ResourseController::getInstance()->m_resourseMap.end()){
        Resourse* resourse = ResourseController::getInstance()->m_resourseMap[pos];
        auto spr = Sprite::createWithSpriteFrame(resourse->m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(spr, 64);
        m_iconNode->addChild(spr);
        if(resourse->m_isEquipedInUI){
            m_numNode->setVisible(true);
            m_desTxt->setString("E");
        }
    }
}
void UIEquipCell::onEnter(){
    TouchNode::onEnter();
}
void UIEquipCell::onExit(){
    TouchNode::onExit();
}

bool UIEquipCell::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_iconNode", Node*, m_iconNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_numNode", Node*, m_numNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_desTxt", Label*, m_desTxt);
    
    return false;
}
cocos2d::extension::Control::Handler UIEquipCell::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    return NULL;
}

bool UIEquipCell::onTouchBegan(Touch* touch, Event* event){
    m_touchMove=false;
    if (isTouchInside(m_touchNode,touch)) {
        return true;
    }
    return false;
}
void UIEquipCell::onTouchMoved(Touch* touch, Event* event){
    if (touch->getLocation().getDistance(touch->getStartLocation())>10) {
        m_touchMove=true;
    }
}
void UIEquipCell::onTouchEnded(Touch* touch, Event* event){
    if (isTouchInside(m_touchNode,touch) && m_touchMove==false) {
        ResourseController::getInstance()->setEquipedResInUIByPos(m_pos);
    }
}

#pragma mark TouchUI
static TouchUI* touchUI = NULL;

TouchUI* TouchUI::getInstance()
{
    if (!touchUI)
    {
        touchUI = new TouchUI();
        touchUI->init();
    }
    return touchUI;
}

bool TouchUI::init()
{
    if ( !Node::init() ){
        return false;
    }
    m_uiDelegate=nullptr;
    m_isLeftTouch=false;
    m_isScrollingLeft=false;
    m_isNodeTouch=false;
    m_isSettingUI=false;
    m_showType=UIShowType_Normal;
    
//    SpriteFrameCache::getInstance()->addSpriteFramesWithFile("Common/Common_1.plist");
    CCBLoadFile("TouchUI",this,this);
    m_layerCover->setOpacity(0);
    m_hintNode->setScaleY(0);
    
    listener = EventListenerTouchOneByOne::create();
    listener->onTouchBegan = CC_CALLBACK_2(TouchUI::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(TouchUI::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(TouchUI::onTouchEnded, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    listener->setSwallowTouches(true);
    
    return true;
}

void TouchUI::onEnter(){
    Node::onEnter();
    __NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TouchUI::refreshEquipNode), "TouchUI::refreshEquipNode", NULL);
    m_isScrollingLeft=false;
    listener->setSwallowTouches(true);
    refreshEquipNode(nullptr);
}
void TouchUI::onExit(){
    __NotificationCenter::getInstance()->removeObserver(this, "TouchUI::refreshEquipNode");
    Node::onExit();
}

//刷新物品UI
void TouchUI::refreshEquipNode(Ref* ref){
//    if(ResourseController::getInstance()->getEquipedResInUI()==nullptr){
//        ResourseController::getInstance()->setEquipedResInUIByPos(0);
//    }
    int bagValue = PlayerController::getInstance()->getBagValue();
    for (int i=0; i<bagValue; i++) {
        if(m_equipNode->getChildByTag(i)){
            UIEquipCell* cell = dynamic_cast<UIEquipCell*>(m_equipNode->getChildByTag(i));
            cell->setData(i,bagValue);
        }else{
            UIEquipCell* cell = UIEquipCell::create(i,bagValue);
            cell->setTag(i);
            m_equipNode->addChild(cell);
        }
    }
}


bool TouchUI::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_layerCover", LayerColor*, m_layerCover);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_downUiNode", Node*, m_downUiNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_yaoGanerNode", Node*, m_yaoGanerNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_yaoGanerSpr", Sprite*, m_yaoGanerSpr);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_yaoGanerSprBg", Sprite*, m_yaoGanerSprBg);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn1", ControlButton*, m_btn1);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn2", ControlButton*, m_btn2);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn2", ControlButton*, m_btn3);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn4", ControlButton*, m_btn4);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn5", ControlButton*, m_btn5);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn6", ControlButton*, m_btn6);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_leftBtnNode1", Node*, m_leftBtnNode1);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_leftBtnNode2", Node*, m_leftBtnNode2);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_leftBtnNode3", Node*, m_leftBtnNode3);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipNode", Node*, m_equipNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_coverNode", Node*, m_coverNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_hintNode", Node*, m_hintNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_hintBg", LayerColor*, m_hintBg);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_hintTxt", Label*, m_hintTxt);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_addViewNode", Node*, m_addViewNode);

    return false;
}
cocos2d::extension::Control::Handler TouchUI::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtn1Click", TouchUI::onBtn1Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtn2Click", TouchUI::onBtn2Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtn3Click", TouchUI::onBtn3Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtn4Click", TouchUI::onBtn4Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtn5Click", TouchUI::onBtn5Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtn6Click", TouchUI::onBtn6Click);
    return NULL;
}

bool TouchUI::onTouchBegan(Touch* touch, Event* event){
    if(m_isSettingUI){
        return true;
    }
    if(isTouchInside(m_yaoGanerSprBg,touch)){
        m_isLeftTouch=true;
        return true;
    }
    if(isTouchInside(m_btn1,touch) || isTouchInside(m_btn2,touch) || isTouchInside(m_btn3,touch) || isTouchInside(m_coverNode,touch)){
        m_isNodeTouch=false;
        return true;
    }
    if(isTouchInside(m_touchNode,touch)){
        m_isNodeTouch=true;
        return true;
    }
    return true;
}
void TouchUI::onTouchMoved(Touch* touch, Event* event){
    if(m_isSettingUI){
        return;
    }
    if(listener->isSwallowTouches() && m_isLeftTouch){
        Point touchPoint = touch->getLocation();
        Point center = m_yaoGanerNode->getPosition();
        float distance = touchPoint.getDistance(center);
        if(distance<=MAX_DISTANCE){
            m_yaoGanerSpr->setPosition(m_yaoGanerSpr->getParent()->convertToNodeSpace(touchPoint));
        }else{
            float px = MAX_DISTANCE*(touchPoint.x-center.x)/distance;
            float py = MAX_DISTANCE*(touchPoint.y-center.y)/distance;
            m_yaoGanerSpr->setPosition(px, py);
        }
        if(m_isScrollingLeft==false){
            m_isScrollingLeft=true;
            this->unschedule(schedule_selector(TouchUI::OnScrollLeft));
            this->schedule(schedule_selector(TouchUI::OnScrollLeft));
            PlayerController::getInstance()->OnUIStartScrollLeft(m_yaoGanerSpr->getPosition());
        }
    }
    if(listener->isSwallowTouches() && m_isNodeTouch){
        if(touch->getLocation().getDistance(touch->getStartLocation())>2){
            m_isNodeTouch=false;
        }
    }
}
void TouchUI::onTouchEnded(Touch* touch, Event* event){
    if(m_isSettingUI){
        return;
    }
    m_isLeftTouch=false;
    m_isScrollingLeft=false;
    if(listener->isSwallowTouches() && m_isNodeTouch){
        m_isNodeTouch=false;
        PlayerController::getInstance()->playerMoveTo(touch->getLocation());
    }
}

void TouchUI::OnScrollLeft(float dt){
    if(m_isScrollingLeft==false){
        this->unschedule(schedule_selector(TouchUI::OnScrollLeft));
        PlayerController::getInstance()->OnUIStopScrollLeft(m_yaoGanerSpr->getPosition());
        m_yaoGanerSpr->setPosition(0, 0);
    }
    if(m_uiDelegate){
        PlayerController::getInstance()->OnUIScrollLeft(m_yaoGanerSpr->getPosition());
    }
}

void TouchUI::onBtn1Click(Ref* pSender, Control::EventType event){
    CCLOG("onBtn1Click");
    if(m_isSettingUI){
        return;
    }
    Role* playerTarget = PlayerController::getInstance()->player->m_target;
    if(playerTarget){
        m_btn1->setEnabled(false);
        if (playerTarget->m_roleType==RoleType_Resource) {
            m_btn1LeftCD=0;
            m_btn1->setEnabled(true);
        }else if (playerTarget->m_roleType==RoleType_Building){
            m_btn1LeftCD=0;
            m_btn1->setEnabled(true);
        }else{
            m_btn1LeftCD = PlayerController::getInstance()->player->m_fightValue.m_attackCD;
            this->schedule(schedule_selector(TouchUI::TouchUISchedule), 1.0f);
            //cd动画
            Sprite *s=CommonUtils::createSprite("UI_btn1_1.png");
            ProgressTimer *pt=ProgressTimer::create(s);
            pt->setScale(m_btn1->getScale());
            pt->setPosition(m_btn1->getPosition());
            pt->setType(cocos2d::ProgressTimer::Type(ProgressTimer::Type::RADIAL));//转圈的CD实现
            //pt->setType(cocos2d::CCProgressTimerType(kCCProgressTimerTypeBar));//从中间到外的出现
            m_downUiNode->addChild(pt,1);
            ProgressTo *t=ProgressTo::create(m_btn1LeftCD,100);
            pt->runAction(t);
            pt->setTag(100);
        }
        PlayerController::getInstance()->player->doActionToTarget();
    }else{
        Resourse* resourse = ResourseController::getInstance()->getEquipedResInUI();
        if(resourse && resourse->m_useType==UseType_UseInUI){
            PlayerController::getInstance()->player->doActionWithEquipedUIRes(resourse);
        }else{
            CCLOG("没有目标");
            flyHint("没有目标");
        }
    }
}
void TouchUI::onBtn2Click(Ref* pSender, Control::EventType event){
    CCLOG("onBtn2Click");
    if(m_isSettingUI){
        return;
    }
    setUiByType(UIShowType_Lookout);
    if(listener->isSwallowTouches()==false){
        m_uiDelegate->OnTouchUIRelease(this,callfunc_selector(TouchUI::startUseTouchUI));
    }else{
        listener->setSwallowTouches(false);
    }
}
void TouchUI::onBtn3Click(Ref* pSender, Control::EventType event){
    CCLOG("onBtn3Click");
    if(m_isSettingUI){
        return;
    }
    EquipView* equipView = EquipView::create();
    m_addViewNode->addChild(equipView);
}

void TouchUI::onBtn4Click(Ref* pSender, Control::EventType event){
    CCLOG("onBtn4Click");
    if(m_isSettingUI){
        return;
    }
    setUiByType(UIShowType_Normal);
    RolesController::getInstance()->layVirtualBuild();
}
void TouchUI::onBtn5Click(Ref* pSender, Control::EventType event){
    CCLOG("onBtn5Click");
    if(m_isSettingUI){
        return;
    }
    setUiByType(UIShowType_Normal);
    RolesController::getInstance()->removeVirtualBuildFromTiledMap();
}
void TouchUI::onBtn6Click(Ref* pSender, Control::EventType event){
    CCLOG("onBtn6Click");
    if(m_isSettingUI){
        return;
    }
    setUiByType(UIShowType_Normal);
    if(listener->isSwallowTouches()==false){
        m_uiDelegate->OnTouchUIRelease(this,callfunc_selector(TouchUI::startUseTouchUI));
    }else{
        listener->setSwallowTouches(false);
    }
}

void TouchUI::startUseTouchUI(){
    listener->setSwallowTouches(true);
}

void TouchUI::setUiDelegate(UIDelegate* delegate){
    m_uiDelegate = delegate;
}

void TouchUI::TouchUISchedule(float dt){
    m_btn1LeftCD--;
    if(m_btn1LeftCD<=0){
        m_btn1LeftCD=0;
        m_btn1->setEnabled(true);
        this->unschedule(schedule_selector(TouchUI::TouchUISchedule));
        if(m_downUiNode->getChildByTag(100)){
            m_downUiNode->removeChildByTag(100);
        }
    }
}

void TouchUI::addToLayer(Layer* layer){
    if(touchUI->getParent()){
        touchUI->retain();
        touchUI->removeFromParent();
    }
//    setUiDelegate(layer);
    layer->addChild(touchUI);
}

void TouchUI::flyHint(string txt,float time/* = 3*/){
    m_hintNode->stopAllActions();
    m_hintNode->setScaleY(0);
    if(m_hintNode->getScaleY()==0){
        m_hintTxt->setString(txt);
        Size txtSize = m_hintTxt->getContentSize();
        m_hintBg->setContentSize(txtSize);
        
        ScaleTo* scaleTo1 = ScaleTo::create(0.2, 1);
        DelayTime* delay = DelayTime::create(time);
        ScaleTo* scaleTo2 = ScaleTo::create(0.2, 1, 0);
        m_hintNode->runAction(Sequence::create(scaleTo1,delay,scaleTo2, NULL));
    }
}

void TouchUI::setUiByType(UIShowType showType){
    m_showType = showType;
    m_isSettingUI=true;
    float aniTime = 0.2;
    if (m_showType==UIShowType_Normal) {
        m_yaoGanerNode->setPositionY(-200);
        m_leftBtnNode1->setPositionY(-300);
        m_equipNode->setPositionY(-290);
        
        MoveTo* moveTo1 = MoveTo::create(aniTime, Vec2(100, 100));
        DelayTime* delayTime1 = DelayTime::create(aniTime);
        m_yaoGanerNode->runAction(Sequence::create(delayTime1,moveTo1, NULL));
        MoveTo* moveTo2 = MoveTo::create(aniTime, Vec2(0, 0));
        DelayTime* delayTime2 = DelayTime::create(aniTime);
        m_leftBtnNode1->runAction(Sequence::create(delayTime2,moveTo2, NULL));
        MoveTo* moveTo3 = MoveTo::create(aniTime, Vec2(568, 10));
        DelayTime* delayTime3 = DelayTime::create(aniTime);
        m_equipNode->runAction(Sequence::create(delayTime3,moveTo3, NULL));
        
        MoveTo* moveTo4 = MoveTo::create(aniTime, Vec2(0, -200));
        m_leftBtnNode2->runAction(moveTo4);
        MoveTo* moveTo5 = MoveTo::create(aniTime, Vec2(0, -300));
        m_leftBtnNode3->runAction(moveTo5);
    }else if (m_showType==UIShowType_Lookout){
        m_leftBtnNode3->setPositionY(-300);
        
        MoveTo* moveTo5 = MoveTo::create(aniTime, Vec2(0, -180));
        DelayTime* delayTime1 = DelayTime::create(aniTime);
        m_leftBtnNode3->runAction(Sequence::create(delayTime1,moveTo5, NULL));
        
        MoveTo* moveTo1 = MoveTo::create(aniTime, Vec2(100, -200));
        m_yaoGanerNode->runAction(moveTo1);
        MoveTo* moveTo2 = MoveTo::create(aniTime, Vec2(0, -300));
        m_leftBtnNode1->runAction(moveTo2);
        MoveTo* moveTo3 = MoveTo::create(aniTime, Vec2(568, -290));
        m_equipNode->runAction(moveTo3);
        MoveTo* moveTo4 = MoveTo::create(aniTime, Vec2(0, -200));
        m_leftBtnNode2->runAction(moveTo4);
    }else if (m_showType==UIShowType_VirtualBuild){
        m_yaoGanerNode->setPositionY(-200);
        m_leftBtnNode2->setPositionY(-200);
        
        MoveTo* moveTo1 = MoveTo::create(aniTime, Vec2(100, 100));
        DelayTime* delayTime1 = DelayTime::create(aniTime);
        m_yaoGanerNode->runAction(Sequence::create(delayTime1,moveTo1, NULL));
        MoveTo* moveTo4 = MoveTo::create(aniTime, Vec2(0, 0));
        DelayTime* delayTime2 = DelayTime::create(aniTime);
        m_leftBtnNode2->runAction(Sequence::create(delayTime2,moveTo4, NULL));
        
        MoveTo* moveTo2 = MoveTo::create(aniTime, Vec2(0, -300));
        m_leftBtnNode1->runAction(moveTo2);
        MoveTo* moveTo3 = MoveTo::create(aniTime, Vec2(568, -290));
        m_equipNode->runAction(moveTo3);
        MoveTo* moveTo5 = MoveTo::create(aniTime, Vec2(0, -300));
        m_leftBtnNode3->runAction(moveTo5);
    }
    this->scheduleOnce(schedule_selector(TouchUI::onSetUIFinish), aniTime*2);
}

void TouchUI::onSetUIFinish(float dt){
    m_isSettingUI=false;
    if (m_showType==UIShowType_Normal) {
        m_yaoGanerNode->setPosition(Vec2(100, 100));
        m_leftBtnNode1->setPosition(Vec2(0, 0));
        m_equipNode->setPosition(Vec2(568, 10));
        m_leftBtnNode2->setPosition(Vec2(0, -200));
        m_leftBtnNode3->setPosition(Vec2(0, -300));
    }else if (m_showType==UIShowType_Lookout){
        m_yaoGanerNode->setPosition(Vec2(100, -200));
        m_leftBtnNode1->setPosition(Vec2(0, -300));
        m_equipNode->setPosition(Vec2(568, -290));
        m_leftBtnNode2->setPosition(Vec2(0, -200));
        m_leftBtnNode3->setPosition(Vec2(0, -180));
    }else if (m_showType==UIShowType_VirtualBuild){
        m_yaoGanerNode->setPosition(Vec2(100, 100));
        m_leftBtnNode1->setPosition(Vec2(0, -300));
        m_equipNode->setPosition(Vec2(568, -290));
        m_leftBtnNode2->setPosition(Vec2(0, 0));
        m_leftBtnNode3->setPosition(Vec2(0, -300));
    }
}

void TouchUI::addViewToUi(Node* view){
    m_addViewNode->removeAllChildrenWithCleanup(true);
    m_addViewNode->addChild(view);
}
