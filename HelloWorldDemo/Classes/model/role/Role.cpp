//
//  Role.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "Role.hpp"
#include "RolesController.hpp"
#include "PlayerController.hpp"

Role::Role(){
    
}
Role::~Role(){
    map<string, Animation*>::iterator it = m_aniMap.begin();
    for (; it!=m_aniMap.end(); it++) {
        it->second->release();
    }
}

Role* Role::createWithPicName(string pic_name)
{
    Role *pRet = new(std::nothrow) Role();
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

bool Role::initWithPicName(string pic_name){
    bool ret = false;
    if(Node::init()){
        ret = true;
        m_rolePicName = pic_name;
        m_moveSpeed = 0;
        m_container = nullptr;
        m_target = nullptr;
        m_direction = Vec2(0, -1);
        m_faceTo = FaceTo_NULL;
        m_tileX = 0;
        m_tileY = 0;
        m_nextTileX = Vec2::ZERO;
        m_nextTileY = Vec2::ZERO;
        m_nextTileXY = Vec2::ZERO;
        m_nextTileXX = Vec2::ZERO;
        m_nextTileYY = Vec2::ZERO;
        m_width=0;//32;//自身宽度
        m_height=0;//32;//自身高度
        m_roleType=RoleType_Role;
        m_selfValue = SelfValues();
        m_fightValue = FightValues();
        m_resourceValue = ResourceValues();
        
        m_desNode = Node::create();
        this->addChild(m_desNode);
        m_desNode->setPositionY(20);
        m_desNode->setVisible(false);
//        m_upLabel = Label::createWithSystemFont(".", "", 12);
//        m_upLabel->setAnchorPoint(Vec2(0.5, 0.5));
//        if(m_upLabel){
//            m_desNode->addChild(m_upLabel);
//        }
    }
    return ret;
}

void Role::onEnter(){
    Node::onEnter();
}
void Role::onExit(){
    this->unschedule(schedule_selector(Role::moveToSchedule));
    Node::onExit();
}

void Role::startMove(Point point){
    setDirection(point);
    this->unschedule(schedule_selector(Role::moveToSchedule));
}

void Role::move(Point point){
    //得到自己的坐标
    Vec2 ptLocation = this->getPosition();
    //获取地图中每个图块的大小
    Size tileSize = m_container->getTileSize();
    //获得地图中图块的个数
    Size mapSize = m_container->getMapSize();
    Vec2 ptInMap;
    ptInMap.y = mapSize.height * tileSize.height - ptLocation.y;
    ptInMap.x = ptLocation.x;
    m_tileX = ptInMap.x / tileSize.width;
    m_tileY = ptInMap.y / tileSize.height;
    int nextX = point.x>0?(m_tileX+1):(m_tileX-1);
    int nextY = point.y>0?(m_tileY-1):(m_tileY+1);

    m_nextTileX = Vec2(nextX, m_tileY);
    m_nextTileY = Vec2(m_tileX, nextY);
    m_nextTileXY = Vec2(nextX, nextY);
    if(point.x>0 && point.y>0){
        m_nextTileXX = Vec2(nextX, m_tileY+1);
        m_nextTileYY = Vec2(m_tileX-1, nextY);
    }
    if(point.x<0 && point.y>0){
        m_nextTileXX = Vec2(nextX, m_tileY+1);
        m_nextTileYY = Vec2(m_tileX+1, nextY);
    }
    if(point.x<0 && point.y<0){
        m_nextTileXX = Vec2(nextX, m_tileY-1);
        m_nextTileYY = Vec2(m_tileX+1, nextY);
    }
    if(point.x>0 && point.y<0){
        m_nextTileXX = Vec2(nextX, m_tileY-1);
        m_nextTileYY = Vec2(m_tileX-1, nextY);
    }

    
    setDirection(point);
    if(m_container){
        float mapHeight = mapSize.height * tileSize.height;//地图高度，算y坐标使用
        Point movePoint = point;
        if(isVecCanGo(m_nextTileX)==false || isVecCanGo(m_nextTileXX)==false){//
            movePoint.x=0;
            if(isHaveRole(m_nextTileX)){
                movePoint.y=0;
            }
        }
        if(isVecCanGo(m_nextTileY)==false || isVecCanGo(m_nextTileYY)==false){//
            movePoint.y=0;
            if(isHaveRole(m_nextTileY)){
                movePoint.x=0;
            }
        }
        if(isVecCanGo(m_nextTileXY)==false){
            movePoint.x=0;
            movePoint.y=0;
            
            float tileUp = mapHeight-m_nextTileXY.y*tileSize.width;
            float tileDown = mapHeight-(m_nextTileXY.y+1)*tileSize.width;
            float tileLeft = m_nextTileXY.x*tileSize.width;
            float tileRight = (m_nextTileXY.x+1)*tileSize.width;
            
            float tileX = (tileUp+tileDown)/2;
            float tileY = (tileLeft+tileRight)/2;
            float dxy = 1;
            if(ptLocation.x>tileX && ptLocation.y>tileY){
                movePoint.x+=dxy;
                movePoint.y+=dxy;
            }
            if(ptLocation.x<tileX && ptLocation.y>tileY){
                movePoint.x-=dxy;
                movePoint.y+=dxy;
            }
            if(ptLocation.x<tileX && ptLocation.y<tileY){
                movePoint.x-=dxy;
                movePoint.y-=dxy;
            }
            if(ptLocation.x>tileX && ptLocation.y<tileY){
                movePoint.x+=dxy;
                movePoint.y-=dxy;
            }
        }
        Vec2 ptInMap;
        ptInMap.y = mapHeight - ptLocation.y+(tileSize.height/2);
        ptInMap.x = ptLocation.x+(tileSize.width/2);
        int tx = ptInMap.x / tileSize.width;
        int ty = ptInMap.y / tileSize.height;
        if((point.x<0 && tx<=0) || (point.x>0 && tx>=mapSize.width)){
            movePoint.x=0;
            this->unschedule(schedule_selector(Role::moveToSchedule));
        }
        if((point.y>0 && ty<=0) || (point.y<0 && ty>=mapSize.height)) {
            movePoint.y=0;
            this->unschedule(schedule_selector(Role::moveToSchedule));
        }
        
        {//显示属性
            int gid = getFaceToTileGID("layer_1");
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            m_upLabel->setString(goThrough);
        }
        this->setPosition(this->getPosition()+(movePoint.getNormalized()*m_moveSpeed));
        Point faceToPoint = getFaceToTilePoint();//得到朝向的点
        Role* role = RolesController::getInstance()->getRoleByTile(faceToPoint);//是否有角色
        if (role) {
            setTarget(role);
        }else{
            removeTarget();
        }
    }
}

void Role::stopMove(Point point){
    m_roleSprite->stopActionByTag(1);
    SpriteFrame* frame = nullptr;
    switch (m_faceTo) {
        case FaceTo_UP:
            frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),10);
            break;
        case FaceTo_DOWN:
            frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),1);
            break;
        case FaceTo_LEFT:
            frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),4);
            break;
        case FaceTo_RIGHT:
            frame = CommonUtils::createRoleSpriteFrameBySizeNumber(m_rolePicName, Size(32, 32),7);
            break;
            
        default:
            break;
    }
    m_roleSprite->setSpriteFrame(frame);
}

