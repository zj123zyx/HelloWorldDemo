//
//  Player.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#ifndef Player_hpp
#define Player_hpp

#include "Role.hpp"

class Player:public Role
{
public:
    
    static Player* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    void setPosition(const Vec2 &position);
    virtual void move(Point point);
    virtual void moveTo(Point point);
    
    void doAction();//攻击
    virtual void setTarget(Role* target);//设置目标
    virtual void removeTarget();//移除目标
    int m_bagValue;//可携带数量
protected:
    void onEnter();
    void onExit();
};

#endif /* Player_hpp */
