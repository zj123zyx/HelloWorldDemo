//
//  ResourseController.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/30.
//
//

#ifndef ResourseController_hpp
#define ResourseController_hpp

#include "CommonHead.h"
#include "Resourse.hpp"

class ResourseController:public Ref
{
public:
    static ResourseController* getInstance();
    
    ResourseController();
    ~ResourseController();
    
    bool mergeResourse(Resourse* resourse);//合并物品
    int getBagPosition();//获得背包空位
    bool getItem(Resourse* resourse);//获得物品
    Resourse* getEquipedRes();
    void setEquipedResByPos(int pos);
    
    map<int, Resourse*> m_resourseMap;
};

#endif /* ResourseController_hpp */
