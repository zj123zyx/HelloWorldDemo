//
//  Goods.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#include "Goods.hpp"

Goods* Goods::createWithGoodsId(string GoodsId){
    Goods *pRet = new(std::nothrow) Goods();
    if (pRet && pRet->initWithGoodsId(GoodsId))
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
bool Goods::initWithGoodsId(string GoodsId){
    bool ret = false;
    if(Resourse::init()){
        ret = true;
        initCommonData();
        
        string nameStr = CommonUtils::getPropById(GoodsId,"name");
        string description = CommonUtils::getPropById(GoodsId,"description");
        string icon = CommonUtils::getPropById(GoodsId,"icon");
        string goods_type = CommonUtils::getPropById(GoodsId,"goods_type");
        //属性
        m_selfValue.m_XMLId=GoodsId;
        m_selfValue.m_name=nameStr;
        m_selfValue.m_description=description;
        if(goods_type!=""){
            m_GoodsType = (GoodsType)atoi(goods_type.c_str());
        }
        
        //frame
        setRoleSpriteFrame(icon);
        m_roleSprite = Sprite::createWithSpriteFrame(m_roleSpriteFrame);
        CommonUtils::setSpriteMaxSize(m_roleSprite,64);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
    }
    return ret;
}

void Goods::initCommonData(){
    m_width=64;//自身宽度
    m_height=64;//自身高度
    m_resourceType=ResourceType_Goods;
    m_upLabel = Label::createWithSystemFont(".", "", 14);
    m_upLabel->setAnchorPoint(Vec2(0.5, 0));
    m_upLabel->setPositionY(4);
    if(m_upLabel){
        m_desNode->addChild(m_upLabel);
    }
}

void Goods::onEnter(){
    Resourse::onEnter();
}
void Goods::onExit(){
    Resourse::onExit();
}

void Goods::showDescription(bool show){
    Resourse::showDescription(show);
    if(show){
        string str = __String::createWithFormat("%s",m_selfValue.m_name.c_str())->getCString();
        m_upLabel->setString(str);
    }
}




