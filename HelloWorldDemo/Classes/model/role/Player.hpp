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
    void move(Point point);
    void moveTo(Point point);
    
    void setTarget(Role* target);
    void removeTarget();
    Role* m_target;
protected:
    void onEnter();
    void onExit();
};

#endif /* Player_hpp */
