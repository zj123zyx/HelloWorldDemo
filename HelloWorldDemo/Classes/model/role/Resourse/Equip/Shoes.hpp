//
//  Shoes.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#ifndef Shoes_hpp
#define Shoes_hpp

#include "Equip.hpp"

class Shoes:public Equip
{
public:    
    static Shoes* createWithShoesId(string ShoesId);
    virtual bool initWithShoesId(string ShoesId);
    
    void initCommonData();
protected:
    void onEnter();
    void onExit();
};

#endif /* Shoes_hpp */
