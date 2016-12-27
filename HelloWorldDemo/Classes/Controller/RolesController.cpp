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
    int tid = CommonUtils::getTileIdByXY(tree->m_tileX, tree->m_tileY);
    m_RoleMap[tid] = tree;
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




