#include "WorldScene.h"
#include "SimpleAudioEngine.h"
#include "TouchUI.h"

USING_NS_CC;

Scene* WorldScene::createScene()
{
    auto scene = Scene::create();
    auto layer = WorldScene::create();
    scene->addChild(layer);
    return scene;
}

bool WorldScene::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    _map = TMXTiledMap::create("image/tiled_test4.tmx");//tiled_test3
    Size size = _map->getContentSize();
    this->addChild(_map);
    
    m_touchDelegateView = TouchDelegateView::create();
    m_touchDelegateView->setViewPortTarget(_map);
    m_touchDelegateView->setTouchDelegate(this);
    this->addChild(m_touchDelegateView);
    
    TouchUI* touchUI = TouchUI::create();
    this->addChild(touchUI);
    
    return true;
}

void WorldScene::onEnter(){
    Node::onEnter();
    
}
void WorldScene::onExit(){
    Node::onExit();
}

void WorldScene::TapView(Touch* pTouch){
    //得到触摸点的坐标
    Point mapPoint = _map->getPosition();
    float mapScale = _map->getScale();
    Vec2 ptLocation = (pTouch->getLocation()-mapPoint)/mapScale;
    //获取地图中每个图块的大小
    Size tileSize = _map->getTileSize();
    //获得地图中图块的个数
    Size mapSize = _map->getMapSize();
    
    Vec2 ptInMap;
    //获取触摸点在地图中的坐标
    ptInMap.y = mapSize.height * tileSize.height - ptLocation.y;
    ptInMap.x = ptLocation.x;
    //获取触摸点在窗口中的坐标
    int tx = ptInMap.x / tileSize.width;
    int ty = ptInMap.y / tileSize.height;
    //通过图层名称获取地图对象
    TMXLayer* layer0 = _map->getLayer("layer_0");//layerNamed("layer_0");
    //设置瓷砖的编号0表示隐藏瓷砖
    layer0->setTileGID(9, Point(tx, ty));
}
