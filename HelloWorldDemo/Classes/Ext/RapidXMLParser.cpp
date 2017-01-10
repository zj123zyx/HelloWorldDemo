//
//  RapidXMLParser.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/5.
//
//

#include "RapidXMLParser.hpp"

static RapidXMLParser* rapidXMLParser = NULL;

RapidXMLParser* RapidXMLParser::getInstance()
{
    if (!rapidXMLParser){
        rapidXMLParser = new RapidXMLParser();
    }
    return rapidXMLParser;
}

RapidXMLParser::RapidXMLParser()
:m_isJumpHeadData(false),m_pDictGroup(NULL),m_pDictItem(NULL)
{
    m_pDictItem = new __Dictionary();
    m_pDictGroup = new __Dictionary();
}

RapidXMLParser::~RapidXMLParser()
{
    CC_SAFE_RELEASE_NULL(this->m_pDictItem);
    CC_SAFE_RELEASE_NULL(this->m_pDictGroup);
}

void RapidXMLParser::parseWithFile(const char *xmlFileName)
{
    if(!rapidXMLParser->initWithFile(xmlFileName) ) {
        CC_SAFE_RELEASE_NULL(rapidXMLParser);
    }
}

bool RapidXMLParser::initWithFile(const char *xmlFileName)
{
    ssize_t size = 0;
    unsigned char* pBuffer;
    
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(xmlFileName);
    log("XMLPath====>%s",fullPath.c_str());
    
    pBuffer =  FileUtils::getInstance()->getFileData(fullPath.c_str(), "r", &size);
    
    bool r = initWithBuf((const char*)pBuffer, size);
    CC_SAFE_DELETE_ARRAY(pBuffer);
    return r;
}

bool RapidXMLParser::initWithBuf(const char* buf, ssize_t buf_size)
{
    if (buf == NULL || buf_size <= 0) {
        assert(0);
        return false;
    }
    
    xml_document<> doc;
    std::string content(buf, buf_size);
    doc.parse<0>(&content[0]);
    
    xml_node<>* node = doc.first_node()->first_node();
    while (node)
    {
        const char* nodeName = node->name();
        if (strcmp(nodeName, "Group") == 0)
        {
            startElement(node);
            node = node->next_sibling();
        }
    }
    
    return true;
}

//  elementNode处理
void RapidXMLParser::startElement(xml_node<>* dictNode)
{
    // 减少临时变量的产生。
    std::string key;
    std::string value;
    
    //  属性值处理
    const char* elementName = dictNode->name();
    __Dictionary * pDictGroupItem = __Dictionary::create();
    if(strcmp(elementName, "Group") == 0)
    {
        xml_attribute<> * attribute = dictNode->first_attribute();
        value = attribute->value();
        // m_groupName = value;
        m_pDictGroup->setObject(pDictGroupItem, value);
        //        CCLOG("crate Group %s",value.c_str());
    }
    
    xml_node<>* node = dictNode->first_node();
    
    //  处理节点属性值；
    if(node)
    {
        while (node)
        {
            xml_attribute<> * attribute = node->first_attribute();
            __Dictionary * pDictTmp = __Dictionary::create();
            while (attribute) {
                key = attribute->name();
                value = attribute->value();
                
                pDictTmp->setObject(__String::create(value), key);
                attribute = attribute->next_attribute();
                //                CCLOG("-----key:%s, value:%s",key.c_str(),value.c_str());
            }
            //  按照id建立索引表
            __String* pID = (__String*)pDictTmp->objectForKey("id");
            if( pID ){
                const std::string& hashkey = pID->_string;
                m_pDictItem->setObject(pDictTmp , hashkey);
                //  按照组id建立索引表
                pDictGroupItem->setObject(pDictTmp , hashkey);
            }
            node = node->next_sibling();
        }
    }
}

__Dictionary * RapidXMLParser::getObjectByKey(std::string const& key)
{
    //  按照id建立索引表
    auto ret = (__Dictionary *)m_pDictItem->objectForKey(key);
    if (ret == NULL) {
        ret = __Dictionary::create();
    }
    return ret;
}

__Dictionary * RapidXMLParser::getObjectByKey(const char* key)
{
    //  按照id建立索引表
    auto ret = (__Dictionary *)m_pDictItem->objectForKey(key);
    if (ret == NULL) {
        ret = __Dictionary::create();
    }
    return ret;
}


__Dictionary * RapidXMLParser::getGroupByKey(std::string const& key)
{
//    PERF_NODE("getGroupByKey-string");
    
    //  按照GroupID建立索引表
    auto ret = (__Dictionary *)m_pDictGroup->objectForKey(key);
    if (ret == NULL) {
        ret = __Dictionary::create();
    }
    return ret;
}

__Dictionary * RapidXMLParser::getGroupByKey(const char* key)
{
//    PERF_NODE("getGroupByKey-const_char");
    
    //  按照GroupID建立索引表
    auto ret = (__Dictionary *)m_pDictGroup->objectForKey(key);
    if (ret == NULL) {
        ret = __Dictionary::create();
    }
    return ret;
}
