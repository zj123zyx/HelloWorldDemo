//
//  TouchNode.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/4.
//
//

#ifndef TouchNode_hpp
#define TouchNode_hpp

#include "CommonHead.h"

class TouchNode:public Node
{
public:
    virtual bool init();
    CREATE_FUNC(TouchNode);
    void onEnter();
    void onExit();
    
protected:
    EventListenerTouchOneByOne* listener;
    virtual bool onTouchBegan(Touch* touch, Event* event);
    virtual void onTouchMoved(Touch* touch, Event* event);
    virtual void onTouchEnded(Touch* touch, Event* event);
};

#endif /* TouchNode_hpp */
