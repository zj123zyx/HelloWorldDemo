local TxsCard = require("app.data.txspoker.beans.TxsCard")
local TxsGameSet = class("TxsGameSet")

function TxsGameSet:ctor(gameId)
    self.gameId=gameId
    self.anteBet=0
    self.aaBet=0 --casino hold'em 特有
    self.callBet=0
    self.turnBet=0 --txs hold'em 特有
    self.riverBet=0 --txs hold'em 特有
    self.dbTable={}
end

function TxsGameSet:toDbTable()
    self.dbTable.anteBet=self.anteBet
    self.dbTable.gameId=self.gameId
    self.dbTable.aaBet=self.aaBet
    self.dbTable.callBet=self.callBet
    self.dbTable.turnBet=self.turnBet
    self.dbTable.riverBet=self.riverBet
    return self.dbTable
end

function TxsGameSet:fromDbTable(dbt)
    if dbt==nil or table.isEmpty(dbt)==true then
        return self
    end

    self.anteBet=dbt.anteBet
    self.gameId=dbt.gameId
    self.aaBet=dbt.aaBet
    self.callBet=dbt.callBet
    self.turnBet=dbt.turnBet
    self.riverBet=dbt.riverBet
    return self
end


return TxsGameSet