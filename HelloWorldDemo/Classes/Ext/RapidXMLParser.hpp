//
//  RapidXMLParser.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#ifndef RapidXMLParser_hpp
#define RapidXMLParser_hpp

#include "cocos2d.h"
#include "rapidxml.hpp"

using namespace rapidxml;

USING_NS_CC;

class RapidXMLParser: public Ref
{
public:
    
    static RapidXMLParser* getInstance();
    
    void parseWithFile(const char *xmlFileName);
    
    RapidXMLParser();
    virtual ~RapidXMLParser();
    
    // 从本地xml文件读取
    bool initWithFile(const char *xmlFileName);
    bool initWithBuf(const char* buf, ssize_t buf_size);
    
    /**
     *对应xml标签开始,如：<string name="alex">, name为string，atts为string的属性，如["name","alex"]
     */
    virtual void startElement(xml_node<>* dictNode);
    
    //  获取某个关键字的属性数据字典
    __Dictionary * getObjectByKey(std::string const& key);
    __Dictionary * getObjectByKey(const char* key);
    
    //  根据分组关键字获取分组数据字典
    __Dictionary * getGroupByKey(std::string const &key);
    __Dictionary * getGroupByKey(const char* key);
    
private:
    std::string m_startXMLElement;
    std::string m_endXMLElement;
    std::string m_currString;//记录每个value的值
    std::string m_root_name;
    bool m_isJumpHeadData;
    
    //  <Animal id="10002" name="Chick"  show_scale="0.5" coin_cost="10"  speed_cash="2" base_cache_key="Chick" in_store="1"
    //  以id的值为key进行存储；
    __Dictionary *   m_pDictItem;
    //  分组存储，以Group id="Animal"中id值为key;
    __Dictionary *   m_pDictGroup;
    // 分组名称
    //std::string m_groupName;
    
};


#endif /* RapidXMLParser_hpp */
