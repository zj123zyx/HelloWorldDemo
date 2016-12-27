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
    void removeRoleByTile(Vec2 tile);
    void addControllerRole(Role* role,bool addToScene = false);
    void setTiledMap(TMXTiledMap* map);//设置瓦片地图
    void addRoleToScene(Role* role,bool isForce = false);//往地图中添加role
    void addAllRoleToScene(bool isForce = false);//往地图中添加所有role
    
    map<int,Role*> m_RoleMap;
    
private:
    TMXTiledMap* _map;
};

#endif /* RolesController_hpp */
