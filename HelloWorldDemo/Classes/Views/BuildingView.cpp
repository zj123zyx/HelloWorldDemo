//
//  BuildingView.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/17.
//
//

#include "BuildingView.hpp"
#include "ResourseController.hpp"
#include "TouchUI.h"

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
    resIdVec.clear();
    if(m_building->m_roleSpriteFrame){
        m_buildSpr->setSpriteFrame(m_building->m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(m_buildSpr, 100);
    }
    m_buildDes->setString(m_building->m_selfValue.m_description);
    
    float progress = m_building->m_buildProgress;
    float maxProgress = MAX(m_building->m_MAXbuildProgress,1);
    
    string progressStr = string(CC_ITOA(progress)).append("/").append(CC_ITOA(maxProgress));
    m_progressTxt->setString(progressStr);
    m_progressBar->setScaleX(progress/maxProgress);
    
    if (m_building->m_buildingState==BuildingState_StartBuild) {
        log("build");
        m_buildStartNode->setVisible(true);
        m_buildingNode->setVisible(false);
        CommonUtils::setButtonTitle(m_buildBtn,"build");
        bool canBuild=true;
        m_resNode[0]->setVisible(false);
        m_resNode[1]->setVisible(false);
        m_resNode[2]->setVisible(false);
        m_resNode[3]->setVisible(false);
        unsigned long mapSize = m_building->m_buildNeedMap.size();
        map<string,int>::iterator it = m_building->m_buildNeedMap.begin();
        for (int i=0; i<mapSize; i++,it++) {
            float px = (i-(mapSize-1.0)/2.0) * 90.0;
            m_resNode[i]->setPositionX(px);
            m_resNode[i]->setVisible(true);
            string sprStr = CommonUtils::getPropById(it->first, "icon");
            Sprite* iconSpr = CommonUtils::createSprite(sprStr);
            CommonUtils::setSpriteMaxSize(iconSpr, 80, true);
            m_resIcon[i]->addChild(iconSpr);
            
            int needNum = it->second;
            int haveNum = m_building->m_buildHaveMap[it->first];
            string resStr = string(CC_ITOA(haveNum)).append("/").append(CC_ITOA(needNum));
            m_resTxt[i]->setString(resStr);
            if(haveNum<needNum){
                canBuild=false;
            }
            resIdVec.push_back(it->first);
        }
        m_buildBtn->setEnabled(canBuild);

        CommonUtils::setButtonTitle(m_buildBtn,"build");
        m_buildStartNode->setVisible(true);
        m_buildingNode->setVisible(false);
    }else if (m_building->m_buildingState==BuildingState_Building){
        m_buildStartNode->setVisible(false);
        m_buildingNode->setVisible(true);
        CommonUtils::setButtonTitle(m_buildBtn,"building");
    }else if (m_building->m_buildingState==BuildingState_Damage){
        log("mend");
        m_buildStartNode->setVisible(false);
        m_buildingNode->setVisible(true);
        CommonUtils::setButtonTitle(m_buildBtn,"mend");
    }else if (m_building->m_buildingState==BuildingState_Finish){
        log("look");
        m_buildStartNode->setVisible(false);
        m_buildingNode->setVisible(true);
//        CommonUtils::setButtonTitle(m_buildBtn,"upgreat");
        m_buildBtn->setVisible(false);
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
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resNode1", Node*, m_resNode[0]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resNode2", Node*, m_resNode[1]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resNode3", Node*, m_resNode[2]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resNode4", Node*, m_resNode[3]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resIcon1", Node*, m_resIcon[0]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resIcon2", Node*, m_resIcon[1]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resIcon3", Node*, m_resIcon[2]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resIcon4", Node*, m_resIcon[3]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resTxt1", Label*, m_resTxt[0]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resTxt2", Label*, m_resTxt[1]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resTxt3", Label*, m_resTxt[2]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_resTxt4", Label*, m_resTxt[3]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_buildingNode", Node*, m_buildingNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_progressTxt", Label*, m_progressTxt);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_progressBar", Scale9Sprite*, m_progressBar);
    
    return false;
}
cocos2d::extension::Control::Handler BuildingView::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onCloseBtnClick", BuildingView::onCloseBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBuildBtnClick", BuildingView::onBuildBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onRemoveBtnClick", BuildingView::onRemoveBtnClick);
    
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onResBtn1Click", BuildingView::onResBtn1Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onResBtn2Click", BuildingView::onResBtn2Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onResBtn3Click", BuildingView::onResBtn3Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onResBtn4Click", BuildingView::onResBtn4Click);
    return NULL;
}

