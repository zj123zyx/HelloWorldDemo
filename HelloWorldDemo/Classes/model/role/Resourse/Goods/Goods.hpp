//
//  Goods.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#ifndef Goods_hpp
#define Goods_hpp

#include "Resourse.hpp"

enum GoodsType{
    GoodsType_NULL=-1,
    GoodsType_Book,       //0
//    GoodsType_Hat,          //1
//    GoodsType_Jacket,       //2
//    GoodsType_Trousers,     //3
//    GoodsType_Shoes,        //4
//    GoodsType_Jewelry,      //5
//    GoodsType_Bag,          //6
    GoodsType_End
};

class Goods:public Resourse
{
public:
    Goods():m_GoodsType(GoodsType_NULL){};
    static Goods* createWithGoodsId(string GoodsId);
    virtual bool initWithGoodsId(string GoodsId);
    
    virtual void initCommonData();
    virtual void showDescription(bool show);//显示简介
    
    GoodsType m_GoodsType;
protected:
    void onEnter();
    void onExit();
};

#endif /* Goods_hpp */
