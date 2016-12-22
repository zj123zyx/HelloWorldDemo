//
//  CommonUtils.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/21.
//
//

#ifndef CommonUtils_hpp
#define CommonUtils_hpp

#include "cocos2d.h"

USING_NS_CC;
using namespace std;

inline bool isTouchInside(Node* pNode, Touch* touch)
{
    if (!pNode || !pNode->getParent())
        return false;
    Point touchLocation=pNode->getParent()->convertToNodeSpace(touch->getLocation());
    Rect bBox=pNode->getBoundingBox();
    return bBox.containsPoint(touchLocation);
}

namespace CommonUtils {
    Sprite* createSprite(string pic_name);
    SpriteFrame* createSpriteFrame(string pic_name);
}

#endif /* CommonUtils_hpp */
