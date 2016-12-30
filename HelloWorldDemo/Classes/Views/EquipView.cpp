//
//  EquipView.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/27.
//
//

#include "EquipView.hpp"

bool EquipView::init(){
    if ( !Node::init() ){
        return false;
    }
    CCBLoadFile("EquipView",this,this);

    m_bg->setOpacity(100);
    return true;
}
void EquipView::onEnter(){
    Node::onEnter();
    listener = EventListenerTouchOneByOne::create();
    listener->onTouchBegan = CC_CALLBACK_2(EquipView::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(EquipView::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(EquipView::onTouchEnded, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    listener->setSwallowTouches(true);
}
void EquipView::onExit(){
    _eventDispatcher->removeEventListener(listener);
    Node::onExit();
}

bool EquipView::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_closeBtn", ControlButton*, m_closeBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bg", Scale9Sprite*, m_bg);

    return false;
}
cocos2d::extension::Control::Handler EquipView::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onCloseBtnClick", EquipView::onCloseBtnClick);
    return NULL;
}

void EquipView::onCloseBtnClick(Ref* pSender, Control::EventType event){
    this->removeFromParent();
}

bool EquipView::onTouchBegan(Touch* touch, Event* event){
    m_isClose=false;
    if (isTouchInside(m_touchNode,touch)==false) {
        m_isClose=true;
    }
    return true;
}
void EquipView::onTouchMoved(Touch* touch, Event* event){

}
void EquipView::onTouchEnded(Touch* touch, Event* event){
    if (isTouchInside(m_touchNode,touch)==false && m_isClose) {
        this->removeFromParent();
    }
}
