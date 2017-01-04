//
//  TouchNode.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/4.
//
//

#include "TouchNode.hpp"

bool TouchNode::init(){
    if ( !Node::init() ){
        return false;
    }
    
    return true;
}
void TouchNode::onEnter(){
    Node::onEnter();
    listener = EventListenerTouchOneByOne::create();
    listener->onTouchBegan = CC_CALLBACK_2(TouchNode::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(TouchNode::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(TouchNode::onTouchEnded, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    listener->setSwallowTouches(true);
}
void TouchNode::onExit(){
    _eventDispatcher->removeEventListener(listener);
    Node::onExit();
}

bool TouchNode::onTouchBegan(Touch* touch, Event* event){
    CCLOG("TouchNode::onTouchBegan not *****inherit*****");
    return false;
}
void TouchNode::onTouchMoved(Touch* touch, Event* event){
    CCLOG("TouchNode::onTouchMoved not *****inherit*****");
}
void TouchNode::onTouchEnded(Touch* touch, Event* event){
    CCLOG("TouchNode::onTouchEnded not *****inherit*****");
}
