//
//  Role.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "Role.hpp"

Role::Role(){
    
}
Role::~Role(){
    map<string, Animation*>::iterator it = m_aniMap.begin();
    for (; it!=m_aniMap.end(); it++) {
        it->second->release();
    }
}

bool Role::init(){
    bool ret = false;
    if(Node::init()){
        ret = true;
        m_moveSpeed = 0.5;
        m_container = nullptr;
        m_direction = Vec2(0, -1);
        m_faceTo = FaceTo_NULL;
        m_tileX = 0;
        m_tileY = 0;
        m_nextTileX = Vec2(0, 0);
        m_nextTileY = Vec2(0, 0);
        m_width=32;//自身宽度
        m_height=32;//自身高度
        
        m_roleSprite = CommonUtils::createSprite("UI_time_1.png");
        m_roleSprite->setScale(0.5);
        if(m_roleSprite){
            this->addChild(m_roleSprite);
        }
        
        m_upLabel = Label::createWithSystemFont(".", "", 12);
        m_upLabel->setAnchorPoint(Vec2(0.5, 0.5));
        m_upLabel->setPositionY(20);
        if(m_upLabel){
            this->addChild(m_upLabel);
        }
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
    if (m_aniMap.find("move")!=m_aniMap.end()) {
        Animation* moveAni = m_aniMap["move"];
        Action* moveAct = RepeatForever::create(Animate::create(moveAni));
        moveAct->setTag(1);
        m_roleSprite->stopActionByTag(1);
        m_roleSprite->runAction(moveAct);
    }
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
    
    m_direction = point.getNormalized();
    if (m_direction.x>0 && m_direction.y>0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            m_faceTo = FaceTo_RIGHT;
        }else{
            m_faceTo = FaceTo_UP;
        }
    }
    if (m_direction.x<0 && m_direction.y>0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            m_faceTo = FaceTo_LEFT;
        }else{
            m_faceTo = FaceTo_UP;
        }
    }
    if (m_direction.x<0 && m_direction.y<0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            m_faceTo = FaceTo_LEFT;
        }else{
            m_faceTo = FaceTo_DOWN;
        }
    }
    if (m_direction.x>0 && m_direction.y<0) {
        if (abs(m_direction.x)>abs(m_direction.y)) {
            m_faceTo = FaceTo_RIGHT;
        }else{
            m_faceTo = FaceTo_DOWN;
        }
    }
    if(m_container){
        float mapHeight = mapSize.height * tileSize.height;
        Point movePoint = point;
        {   //碰撞检测X
            int gid = getLayerTileGIDAtPoint("layer_1",m_nextTileX);
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            if(goThrough=="1" && CommonUtils::isRectInTile(ptLocation, m_width, m_height, m_nextTileX.x, m_nextTileX.y, tileSize.width,mapHeight)){
                movePoint.x=0;
            }
        }
        {   //碰撞检测Y
            int gid = getLayerTileGIDAtPoint("layer_1",m_nextTileY);
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            if(goThrough=="1" && CommonUtils::isRectInTile(ptLocation, m_width, m_height, m_nextTileY.x, m_nextTileY.y, tileSize.width,mapHeight)){
                movePoint.y=0;
            }
        }
        {   //碰撞检测XY
            int gid = getLayerTileGIDAtPoint("layer_1",m_nextTileXY);
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            if(goThrough=="1" && CommonUtils::isRectInTile(ptLocation, m_width, m_height, m_nextTileXY.x, m_nextTileXY.y, tileSize.width,mapHeight)){
                movePoint.x=0;
                movePoint.y=0;
                
                float tileUp = mapHeight-m_nextTileXY.y*tileSize.width;
                float tileDown = mapHeight-(m_nextTileXY.y+1)*tileSize.width;
                float tileLeft = m_nextTileXY.x*tileSize.width;
                float tileRight = (m_nextTileXY.x+1)*tileSize.width;
                
                float tileX = (tileUp+tileDown)/2;
                float tileY = (tileLeft+tileRight)/2;
                float dxy = 0.2;
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
        }
        Vec2 ptInMap;
        ptInMap.y = mapHeight - ptLocation.y+(tileSize.height/2);
        ptInMap.x = ptLocation.x+(tileSize.width/2);
        int tx = ptInMap.x / tileSize.width;
        int ty = ptInMap.y / tileSize.height;
        if((point.x<0 && tx<=0) || (point.x>0 && tx>=mapSize.width)){
            movePoint.x=0;
        }
        if((point.y>0 && ty<=0) || (point.y<0 && ty>=mapSize.height)) {
            movePoint.y=0;
        }
        
        {//显示属性
            Vec2 ptInMap;
            ptInMap.y = mapHeight - ptLocation.y;
            ptInMap.x = ptLocation.x;
            int tx = ptInMap.x / tileSize.width;
            int ty = ptInMap.y / tileSize.height;
            int gid = getFaceToTileGID(tx,ty,"layer_1");
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            m_upLabel->setString(goThrough);
        }
        this->setPosition(this->getPosition()+(movePoint/10*m_moveSpeed));
    }
}

void Role::stopMove(Point point){
    m_roleSprite->stopActionByTag(1);
}

void Role::moveTo(Point point){
    m_moveVector = point-getPositionInScreen();
    m_moveToPoint = this->getPosition()+m_moveVector;
    
//    this->setPosition(m_moveToPoint);
//    m_container->setPosition(this->getPositionInScreen()-this->getPosition());
    
    this->unschedule(schedule_selector(Role::moveToSchedule));
    this->schedule(schedule_selector(Role::moveToSchedule));
}

void Role::moveToSchedule(float dt){
    if(m_moveToPoint.getDistance(this->getPosition())<10){
        this->unschedule(schedule_selector(Role::moveToSchedule));
    }else{
//        m_moveVector = m_moveToPoint-this->getPosition();
//        m_moveVector = m_moveVector.getNormalized();
        move((m_moveVector/(10*m_moveSpeed)));
    }
}

Point Role::getPositionInScreen(){
    Size wSize = Director::getInstance()->getWinSize();
    return Vec2(wSize.width/2, wSize.height/2);
}

void Role::setContainer(TMXTiledMap* container){
    m_container = container;
}

void Role::setAnimation(const char* aniName,string frameName,int frameCount,float dTime){
    Vector<SpriteFrame *> array;
    for (int i=0; i<frameCount; i++) {
        string tempName = __String::createWithFormat("%s%d.png",frameName.c_str(),i)->getCString();
        SpriteFrame* frame = CommonUtils::createSpriteFrame(tempName);
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

int Role::getFaceToTileGID(int x,int y,string layerName){
    int tx = x;
    int ty = y;
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
    int gid = getLayerTileGIDAtPoint(layerName,Point(tx, ty));
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