void Role::moveTo(Point point){
    m_moveVector = point-getPositionInScreen();
    m_moveToPoint = this->getPosition()+m_moveVector;
    this->unschedule(schedule_selector(Role::moveToSchedule));
    this->schedule(schedule_selector(Role::moveToSchedule));
}

void Role::moveToSchedule(float dt){
    if(m_moveToPoint.getDistance(this->getPosition())<10){
        this->unschedule(schedule_selector(Role::moveToSchedule));
        stopMove(Vec2::ZERO);
    }else{
        move(m_moveVector);
    }
}

Point Role::getPositionInScreen(){
    Size wSize = Director::getInstance()->getWinSize();
    return Vec2(wSize.width/2, wSize.height/2);
}

void Role::setContainer(TMXTiledMap* container){
    m_container = container;
}

void Role::setAnimation(const char* aniName,string frameName,int fromCount,int toCount,Size roleSize,float dTime){
    Vector<SpriteFrame *> array;
    for (int i=fromCount; i<toCount; i++) {
//        string tempName = __String::createWithFormat("%s%d.png",frameName.c_str(),i)->getCString();
//        SpriteFrame* frame = CommonUtils::createSpriteFrame(tempName);
        SpriteFrame* frame = CommonUtils::createRoleSpriteFrameBySizeNumber(frameName, roleSize,i);
        if(frame){
            array.pushBack(frame);
        }
    }
    if (array.size()>0) {
        if (m_aniMap.find(aniName)!=m_aniMap.end()) {
            Animation* ani = m_aniMap[aniName];
            if(ani){
                ani->release();
            }
        }
        auto animation = Animation::createWithSpriteFrames(array, dTime);
        animation->retain();
        m_aniMap[aniName]=animation;
    }
}

