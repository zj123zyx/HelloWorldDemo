//
//  ResourseController.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/30.
//
//

#include "ResourseController.hpp"
#include "PlayerController.hpp"

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

Resourse* ResourseController::getEquipedRes(){
    Resourse* ret = nullptr;
    map<int, Resourse*>::iterator it = m_resourseMap.begin();
    for (; it!=m_resourseMap.end(); it++) {
        if (it->second->m_isEquiped) {
            ret = it->second;
            break;
        }
    }
    return ret;
}

void ResourseController::setEquipedResByPos(int pos){
    map<int, Resourse*>::iterator it = m_resourseMap.begin();
    for (; it!=m_resourseMap.end(); it++) {
        if(it->second->m_isEquiped==true){
            it->second->m_isEquiped=false;
            if (it->second->m_fightValue.m_enabled) {
                PlayerController::getInstance()->removeFightValue(it->second->m_fightValue);
            }
        }
    }
    if(m_resourseMap.find(pos)!=m_resourseMap.end()){
        if (m_resourseMap[pos]->m_isEquiped==false) {
            m_resourseMap[pos]->m_isEquiped=true;
            if (m_resourseMap[pos]->m_fightValue.m_enabled) {
                PlayerController::getInstance()->addFightValue(m_resourseMap[pos]->m_fightValue);
            }
        }
        //刷新UI通知
        __NotificationCenter::getInstance()->postNotification("TouchUI::refreshEquipNode");
    }
}












