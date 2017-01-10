#include "WorldScene.h"
#include "SimpleAudioEngine.h"
#include "PlayerController.hpp"
#include "RolesController.hpp"
#include "Role.hpp"
#include "Tree.hpp"
#include "House.hpp"
#include "Shoes.hpp"

USING_NS_CC;

WorldScene::WorldScene(){
    
}
WorldScene::~WorldScene(){
    
}

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
    _map = TMXTiledMap::create("image/tiled_test5.tmx");//tiled_test3
    this->addChild(_map);
    //ui
    TouchUI::getInstance()->setUiDelegate(this);
    TouchUI::getInstance()->addToLayer(this);
    TouchUI::getInstance()->m_btn2->setEnabled(true);
    //touch
    m_touchDelegateView = TouchDelegateView::create();
    m_touchDelegateView->setViewPortTarget(_map);
    m_touchDelegateView->setTouchDelegate(this);
    this->addChild(m_touchDelegateView);
    
    Size mapSize = _map->getContentSize();
    Size tileSize = _map->getTileSize();
    //add player
    Player *m_player = PlayerController::getInstance()->getPlayer();
    m_player->setContainer(_map);
    int py = mapSize.height - (m_player->m_tileY*tileSize.height+tileSize.height/2);
    int px = m_player->m_tileX*tileSize.width+tileSize.width/2;
    m_player->setPosition(Vec2(px, py));
    _map->addChild(m_player,3);
    
    return true;
}

void WorldScene::onEnter(){
    Node::onEnter();
    //add tree house
    RolesController::getInstance()->setTiledMap(_map);
    //添加树
    Tree* tree = Tree::createWithPicName("res/Roles/assassin1a.png");
    tree->setTileXY(20, 90);
    RolesController::getInstance()->addControllerRole(tree,true);
    //添加房屋
    House* house = House::createWithPicName("res/Roles/assassin1a.png");
    house->setTileXY(20, 80);
    RolesController::getInstance()->addControllerRole(house,true);
    m_RoleMap = RolesController::getInstance()->m_RoleMap;
    
    Shoes* shoes1 = Shoes::createWithShoesId("100040001");
    shoes1->setTileXY(15, 90);
    RolesController::getInstance()->addControllerRole(shoes1,true);
    
    Shoes* shoes2 = Shoes::createWithShoesId("100040002");
    shoes2->setTileXY(16, 90);
    RolesController::getInstance()->addControllerRole(shoes2,true);
    
}
void WorldScene::onExit(){
    RolesController::getInstance()->clearRoleMap();
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

void WorldScene::OnTouchUIRelease(Ref *target,SEL_CallFunc func){
    Point playerPoint = PlayerController::getInstance()->player->getPosition();
    Size size = Director::getInstance()->getWinSize()/2;
    Point moveToPoint = Vec2(size.width-playerPoint.x, size.height-playerPoint.y);
    m_touchDelegateView->moveToPosition(moveToPoint, 0.5, target, func);
}
