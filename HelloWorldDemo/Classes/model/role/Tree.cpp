//
//  Tree.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/26.
//
//

#include "Tree.hpp"
#include "Wood.hpp"
#include "RolesController.hpp"

Tree* Tree::createWithPicName(string pic_name)
{
    Tree *pRet = new(std::nothrow) Tree();
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

bool Tree::initWithPicName(string pic_name){
    bool ret = false;
    if(Role::initWithPicName(pic_name)){
        ret = true;
        totalHealth = 10;
        m_roleType = RoleType_Tree;
        m_width=64;//自身宽度
        m_height=64;//自身高度
        m_fightValue.m_health=totalHealth;
        m_selfValue.m_name="松树";
        m_selfValue.m_sticky=true;
        
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        m_roleSprite->setScale(2);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
        m_healthBg = Scale9Sprite::createWithSpriteFrame(CommonUtils::createSpriteFrame("BlackFrame10X10.png"));
        m_healthBg->setContentSize(Size(68, 14));
        m_healthBg->setAnchorPoint(Vec2(0.5, 0));
        m_healthBg->setPositionY(4);
        m_desNode->addChild(m_healthBg);
        
        m_healthBar = Scale9Sprite::createWithSpriteFrame(CommonUtils::createSpriteFrame("RedFrame10X10.png"));
        m_healthBar->setContentSize(Size(64, 10));
        m_healthBar->setAnchorPoint(Vec2(0, 0));
        m_healthBar->setPosition(-32, 6);
        m_desNode->addChild(m_healthBar);
        
        m_upLabel = Label::createWithSystemFont(".", "", 12);
        m_upLabel->setPositionY(18);
        m_upLabel->setAnchorPoint(Vec2(0.5, 0));
        m_desNode->addChild(m_upLabel);
    }
    return ret;
}

void Tree::onEnter(){
    Role::onEnter();
}
void Tree::onExit(){
    Role::onExit();
}

void Tree::showDescription(bool show){
    Role::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s:%d",m_selfValue.m_name.c_str(),m_fightValue.m_health)->getCString();
        m_upLabel->setString(str);
    }
}

int Tree::beAttackedByRole(Role* selfRole,int hurt){//被攻击 返回生命值
    int saveX = m_tileX;
    int saveY = m_tileY;
    int ret = Role::beAttackedByRole(selfRole,hurt);
    if(m_fightValue.m_health<=0){//如果生命为0就变为木材
        Wood* wood = Wood::createWithPicName("res/Roles/assassin1a.png");
        wood->setTileXY(saveX, saveY);
        RolesController::getInstance()->addControllerRole(wood,true);
        selfRole->setTarget(wood);
    }else{
        float healthPercent = (m_fightValue.m_health*1.0)/(totalHealth*1.0);
        m_healthBar->setScaleX(healthPercent);
    }
    return ret;
}
