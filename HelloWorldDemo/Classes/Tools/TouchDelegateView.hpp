//
//  TouchDelegateView.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/9.
//
//

#ifndef TouchDelegateView_hpp
#define TouchDelegateView_hpp

#include "CommonHead.h"

class TouchDelegate{
public:
    virtual void TapView(Touch* pTouch)=0;
};

class TouchDelegateView:public Layer{
public:
    CREATE_FUNC(TouchDelegateView);
    virtual bool init();
    virtual void onEnter();
    virtual void onExit();
    
    void setViewPortTarget(Node* target);
    void setTouchDelegate(TouchDelegate* delegate);
    
    void moveToPosition(Point point,float duration,Ref *target,SEL_CallFunc func);
    void addListener();
    
    bool m_isInit;
protected:
    virtual void onTouchesBegan(const std::vector<Touch*>& pTouches, Event *pEvent);
    virtual void onTouchesMoved(const std::vector<Touch*>& pTouches, Event *pEvent);
    virtual void onTouchesEnded(const std::vector<Touch*>& pTouches, Event *pEvent);
    
    void BeginScroll(Touch* touch);
    void OnScroll(Touch* touch);
    void EndScroll(Touch* touch);
    void intervalMove(float dt);
    void OnZoom(Point p1,Point p2);
    void setMapScale(float scale);
    
    void TargetNodeSetPosition(float x,float y);
private:
    Node* m_TargetNode;
    TouchDelegate* m_touchDelegate;
    EventListenerTouchAllAtOnce* listener;
    bool m_isTap;
    bool m_isZoom;
//    bool m_isScroll;
    std::map<int, Point> m_fingerMap;
    Point scrollBeganPoint;
    float zoomDistance;
    float zoomScale;
    Point m_tScrollDistance;
};

#endif /* TouchDelegateView_hpp */
