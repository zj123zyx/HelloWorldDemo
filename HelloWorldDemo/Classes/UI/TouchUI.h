#ifndef __TouchUI_H__
#define __TouchUI_H__

#include "CommonHead.h"

class UIDelegate{
public:
    virtual void OnTouchUIRelease(Ref *target,SEL_CallFunc func)=0;
};

class TouchUI :
public Node
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    static TouchUI* getInstance();
    virtual bool init();
    CREATE_FUNC(TouchUI);
    void onEnter();
    void onExit();
    void setUiDelegate(UIDelegate* delegate);
    void addToLayer(Layer* layer);
    ControlButton* m_btn2;
protected:
    EventListenerTouchOneByOne* listener;
    bool onTouchBegan(Touch* touch, Event* event);
    void onTouchMoved(Touch* touch, Event* event);
    void onTouchEnded(Touch* touch, Event* event);
    void OnScrollLeft(float dt);
private:
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char * pSelectorName){return NULL;}
    virtual Control::Handler onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName);
    
    void onBtn1Click(Ref* pSender, Control::EventType event);
    void onBtn2Click(Ref* pSender, Control::EventType event);
    void onBtn3Click(Ref* pSender, Control::EventType event);
    void startUseTouchUI();
    void TouchUISchedule(float dt);
    
    UIDelegate* m_uiDelegate;
    
    LayerColor* m_layerCover;
    Node* m_touchNode;
    Node* m_downUiNode;
    Node* m_yaoGanerNode;
    Sprite* m_yaoGanerSpr;
    Sprite* m_yaoGanerSprBg;
    ControlButton* m_btn1;
    ControlButton* m_btn3;
    
    bool m_isLeftTouch;
    bool m_isNodeTouch;
    bool m_isScrollingLeft;
    
    int m_btn1LeftCD;
};

#endif // __TouchUI_H__
