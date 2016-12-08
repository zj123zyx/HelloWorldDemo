#include "HelloWorldScene.h"
#include "SimpleAudioEngine.h"

USING_NS_CC;

Scene* HelloWorld::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size wsize = Director::getInstance()->getWinSize();
    setContentSize(wsize);
//    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    auto closeItem = MenuItemImage::create("CloseNormal.png","CloseSelected.png",CC_CALLBACK_1(HelloWorld::menuCloseCallback, this));
    closeItem->setPosition(Vec2(50 ,50));
    auto menu = Menu::create(closeItem, NULL);
    menu->setPosition(Vec2::ZERO);
    this->addChild(menu, 1);
//    auto label = Label::createWithTTF("Hello World", "fonts/Marker Felt.ttf", 24);
//    label->setPosition(Vec2(origin.x + visibleSize.width/2,origin.y + visibleSize.height - label->getContentSize().height));
//    this->addChild(label, 1);
//    auto sprite = Sprite::create("HelloWorld.png");
//    sprite->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));
//    this->addChild(sprite, 0);
    
    _map = TMXTiledMap::create("image/tiled_test3.tmx");
    Size size = _map->getContentSize();
//    float scale = _map->getScale();
//    _map->setPosition(0, 0);
//    _map->setAnchorPoint(Point(0,0));
    this->addChild(_map);
    
    //获取自定义属性
    Value tValue = _map->getPropertiesForGID(10);
    ValueMap tMap = tValue.asValueMap();
    log("type1 = %s ", tMap.at("type1").asString().c_str());
    
    tValue = _map->getPropertiesForGID(30);
    tMap = tValue.asValueMap();
    log("type2 = %s ", tMap.at("type2").asString().c_str());
    
    int i=0;
    i++;
    
    return true;
}


void HelloWorld::menuCloseCallback(Ref* pSender)
{
    //Close the cocos2d-x game scene and quit the application
    Director::getInstance()->end();

    #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
    
    /*To navigate back to native iOS screen(if present) without quitting the application  ,do not use Director::getInstance()->end() and exit(0) as given above,instead trigger a custom event created in RootViewController.mm as below*/
    
    //EventCustom customEndEvent("game_scene_close_event");
    //_eventDispatcher->dispatchEvent(&customEndEvent);
    
    
}

void HelloWorld::onEnter(){
    Node::onEnter();
    setTouchEnabled(true);
    setTouchMode(kCCTouchesOneByOne);
    
}
void HelloWorld::onExit(){
    setTouchEnabled(false);
    Node::onExit();
}

bool HelloWorld::onTouchBegan(Touch *touch, Event *unused_event){
    //得到触摸点的坐标
    Vec2 ptLocation = touch->getLocation();
    
    //ptLcocation -> 在tmx地图里的坐标
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
    TMXLayer* layer0 = _map->layerNamed("layer_0");
    
    //设置瓷砖的编号0表示隐藏瓷砖
    layer0->setTileGID(9, Point(tx, ty));
    layer0->removeTileAt(Point(5, 30));
    
    /////////////////////////////////////////遍历对象层中对象
    TMXObjectGroup* objectGroup = _map->getObjectGroup("objLayer");
    ValueVector object = objectGroup->getObjects();
    
    for (ValueVector::iterator it = object.begin(); it != object.end(); it++) {
        Value obj = *it;
        ValueMap map = obj.asValueMap();
        log("x = %d y = %d", map.at("x").asInt(), map.at("y").asInt());
    }
    
    return false;
}
void HelloWorld::onTouchMoved(Touch *touch, Event *unused_event){
    
}
void HelloWorld::onTouchEnded(Touch *touch, Event *unused_event){
    
}