void BuildingView::onCloseBtnClick(Ref* pSender, Control::EventType event){
    this->removeFromParent();
}
void BuildingView::onBuildBtnClick(Ref* pSender, Control::EventType event){
    log("onBuildBtnClick");
    if (m_building->m_buildingState==BuildingState_StartBuild) {
        m_buildStartNode->setVisible(true);
        m_buildStartNode->setScale(1, 1);
        ScaleTo* scaleTo1 = ScaleTo::create(0.2, 1, 0);
        m_buildStartNode->runAction(scaleTo1);
        
        m_buildingNode->setVisible(true);
        m_buildingNode->setScale(1, 0);
        DelayTime* delayTime1 = DelayTime::create(0.2);
        ScaleTo* scaleTo2 = ScaleTo::create(0.2, 1, 1);

        m_buildingNode->runAction(Sequence::create(delayTime1,scaleTo2, NULL));
        m_building->m_buildingState=BuildingState_Building;
        CommonUtils::setButtonTitle(m_buildBtn,"building");
    }else if (m_building->m_buildingState==BuildingState_Building) {
        if(m_building->m_buildProgress<m_building->m_MAXbuildProgress){
            m_building->m_buildProgress++;
        }
        if(m_building->m_buildProgress==m_building->m_MAXbuildProgress){
            m_building->m_buildingState=BuildingState_Finish;
            m_building->buildFinish();
        }

        refreshData(nullptr);
    }
    
}
void BuildingView::onRemoveBtnClick(Ref* pSender, Control::EventType event){
    log("onRemoveBtnClick");
}

void BuildingView::onResBtn1Click(Ref* pSender, Control::EventType event){
    log("onResBtn1Click");
    showConfirmNumberView(0);
}
void BuildingView::onResBtn2Click(Ref* pSender, Control::EventType event){
    log("onResBtn2Click");
    showConfirmNumberView(1);
}
void BuildingView::onResBtn3Click(Ref* pSender, Control::EventType event){
    log("onResBtn3Click");
    showConfirmNumberView(2);
}
void BuildingView::onResBtn4Click(Ref* pSender, Control::EventType event){
    log("onResBtn4Click");
    showConfirmNumberView(3);
}

void BuildingView::showConfirmNumberView(int idx){
    int needNum = m_building->m_buildNeedMap[resIdVec[idx]]-m_building->m_buildHaveMap[resIdVec[idx]];
    int maxValue = 0;
    map<int, Resourse*>::iterator it = ResourseController::getInstance()->m_resourseMap.begin();
    for (; it!=ResourseController::getInstance()->m_resourseMap.end(); it++) {
        Resourse* resourse = it->second;
        if(resourse->m_selfValue.m_XMLId==resIdVec[idx]){
            int addValue = resourse->m_resourceValue<needNum?resourse->m_resourceValue:needNum;
            maxValue+=addValue;
            needNum-=addValue;
            if(needNum<=0){
                break;
            }
        }
    }
    if(maxValue>0){
        ConfirmNumberView* view = ConfirmNumberView::createWithItemId(resIdVec[idx]);
        view->setSliderMaxValue(maxValue);
        view->m_delegate = this;
        this->addChild(view);
    }else{
        if(m_building->m_buildNeedMap[resIdVec[idx]]-m_building->m_buildHaveMap[resIdVec[idx]]<=0){
            TouchUI::getInstance()->flyHint("资源已满");
        }else{
            TouchUI::getInstance()->flyHint("没有该资源");
        }
    }
}

void BuildingView::onConfirmWithValue(int value,string itemId){
    log("%d,%s",value,itemId.c_str());
    int costValue = value;
    map<int, Resourse*>::iterator it = ResourseController::getInstance()->m_resourseMap.begin();
    for (; it!=ResourseController::getInstance()->m_resourseMap.end(); it++) {
        Resourse* resourse = it->second;
        if(resourse->m_selfValue.m_XMLId==itemId){
            int addValue = resourse->m_resourceValue<costValue?resourse->m_resourceValue:costValue;
            ResourseController::getInstance()->costResourse(resourse, addValue);//消耗物品
            m_building->m_buildHaveMap[itemId]+=addValue;
            costValue-=addValue;
            if(costValue<=0){
                break;
            }
        }
    }
    ResourseController::getInstance()->deleteZeroValueResourse();//删除m_resourceValue=0的物品
    refreshData(nullptr);
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
