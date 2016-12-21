//
//  CCBLoadHelper.cpp
//  IF
//
//  Created by ZhangJun on 2016/12/20.
//
//

#include "CCBLoadHelper.hpp"

Node* CCBLoadFile(const char * pCCBFileName, Node* pParent, Ref* pOwner){
    CCLOG("Load ccbi :%s", pCCBFileName);
    NodeLoaderLibrary *nodeLoaderLibrary = NodeLoaderLibrary::getInstance();
    if (!nodeLoaderLibrary) {return NULL;}
    cocosbuilder::CCBReader * ccbReader = new cocosbuilder::CCBReader(nodeLoaderLibrary);
    if (!ccbReader) {return NULL;}
    string ccbPathName = string("ccbi/").append(pCCBFileName);
    Node * node = ccbReader->readNodeGraphFromFile(ccbPathName.c_str(),pOwner);
    if(node != NULL) {
        if (pParent)
            pParent->addChild(node);
    } else {
        CCLOG("ccbi :%s load =========Error=========", pCCBFileName);
    }
    ccbReader->release();
    return node;
}
