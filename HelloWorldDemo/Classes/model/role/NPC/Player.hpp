//
//  Player.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#ifndef Player_hpp
#define Player_hpp

#include "NPCRole.hpp"
#include "Resourse.hpp"

class Player:public NPCRole
{
public:
    
    static Player* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    void setPosition(const Vec2 &position);
    virtual void move(Point point);
    virtual void moveTo(Point point);
    
    void doActionToTarget();//对目标操作
    void doActionWithEquipedUIRes(Resourse* resourse);//通过UI中装备实行操作
    
    virtual int beAttackedByRole(Role* selfRole,int hurt);//被攻击 返回生命值
    
    bool m_isDead;
protected:
    void onEnter();
    void onExit();
};

#endif /* Player_hpp */
