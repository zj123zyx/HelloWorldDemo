//
//  Tree.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/26.
//
//

#ifndef Tree_hpp
#define Tree_hpp

#include "Role.hpp"

class Tree:public Role
{
public:
    
    static Tree* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);

    virtual void showDescription(bool show);//显示简介
protected:
    void onEnter();
    void onExit();
};


#endif /* Tree_hpp */
