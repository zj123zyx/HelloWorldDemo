//
//  CCBLoadHelper.hpp
//  IF
//
//  Created by ZhangJun on 2016/12/20.
//
//

#ifndef CCBLoadHelper_hpp
#define CCBLoadHelper_hpp

#include "cocos2d.h"
#include "editor-support/cocosbuilder/CocosBuilder.h"

USING_NS_CC;
using namespace std;
using namespace cocosbuilder;

Node* CCBLoadFile(const char * pCCBFileName, Node* pParent, Ref* pOwner);

#endif /* CCBLoadHelper_hpp */
