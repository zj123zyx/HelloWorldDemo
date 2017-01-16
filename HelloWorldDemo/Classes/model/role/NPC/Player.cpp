//
//  Player.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "Player.hpp"
#include "RolesController.hpp"
#include "Goods.hpp"
#include "BookCreateView.hpp"
#include "TouchUI.h"

Player* Player::createWithPicName(string pic_name)
{
    Player *pRet = new(std::nothrow) Player();
    if (pRet && pRet->initWithPicName(pic_name))
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

bool Player::initWithPicName(string pic_name){
    bool ret = false;
    if(Role::init()){
        ret = true;
        m_roleType = RoleType_Player;
        m_width=60;//32;//自身宽度
        m_height=60;//32;//自身高度
        m_bagValue = 8;
        m_fightValue.m_moveSpeed = 5;
//        m_fightValue.m_useType=1;
        m_fightValue.m_health=10;
        m_fightValue.m_attack=2;
        m_fightValue.m_attackCD=3;
        m_fightValue.m_attackRange=1;
        m_selfValue.m_name="me";
        m_maxFightValue = m_fightValue;
        m_isDead=false;
        
        setRoleSpriteFrame(pic_name);
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
        setAnimation(ROLW_MOVE_DOWN,"res/Roles/assassin1a.png",0,2);
        setAnimation(ROLW_MOVE_LEFT,"res/Roles/assassin1a.png",3,5);
        setAnimation(ROLW_MOVE_RIGHT,"res/Roles/assassin1a.png",6,8);
        setAnimation(ROLW_MOVE_UP,"res/Roles/assassin1a.png",9,11);
    }
    return ret;
}

void Player::onEnter(){
    Role::onEnter();
}
void Player::onExit(){
    Role::onExit();
}

void Player::move(Point point){
    if(!m_isDead){
        Role::move(point);
        m_container->setPosition(this->getPositionInScreen()-this->getPosition());
        if(m_isLayingBuild && m_virtualBuild){
            m_virtualBuild->refreshPosition(Vec2(m_tileX, m_tileY));
        }
    }
}

void Player::moveTo(Point point){
    if(!m_isDead){
        Role::moveTo(point);
    }
}

void Player::setPosition(const Vec2 &position){
    Node::setPosition(position);
    if(m_container){
        m_container->setPosition(this->getPositionInScreen()-this->getPosition());
    }
}

void Player::doActionToTarget(){//对目标操作
    if (m_target && !m_isDead) {
        switch (m_target->m_roleType) {
            case RoleType_NPCRole:
            case RoleType_Tree:
            {
                Role::roleAttackTarget(this);
            }
                break;
            case RoleType_Resource:
            {
                Resourse* resourse = (Resourse*)m_target;
                resourse->getThisItem(this);
            }
                break;
                
            default:
                break;
        }
    }
}

void Player::doActionWithEquipedUIRes(Resourse* resourse){//通过UI中装备实行操作
    log("Player::doActionWithEquipedUIRes");
    if(resourse->m_resourceType==ResourceType_Goods){
        Goods* goods = dynamic_cast<Goods*>(resourse);
        if(goods->m_GoodsType==GoodsType_Book){
            log("GoodsType_Book");
            BookCreateView* bookView = BookCreateView::create();
            TouchUI::getInstance()->m_addViewNode->addChild(bookView);
        }
    }
}

int Player::beAttackedByRole(Role* selfRole,int hurt){//被攻击 返回生命值
    m_fightValue.m_health -= hurt;
    showDescription(true);
    if(m_fightValue.m_health<=0){//如果生命为0就变为木材
        m_isDead=true;
    }
    return m_fightValue.m_health;
}

void Player::layBuild(VirtualBuild* vb){//放置建筑
    m_isLayingBuild=true;
    m_virtualBuild = vb;
    RolesController::getInstance()->addVirtualBuildToTiledMapByPoint(m_virtualBuild,Vec2(m_tileX, m_tileY));
    TouchUI::getInstance()->setUiByType(UIShowType_VirtualBuild);
//    this->getParent()->addChild(m_virtualBuild);
//    Sprite* sprite = CommonUtils::createSprite("BlackFrame10X10.png");
//    CommonUtils::setSpriteMaxSize(sprite, 64, true);
//    this->addChild(sprite);
}












