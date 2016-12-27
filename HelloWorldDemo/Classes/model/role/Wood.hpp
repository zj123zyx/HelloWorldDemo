//
//  Wood.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/27.
//
//

#ifndef Wood_hpp
#define Wood_hpp

#include "Role.hpp"

class Wood:public Role
{
public:
    
    static Wood* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    virtual void showDescription(bool show);//显示简介
protected:
    void onEnter();
    void onExit();
};

#endif /* Wood_hpp */
