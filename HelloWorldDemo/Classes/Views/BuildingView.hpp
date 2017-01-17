//
//  BuildingView.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/17.
//
//

#ifndef BuildingView_hpp
#define BuildingView_hpp

#include "TouchNode.hpp"
#include "Building.hpp"

class BuildingView :
public TouchNode
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    virtual bool initWithBuilding(Building* building);
    static BuildingView* createWithBuilding(Building* building);

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
    void onBuildBtnClick(Ref* pSender, Control::EventType event);
    void onRemoveBtnClick(Ref* pSender, Control::EventType event);
    void onResBtn1Click(Ref* pSender, Control::EventType event);
    
    Node* m_touchNode;
    ControlButton* m_closeBtn;
    Scale9Sprite *m_bg;
    ControlButton* m_buildBtn;
    ControlButton* m_removeBtn;
    Label* m_TitleTxt;
    Label* m_buildDes;
    Sprite* m_buildSpr;
    Node* m_buildStartNode;
    Node* m_resNode1;
    Node* m_resIcon1;
    Label* m_resTxt1;
    Node* m_buildingNode;
    
    
    bool m_isClose;
    Building* m_building;
};

#endif /* BuildingView_hpp */
