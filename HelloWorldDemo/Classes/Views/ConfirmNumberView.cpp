//
//  ConfirmNumberView.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/17.
//
//

#include "ConfirmNumberView.hpp"

ConfirmNumberView* ConfirmNumberView::createWithItemId(string itemId)
{
    ConfirmNumberView *pRet = new(std::nothrow) ConfirmNumberView();
    if (pRet && pRet->initWithItemId(itemId))
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

bool ConfirmNumberView::initWithItemId(string itemId){
    if ( !TouchNode::init() ){
        return false;
    }
    CCBLoadFile("ConfirmNumberView",this,this);
    m_bg->setOpacity(100);
    m_itemId=itemId;
    
    Sprite* spr1=CommonUtils::createSprite("UI_huadongtiao3.png");
    Sprite* spr2=CommonUtils::createSprite("UI_huadongtiao4.png");
    Sprite* spr3=CommonUtils::createSprite("UI_huadongtiao1.png");
    slider=ControlSlider::create(spr1, spr2, spr3);
    slider->setMinimumValue(0);
    slider->setMaximumValue(100);
    slider->addTargetWithActionForControlEvents(this, cccontrol_selector(ConfirmNumberView::sliderCallBack), Control::EventType::VALUE_CHANGED);
    m_sliderNode->addChild(slider);
    
    
    refreshData(nullptr);
    return true;
}

//slider
void ConfirmNumberView::sliderCallBack(Ref* pSender, Control::EventType event){
    int sValue = slider->getValue();
    string sNum = CC_ITOA(sValue);
    m_sliderValueTxt->setString(sNum);
}

void ConfirmNumberView::setSliderMaxValue(int maxValue){
    slider->setMaximumValue(maxValue);
    slider->setValue(maxValue);
}

void ConfirmNumberView::refreshData(Ref* ref){
    string sprStr = CommonUtils::getPropById(m_itemId, "icon");
    Sprite* iconSpr = CommonUtils::createSprite(sprStr);
    CommonUtils::setSpriteMaxSize(iconSpr, 80, true);
    m_icon->addChild(iconSpr);
}

void ConfirmNumberView::onEnter(){
    TouchNode::onEnter();
    //    __NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(ConfirmNumberView::refreshData), "ConfirmNumberView::refreshData", NULL);
}

void ConfirmNumberView::onExit(){
    //    __NotificationCenter::getInstance()->removeObserver(this, "ConfirmNumberView::refreshData");
    TouchNode::onExit();
}

bool ConfirmNumberView::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_closeBtn", ControlButton*, m_closeBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bg", Scale9Sprite*, m_bg);
   
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_confirmBtn", ControlButton*, m_confirmBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_addBtn", ControlButton*, m_addBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_delBtn", ControlButton*, m_delBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_desTxt", Label*, m_desTxt);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_icon", Node*, m_icon);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_sliderNode", Node*, m_sliderNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_sliderValueTxt", Label*, m_sliderValueTxt);
        
    return false;
}
cocos2d::extension::Control::Handler ConfirmNumberView::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onCloseBtnClick", ConfirmNumberView::onCloseBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onConfirmBtnClick", ConfirmNumberView::onConfirmBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onDelBtnClick", ConfirmNumberView::onDelBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onAddBtnClick", ConfirmNumberView::onAddBtnClick);

    return NULL;
}

void ConfirmNumberView::onCloseBtnClick(Ref* pSender, Control::EventType event){
    this->removeFromParent();
}
void ConfirmNumberView::onConfirmBtnClick(Ref* pSender, Control::EventType event){
    log("onConfirmBtnClick");
    int sValue = slider->getValue();
    m_delegate->onConfirmWithValue(sValue,m_itemId);
    this->removeFromParent();
}
void ConfirmNumberView::onDelBtnClick(Ref* pSender, Control::EventType event){
    log("onDelBtnClick");
    int sValue = slider->getValue();
    if(sValue>=1){
        slider->setValue(sValue-1);
    }
}
void ConfirmNumberView::onAddBtnClick(Ref* pSender, Control::EventType event){
    log("onAddBtnClick");
    int sValue = slider->getValue();
    if(sValue<=99){
        slider->setValue(sValue+1);
    }
}

bool ConfirmNumberView::onTouchBegan(Touch* touch, Event* event){
    m_isClose=false;
    if (isTouchInside(m_touchNode,touch)==false) {
        m_isClose=true;
        return true;
    }
    return true;
}
void ConfirmNumberView::onTouchMoved(Touch* touch, Event* event){
    
}
void ConfirmNumberView::onTouchEnded(Touch* touch, Event* event){
    if (isTouchInside(m_touchNode,touch)==false && m_isClose) {
        this->removeFromParent();
    }
}
