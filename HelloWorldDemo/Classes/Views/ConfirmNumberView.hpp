//
//  ConfirmNumberView.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/17.
//
//

#ifndef ConfirmNumberView_hpp
#define ConfirmNumberView_hpp

#include "TouchNode.hpp"

class ConfirmNumberViewDelegate{
public:
    virtual void onConfirmWithValue(int value,string itemId)=0;
};

class ConfirmNumberView :
public TouchNode
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    virtual bool initWithItemId(string itemId);
    static ConfirmNumberView* createWithItemId(string itemId);
    
    void onEnter();
    void onExit();
    
    void refreshData(Ref* ref);
    void setSliderMaxValue(int maxValue);
    ConfirmNumberViewDelegate* m_delegate;
protected:
    bool onTouchBegan(Touch* touch, Event* event);
    void onTouchMoved(Touch* touch, Event* event);
    void onTouchEnded(Touch* touch, Event* event);
    
private:
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char * pSelectorName){return NULL;}
    virtual Control::Handler onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName);
    
    void onCloseBtnClick(Ref* pSender, Control::EventType event);
    void onConfirmBtnClick(Ref* pSender, Control::EventType event);
    void onDelBtnClick(Ref* pSender, Control::EventType event);
    void onAddBtnClick(Ref* pSender, Control::EventType event);
    
    void sliderCallBack(Ref* pSender, Control::EventType event);
    
    Node* m_touchNode;
    ControlButton* m_closeBtn;
    Scale9Sprite *m_bg;
    ControlButton* m_confirmBtn;
    ControlButton* m_addBtn;
    ControlButton* m_delBtn;
    Label* m_desTxt;
    Node* m_icon;
    Node* m_sliderNode;
    Label* m_sliderValueTxt;
    
    bool m_isClose;
    string m_itemId;
    
    ControlSlider* slider;
};

#endif /* ConfirmNumberView_hpp */
