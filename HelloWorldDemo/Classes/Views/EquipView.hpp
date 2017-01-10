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
#include "Resourse.hpp"

class EquipViewDelegate{
public:
    virtual void showPopNode(Touch* touch,Resourse* resourse)=0;
    virtual void closePopNode()=0;
};

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
    EquipViewDelegate* m_delegate;
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
    bool m_touchMove;
    Resourse* m_resourse;
};

class EquipView :
public TouchNode
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
, public EquipViewDelegate
{
public:
    virtual bool init();
    CREATE_FUNC(EquipView);
    void onEnter();
    void onExit();
    
    void refreshData(Ref* ref);
protected:
    EventListenerTouchOneByOne* listener;
    bool onTouchBegan(Touch* touch, Event* event);
    void onTouchMoved(Touch* touch, Event* event);
    void onTouchEnded(Touch* touch, Event* event);
    
    virtual void showPopNode(Touch* touch,Resourse* resourse);
    virtual void closePopNode();
private:
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char * pSelectorName){return NULL;}
    virtual Control::Handler onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName);
    
    void onCloseBtnClick(Ref* pSender, Control::EventType event);
    void onPopBtn1Click(Ref* pSender, Control::EventType event);
    void onPopBtn2Click(Ref* pSender, Control::EventType event);
    void onPopBtn3Click(Ref* pSender, Control::EventType event);
    void onInfoBtnClick(Ref* pSender, Control::EventType event);
    void onEquipBtnClick(Ref* pSender, Control::EventType event);
    
    void setPage(int page);

    Node* m_touchNode;
    ControlButton* m_closeBtn;
    Scale9Sprite *m_bg;
    Label* m_bagUpTxt;
    Node* m_bagListNode;
    Node* m_popNode1;
    Node* m_popNode2;
    Label* m_popTxt;
    ControlButton* m_popBtn1;
    ControlButton* m_popBtn2;
    ControlButton* m_popBtn3;
    Node* m_equipNode[7];
    Sprite* m_equipBg[7];
    ControlButton* m_equipBtn;
    ControlButton* m_infoBtn;
    Node* m_playerInfoNode;
    Node* m_equipInfoNode;
    Label* m_playerInfoTxt;
    
    Resourse* m_resourse;
    ScrollView* m_scrollView;
    
    bool m_isClose;
};

#endif /* BagView_hpp */
