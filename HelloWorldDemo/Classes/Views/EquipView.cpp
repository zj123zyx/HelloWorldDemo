//
//  EquipView.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/27.
//
//

#include "EquipView.hpp"
#include "ResourseController.hpp"
#include "PlayerController.hpp"

static const float EquipBagNodeH = 320.0;
static const float EquipBagNodeW = 450.0;
static const float EquipBagCellH = 75.0;
static const float EquipBagCellW = 75.0;

#pragma mark EquipBagCell
EquipBagCell* EquipBagCell::create(int pos,int sum){
    EquipBagCell *pRet = new(std::nothrow) EquipBagCell();
    if (pRet && pRet->init(pos,sum)){
        pRet->autorelease();
        return pRet;
    }else{
        delete pRet;
        pRet = nullptr;
        return nullptr;
    }
}

bool EquipBagCell::init(int pos,int sum){
    if ( !Node::init() ){
        return false;
    }
    auto node = CCBLoadFile("EquipBagCell",this,this);
    this->setContentSize(node->getContentSize());
    
    m_pos = pos;
    m_sum = sum;
    float dx = (EquipBagNodeW-(EquipBagCellW*5))/6;
    float px = dx+((m_pos%5)*(EquipBagCellW+dx));
    float py = (m_sum/5+1)*(EquipBagCellH+dx)-((m_pos/5+1)*(EquipBagCellH+dx));
    this->setPosition(px, py);
    
    setData(m_pos,m_sum);
    
    return true;
}

void EquipBagCell::setData(int pos,int sum){
    m_pos = pos;
    m_sum = sum;
    m_numNode->setVisible(false);
    if(ResourseController::getInstance()->m_resourseMap.find(pos)!=ResourseController::getInstance()->m_resourseMap.end()){
        Resourse* resourse = ResourseController::getInstance()->m_resourseMap[pos];
        auto spr = Sprite::createWithSpriteFrame(resourse->m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(spr, 64);
        m_iconNode->addChild(spr);
        if(resourse->m_resourceMaxValue>1){
            m_numNode->setVisible(true);
            string num = CC_ITOA(resourse->m_resourceValue);// __String::createWithFormat("%d",resourse->m_resourceValue)->getCString();
            m_numTxt->setString(num);
        }
    }
}
void EquipBagCell::onEnter(){
    TouchNode::onEnter();
}
void EquipBagCell::onExit(){
    TouchNode::onExit();
}

bool EquipBagCell::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_iconNode", Node*, m_iconNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_numNode", Node*, m_numNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_numTxt", Label*, m_numTxt);

    return false;
}
cocos2d::extension::Control::Handler EquipBagCell::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    return NULL;
}

bool EquipBagCell::onTouchBegan(Touch* touch, Event* event){
//    m_isClose=false;
//    if (isTouchInside(m_touchNode,touch)==false) {
//        m_isClose=true;
//    }
    return false;
}
void EquipBagCell::onTouchMoved(Touch* touch, Event* event){
    
}
void EquipBagCell::onTouchEnded(Touch* touch, Event* event){
//    if (isTouchInside(m_touchNode,touch)==false && m_isClose) {
//        this->removeFromParent();
//    }
}


#pragma mark EquipView
bool EquipView::init(){
    if ( !TouchNode::init() ){
        return false;
    }
    CCBLoadFile("EquipView",this,this);

    m_bg->setOpacity(100);
    
    int bagValue = PlayerController::getInstance()->getBagValue();
    m_scrollView = ScrollView::create(m_bagListNode->getContentSize());
    m_scrollView->setDirection(cocos2d::extension::ScrollView::Direction::VERTICAL);
    for (int i=0; i<bagValue; i++) {
        Node* cell = EquipBagCell::create(i,bagValue);
        m_scrollView->addChild(cell);
    }
    float dx = (EquipBagNodeW-(EquipBagCellW*5))/6;
    float cy = (bagValue/5+1)*(EquipBagCellH+dx);
    
    m_scrollView->setContentSize(Size(m_bagListNode->getContentSize().width, cy));
    m_scrollView->setContentOffset(Vec2(0, EquipBagNodeH-cy));
    m_bagListNode->addChild(m_scrollView);
    
    return true;
}
void EquipView::onEnter(){
    TouchNode::onEnter();
}
void EquipView::onExit(){
    TouchNode::onExit();
}

bool EquipView::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_closeBtn", ControlButton*, m_closeBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bg", Scale9Sprite*, m_bg);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bagListNode", Node*, m_bagListNode);

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
