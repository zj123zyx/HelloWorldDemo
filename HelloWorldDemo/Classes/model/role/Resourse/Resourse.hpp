//
//  Resourse.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/30.
//
//

#ifndef Resourse_hpp
#define Resourse_hpp

#include "Role.hpp"

enum ResourceType{
    ResourceType_NULL=0,
    ResourceType_Wood
};

class Resourse:public Role
{
public:
    Resourse():m_resourceType(ResourceType_NULL)
    ,m_resourceValue(0)
    ,m_resourceMaxValue(1)
    ,m_bagPosition(-1)
    {}
    ~Resourse(){}
    
    static Resourse* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    virtual void getThisItem(Role* role);//role获得此物品
    
    ResourceType m_resourceType;//资源类型
    int m_resourceValue;//资源叠加数量
    int m_resourceMaxValue;//资源叠加最大数量
    
    int m_bagPosition;
protected:
    void onEnter();
    void onExit();
};

#endif /* Resourse_hpp */
