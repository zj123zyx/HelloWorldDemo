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
    
    m_delegate = nullptr;
    m_resourse = nullptr;
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
    m_resourse = nullptr;
    m_pos = pos;
    m_sum = sum;
    m_numNode->setVisible(false);
    if(ResourseController::getInstance()->m_resourseMap.find(pos)!=ResourseController::getInstance()->m_resourseMap.end()){
        m_resourse = ResourseController::getInstance()->m_resourseMap[pos];
        auto spr = Sprite::createWithSpriteFrame(m_resourse->m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(spr, 64);
        m_iconNode->addChild(spr);
        if(m_resourse->m_resourceMaxValue>1){
            m_numNode->setVisible(true);
            string num = CC_ITOA(m_resourse->m_resourceValue);// __String::createWithFormat("%d",resourse->m_resourceValue)->getCString();
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
    if (m_delegate) {
        m_delegate->closePopNode();
    }
    m_touchMove=false;
    if (isTouchInside(m_touchNode,touch)) {
        return true;
    }
    return false;
}
void EquipBagCell::onTouchMoved(Touch* touch, Event* event){
    if(touch->getLocation().getDistance(touch->getStartLocation())>10){
        m_touchMove=true;
    }
}
void EquipBagCell::onTouchEnded(Touch* touch, Event* event){
    if (m_delegate && m_resourse && isTouchInside(m_touchNode,touch) && m_touchMove==false) {
        m_delegate->showPopNode(touch, m_resourse);
    }
}

#pragma mark EquipView
bool EquipView::init(){
    if ( !TouchNode::init() ){
        return false;
    }
    CCBLoadFile("EquipView",this,this);
    m_bg->setOpacity(100);
    m_scrollView = ScrollView::create(m_bagListNode->getContentSize());
    m_scrollView->setDirection(cocos2d::extension::ScrollView::Direction::VERTICAL);
    m_bagListNode->addChild(m_scrollView);
    refreshData(nullptr);
    setPage(1);
    return true;
}

void EquipView::refreshData(Ref* ref){
    m_bagUpTxt->setString("bag");
    //物品
    m_scrollView->getContainer()->removeAllChildren();
    int bagValue = PlayerController::getInstance()->getBagValue();
    for (int i=0; i<bagValue; i++) {
        EquipBagCell* cell = EquipBagCell::create(i,bagValue);
        cell->m_delegate = this;
        m_scrollView->addChild(cell);
    }
    float dx = (EquipBagNodeW-(EquipBagCellW*5))/6;
    float cy = (bagValue/5+1)*(EquipBagCellH+dx);
    
    m_scrollView->setContentSize(Size(m_bagListNode->getContentSize().width, cy));
    m_scrollView->setContentOffset(Vec2(0, EquipBagNodeH-cy));
    m_popNode1->setVisible(false);
    m_popNode2->setVisible(false);
    //装备
    for (int i=1; i<=6; i++) {
        m_equipNode[i]->removeAllChildren();
    }
    map<int, Equip*>::iterator eit = ResourseController::getInstance()->m_equipMap.begin();
    for (; eit!=ResourseController::getInstance()->m_equipMap.end(); eit++) {
        Equip* equip = eit->second;
        int equipType = equip->m_equipType;
        m_equipNode[equipType]->removeAllChildren();
        auto spr = Sprite::createWithSpriteFrame(equip->m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(spr, 64);
        spr->setTag(equipType);
        m_equipNode[equipType]->addChild(spr);
    }

    FightValues fightValue = PlayerController::getInstance()->player->m_fightValue;
    string infoStr = string("m_health:").append(CC_ITOA(fightValue.m_health)).append("\n").
                    append("m_attack:").append(CC_ITOA(fightValue.m_attack)).append("\n").
                    append("m_attackCD:").append(CC_ITOA(fightValue.m_attackCD)).append("\n").
                    append("m_attackRange:").append(CC_ITOA(fightValue.m_attackRange)).append("\n").
                    append("m_defense:").append(CC_ITOA(fightValue.m_defense)).append("\n").
                    append("m_moveSpeed:").append(CC_ITOA(fightValue.m_moveSpeed));
    
    m_playerInfoTxt->setString(infoStr);
}

void EquipView::onEnter(){
    TouchNode::onEnter();
    __NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(EquipView::refreshData), "EquipView::refreshData", NULL);
}

void EquipView::onExit(){
    __NotificationCenter::getInstance()->removeObserver(this, "EquipView::refreshData");
    TouchNode::onExit();
}

bool EquipView::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_touchNode", Node*, m_touchNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_closeBtn", ControlButton*, m_closeBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bg", Scale9Sprite*, m_bg);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bagUpTxt", Label*, m_bagUpTxt);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_bagListNode", Node*, m_bagListNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_popNode1", Node*, m_popNode1);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_popNode2", Node*, m_popNode2);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_popTxt", Label*, m_popTxt);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_popBtn1", ControlButton*, m_popBtn1);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_popBtn2", ControlButton*, m_popBtn2);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_popBtn3", ControlButton*, m_popBtn3);

    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipNode1", Node*, m_equipNode[1]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipNode2", Node*, m_equipNode[2]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipNode3", Node*, m_equipNode[3]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipNode4", Node*, m_equipNode[4]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipNode5", Node*, m_equipNode[5]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipNode6", Node*, m_equipNode[6]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipBg1", Sprite*, m_equipBg[1]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipBg2", Sprite*, m_equipBg[2]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipBg3", Sprite*, m_equipBg[3]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipBg4", Sprite*, m_equipBg[4]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipBg5", Sprite*, m_equipBg[5]);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipBg6", Sprite*, m_equipBg[6]);
    
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipBtn", ControlButton*, m_equipBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_infoBtn", ControlButton*, m_infoBtn);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_playerInfoNode", Node*, m_playerInfoNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_equipInfoNode", Node*, m_equipInfoNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_playerInfoTxt", Label*, m_playerInfoTxt);

    return false;
}
cocos2d::extension::Control::Handler EquipView::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onCloseBtnClick", EquipView::onCloseBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onPopBtn1Click", EquipView::onPopBtn1Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onPopBtn2Click", EquipView::onPopBtn2Click);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onPopBtn3Click", EquipView::onPopBtn3Click);
    
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onInfoBtnClick", EquipView::onInfoBtnClick);
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onEquipBtnClick", EquipView::onEquipBtnClick);
    return NULL;
}

