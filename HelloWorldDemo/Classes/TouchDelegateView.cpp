//
//  TouchDelegateView.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/9.
//
//

#include "TouchDelegateView.hpp"

bool TouchDelegateView::init(){
    bool ret = false;
    if(Layer::init()){
        ret = true;
    }
    return ret;
}

void TouchDelegateView::onEnter(){
    Layer::onEnter();
    setTouchMode(Touch::DispatchMode::ALL_AT_ONCE);
    setTouchEnabled(true);
}
void TouchDelegateView::onExit(){
    setTouchEnabled(false);
    Layer::onExit();
}

void TouchDelegateView::onTouchesBegan(const std::vector<Touch*>& pTouches, Event *pEvent){
    CC_ASSERT(this->m_TargetNode);
    m_fingerMap.clear();
    for ( auto &item: pTouches ){
        Touch* curTouch = dynamic_cast<Touch*>(item);
        CC_ASSERT(curTouch);
        if (m_fingerMap.size() <= 2) {
            m_fingerMap[curTouch->getID()] = curTouch->getLocation();
        }
    }
    if(m_fingerMap.size()==1){
        
    }else if (m_fingerMap.size()==2){
        
    }
}
void TouchDelegateView::onTouchesMoved(const std::vector<Touch*>& pTouches, Event *pEvent){
    CC_ASSERT(this->m_TargetNode);
    if(m_fingerMap.size()==1){
        
//        auto tmpIt = pTouches.begin();
//        while (tmpIt != pTouches.end()) {
//            auto tmpTouch = dynamic_cast<CCTouch*>(*tmpIt);
//            if (mFingerMap.find(tmpTouch->getID()) != mFingerMap.end()) {
//                tmpTouches.push_back(tmpTouch);
//            }
//            ++tmpIt;
//        }
        
//        auto fingerMapIt = m_fingerMap.begin();
//        auto fingerMapTouch = dynamic_cast<Touch*>(fingerMapIt->second);
//        
        auto tmpIt = pTouches.begin();
        auto tmpTouch = dynamic_cast<Touch*>(*tmpIt);
        if(m_fingerMap.find(tmpTouch->getID())!=m_fingerMap.end()){
            
        }
        
//        OnScroll();
    }else if (m_fingerMap.size()==2){
        
    }
}
void TouchDelegateView::onTouchesEnded(const std::vector<Touch*>& pTouches, Event *pEvent){
    CC_ASSERT(this->m_TargetNode);
    if(m_fingerMap.size()==1){
        
    }else if (m_fingerMap.size()==2){
        
    }
}
void TouchDelegateView::onTouchesCancelled(const std::vector<Touch*>& pTouches, Event *pEvent){
    onTouchesEnded(pTouches, pEvent);
}
void TouchDelegateView::setViewPortTarget(Node* target){
    m_TargetNode = target;
}

void TouchDelegateView::BeginScroll(Touch* touch){
    
}
void TouchDelegateView::OnScroll(Touch* touch){
    
}
void TouchDelegateView::EndScroll(Touch* touch){
    
}
