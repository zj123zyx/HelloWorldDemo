//
//  House.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#ifndef House_hpp
#define House_hpp

#include "Role.hpp"
#include "SceneController.hpp"

class House:public Role
{
public:
    
    static House* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    virtual void showDescription(bool show);//显示简介
    void setTileXY(int tx,int ty,bool setOccupy = true);//设置XY
    
    
    virtual void doAction(Role* sender);//处理事件
protected:
    void onEnter();
    void onExit();
    
    SceneInfo m_sceneInfo;
};

#endif /* House_hpp */
