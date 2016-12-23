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

bool CommonUtils::isRectInTile(Point rectCenter,float rectWidth,float rectHeight,int tileX,int tileY,float tileSize,float mapHeight){
    bool ret = true;
    float rectUp = rectCenter.y + rectHeight/2;
    float rectDown = rectCenter.y - rectHeight/2;
    float rectRight = rectCenter.x + rectWidth/2;
    float rectLeft = rectCenter.x - rectWidth/2;
    
    float tileUp = mapHeight-tileY*tileSize;
    float tileDown = mapHeight-(tileY+1)*tileSize;
    float tileLeft = tileX*tileSize;
    float tileRight = (tileX+1)*tileSize;
    
    if(rectUp<tileDown || rectDown>tileUp || rectLeft>tileRight || rectRight<tileLeft){
        ret = false;
    }
    return ret;
}
