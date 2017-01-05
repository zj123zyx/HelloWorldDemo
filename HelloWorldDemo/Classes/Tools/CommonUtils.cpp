//
//  CommonUtils.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/21.
//
//

#include "CommonUtils.hpp"

Sprite* CommonUtils::createSprite(string pic_name){
    Sprite* sprite = nullptr;
    SpriteFrame* frame = createSpriteFrame(pic_name);
    if(frame){
        sprite = Sprite::createWithSpriteFrame(frame);
    }else{
        CCLOG("frame is nul,pic_name====>%s",pic_name.c_str());
    }
    return sprite;
}

SpriteFrame* CommonUtils::createSpriteFrame(string pic_name){
    SpriteFrame* frame = SpriteFrameCache::getInstance()->getSpriteFrameByName(pic_name);
    return frame;
}

SpriteFrame* CommonUtils::createRoleSpriteFrameBySizeNumber(string pic_name,Size RoleSize, int Number){
    SpriteFrame* frame = nullptr;
    Texture2D *texture = Director::getInstance()->getTextureCache()->addImage(pic_name);
    if (texture)
    {
        Size tSize = texture->getContentSize();
        int rowNum = tSize.width/RoleSize.width;
//        int colNum = tSize.height/RoleSize.height;
        int row = Number/rowNum;
        int col = Number%rowNum;
        Rect rect = Rect::ZERO;
        rect.size = RoleSize;
        rect.origin.x = col*RoleSize.width;
        rect.origin.y = row*RoleSize.height;
        frame = SpriteFrame::create(pic_name, rect);
    }
    return frame;
}

bool CommonUtils::isRectInTile(Point rectCenter,float rectWidth,float rectHeight,Rect tileRect,float mapHeight){
    bool ret = true;
    float rectUp = rectCenter.y + rectHeight/2;
    float rectDown = rectCenter.y - rectHeight/2;
    float rectRight = rectCenter.x + rectWidth/2;
    float rectLeft = rectCenter.x - rectWidth/2;
    
    float tileUp = mapHeight-tileRect.origin.y*tileRect.size.height;
    float tileDown = mapHeight-(tileRect.origin.y+1)*tileRect.size.height;
    float tileLeft = tileRect.origin.x*tileRect.size.width;
    float tileRight = (tileRect.origin.x+1)*tileRect.size.width;
    
    if(rectUp<tileDown || rectDown>tileUp || rectLeft>tileRight || rectRight<tileLeft){
        ret = false;
    }
    return ret;
}

int CommonUtils::getTileIdByXY(int x,int y){
    int idx = 0;
    idx = x*1000+y;
    return idx;
}
Vec2 CommonUtils::getTileXYById(int Tid){
    Vec2 ret = Vec2::ZERO;
    ret.x = Tid/1000;
    ret.y = Tid%1000;
    return ret;
}

Sprite* CommonUtils::setSpriteMaxSize(Sprite* spr, int limitNum, bool isForce){
    if( spr == NULL )
        return NULL;
    
    if (isForce || spr->getContentSize().width>limitNum || spr->getContentSize().height>limitNum) {
        float sc1 = limitNum*1.0/spr->getContentSize().width;
        float sc2 = limitNum*1.0/spr->getContentSize().height;
        spr->setScale( sc1<sc2?sc1:sc2 );
    }
    return spr;
}
