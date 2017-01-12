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
    ResourceType_Wood,
    ResourceType_Equip,
    ResourceType_End
};
enum UseType{
    UseType_NULL=0,
    UseType_UseInUI,
    UseType_EquipInUI,
    UseType_UseInBag,
    UseType_EquipInBag,
    UseType_End
};

class Resourse:public Role
{
public:
    Resourse():m_resourceType(ResourceType_NULL)
    ,m_resourceValue(0)
    ,m_resourceMaxValue(1)
    ,m_bagPosition(-1)
    ,m_isEquipedInUI(false)
    ,m_useType(UseType_NULL)
    {}
    ~Resourse(){}
    
    static Resourse* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    static Resourse* create();
    virtual bool init();
    
    virtual void showDescription(bool show);//显示简介
    
    virtual void getThisItem(Role* role);//role获得此物品
    
    ResourceType m_resourceType;//资源类型
    int m_resourceValue;//资源叠加数量
    int m_resourceMaxValue;//资源叠加最大数量
    
    int m_bagPosition;//背包中位置
    bool m_isEquipedInUI;//ui装备中
//    bool m_useInBag;//背包中使用
    UseType m_useType;//1:可以在ui使用,2:可以在背包装备,0:不可使用和装备
protected:
    void onEnter();
    void onExit();
};

#endif /* Resourse_hpp */
