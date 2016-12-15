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

class TouchDelegateView:public Layer{
public:
    CREATE_FUNC(TouchDelegateView);
    virtual bool init();
    virtual void onEnter();
    virtual void onExit();
    virtual void onTouchesBegan(const std::vector<Touch*>& pTouches, Event *pEvent);
    virtual void onTouchesMoved(const std::vector<Touch*>& pTouches, Event *pEvent);
    virtual void onTouchesEnded(const std::vector<Touch*>& pTouches, Event *pEvent);
    virtual void onTouchesCancelled(const std::vector<Touch*>& pTouches, Event *pEvent);
    void setViewPortTarget(Node* target);
    
protected:
    void BeginScroll(Touch* touch);
    void OnScroll(Touch* touch);
    void EndScroll(Touch* touch);
    
private:
    Node* m_TargetNode;
    std::map<int, Point> m_fingerMap;
    
};

#endif /* TouchDelegateView_hpp */