int Role::getLayerTileGIDAtPoint(string layerName, Point point){
    Size mapSize = m_container->getMapSize();
    if(point.x>=0 && point.x<mapSize.width && point.y>=0 && point.y<mapSize.height){
        TMXLayer* layer = m_container->getLayer(layerName.c_str());//layerNamed("layer_0");
        int gid = layer->getTileGIDAt(point);
        return gid;
    }else{
        return 0;
    }
}

Point Role::getFaceToTilePoint(){//获得面向的位置
    Vec2 ret = Vec2::ZERO;
    int tx = m_tileX;
    int ty = m_tileY;
    switch (m_faceTo) {
        case FaceTo_UP:
            ty-=1;
            break;
        case FaceTo_DOWN:
            ty+=1;
            break;
        case FaceTo_LEFT:
            tx-=1;
            break;
        case FaceTo_RIGHT:
            tx+=1;
            break;
        default:
            break;
    }
    ret = Vec2(tx, ty);
    return ret;
}

int Role::getFaceToTileGID(string layerName){
    int gid = getLayerTileGIDAtPoint(layerName,getFaceToTilePoint());
    return gid;
}
string Role::getPropertyByGIDAndNameToString(int gid,string propertyName){
    string ret = "";
    if (gid>0) {
        Value tValue = m_container->getPropertiesForGID(gid);
        ValueMap tMap = tValue.asValueMap();
        log("propertyName = %s ", tMap.at(propertyName.c_str()).asString().c_str());
        ret = tMap.at(propertyName.c_str()).asString();
    }
    return ret;
}

void Role::setDirection(Point point){
    m_direction = point.getNormalized();
    FaceTo tempFaceTo = FaceTo_NULL;
    if (m_direction.x>0 && m_direction.y>0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            tempFaceTo = FaceTo_RIGHT;
        }else{
            tempFaceTo = FaceTo_UP;
        }
    }
    if (m_direction.x<0 && m_direction.y>0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            tempFaceTo = FaceTo_LEFT;
        }else{
            tempFaceTo = FaceTo_UP;
        }
    }
    if (m_direction.x<0 && m_direction.y<0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            tempFaceTo = FaceTo_LEFT;
        }else{
            tempFaceTo = FaceTo_DOWN;
        }
    }
    if (m_direction.x>0 && m_direction.y<0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            tempFaceTo = FaceTo_RIGHT;
        }else{
            tempFaceTo = FaceTo_DOWN;
        }
    }
    
    if(m_faceTo != tempFaceTo && tempFaceTo!=FaceTo_NULL){
        m_faceTo = tempFaceTo;
        onDirectionChanged();
    }
}

