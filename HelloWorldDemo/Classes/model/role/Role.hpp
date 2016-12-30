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

#define ROLW_MOVE_UP "ROLW_MOVE_UP"
#define ROLW_MOVE_DOWN "ROLW_MOVE_DOWN"
#define ROLW_MOVE_RIGHT "ROLW_MOVE_RIGHT"
#define ROLW_MOVE_LEFT "ROLW_MOVE_LEFT"

enum RoleType{
    RoleType_Role=0,
    RoleType_Player,
    RoleType_Tree,
    RoleType_Resource
};

enum ResourceType{
    ResourceType_NULL=0,
    ResourceType_Wood
};

enum FaceTo{
    FaceTo_NULL=0,
    FaceTo_UP,
    FaceTo_DOWN,
    FaceTo_RIGHT,
    FaceTo_LEFT
};

class SelfValues{
public:
    SelfValues():m_name("")
    ,m_description("")
    ,m_sticky(false){};
    ~SelfValues(){};

    string m_name;
    string m_description;
    bool m_sticky;//粘性
};
class FightValues{
public:
    FightValues():m_health(0)
    ,m_defense(0)
    ,m_attack(0)
    ,m_attackCD(0)
    ,m_attackRange(0)
    {};
    ~FightValues(){};
    
    int m_health;
    int m_defense;
    int m_attack;
    int m_attackCD;
    int m_attackRange;
};
class ResourceValues{
public:
    ResourceValues():m_resourceType(ResourceType_NULL)
    ,m_value(0)
    {};
    ~ResourceValues(){};
    
    ResourceType m_resourceType;
    int m_value;
};

class Role:public Node
{
public:
    Role();
    ~Role();
    
    static Role* createWithPicName(string pic_name);
    virtual bool initWithPicName(string pic_name);
    
    Point getPositionInScreen();
    void setContainer(TMXTiledMap* container);
    virtual void startMove(Point point);
    virtual void move(Point point);
    virtual void stopMove(Point point);
    virtual void moveTo(Point point);
    void moveToSchedule(float dt);
    void setAnimation(const char* aniName,string frameName,int fromCount,int toCount,Size roleSize = Size(32, 32),float dTime = 0.2f);//设置动画
    int getLayerTileGIDAtPoint(string layerName, Point point);//获得该位置的GID
    Point getFaceToTilePoint();//获得面向的位置
    int getFaceToTileGID(string layerName);//获得面向位置的GID
    string getPropertyByGIDAndNameToString(int gid,string propertyName);//得到该GID对应的自定义属性名字
    void setDirection(Point point);//设置朝向
    void onDirectionChanged();//朝向发生改变
    bool isVecCanGo(Vec2 vec,bool unschedule = true);//是否可通过
    bool isHaveRole(Vec2 vec);//是否有role
    void roleAttackTarget(Role* selfRole);//攻击
    virtual int beAttackedByRole(Role* selfRole,int hurt);//被攻击 返回生命值
    virtual void getThisItem(Role* role);//role获得此物品
    virtual void showDescription(bool show);//显示简介
    virtual void setTarget(Role* target);//设置目标
    virtual void removeTarget();//移除目标
    virtual void setTileXY(int tx,int ty,bool setOccupy = true);//设置XY
    virtual void doAction(Role* sender){};//处理事件
    
    Role* m_target;//目标
    float m_moveSpeed;//移动速度
    map<string, Animation*> m_aniMap;
    Vec2 m_direction;//方向
    FaceTo m_faceTo;//朝向
    
    SelfValues m_selfValue;//自身属性
    FightValues m_fightValue;//战斗属性
    ResourceValues m_resourceValue;//资源属性
    int m_tileX;//自身tile位置
    int m_tileY;//自身tile位置
    vector<Vec2> m_occupy;//占用地块坐标
    RoleType m_roleType;//角色类型
    Point m_actionPoint;//事件点
//    Point m_actionShowPoint;//事件进入后出现点
protected:
    virtual void onEnter();
    virtual void onExit();
    
    TMXTiledMap* m_container;
    
    Point m_nextTileX;//X方向下一个tile位置
    Point m_nextTileY;//Y方向下一个tile位置
    Point m_nextTileXY;//斜角方向下一个tile位置
    Point m_nextTileXX;
    Point m_nextTileYY;
    
    float m_width;//自身宽度
    float m_height;//自身高度

    Sprite* m_roleSprite;
    Node* m_desNode;
    Label* m_upLabel;
    Scale9Sprite *m_healthBar;
    Scale9Sprite *m_healthBg;
    
    Point m_moveToPoint;
    Point m_moveVector;
    
    string m_rolePicName;
};

#endif /* Role_hpp */
