//
//  Weapon.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#ifndef Weapon_hpp
#define Weapon_hpp

#include "Resourse.hpp"

class Weapon:public Resourse
{
public:
    
    static Weapon* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    virtual void showDescription(bool show);//显示简介
protected:
    void onEnter();
    void onExit();
};

#endif /* Weapon_hpp */
