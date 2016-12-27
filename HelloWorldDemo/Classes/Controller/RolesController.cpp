//
//  RolesController.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/26.
//
//

#include "RolesController.hpp"

static RolesController* rolesController = NULL;

RolesController* RolesController::getInstance(){
    if (!rolesController){
        rolesController = new RolesController();
    }
    return rolesController;
}

RolesController::RolesController(){
    Tree* tree = Tree::createWithPicName("res/Roles/assassin1a.png");
    tree->m_tileX = 20;
    tree->m_tileY = 90;
    tree->m_occupy.push_back(Vec2(tree->m_tileX,tree->m_tileY));
    addControllerRole(tree);
}

RolesController::~RolesController(){
    
}

void RolesController::createTrees(){
    
}

Role* RolesController::getRoleByTile(Vec2 tile){
    Role* role = nullptr;
    int tid = CommonUtils::getTileIdByXY(tile.x, tile.y);
    if (m_RoleMap.find(tid)!=m_RoleMap.end()) {
        role = m_RoleMap[tid];
    }
    return role;
}

void RolesController::removeRoleByTile(Vec2 tile){
    int tid = CommonUtils::getTileIdByXY(tile.x, tile.y);
    m_RoleMap.erase(tid);
}

void RolesController::addControllerRole(Role* role,bool addToScene){
    int tid = CommonUtils::getTileIdByXY(role->m_tileX, role->m_tileY);
    m_RoleMap[tid] = role;
    if(addToScene){
        addRoleToScene(role);
    }
}

void RolesController::setTiledMap(TMXTiledMap* map){
    _map=map;
}

void RolesController::addRoleToScene(Role* role,bool isForce){//往地图中添加role
    if(_map){
        int tid = CommonUtils::getTileIdByXY(role->m_tileX, role->m_tileY);
        if(_map->getChildByTag(tid)!=nullptr){
            if (isForce) {
                _map->removeChildByTag(tid);
            }else{
                return;
            }
        }
        Size mapSize = _map->getContentSize();
        Size tileSize = _map->getTileSize();
        int py = mapSize.height - (role->m_tileY*tileSize.height+tileSize.height/2);
        int px = role->m_tileX*tileSize.width+tileSize.width/2;
        role->setPosition(Vec2(px, py));
        role->setTag(tid);
        _map->addChild(role,3);
    }
}

void RolesController::addAllRoleToScene(bool isForce){//往地图中添加所有role
    map<int,Role*>::iterator it = m_RoleMap.begin();
    for (; it!=m_RoleMap.end(); it++) {
        Role *role = it->second;
        addRoleToScene(role,isForce);
    }
}
