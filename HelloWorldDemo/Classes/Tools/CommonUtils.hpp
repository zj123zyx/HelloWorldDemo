//
//  CommonUtils.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/21.
//
//

#ifndef CommonUtils_hpp
#define CommonUtils_hpp

#include "CCBLoadHelper.hpp"
#include "cocos2d.h"
#include "cocos-ext.h"

USING_NS_CC;
USING_NS_CC_EXT;
using namespace std;

inline const char* CC_ITOA(double v){return __String::createWithFormat("%.f", v)->getCString();}

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
    SpriteFrame* createRoleSpriteFrameBySizeNumber(string pic_name,Size RoleSize, int Number);
    bool isRectInTile(Point rectCenter,float rectWidth,float rectHeight,Rect tileRect,float mapHeight);//瓦片地图碰撞检测
    int getTileIdByXY(int x,int y);//通过坐标得到id
    Vec2 getTileXYById(int Tid);//通过id得到坐标
    Sprite* setSpriteMaxSize(Sprite* spr, int limitNum, bool isForce=false);//设置图片最大宽度
    string getPropById(std::string xmlId, std::string propName);
    void setButtonTitle(ControlButton *button, const char *str);
    void splitString(const std::string& strSrc, const std::string& strFind, std::vector<std::string>& arSplit);//字符串分割
}

#endif /* CommonUtils_hpp */
