//
//  RolesController.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/26.
//
//

#include "RolesController.hpp"
#include "Tree.hpp"
#include "House.hpp"

static RolesController* rolesController = NULL;

RolesController* RolesController::getInstance(){
    if (!rolesController){
        rolesController = new RolesController();
    }
    return rolesController;
}

RolesController::RolesController(){
    
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

//void RolesController::removeRoleByTile(Vec2 tile){
//    int tid = CommonUtils::getTileIdByXY(tile.x, tile.y);
//    m_RoleMap.erase(tid);
//}

void RolesController::removeRole(Role* role){
    int tid = CommonUtils::getTileIdByXY(role->m_tileX, role->m_tileY);
    if(m_RoleMap.find(tid)!=m_RoleMap.end()){
        m_RoleMap.erase(tid);
    }
    vector<Role*>::iterator it = m_actRoleVec.begin();
    for (; it!=m_actRoleVec.end(); it++) {
        Role* temp = (*it);
        if (temp==role) {
            m_actRoleVec.erase(it);
            break;
        }
    }
}

void RolesController::addControllerRole(Role* role,bool addToScene){
    vector<Vec2> occupy = role->m_occupy;
    for (int i=0; i<occupy.size(); i++) {
        Vec2 tempVec2=occupy[i];
        int tid = CommonUtils::getTileIdByXY(tempVec2.x, tempVec2.y);
        m_RoleMap[tid] = role;
    }
    if(role->m_roleType==RoleType_Player || role->m_roleType==RoleType_NPCRole){
        m_actRoleVec.push_back(role);
    }
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

void RolesController::clearRoleMap(){//清空m_RoleMap
    m_RoleMap.clear();
    m_actRoleVec.clear();
}

Role* RolesController::getActRoleByDistance(Role* self,float dis/*=64*/){
    Role* role = nullptr;
    vector<Role*>::iterator it = m_actRoleVec.begin();
    for (; it!=m_actRoleVec.end(); it++) {
        Role* temp = (*it);
        if (temp==self) {
            continue;
        }else{
            float ds=(temp->m_width+self->m_width)/2;
            float minDs=MIN(ds, dis);
            if(self->m_faceTo==FaceTo_UP &&
               (temp->getPosition().y>self->getPosition().y) &&
               (self->getPosition().getDistance(temp->getPosition())<=minDs)){
                role = temp;
            }
            if(self->m_faceTo==FaceTo_DOWN &&
               (temp->getPosition().y<self->getPosition().y) &&
               (self->getPosition().getDistance(temp->getPosition())<=minDs)){
                role = temp;
            }
            if(self->m_faceTo==FaceTo_LEFT &&
               (temp->getPosition().x<self->getPosition().x) &&
               (self->getPosition().getDistance(temp->getPosition())<=minDs)){
                role = temp;
            }
            if(self->m_faceTo==FaceTo_RIGHT &&
               (temp->getPosition().x>self->getPosition().x) &&
               (self->getPosition().getDistance(temp->getPosition())<=minDs)){
                role = temp;
            }
        }
    }
    return role;
}




