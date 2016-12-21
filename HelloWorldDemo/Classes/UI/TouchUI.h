#ifndef __TouchUI_H__
#define __TouchUI_H__

#include "CommonHead.h"

class TouchUI :
public Node
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    virtual bool init();
    CREATE_FUNC(TouchUI);
    
    void onEnter();
    void onExit();
    
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
    
    LayerColor* m_layerCover;
    Node* m_downUiNode;
    Node* m_yaoGanerNode;
    Sprite* m_yaoGanerSpr;
    Sprite* m_yaoGanerSprBg;
    ControlButton* m_btn1;
    
    bool m_isLeftTouch;
    bool m_isScrollingLeft;
};

#endif // __TouchUI_H__
