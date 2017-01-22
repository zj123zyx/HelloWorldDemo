#include "WorldScene.h"
#include "SimpleAudioEngine.h"
#include "PlayerController.hpp"
#include "RolesController.hpp"
#include "Role.hpp"
#include "Tree.hpp"
#include "House.hpp"
#include "BodyEquip.hpp"
#include "NPCRole.hpp"
#include "Book.hpp"
#include "UsedRes.hpp"

USING_NS_CC;

Scene* WorldScene::createScene()
{
    auto scene = Scene::create();
    auto layer = WorldScene::create();
    layer->setTag(1);
    scene->addChild(layer);
    return scene;
}

bool WorldScene::init()
{
    if ( !SceneModel::initWithTiledName("image/tiled_test5.tmx") )
    {
        return false;
    }
    //touch
    m_touchDelegateView = TouchDelegateView::create();
    m_touchDelegateView->setViewPortTarget(_map);
    m_touchDelegateView->setTouchDelegate(this);
    this->addChild(m_touchDelegateView);
    m_sceneType=SceneType_WORLD;
    return true;
}

void WorldScene::onEnter(){
    SceneModel::onEnter();
    //ui
    TouchUI::getInstance()->m_btn2->setEnabled(true);
    //touch
    m_touchDelegateView->setViewPortTarget(_map);
    m_touchDelegateView->setTouchDelegate(this);
    //add player
    Player *m_player = PlayerController::getInstance()->getPlayer();
    m_player->setContainer(_map);//player位置由controller控制
    RolesController::getInstance()->addControllerRole(m_player,true);
}
void WorldScene::onExit(){
    SceneModel::onExit();
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

void WorldScene::addRoles(){
    SceneModel::addRoles();
    
    //添加树
    Tree* tree = Tree::createWithPicName("res/Roles/assassin1a.png");
    tree->setTileXY(20, 90);
    RolesController::getInstance()->addControllerRole(tree,true);
    //添加房屋
    House* house = House::createWithPicName("res/Roles/assassin1a.png");
    house->setTileXY(20, 80);
    RolesController::getInstance()->addControllerRole(house,true);
    
    if(SqliteHelper::getInstance()->TableExists("WorldElements")==false){//没有表
        string sql = CommonUtils::getPropById("create_WorldElements", "sql");
        SqliteHelper::getInstance()->ExecuteSql(sql);
    }
    if(SqliteHelper::getInstance()->TableEmpty("WorldElements")==true){//没有数据
        BodyEquip* shoes1 = BodyEquip::createWithBodyEquipId("100040001");
        shoes1->setTileXY(15, 90);
        RolesController::getInstance()->addControllerRole(shoes1,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'BodyEquip', 15, 90, 100040001)");
        
        BodyEquip* shoes2 = BodyEquip::createWithBodyEquipId("100040002");
        shoes2->setTileXY(16, 90);
        RolesController::getInstance()->addControllerRole(shoes2,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'BodyEquip', 16, 90, 100040002)");
        
        Book* goodsBook = Book::createWithBookId("200000001");
        goodsBook->setTileXY(8,90);
        RolesController::getInstance()->addControllerRole(goodsBook,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'Book', 8, 90, 200000001)");
        
        UsedRes* wood = UsedRes::createWithResId("400000001");
        wood->setTileXY(5,80);
        RolesController::getInstance()->addControllerRole(wood,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'UsedRes', 5, 80, 400000001)");
        
        UsedRes* food = UsedRes::createWithResId("400000002");
        food->setTileXY(6,80);
        RolesController::getInstance()->addControllerRole(food,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'UsedRes', 6, 80, 400000002)");
        
        UsedRes* stone = UsedRes::createWithResId("400000003");
        stone->setTileXY(7,80);
        RolesController::getInstance()->addControllerRole(stone,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'UsedRes', 7, 80, 400000003)");
        //add npc
        NPCRole *npcPlayer1 = NPCRole::createWithNpcId("500000001");
        npcPlayer1->setContainer(_map);
        npcPlayer1->setTileXY(16, 91,false);
        RolesController::getInstance()->addControllerRole(npcPlayer1,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'NPCRole', 16, 91, 500000001)");
        
        NPCRole *npcPlayer2 = NPCRole::createWithNpcId("500000002");
        npcPlayer2->setContainer(_map);
        npcPlayer2->setTileXY(15, 91,false);
        RolesController::getInstance()->addControllerRole(npcPlayer2,true);
        SqliteHelper::getInstance()->ExecuteSql("insert into WorldElements (create_type, tile_x, tile_y, xml_id) values ( 'NPCRole', 15, 91, 500000002)");
    }else{
        vector<map<int,DBKeyValue>> vec = SqliteHelper::getInstance()->SelectSql("select * from WorldElements");
        for (int i=0; i<vec.size(); i++) {
            string create_type="";
            string xml_id="";
            int tile_x=0;
            int tile_y=0;
            
            map<int,DBKeyValue> dataMap = vec[i];
            map<int,DBKeyValue>::iterator it = dataMap.begin();
            for (; it!=dataMap.end(); it++) {
                DBKeyValue kv = it->second;
                if(kv.DBKey=="create_type"){
                    create_type=kv.DBValue;
                }
                if(kv.DBKey=="xml_id"){
                    xml_id=kv.DBValue;
                }
                if(kv.DBKey=="tile_x"){
                    tile_x=atoi(kv.DBValue.c_str());
                }
                if(kv.DBKey=="tile_y"){
                    tile_y=atoi(kv.DBValue.c_str());
                }
            }
            
            if(create_type=="BodyEquip"){
                BodyEquip* bodyEquip = BodyEquip::createWithBodyEquipId(xml_id);
                bodyEquip->setTileXY(tile_x, tile_y);
                RolesController::getInstance()->addControllerRole(bodyEquip,true);
            }
            if(create_type=="Book"){
                Book* book = Book::createWithBookId(xml_id);
                book->setTileXY(tile_x, tile_y);
                RolesController::getInstance()->addControllerRole(book,true);
            }
            if(create_type=="UsedRes"){
                UsedRes* usedRes = UsedRes::createWithResId(xml_id);
                usedRes->setTileXY(tile_x, tile_y);
                RolesController::getInstance()->addControllerRole(usedRes,true);
            }
            if(create_type=="NPCRole"){
                NPCRole *npcPlayer1 = NPCRole::createWithNpcId(xml_id);
                npcPlayer1->setContainer(_map);
                npcPlayer1->setTileXY(tile_x, tile_y,false);
                RolesController::getInstance()->addControllerRole(npcPlayer1,true);
            }
            
        }
    }
    
    
    m_RoleMap = RolesController::getInstance()->m_RoleMap;
}
