#include "TouchUI.h"

USING_NS_CC;

static const float MAX_DISTANCE=100;

bool TouchUI::init()
{
    if ( !Node::init() ){
        return false;
    }
    m_isLeftTouch=false;
    m_isScrollingLeft=false;
    
    SpriteFrameCache::getInstance()->addSpriteFramesWithFile("Common/Common_1.plist");
    CCBLoadFile("TouchUI",this,this);
    m_layerCover->setOpacity(0);
    return true;
}

void TouchUI::onEnter(){
    Node::onEnter();
    listener = EventListenerTouchOneByOne::create();
    listener->onTouchBegan = CC_CALLBACK_2(TouchUI::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(TouchUI::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(TouchUI::onTouchEnded, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    
    listener->setSwallowTouches(true);
}
void TouchUI::onExit(){
    _eventDispatcher->removeEventListener(listener);
    Node::onExit();
}

bool TouchUI::onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode){
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_layerCover", LayerColor*, m_layerCover);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_downUiNode", Node*, m_downUiNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_yaoGanerNode", Node*, m_yaoGanerNode);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_yaoGanerSpr", Sprite*, m_yaoGanerSpr);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_yaoGanerSprBg", Sprite*, m_yaoGanerSprBg);
    CCB_MEMBERVARIABLEASSIGNER_GLUE_WEAK(this, "m_btn1", ControlButton*, m_btn1);
    return false;
}
cocos2d::extension::Control::Handler TouchUI::onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName){
    CCB_SELECTORRESOLVER_CCCONTROL_GLUE(this, "onBtn1Click", TouchUI::onBtn1Click);
    return NULL;
}

bool TouchUI::onTouchBegan(Touch* touch, Event* event){
    if(isTouchInside(m_yaoGanerSprBg,touch)){
        m_isLeftTouch=true;
    }
    return true;
}
void TouchUI::onTouchMoved(Touch* touch, Event* event){
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
        }
    }
}
void TouchUI::onTouchEnded(Touch* touch, Event* event){
    m_isLeftTouch=false;
    m_isScrollingLeft=false;
    m_yaoGanerSpr->setPosition(0, 0);
}

void TouchUI::OnScrollLeft(float dt){
    if(m_isScrollingLeft==false){
        this->unschedule(schedule_selector(TouchUI::OnScrollLeft));
    }
    Point touchPoint = m_yaoGanerSpr->getPosition();
    float distance = touchPoint.getLength();
    CCLOG("touchPoint.x=%f,touchPoint.y=%f,distance=%f",touchPoint.x,touchPoint.y,distance);
}



void TouchUI::onBtn1Click(Ref* pSender, Control::EventType event){
    CCLOG("onBtnClick");
    listener->setSwallowTouches(!listener->isSwallowTouches());
}


