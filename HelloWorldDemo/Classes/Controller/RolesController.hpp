//
//  RolesController.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/26.
//
//

#ifndef RolesController_hpp
#define RolesController_hpp

#include "CommonHead.h"
#include "Tree.hpp"

class RolesController:public Ref
{
public:
    static RolesController* getInstance();
    
    RolesController();
    ~RolesController();
    
    void createTrees();
    
    Role* getRoleByTile(Vec2 tile);
    map<int,Role*> m_RoleMap;
};

#endif /* RolesController_hpp */
