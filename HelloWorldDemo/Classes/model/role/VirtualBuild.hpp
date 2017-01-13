//
//  VirtualBuild.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/12.
//
//

#ifndef VirtualBuild_hpp
#define VirtualBuild_hpp

#include "CommonHead.h"

class VirtualBuild:public Node
{
public:
    VirtualBuild():m_size(64){};
    
    static VirtualBuild* create();
    virtual bool init();

    void onEnter();
    void onExit();
    
    void addPointToVec(Vec2 point);
    
    void refreshPosition(Vec2 playerPoint);
    bool isVecCanPut(Vec2 vec);
    
//    vector<Vec2> m_pointVec;
    map<Vec2,Sprite*>  m_sprMap;
    
    Node* m_mainNode;
    float m_size;
};

#endif /* VirtualBuild_hpp */
