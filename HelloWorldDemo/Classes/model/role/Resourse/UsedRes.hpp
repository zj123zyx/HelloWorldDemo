//
//  UsedRes.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/17.
//
//

#ifndef UsedRes_hpp
#define UsedRes_hpp

#include "Resourse.hpp"

class UsedRes:public Resourse
{
public:
    
    static UsedRes* createWithResId(string resId);
    virtual bool initWithResId(string resId);
    
    virtual void showDescription(bool show);//显示简介
protected:
    void onEnter();
    void onExit();
};

#endif /* UsedRes_hpp */
