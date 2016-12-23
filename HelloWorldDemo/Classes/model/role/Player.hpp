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
    
    CREATE_FUNC(Player);
    virtual bool init();
    
    void move(Point point);
    void moveTo(Point point);
protected:
    void onEnter();
    void onExit();
};

#endif /* Player_hpp */
