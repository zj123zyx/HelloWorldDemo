//
//  BookCreateView.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#ifndef BookCreateView_hpp
#define BookCreateView_hpp

#include "TouchNode.hpp"

class BookCreateView :
public TouchNode
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    virtual bool init();
    CREATE_FUNC(BookCreateView);
    void onEnter();
    void onExit();
    
    void refreshData(Ref* ref);
protected:
    bool onTouchBegan(Touch* touch, Event* event);
    void onTouchMoved(Touch* touch, Event* event);
    void onTouchEnded(Touch* touch, Event* event);

private:
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char * pSelectorName){return NULL;}
    virtual Control::Handler onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName);
    
    void onCloseBtnClick(Ref* pSender, Control::EventType event);
    void onBtnClick(Ref* pSender, Control::EventType event);
    
    Node* m_touchNode;
    ControlButton* m_closeBtn;
    Scale9Sprite *m_bg;
    ControlButton* m_btn;

    bool m_isClose;
};

#endif /* BookCreateView_hpp */
