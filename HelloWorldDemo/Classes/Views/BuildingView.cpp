//
//  BuildingView.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/17.
//
//

#include "BuildingView.hpp"

BuildingView* BuildingView::createWithBuilding(Building* building)
{
    BuildingView *pRet = new(std::nothrow) BuildingView();
    if (pRet && pRet->initWithBuilding(building))
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

bool BuildingView::initWithBuilding(Building* building){
    if ( !TouchNode::init() ){
        return false;
    }
    CCBLoadFile("BuildingView",this,this);
    m_bg->setOpacity(100);
    m_building=building;
    m_TitleTxt->setString("BuildingView");
    refreshData(nullptr);
    return true;
}

void BuildingView::refreshData(Ref* ref){
    if(m_building->m_roleSpriteFrame){
        m_buildSpr->setSpriteFrame(m_building->m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(m_buildSpr, 100);
    }
    m_buildDes->setString(m_building->m_selfValue.m_description);
    if (m_building->m_buildingState==BuildingState_Building) {
        log("build");
        m_buildStartNode->setVisible(true);
        m_buildingNode->setVisible(false);
        CommonUtils::setButtonTitle(m_buildBtn,"build");
        
        int mapSize = m_building->m_buildNeedMap.size();
        map<string,int>::iterator it = m_building->m_buildNeedMap.begin();
//        for (int i=0; i<mapSize; i++,it++) {
//            
//        }

        m_resNode1->setVisible(true);
        string sprStr = CommonUtils::getPropById(it->first, "icon");
        Sprite* iconSpr = CommonUtils::createSprite(sprStr);
        CommonUtils::setSpriteMaxSize(iconSpr, 80, true);
        m_resIcon1->addChild(iconSpr);
        string resStr = string(CC_ITOA(m_building->m_buildHaveMap[it->first])).append("/").append(CC_ITOA(it->second));
        m_resTxt1->setString(resStr);
    }else if (m_building->m_buildingState==BuildingState_Damage){
        log("mend");
        m_buildStartNode->setVisible(false);
        m_buildingNode->setVisible(true);
        CommonUtils::setButtonTitle(m_buildBtn,"mend");
    }else if (m_building->m_buildingState==BuildingState_Finish){
        log("look");
        m_buildStartNode->setVisible(false);
        m_buildingNode->setVisible(true);
        CommonUtils::setButtonTitle(m_buildBtn,"upgreat");
    }
}

void BuildingView::onEnter(){
    TouchNode::onEnter();
    //    __NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BuildingView::refreshData), "BuildingView::refreshData", NULL);
}

void BuildingView::onExit(){
    //    __NotificationCenter::getInstance()->removeObserver(this, "BuildingView::refreshData");
    TouchNode::onExit();
}

bool BuildingView::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_closeBtn", ControlButton*, m_closeBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bg", Scale9Sprite*, m_bg);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_buildBtn", ControlButton*, m_buildBtn);
    
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_removeBtn", ControlButton*, m_removeBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_TitleTxt", Label*, m_TitleTxt);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_buildDes", Label*, m_buildDes);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_buildSpr", Sprite*, m_buildSpr);
    
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_buildStartNode", Node*, m_buildStartNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resNode1", Node*, m_resNode1);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resIcon1", Node*, m_resIcon1);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resTxt1", Label*, m_resTxt1);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_buildingNode", Node*, m_buildingNode);
    
    return false;
}
cocos2d::extension::Control::Handler BuildingView::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onCloseBtnClick", BuildingView::onCloseBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBuildBtnClick", BuildingView::onBuildBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onRemoveBtnClick", BuildingView::onRemoveBtnClick);
    
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onResBtn1Click", BuildingView::onResBtn1Click);
    return NULL;
}

void BuildingView::onCloseBtnClick(Ref* pSender, Control::EventType event){
    this->removeFromParent();
}
void BuildingView::onBuildBtnClick(Ref* pSender, Control::EventType event){
    log("onBuildBtnClick");
}
void BuildingView::onRemoveBtnClick(Ref* pSender, Control::EventType event){
    log("onRemoveBtnClick");
}

void BuildingView::onResBtn1Click(Ref* pSender, Control::EventType event){
    log("onResBtn1Click");
}

bool BuildingView::onTouchBegan(Touch* touch, Event* event){
    m_isClose=false;
    if (isTouchInside(m_touchNode,touch)==false) {
        m_isClose=true;
        return true;
    }
    return true;
}
void BuildingView::onTouchMoved(Touch* touch, Event* event){
    
}
void BuildingView::onTouchEnded(Touch* touch, Event* event){
    if (isTouchInside(m_touchNode,touch)==false && m_isClose) {
        this->removeFromParent();
    }
}