void EquipView::onCloseBtnClick(Ref* pSender, Control::EventType event){
    this->removeFromParent();
}
void EquipView::onPopBtn1Click(Ref* pSender, Control::EventType event){
    if(m_resourse->m_useInBag){//在背包中使用
        log("使用");
    }else if (m_resourse->m_fightValue.m_useType==2){//可以在背包装备
        log("装备");
        ResourseController::getInstance()->equipResourse(dynamic_cast<Equip*>(m_resourse));
    }
}
void EquipView::onPopBtn2Click(Ref* pSender, Control::EventType event){
    log("丢弃");
    if(m_resourse){
        ResourseController::getInstance()->abandonResourse(m_resourse);
    }
    
}
void EquipView::onPopBtn3Click(Ref* pSender, Control::EventType event){
    log("卸下");
    ResourseController::getInstance()->unwieldResourse(dynamic_cast<Equip*>(m_resourse));
}

void EquipView::onEquipBtnClick(Ref* pSender, Control::EventType event){
    setPage(1);
}
void EquipView::onInfoBtnClick(Ref* pSender, Control::EventType event){
    setPage(2);
}

void EquipView::setPage(int page){
    if(page==1){
        m_equipBtn->setEnabled(false);
        m_equipInfoNode->setVisible(true);
        m_infoBtn->setEnabled(true);
        m_playerInfoNode->setVisible(false);
    }else if(page==2){
        m_equipBtn->setEnabled(true);
        m_equipInfoNode->setVisible(false);
        m_infoBtn->setEnabled(false);
        m_playerInfoNode->setVisible(true);
    }
}

bool EquipView::onTouchBegan(Touch* touch, Event* event){
    m_isClose=false;
    m_popNode2->setVisible(false);
    if (isTouchInside(m_touchNode,touch)==false) {
        m_isClose=true;
        return true;
    }
    return true;
}
void EquipView::onTouchMoved(Touch* touch, Event* event){

}
void EquipView::onTouchEnded(Touch* touch, Event* event){
    if (isTouchInside(m_touchNode,touch)==false && m_isClose) {
        this->removeFromParent();
    }else{
        for (int i=1; i<=6; i++) {
            if (isTouchInside(m_equipBg[i],touch) && m_equipNode[i]->getChildByTag(i)) {
                m_popNode2->setVisible(true);
                m_popNode2->setPosition(touch->getLocation());
                
                map<int, Equip*>::iterator eit = ResourseController::getInstance()->m_equipMap.begin();
                for (; eit!=ResourseController::getInstance()->m_equipMap.end(); eit++) {
                    Equip* equip = eit->second;
                    if(equip->m_equipType==i){
                        m_resourse = equip;
                    }
                }
                return;
            }
        }
    }
}

void EquipView::showPopNode(Touch* touch,Resourse* resourse){
    m_popNode1->setVisible(true);
    m_popNode2->setVisible(false);
    m_resourse = resourse;
    m_popTxt->setString(m_resourse->m_selfValue.m_name);
    m_bagUpTxt->setString(m_resourse->m_selfValue.m_description);
    if(m_resourse->m_useInBag){//在背包中使用
        CommonUtils::setButtonTitle(m_popBtn1,"使用");
        m_popBtn1->setEnabled(true);
    }else if (m_resourse->m_fightValue.m_useType==2){//可以在背包装备
        CommonUtils::setButtonTitle(m_popBtn1,"装备");
        m_popBtn1->setEnabled(true);
    }else{
        CommonUtils::setButtonTitle(m_popBtn1,"使用");
        m_popBtn1->setEnabled(false);
    }
    CommonUtils::setButtonTitle(m_popBtn2,"丢弃");
    m_popBtn2->setEnabled(true);
    m_popNode1->setPosition(touch->getLocation());
}

void EquipView::closePopNode(){
    m_popNode1->setVisible(false);
    m_popNode2->setVisible(false);
}









