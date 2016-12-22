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
