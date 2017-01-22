//
//  MapRes.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/22.
//
//

#ifndef MapRes_hpp
#define MapRes_hpp

#include "Role.hpp"

class MapRes:public Role
{
public:    
    static MapRes* createWithMapResId(string mrId);
    virtual bool initWithMapResId(string mrId);
    
    void setTileXY(int tx,int ty,bool setOccupy = true);//设置XY
    virtual void showDescription(bool show);//显示简介
    virtual int beAttackedByRole(Role* selfRole,int hurt);//被攻击 返回生命值
protected:
    void onEnter();
    void onExit();
    
    int totalHealth;
};

#endif /* MapRes_hpp */
