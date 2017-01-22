#ifndef __WorldScene_H__
#define __WorldScene_H__

#include "SceneModel.hpp"
#include "TouchDelegateView.hpp"

class WorldScene :public SceneModel
,public TouchDelegate
{
public:
    WorldScene():m_touchDelegateView(nullptr){};
    ~WorldScene(){};
    static cocos2d::Scene* createScene();
    virtual bool init();
    
    // implement the "static create()" method manually
    CREATE_FUNC(WorldScene);
    
    void onEnter();
    void onExit();
protected:
    //delegate method
    void TapView(Touch* pTouch);
    void OnTouchUIRelease(Ref *target,SEL_CallFunc func);
    virtual void addRoles();
    
private:
    TouchDelegateView* m_touchDelegateView;
    
};

#endif // __WorldScene_H__
