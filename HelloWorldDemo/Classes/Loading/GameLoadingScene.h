#ifndef __GameLoadingScene_H__
#define __GameLoadingScene_H__

#include "CommonHead.h"

class GameLoadingScene :
public cocos2d::Layer
, public CCBSelectorResolver
, public CCBMemberVariableAssigner
{
public:
    static cocos2d::Scene* createScene();

    virtual bool init();
    CREATE_FUNC(GameLoadingScene);
    
    GameLoadingScene(){};
    ~GameLoadingScene(){Director::getInstance()->purgeCachedData();};
    
    void onEnter();
    void onExit();
    
    void gotoWorldScene(float dt);
    
private:
    virtual bool onAssignCCBMemberVariable(Ref * pTarget, const char * pMemberVariableName, Node * pNode);
    virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref * pTarget, const char * pSelectorName){return NULL;}
    virtual Control::Handler onResolveCCBCCControlSelector(Ref * pTarget, const char * pSelectorName);
    
    void onBtnClick(Ref* pSender, Control::EventType event);
    
    Label* helloLabel;
    ControlButton* m_btn;
    
};

#endif // __GameLoadingScene_H__
