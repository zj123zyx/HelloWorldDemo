#ifndef __TouchUI_H__
#define __TouchUI_H__

#include "CommonHead.h"
#include "TouchNode.hpp"

class UIEquipCell:
public TouchNode
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    virtual bool init(int pos,int sum);
    static UIEquipCell* create(int pos,int sum);
    void onEnter();
    void onExit();
    
    void setData(int pos,int sum);
protected:
    bool onTouchBegan(Touch* touch, Event* event);
    void onTouchMoved(Touch* touch, Event* event);
    void onTouchEnded(Touch* touch, Event* event);
private:
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char * pSelectorName){return NULL;}
    virtual Control::Handler onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName);
    
    Node* m_touchNode;
    Node* m_iconNode;
    Node* m_numNode;
    Label* m_desTxt;
    
    int m_pos;
    int m_sum;
    bool m_touchMove;
};

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
    
    void refreshEquipNode(Ref* ref);
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
    Node* m_equipNode;
    Node* m_coverNode;
    
    bool m_isLeftTouch;
    bool m_isNodeTouch;
    bool m_isScrollingLeft;
    
    int m_btn1LeftCD;
};

#endif // __TouchUI_H__
