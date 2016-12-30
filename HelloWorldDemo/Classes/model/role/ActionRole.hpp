//
//  ActionRole.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#ifndef ActionRole_hpp
#define ActionRole_hpp

#include "Role.hpp"
#include "SceneController.hpp"

class ActionRole:public Role
{
public:
    
    static ActionRole* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    void setTileXY(int tx,int ty,bool setOccupy = true);
    virtual void doAction(Role* sender);//处理事件
protected:
    void onEnter();
    void onExit();
    
    SceneInfo m_sceneInfo;
};

#endif /* ActionRole_hpp */
