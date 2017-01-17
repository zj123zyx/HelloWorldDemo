//
//  BookCreateView.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#include "BookCreateView.hpp"
#include "PlayerController.hpp"
#include "VirtualBuild.hpp"

bool BookCreateView::init(){
    if ( !TouchNode::init() ){
        return false;
    }
    CCBLoadFile("BookCreateView",this,this);
    m_bg->setOpacity(100);
    refreshData(nullptr);
    return true;
}

void BookCreateView::refreshData(Ref* ref){

}

void BookCreateView::onEnter(){
    TouchNode::onEnter();
//    __NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BookCreateView::refreshData), "BookCreateView::refreshData", NULL);
}

void BookCreateView::onExit(){
//    __NotificationCenter::getInstance()->removeObserver(this, "BookCreateView::refreshData");
    TouchNode::onExit();
}

bool BookCreateView::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_closeBtn", ControlButton*, m_closeBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bg", Scale9Sprite*, m_bg);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn", ControlButton*, m_btn);
    
    return false;
}
cocos2d::extension::Control::Handler BookCreateView::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onCloseBtnClick", BookCreateView::onCloseBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtnClick", BookCreateView::onBtnClick);
    return NULL;
}

void BookCreateView::onCloseBtnClick(Ref* pSender, Control::EventType event){
    this->removeFromParent();
}
void BookCreateView::onBtnClick(Ref* pSender, Control::EventType event){
    VirtualBuild* vb = VirtualBuild::createWithBuildId("300000001");//home    
    PlayerController::getInstance()->player->layBuild(vb);
    this->removeFromParent();
}

bool BookCreateView::onTouchBegan(Touch* touch, Event* event){
    m_isClose=false;
    if (isTouchInside(m_touchNode,touch)==false) {
        m_isClose=true;
        return true;
    }
    return true;
}
void BookCreateView::onTouchMoved(Touch* touch, Event* event){
    
}
void BookCreateView::onTouchEnded(Touch* touch, Event* event){
    if (isTouchInside(m_touchNode,touch)==false && m_isClose) {
        this->removeFromParent();
    }
}
