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

vector<map<int,DBKeyValue>> SqliteHelper::SelectSql(string sqlStr){//数据库查询
    vector<map<int,DBKeyValue>> dataVec;
    sqlite3 *pdb = getDataBase();
    if(pdb==nullptr){
        log("error database null");
        return dataVec;
    }
    char **re;//查询结果
    int r,c;//行、列
    sqlite3_get_table(pdb,sqlStr.c_str(),&re,&r,&c,NULL);//1
//    log("row is %d,column is %d",r,c);
    vector<string> keyVec;
    for(int i=0;i<c;i++)//2
    {
        keyVec.push_back(string(re[i]));
    }
    int idx=0;
    for(int i=1;i<=r;i++)//2
    {
        map<int,DBKeyValue> dataMap;
        for(int j=0;j<c;j++)
        {
            DBKeyValue kv = {keyVec[j],re[i*c+j]};
            dataMap[idx]=kv;
            idx++;
        }
        dataVec.push_back(dataMap);
    }
    sqlite3_free_table(re);
    sqlite3_close(pdb);
    
    for (int i=0; i<dataVec.size(); i++) {
        map<int,DBKeyValue> tempMap = dataVec[i];
        map<int,DBKeyValue>::iterator it = tempMap.begin();
        for (; it!=tempMap.end(); it++) {
            DBKeyValue kv = it->second;
            log("%s:%s",kv.DBKey.c_str(),kv.DBValue.c_str());
        }
    }
    return dataVec;
}

bool SqliteHelper::TableExists(string tableName){//表是否存在
    bool ret = false;
    string sqlStr = string("select count(*) from sqlite_master where type='table' and name='").append(tableName).append("'");
    vector<map<int,DBKeyValue>> vec = SelectSql(sqlStr);
    if(vec.size()==1){
        map<int,DBKeyValue> map = vec[0];
        if(map.find(0)!=map.end() && map[0].DBValue=="1"){
            ret = true;
        }
    }
    return ret;
}

bool SqliteHelper::TableEmpty(string tableName){//表是否为空
    bool ret = false;
    string sqlStr = string("select count(*) from '").append(tableName).append("'");
    vector<map<int,DBKeyValue>> vec = SelectSql(sqlStr);
    if(vec.size()==1){
        map<int,DBKeyValue> map = vec[0];
        if(map.find(0)!=map.end() && atoi(map[0].DBValue.c_str())>0){
            ret = false;
        }else{
            ret = true;
        }
    }
    
    return ret;
}


















