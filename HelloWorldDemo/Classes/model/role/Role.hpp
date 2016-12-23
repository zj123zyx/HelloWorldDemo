//
//  Role.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#ifndef Role_hpp
#define Role_hpp

#include "CommonHead.h"

enum FaceTo{
    FaceTo_NULL=0,
    FaceTo_UP,
    FaceTo_DOWN,
    FaceTo_RIGHT,
    FaceTo_LEFT
};

class Role:public Node
{
public:
    Role();
    ~Role();
    
    CREATE_FUNC(Role);
    virtual bool init();
    
    Point getPositionInScreen();
    void setContainer(TMXTiledMap* container);
    virtual void startMove(Point point);
    virtual void move(Point point);
    virtual void stopMove(Point point);
    virtual void moveTo(Point point);
    void moveToSchedule(float dt);
    
    void setAnimation(const char* aniName,string frameName,int frameCount,float dTime = 0.2f);
    int getLayerTileGIDAtPoint(string layerName, Point point);
    int getFaceToTileGID(int x,int y,string layerName);
    string getPropertyByGIDAndNameToString(int gid,string propertyName);
    
    float m_moveSpeed;
    map<string, Animation*> m_aniMap;
    Vec2 m_direction;
    FaceTo m_faceTo;
protected:
    virtual void onEnter();
    virtual void onExit();
    
    TMXTiledMap* m_container;
    int m_tileX;//自身tile位置
    int m_tileY;//自身tile位置
    Point m_nextTileX;//X方向下一个tile位置
    Point m_nextTileY;//Y方向下一个tile位置
    Point m_nextTileXY;//斜角方向下一个tile位置
    float m_width;//自身宽度
    float m_height;//自身高度

    Sprite* m_roleSprite;
    Label* m_upLabel;
    
    Point m_moveToPoint;
    Point m_moveVector;
};

#endif /* Role_hpp */
