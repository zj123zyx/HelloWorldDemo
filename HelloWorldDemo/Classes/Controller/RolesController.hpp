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
#include "Role.hpp"

class RolesController:public Ref
{
public:
    static RolesController* getInstance();
    
    RolesController();
    ~RolesController();
    
    void createTrees();
    
    Role* getRoleByTile(Vec2 tile);
    void removeRole(Role* role);
    void addControllerRole(Role* role,bool addToScene = true);
    void setTiledMap(TMXTiledMap* map);//设置瓦片地图
    void addRoleToScene(Role* role,bool isForce = false);//往地图中添加role
    void addAllRoleToScene(bool isForce = false);//往地图中添加所有role
    void clearRoleMap();//清空m_RoleMap
    Role* getActRoleByDistance(Role* self,float dis=64);
    
    void addVirtualBuildToTiledMapByPoint(Node* virtualBuild,Vec2 playerPoint);//往地图中添加VirtualBuild
    void refreshVirtualBuildPosition(Vec2 playerPoint);//更新VirtualBuild位置
    void layVirtualBuild();//放置VirtualBuild
    void removeVirtualBuildFromTiledMap();//删除VirtualBuild
    int getLayerTileGIDAtPoint(string layerName, Point point);//获得该位置的GID
    string getPropertyByGIDAndNameToString(int gid,string propertyName);//得到该GID对应的自定义属性名字
    
    map<int,Role*> m_RoleMap;
    vector<Role*> m_actRoleVec;
    
private:
    TMXTiledMap* _map;
};

#endif /* RolesController_hpp */