void Role::onDirectionChanged(){
    Animation* moveAni = nullptr;
    switch (m_faceTo) {
        case FaceTo_UP:
        {
            if (m_aniMap.find(ROLW_MOVE_UP)!=m_aniMap.end()) {
                moveAni = m_aniMap[ROLW_MOVE_UP];
            }
        }
            break;
        case FaceTo_DOWN:
        {
            if (m_aniMap.find(ROLW_MOVE_DOWN)!=m_aniMap.end()) {
                moveAni = m_aniMap[ROLW_MOVE_DOWN];
            }
        }
            break;
        case FaceTo_LEFT:
        {
            if (m_aniMap.find(ROLW_MOVE_LEFT)!=m_aniMap.end()) {
                moveAni = m_aniMap[ROLW_MOVE_LEFT];
            }
        }
            break;
        case FaceTo_RIGHT:
        {
            if (m_aniMap.find(ROLW_MOVE_RIGHT)!=m_aniMap.end()) {
                moveAni = m_aniMap[ROLW_MOVE_RIGHT];
            }
        }
            break;
            
        default:
            break;
    }
    if (moveAni) {
        Action* moveAct = RepeatForever::create(Animate::create(moveAni));
        moveAct->setTag(1);
        m_roleSprite->stopActionByTag(1);
        m_roleSprite->runAction(moveAct);
    }
}

bool Role::isVecCanGo(Vec2 vec){
    
    int gid = getLayerTileGIDAtPoint("layer_1",vec);
    string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
    Vec2 ptLocation = this->getPosition();
    Size tileSize = m_container->getTileSize();
    Size mapSize = m_container->getMapSize();
    float mapHeight = mapSize.height * tileSize.height;//地图高度，算y坐标使用
    if(goThrough=="1" && CommonUtils::isRectInTile(ptLocation, m_width, m_height, Rect(vec.x, vec.y, tileSize.width, tileSize.height),mapHeight)){
        this->unschedule(schedule_selector(Role::moveToSchedule));
        return false;
    }
    Role* role = RolesController::getInstance()->getRoleByTile(vec);
    if (role!=nullptr && CommonUtils::isRectInTile(ptLocation, m_width, m_height, Rect(vec.x, vec.y, role->m_width, role->m_height),mapHeight)) {
        this->unschedule(schedule_selector(Role::moveToSchedule));
        return false;
    }
    return true;
}
bool Role::isHaveRole(Vec2 vec){//是否有role
    Role* role = RolesController::getInstance()->getRoleByTile(vec);
    if(role){
        return true;
    }else{
        return false;
    }
}

void Role::roleAttackTarget(Role* selfRole){//攻击
    if(m_target){
        int hitValue = m_fightValue.m_attack-m_target->m_fightValue.m_defense;
        hitValue = MAX(hitValue, 0);
        int roleHealth = m_target->beAttackedByRole(selfRole,hitValue);
//        if(roleHealth<=0){
//            m_target=nullptr;
//        }
    }
}

int Role::beAttackedByRole(Role* selfRole,int hurt){//被攻击
    m_fightValue.m_health -= hurt;
    showDescription(true);
    if (m_fightValue.m_health<=0) {
        this->removeFromParent();
        RolesController::getInstance()->removeRoleByTile(Vec2(m_tileX, m_tileY));//删除角色
    }
    return m_fightValue.m_health;
}

void Role::getThisItem(Role* role){//获得此物品
    if (role->m_roleType==RoleType_Player) {
        PlayerController::getInstance()->getItem(this);
        this->removeFromParent();
        RolesController::getInstance()->removeRoleByTile(Vec2(m_tileX, m_tileY));//删除角色
        role->m_target=nullptr;
    }
}

void Role::showDescription(bool show){
    m_desNode->setVisible(show);
}

void Role::setTarget(Role* target){
    m_target = target;
}

void Role::removeTarget(){
    if(m_target){
        m_target = nullptr;
    }
}
