//
//  EquipView.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/27.
//
//

#ifndef EquipView_hpp
#define EquipView_hpp

#include "TouchNode.hpp"

class EquipBagCell:
public TouchNode
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    virtual bool init(int pos,int sum);
    static EquipBagCell* create(int pos,int sum);
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
    Label* m_numTxt;
    
    int m_pos;
    int m_sum;
};

class EquipView :
public TouchNode
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
    Node* m_bagListNode;
    
    ScrollView* m_scrollView;
    
    bool m_isClose;
};

#endif /* BagView_hpp */
