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

class SqliteHelper
{
public:
    static SqliteHelper* getInstance();
    
    SqliteHelper();
    ~SqliteHelper();
    
    sqlite3* getDataBase();//得到数据库
    bool ExecuteSql(string sqlStr);//执行sql语句
    bool TableExists(string tableName);//表是否存在
    
    string m_dbPath;
};

#endif /* SqliteHelper_hpp */
