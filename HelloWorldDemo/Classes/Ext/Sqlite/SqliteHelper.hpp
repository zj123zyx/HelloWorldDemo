//
//  SqliteHelper.hpp
//  IF
//
//  Created by ZhangJun on 2017/1/19.
//
//

#ifndef SqliteHelper_hpp
#define SqliteHelper_hpp

#include "CommonHead.h"
#include "sqlite3.h"

struct DBKeyValue{
    string DBKey;
    string DBValue;
};

class SqliteHelper
{
public:
    static SqliteHelper* getInstance();
    
    SqliteHelper();
    ~SqliteHelper();
    
    sqlite3* getDataBase();//得到数据库
    bool ExecuteSql(string sqlStr);//执行sql语句
    vector<map<int,DBKeyValue>> SelectSql(string sqlStr);//数据库查询
    bool TableExists(string tableName);//表是否存在
    bool TableEmpty(string tableName);//表是否为空
    
    string m_dbPath;
};

#endif /* SqliteHelper_hpp */
