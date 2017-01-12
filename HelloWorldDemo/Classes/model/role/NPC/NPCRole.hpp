//
//  NPCRole.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/10.
//
//

#ifndef NPCRole_hpp
#define NPCRole_hpp

#include "Role.hpp"

class NPCRole:public Role
{
public:
    
    static NPCRole* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    void setPosition(const Vec2 &position);
    virtual void move(Point point);
    virtual void moveTo(Point point);
    
    virtual void showDescription(bool show);//显示简介
    
    virtual void doAction();//攻击
    virtual void setTarget(Role* target);//设置目标
    virtual void removeTarget();//移除目标
    int m_bagValue;//可携带数量
    
    void NPCSchedule(float dt);
    
    virtual int beAttackedByRole(Role* selfRole,int hurt);//被攻击 返回生命值
protected:
    void onEnter();
    void onExit();
};

#endif /* NPCRole_hpp */
