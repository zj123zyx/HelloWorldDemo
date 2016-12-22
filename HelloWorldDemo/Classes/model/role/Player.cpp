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
        
        Vec2 ptInMap;
        //获取触摸点在地图中的坐标
        ptInMap.y = mapSize.height * tileSize.height - ptLocation.y;
        ptInMap.x = ptLocation.x;
        //获取触摸点在窗口中的坐标
        int tx = ptInMap.x / tileSize.width;
        int ty = ptInMap.y / tileSize.height;
        //通过图层名称获取地图对象
        TMXLayer* layer0 = m_container->getLayer("layer_0");//layerNamed("layer_0");
        //设置瓷砖的编号0表示隐藏瓷砖
        layer0->setTileGID(9, Point(tx, ty));
        
        Point movePoint = point;
        if((point.x<0 && tx<=0) || (point.x>0 && tx>=mapSize.width-1)){
            movePoint.x=0;
        }
        
        if((point.y>0 && ty<=0) || (point.y<0 && ty>=mapSize.height-1)) {
            movePoint.y=0;
        }
        
        m_container->setPosition(m_container->getPosition()-(movePoint/10*m_moveSpeed));
        this->setPosition(this->getPositionInScreen()-m_container->getPosition());
    }
}
