local PokerData = class("PokerData")

function PokerData:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    if core.Sqlite.tableExist("poker_data") == 0 then
        local createTableSentence= string.format("CREATE TABLE %s (id INT PRIMARY KEY, pokerresult, wincoins)", "poker_data")
        local res1=core.Sqlite.executeSql(createTableSentence)
        print("res1:",res1)

        local isql=string.format("INSERT INTO poker_data VALUES (1, '%s',0)","{}")
        core.Sqlite.executeSql(isql)
        --print("ccc,", Sqlite:executeSql("INSERT INTO poker_data VALUES (1, '{}',12)"))


        --print("aaa,", Sqlite:executeSql("CREATE TABLE test2 (id INTEGER PRIMARY KEY, content)"))
        --print("bbb,", Sqlite:executeSql("INSERT INTO test2 VALUES (NULL, 'Hello World')"))
   
    
    end
end

function PokerData:init(pokerModel)
    local cls = pokerModel.class

    cc.EventProxy.new(pokerModel):addEventListener(cls.DRAW_CARD_EVENT, handler(self, self.updatePokerResult))

    self:loadToModel(pokerModel)
end

function PokerData:loadToModel(model)

    local cls   =   model.class

    local userdata = nil

    local function queryBack(row)
        userdata = row
    end

    core.Sqlite.queryRecord(
        "SELECT * FROM poker_data where id=1",
        queryBack
    )

    local properties = {}
    print("userdata:",userdata.id,userdata.pokerresult,userdata.wincoins)
    properties[cls.wincoinskey] = userdata.wincoins
    properties[cls.pokerresultkey] = userdata.pokerresult
    model:setProperties(properties)
end

function PokerData:updatePokerResult(event)
    print("pokerresult :", event.model:getPokerResult())
    core.Sqlite.executeSql(string.format("UPDATE poker_data SET pokerresult = '%s',wincoins=%d where id=1", event.model:getPokerResult(),event.model:getWinCoins()))
end

return PokerData