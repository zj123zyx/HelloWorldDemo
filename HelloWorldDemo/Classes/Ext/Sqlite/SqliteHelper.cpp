//
//  SqliteHelper.cpp
//  IF
//
//  Created by ZhangJun on 2017/1/19.
//
//

#include "SqliteHelper.hpp"

static SqliteHelper* instance = NULL;

SqliteHelper* SqliteHelper::getInstance()
{
    if (!instance)
    {
        instance = new SqliteHelper();
    }
    return instance;
}

SqliteHelper::SqliteHelper(){
    m_dbPath = FileUtils::getInstance()->getWritablePath()+"save.db";
    log("database path:%s",m_dbPath.c_str());
}
SqliteHelper::~SqliteHelper(){
    
}

sqlite3* SqliteHelper::getDataBase(){//得到数据库
    sqlite3 *pdb=NULL;
    std::string sql;
    int result;
    result=sqlite3_open(m_dbPath.c_str(),&pdb);
    if(result!=SQLITE_OK)
    {
        log("open database failed,  number%d",result);
    }
    return pdb;
}

bool SqliteHelper::ExecuteSql(string sqlStr){//执行sql语句
    bool ret = false;
    sqlite3 *pdb = getDataBase();
    if(pdb==nullptr){
        return ret;
    }
    int result=sqlite3_exec(pdb,sqlStr.c_str(),NULL,NULL,NULL);//1
    if(result!=SQLITE_OK){
        log("Execute sql failed,sqlStr======>%s",sqlStr.c_str());
        ret = false;
    }else{
        ret = true;
    }
    sqlite3_close(pdb);
    return ret;
}

bool SqliteHelper::TableExists(string tableName){//表是否存在
    bool ret = false;
    sqlite3 *pdb = getDataBase();
    if(pdb==nullptr){
        return ret;
    }
    
    string sqlStr = string("select count(*) from sqlite_master where type='table' and name='").append(tableName).append("'");
    char **re;//查询结果
    int r,c;//行、列
    sqlite3_get_table(pdb,sqlStr.c_str(),&re,&r,&c,NULL);//1
    log("row is %d,column is %d",r,c);
    
    for(int i=1;i<=r;i++)//2
    {
        for(int j=0;j<c;j++)
        {
            log("%s",re[i*c+j]);
        }
    }

    
//    char **re;//查询结果
//    int r,c;//行、列
//    sqlite3_get_table(pdb,"select * from student",&re,&r,&c,NULL);//1
//    log("row is %d,column is %d",r,c);
//    
//    for(int i=1;i<=r;i++)//2
//    {
//        for(int j=0;j<c;j++)
//        {
//            log("%s",re[i*c+j]);
//        }
//    }
    sqlite3_free_table(re);
    
    sqlite3_close(pdb);
    return ret;
}
























