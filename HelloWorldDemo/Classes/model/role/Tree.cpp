//
//  Tree.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/26.
//
//

#include "Tree.hpp"

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
        m_roleType = RoleType_Tree;
        m_width=32;//自身宽度
        m_height=32;//自身高度
        
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
        m_roleSprite = Sprite::createWithSpriteFrame(frame);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
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
        m_upLabel->setString("树");
    }
}
