//
//  Player.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#include "Player.hpp"

bool Player::init(){
    bool ret = false;
    if(Role::init()){
        ret = true;
        
        setAnimation("move","UI_time_",2);
    }
    return ret;
}

void Player::onEnter(){
    Role::onEnter();
}
void Player::onExit(){
    Role::onExit();
}

void Player::move(Point point){
    Role::move(point);
    if(m_container){
        //得到自己的坐标
        Vec2 ptLocation = this->getPosition();
        //获取地图中每个图块的大小
        Size tileSize = m_container->getTileSize();
        //获得地图中图块的个数
        Size mapSize = m_container->getMapSize();
        float mapHeight = mapSize.height * tileSize.height;
        
        Point movePoint = point;
        {
            int gid = getLayerTileGIDAtPoint("layer_1",m_nextTileX);
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            if(goThrough=="1" && CommonUtils::isRectInTile(ptLocation, m_width, m_height, m_nextTileX.x, m_nextTileX.y, tileSize.width,mapHeight)){
                movePoint.x=0;
            }
        }
        {
            int gid = getLayerTileGIDAtPoint("layer_1",m_nextTileY);
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            if(goThrough=="1" && CommonUtils::isRectInTile(ptLocation, m_width, m_height, m_nextTileY.x, m_nextTileY.y, tileSize.width,mapHeight)){
                movePoint.y=0;
            }
        }
        {
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
        
        {
            Vec2 ptInMap;
            ptInMap.y = mapHeight - ptLocation.y;
            ptInMap.x = ptLocation.x;
            int tx = ptInMap.x / tileSize.width;
            int ty = ptInMap.y / tileSize.height;
            int gid = getFaceToTileGID(tx,ty,"layer_1");
            string goThrough = getPropertyByGIDAndNameToString(gid,"goThrough");
            m_upLabel->setString(goThrough);
        }
        
        m_container->setPosition(m_container->getPosition()-(movePoint/10*m_moveSpeed));
        this->setPosition(this->getPositionInScreen()-(m_container->getPosition()-(movePoint/10*m_moveSpeed)));
//        m_container->setPosition(this->getPositionInScreen()-this->getPosition());
    }
}

void Player::moveTo(Point point){
    Point movePoint = point-getPositionInScreen();
//    m_container->setPosition(m_container->getPosition()-movePoint);
//    this->setPosition(this->getPositionInScreen()-m_container->getPosition());
//    this->unschedule(schedule_selector(TouchUI::OnScrollLeft));
//    this->schedule(schedule_selector(TouchUI::OnScrollLeft));
}
