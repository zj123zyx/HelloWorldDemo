//
//  PlayerController.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/22.
//
//

#ifndef PlayerController_hpp
#define PlayerController_hpp

#include "CommonHead.h"
#include "Player.hpp"
#include "Resourse.hpp"

class PlayerController:public Ref
{
public:
    static PlayerController* getInstance();
    
    PlayerController();
    ~PlayerController();
    
    void OnUIStartScrollLeft(Point scrollPoint);
    void OnUIScrollLeft(Point scrollPoint);
    void OnUIStopScrollLeft(Point scrollPoint);
    void playerMoveTo(Point point);
    int getBagValue();//获得可携带数量
    void addResourseFightValue(Resourse* resourse);
    void removeResourseFightValue(Resourse* resourse);

    Player* getPlayer();
    Player* player;
};

#endif /* PlayerController_hpp */
