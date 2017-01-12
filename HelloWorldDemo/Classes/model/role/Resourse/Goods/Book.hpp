//
//  Book.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#ifndef Book_hpp
#define Book_hpp

#include "Goods.hpp"

class Book:public Goods
{
public:
    static Book* createWithBookId(string BookId);
    virtual bool initWithBookId(string BookId);
    
    void initCommonData();
protected:
    void onEnter();
    void onExit();
};

#endif /* Book_hpp */
