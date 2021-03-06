//
//  NPCRole.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/10.
//
//

#include "NPCRole.hpp"
#include "RolesController.hpp"
#include "Resourse.hpp"
#include "PlayerController.hpp"
#include "Wood.hpp"
#include "Player.hpp"

NPCRole* NPCRole::createWithNpcId(string npcId){
    NPCRole *pRet = new(std::nothrow) NPCRole();
    if (pRet && pRet->initWithNpcId(npcId))
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        delete pRet;
        pRet = nullptr;
        return nullptr;
    }
}
bool NPCRole::initWithNpcId(string npcId){
    bool ret = false;
    if(Role::init()){
        ret = true;
        m_selfValue.m_XMLId=npcId;
        m_roleType = RoleType_NPCRole;
        
        string nameStr = CommonUtils::getPropById(npcId,"name");
        string description = CommonUtils::getPropById(npcId,"description");
        string picture = CommonUtils::getPropById(npcId,"picture");
        int width = atoi(CommonUtils::getPropById(npcId, "width").c_str());
        int height = atoi(CommonUtils::getPropById(npcId, "height").c_str());
        int bagValue = atoi(CommonUtils::getPropById(npcId, "bagValue").c_str());
        float moveSpeed = atof(CommonUtils::getPropById(npcId, "moveSpeed").c_str());
        float health = atof(CommonUtils::getPropById(npcId, "health").c_str());
        float attack = atof(CommonUtils::getPropById(npcId, "attack").c_str());
        float attackCD = atof(CommonUtils::getPropById(npcId, "attackCD").c_str());
        float attackRange = atof(CommonUtils::getPropById(npcId, "attackRange").c_str());
        int sticky = atoi(CommonUtils::getPropById(npcId, "sticky").c_str());
        
        m_width=width;//自身宽度
        m_height=height;//自身高度
        m_selfValue.m_name=nameStr;
        m_selfValue.m_sticky=(sticky>0);
        m_bagValue = bagValue;
        m_fightValue.m_moveSpeed = moveSpeed;
        m_fightValue.m_health=health;
        m_fightValue.m_attack=attack;
        m_fightValue.m_attackCD=attackCD;
        m_fightValue.m_attackRange=attackRange;
        
        m_maxFightValue = m_fightValue;
        
        setRoleSpriteFrame(picture);
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        m_roleSprite->setScale(2);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
        m_upLabel = Label::createWithSystemFont(".", "", 14);
        m_upLabel->setAnchorPoint(Vec2(0.5, 0));
        m_upLabel->setPositionY(4);
        if(m_upLabel){
            m_desNode->addChild(m_upLabel);
        }
        //设置动画
        setAnimation(ROLW_MOVE_DOWN,picture,0,2);
        setAnimation(ROLW_MOVE_LEFT,picture,3,5);
        setAnimation(ROLW_MOVE_RIGHT,picture,6,8);
        setAnimation(ROLW_MOVE_UP,picture,9,11);
    }
    return ret;
}

void NPCRole::onEnter(){
    Role::onEnter();
    this->unschedule(schedule_selector(NPCRole::NPCSchedule));
    this->schedule(schedule_selector(NPCRole::NPCSchedule));
}
void NPCRole::onExit(){
    this->unschedule(schedule_selector(NPCRole::NPCSchedule));
    Role::onExit();
}

void NPCRole::NPCSchedule(float dt){
    Player* player = PlayerController::getInstance()->player;
    if(player && player->m_isDead==false){
        Point playerPoint = player->getPosition();
        float dist = playerPoint.getDistance(this->getPosition());
        if(dist<200 && (dist>m_width || m_target==nullptr)){
            Point dPoint = playerPoint - this->getPosition();
            move(dPoint);
        }else{
            stopMove(Vec2::ZERO);
        }
        if(m_fightValue.m_attackCD>=m_maxFightValue.m_attackCD){
            doActionToTarget();
        }else{
            m_fightValue.m_attackCD+=dt;
        }
    }else{
        this->unschedule(schedule_selector(NPCRole::NPCSchedule));
    }
    
}

void NPCRole::move(Point point){
    if(m_roleSprite->getActionByTag(1)==nullptr){
        m_faceTo=FaceTo_NULL;
    }
    Role::move(point);
}

void NPCRole::moveTo(Point point){
    Role::moveTo(point);
}

void NPCRole::setPosition(const Vec2 &position){
    Node::setPosition(position);
}

void NPCRole::doActionToTarget(){
    if (m_target) {
        switch (m_target->m_roleType) {
            case RoleType_Player:
            {
                Player* player = (Player*)m_target;
                if(!player->m_isDead){
                    Role::roleAttackTarget(this);
                }
            }
                break;
            default:
                break;
        }
        m_fightValue.m_attackCD=0;
    }
}

void NPCRole::setTarget(Role* target){
    Role::setTarget(target);
    if(m_target){
        m_target->showDescription(true);
    }
}

void NPCRole::removeTarget(){
    if(m_target){
        m_target->showDescription(false);
    }
    Role::removeTarget();
}

void NPCRole::showDescription(bool show){
    Role::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s:%d",m_selfValue.m_name.c_str(),m_fightValue.m_health)->getCString();
        m_upLabel->setString(str);
    }
}

int NPCRole::beAttackedByRole(Role* selfRole,int hurt){//被攻击 返回生命值
    int saveX = m_tileX;
    int saveY = m_tileY;
    int ret = Role::beAttackedByRole(selfRole,hurt);
    if(m_fightValue.m_health<=0){//如果生命为0就变为木材
        Wood* wood = Wood::createWithPicName();
        wood->setTileXY(saveX, saveY);
        RolesController::getInstance()->addControllerRole(wood,true);
        selfRole->setTarget(wood);
    }
    return ret;
}
