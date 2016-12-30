//
//  EquipView.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/27.
//
//

#ifndef EquipView_hpp
#define EquipView_hpp

#include "CommonHead.h"

class EquipView :
public Node
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    virtual bool init();
    CREATE_FUNC(EquipView);
    void onEnter();
    void onExit();
    
protected:
    EventListenerTouchOneByOne* listener;
    bool onTouchBegan(Touch* touch, Event* event);
    void onTouchMoved(Touch* touch, Event* event);
    void onTouchEnded(Touch* touch, Event* event);
private:
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char * pSelectorName){return NULL;}
    virtual Control::Handler onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName);
    
    void onCloseBtnClick(Ref* pSender, Control::EventType event);

    Node* m_touchNode;
    ControlButton* m_closeBtn;
    Scale9Sprite *m_bg;
    
    bool m_isClose;
};

#endif /* BagView_hpp */
