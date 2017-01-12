//
//  Book.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#include "Book.hpp"

Book* Book::createWithBookId(string BookId){
    Book *pRet = new(std::nothrow) Book();
    if (pRet && pRet->initWithBookId(BookId))
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        delete pRet;
        pRet = nullptr;
        return nullptr;
    }
}
bool Book::initWithBookId(string BookId){
    bool ret = false;
    if(Goods::initWithGoodsId(BookId)){
        ret = true;
    }
    return ret;
}

void Book::initCommonData(){
    Goods::initCommonData();
    m_GoodsType=GoodsType_Book;
    m_useType=UseType_UseInUI;
}

void Book::onEnter(){
    Goods::onEnter();
}
void Book::onExit(){
    Goods::onExit();
}
