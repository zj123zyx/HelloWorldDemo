//
//  TouchDelegateView.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/9.
//
//

#include "TouchDelegateView.hpp"

static float MaxMapScall=2;
static float MinMapScall=0.5;

bool TouchDelegateView::init(){
    bool ret = false;
    if(Layer::init()){
        ret = true;
    }
    return ret;
}

void TouchDelegateView::onEnter(){
    Layer::onEnter();
    listener = EventListenerTouchAllAtOnce::create();
    listener->onTouchesBegan = CC_CALLBACK_2(TouchDelegateView::onTouchesBegan, this);
    listener->onTouchesMoved = CC_CALLBACK_2(TouchDelegateView::onTouchesMoved, this);
    listener->onTouchesEnded = CC_CALLBACK_2(TouchDelegateView::onTouchesEnded, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    m_isZoom = false;
    zoomDistance = 0;
    scrollBeganPoint=Vec2(-1, -1);
}
void TouchDelegateView::onExit(){
    _eventDispatcher->removeEventListener(listener);
    Layer::onExit();
}

void TouchDelegateView::onTouchesBegan(const std::vector<Touch*>& pTouches, Event *pEvent){
    CC_ASSERT(this->m_TargetNode);
    if(pTouches.size()==1){
        BeginScroll(dynamic_cast<Touch*>(pTouches[0]));
    }else if (pTouches.size()==2){
    }
}
void TouchDelegateView::onTouchesMoved(const std::vector<Touch*>& pTouches, Event *pEvent){
    CC_ASSERT(this->m_TargetNode);
    if(pTouches.size()==1){
        OnScroll(dynamic_cast<Touch*>(pTouches[0]));
    }else if (pTouches.size()==2){
        Point p1 = dynamic_cast<Touch*>(pTouches[0])->getLocation();
        Point p2 = dynamic_cast<Touch*>(pTouches[1])->getLocation();
        OnZoom(p1,p2);
    }
}
void TouchDelegateView::onTouchesEnded(const std::vector<Touch*>& pTouches, Event *pEvent){
    CC_ASSERT(this->m_TargetNode);
    if(pTouches.size()==1){
        EndScroll(dynamic_cast<Touch*>(pTouches[0]));
    }else if (pTouches.size()==2){
    }
    if(m_isZoom){//缩放后边界检测
        m_isZoom = false;
        
        float mapScale = m_TargetNode->getScale();
        Size mapSize = m_TargetNode->getContentSize()*mapScale;
        Size winSize = Director::getInstance()->getWinSize();
        float endX = this->m_TargetNode->getPositionX();
        float endY = this->m_TargetNode->getPositionY();
        endX = endX<0?endX:0;
        endX = endX>(winSize.width-mapSize.width)?endX:(winSize.width-mapSize.width);
        endY = endY<0?endY:0;
        endY = endY>(winSize.height-mapSize.height)?endY:(winSize.height-mapSize.height);
        this->m_TargetNode->setPosition(Vec2(endX,endY));
    }
    zoomDistance = 0;
    scrollBeganPoint=Vec2(-1, -1);
}

void TouchDelegateView::setViewPortTarget(Node* target){
    m_TargetNode = target;
}
void TouchDelegateView::setTouchDelegate(TouchDelegate* delegate){
    m_touchDelegate = delegate;
}

void TouchDelegateView::BeginScroll(Touch* touch){
    if(m_isZoom) return;
    m_isTap=true;
}
void TouchDelegateView::OnScroll(Touch* touch){
    if(m_isZoom) return;
    if(scrollBeganPoint==Vec2(-1, -1)){
        scrollBeganPoint = touch->getLocation();
        return;
    }
    if(m_isTap==false || touch->getLocation().getDistance(scrollBeganPoint)>20){
        Point curPoint = this->m_TargetNode->getPosition();
        float moveX = touch->getLocation().x - scrollBeganPoint.x;
        float moveY = touch->getLocation().y - scrollBeganPoint.y;
        
        float endX = curPoint.x+moveX;
        float endY = curPoint.y+moveY;
        if(m_TargetNode){//边界检测
            float mapScale = m_TargetNode->getScale();
            Size mapSize = m_TargetNode->getContentSize()*mapScale;
            Size winSize = Director::getInstance()->getWinSize();
            endX = endX<0?endX:0;
            endX = endX>(winSize.width-mapSize.width)?endX:(winSize.width-mapSize.width);
            endY = endY<0?endY:0;
            endY = endY>(winSize.height-mapSize.height)?endY:(winSize.height-mapSize.height);
        }

        Point endPoint = Vec2(endX,endY);
        this->m_TargetNode->setPosition(endPoint);
        scrollBeganPoint = touch->getLocation();
        m_isTap=false;
    }
}
void TouchDelegateView::EndScroll(Touch* touch){
    if(m_isZoom) return;
    if(m_isTap && m_touchDelegate){
        m_touchDelegate->TapView(touch);
    }else{
        
    }
}

void TouchDelegateView::OnZoom(Point p1,Point p2){
    m_isZoom = true;
    m_isTap=false;
    if(zoomDistance<=0){
        zoomDistance = p1.getDistance(p2);
        zoomScale = m_TargetNode->getScale();
        return;
    }
    float distance = p1.getDistance(p2);
    float scale = (distance/zoomDistance)*zoomScale;
    float mapScale = m_TargetNode->getScale();
    Size mapSize = m_TargetNode->getContentSize();
    Size winSize = Director::getInstance()->getWinSize();
    Point mapPoint = m_TargetNode->getPosition();
    scale = scale<MaxMapScall?scale:MaxMapScall;
    scale = scale>MinMapScall?scale:MinMapScall;
    m_TargetNode->setScale(scale);//设置缩放
    float moveX = mapPoint.x - ((scale-mapScale)*mapSize.width)*(((winSize.width/2)-mapPoint.x)/(mapSize.width*mapScale));
    float moveY = mapPoint.y - ((scale-mapScale)*mapSize.height)*(((winSize.height/2)-mapPoint.y)/(mapSize.height*mapScale));
    m_TargetNode->setPosition(moveX, moveY);//设置位置
}
