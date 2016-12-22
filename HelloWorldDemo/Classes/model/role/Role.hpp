//
//  Role.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#ifndef Role_hpp
#define Role_hpp

#include "CommonHead.h"

class Role:public Node
{
public:
    Role();
    ~Role();
    
    CREATE_FUNC(Role);
    virtual bool init();
    
    Point getPositionInScreen();
    void setContainer(TMXTiledMap* container);
    virtual void startMove(Point point);
    virtual void move(Point point);
    virtual void stopMove(Point point);
    void setAnimation(const char* aniName,string frameName,int frameCount,float dTime = 0.2f);
    
    float m_moveSpeed;
    map<string, Animation*> m_aniMap;
protected:
    virtual void onEnter();
    virtual void onExit();
    
    TMXTiledMap* m_container;
private:
    Sprite* m_roleSprite;
};

#endif /* Role_hpp */
