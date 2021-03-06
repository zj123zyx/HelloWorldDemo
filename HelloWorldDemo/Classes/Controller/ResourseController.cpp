//
//  ResourseController.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/30.
//
//

#include "ResourseController.hpp"
#include "PlayerController.hpp"
#include "RolesController.hpp"
#include "TouchUI.h"

static ResourseController* resourseController = NULL;

ResourseController* ResourseController::getInstance()
{
    if (!resourseController)
    {
        resourseController = new ResourseController();
    }
    return resourseController;
}

ResourseController::ResourseController(){
    
}
ResourseController::~ResourseController(){
    
}

bool ResourseController::mergeResourse(Resourse* resourse){//合并物品
    bool ret = false;
    map<int, Resourse*>::iterator it = m_resourseMap.begin();
    for (; it!=m_resourseMap.end(); it++) {
        if (it->second->m_resourceMaxValue>1 &&
            it->second->m_resourceValue>0 &&
            it->second->m_resourceType==resourse->m_resourceType &&
            it->second->m_resourceMaxValue>it->second->m_resourceValue) {
            int maxAddValue = it->second->m_resourceMaxValue-it->second->m_resourceValue;
            if(resourse->m_resourceValue<maxAddValue){
                ret=true;
                it->second->m_resourceValue += resourse->m_resourceValue;
                resourse->m_resourceValue = 0;
            }else{
                it->second->m_resourceValue += maxAddValue;
                resourse->m_resourceValue -= maxAddValue;
            }
        }
    }
    return ret;
}

int ResourseController::getBagPosition(){//获得背包空位
    int ret = -1;
    int bagValue = PlayerController::getInstance()->getBagValue();
    if(m_resourseMap.size()<bagValue){
        ret = 0;
        for (int i=0; i<bagValue; i++) {
            int temp = ret;
            map<int, Resourse*>::iterator it = m_resourseMap.begin();
            for (; it!=m_resourseMap.end(); it++) {
                if (it->second->m_bagPosition==i) {
                    ret++;
                    break;
                }
            }
            if (temp==ret) {
                break;
            }
        }
    }
    return ret;
}

bool ResourseController::getItem(Resourse* resourse){//获得物品
    bool ret = false;
    if (resourse->m_roleType==RoleType_Resource) {
        CCLOG("player getting %s:%d",resourse->m_selfValue.m_name.c_str(),resourse->m_resourceValue);
        if (mergeResourse(resourse)) {
            return true;
        }
        int bagPosition = getBagPosition();
        if (bagPosition>-1) {
            ret=true;
            resourse->m_bagPosition = bagPosition;
            resourse->retain();
            m_resourseMap[bagPosition] = resourse;
        }
    }
    return ret;
}

Resourse* ResourseController::getEquipedResInUI(){
    Resourse* ret = nullptr;
    map<int, Resourse*>::iterator it = m_resourseMap.begin();
    for (; it!=m_resourseMap.end(); it++) {
        if (it->second->m_isEquipedInUI) {
            ret = it->second;
            break;
        }
    }
    return ret;
}

void ResourseController::setEquipedResInUIByPos(int pos){
    map<int, Resourse*>::iterator it = m_resourseMap.begin();
    for (; it!=m_resourseMap.end(); it++) {
        if(it->second->m_isEquipedInUI==true){
            it->second->m_isEquipedInUI=false;
            if (it->second->m_useType==UseType_EquipInUI) {
                PlayerController::getInstance()->removeResourseFightValue(it->second);
            }
        }
    }
    if(m_resourseMap.find(pos)!=m_resourseMap.end()){
        if (m_resourseMap[pos]->m_isEquipedInUI==false) {
            m_resourseMap[pos]->m_isEquipedInUI=true;
            if (m_resourseMap[pos]->m_useType==UseType_EquipInUI) {
                PlayerController::getInstance()->addResourseFightValue(m_resourseMap[pos]);
            }
        }
    }
    //刷新UI通知
    __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
}

void ResourseController::abandonResourse(Resourse* resourse){//丢弃物品
    if(resourse && m_resourseMap.find(resourse->m_bagPosition)!=m_resourseMap.end()){
        Point faceTo = PlayerController::getInstance()->player->getFaceToTilePoint();
        if(PlayerController::getInstance()->player->isVecCanPut(faceTo)){
            m_resourseMap.erase(resourse->m_bagPosition);
            __NotificationCenter::getInstance()->postNotification("EquipView::refreshData");
            __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
            //放置物品
            resourse->setTileXY(faceTo.x,faceTo.y);
            RolesController::getInstance()->addControllerRole(resourse,true);
        }else{
            TouchUI::getInstance()->flyHint("此位置不能放置物品");
        }
    }
}

void ResourseController::equipResourse(Equip* equip){//装备物品
    if(equip && m_resourseMap.find(equip->m_bagPosition)!=m_resourseMap.end()){
        m_resourseMap.erase(equip->m_bagPosition);
        map<int, Equip*>::iterator eit = m_equipMap.begin();
        for (; eit!=m_equipMap.end(); eit++) {
            if(eit->second->m_equipType==equip->m_equipType){
                m_equipMap.erase(eit->second->m_equipType);
                PlayerController::getInstance()->removeResourseFightValue(eit->second);
                eit->second->m_bagPosition = getBagPosition();
                m_resourseMap[eit->second->m_bagPosition]=eit->second;
                break;
            }
        }
        m_equipMap[equip->m_equipType]=equip;
        PlayerController::getInstance()->addResourseFightValue(equip);
        __NotificationCenter::getInstance()->postNotification("EquipView::refreshData");
        __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
    }
}
void ResourseController::unwieldResourse(Equip* equip){//卸下装备
    int pos = getBagPosition();
    if(pos>-1){
        equip->m_bagPosition = pos;
        m_resourseMap[equip->m_bagPosition] = equip;
        m_equipMap.erase(equip->m_equipType);
        PlayerController::getInstance()->removeResourseFightValue(equip);
        __NotificationCenter::getInstance()->postNotification("EquipView::refreshData");
        __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
    }else{
        TouchUI::getInstance()->flyHint("没有足够空间放置卸下的装备");
    }
    
}

void ResourseController::costResourse(Resourse* resourse,int costValue){//消耗物品
    resourse->m_resourceValue-=costValue;
//    if(resourse->m_resourceValue<=0){
//        m_resourseMap.erase(resourse->m_bagPosition);
//        __NotificationCenter::getInstance()->postNotification("EquipView::refreshData");
//        __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
//    }
}

void ResourseController::deleteZeroValueResourse(){//删除m_resourceValue=0的物品
    map<int, Resourse*>::iterator it = m_resourseMap.begin();
    for (; it!=m_resourseMap.end(); it++) {
        Resourse* resourse = it->second;
        if(resourse->m_resourceValue<=0){
            m_resourseMap.erase(resourse->m_bagPosition);
            deleteZeroValueResourse();
            break;
        }
    }
    __NotificationCenter::getInstance()->postNotification("EquipView::refreshData");
    __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
}





