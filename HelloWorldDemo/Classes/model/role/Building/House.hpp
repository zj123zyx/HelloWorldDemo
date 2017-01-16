//
//  House.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/28.
//
//

#ifndef House_hpp
#define House_hpp

#include "Building.hpp"
#include "SceneController.hpp"

class House:public Building
{
public:
    
    static House* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    void setTileXY(int tx,int ty,bool setOccupy = true);//设置XY
    virtual void doAction(Role* sender);//处理事件
protected:
    void onEnter();
    void onExit();
    
};

#endif /* House_hpp */
