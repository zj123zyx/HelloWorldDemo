local TxsRound = class("TxsRound")
local TxsCard=require("app.data.txspoker.beans.TxsCard")
local TxsGameSet=require("app.data.txspoker.beans.TxsGameSet")

function TxsRound:ctor(txsGameSet)
    self.txsGameSet=txsGameSet
    self.storeIds={} --牌库
    self.playerCardArray={} --玩家手上牌
    self.bankerCardArray={} --庄家手上牌
    self.commonCardArray={} --公共牌
    self.playerWinCardArray={} --玩家赢牌牌组
    self.bankerWinCardArray={} --庄家赢牌牌组
    
    self.playerWinPattern=0 --玩家牌组模式
    self.bankerWinPattern=0 --庄家牌组模式
    
    self.result= TXS.ROUND_RESULT.INIT --比赛结果
    
    self.antiWin=0
    self.callWin=0
    self.aaWin=0 --casino hold'em 特有
    self.turnWin=0 --txs hold'em 特有
    self.riverWin=0 --txs hold'em 特有
    
    self.roundstate = 0 --本局是否结束 1 是 0 否
    self.dbTable={}
end

--获得anti区总共赢的钱
function TxsRound:getAntiRewardCoins()
    if self.result == TXS.ROUND_RESULT.NO_WIN then
        return 0
    elseif self.result == TXS.ROUND_RESULT.PUSH then
        return self.txsGameSet.anteBet
    elseif self.result == TXS.ROUND_RESULT.WIN then
        return self.txsGameSet.anteBet+self.antiWin
    end
    return 0
end

--获得call区总共赢的钱
function TxsRound:getCallRewardCoins()
    if self.result == TXS.ROUND_RESULT.NO_WIN then
        return 0
    elseif self.result == TXS.ROUND_RESULT.PUSH then
        return self.txsGameSet.callBet
    elseif self.result == TXS.ROUND_RESULT.WIN then
        return self.txsGameSet.callBet+self.callWin
    end
    return 0
end

--获得AABonus总共赢的钱
function TxsRound:getAaRewardCoins()
    if self.aaWin > 0 then
        return self.aaWin+self.txsGameSet.aaBet
    end
    return 0
end

--获得turn区总共赢的钱
function TxsRound:getTurnRewardCoins()
    if self.result == TXS.ROUND_RESULT.NO_WIN then
        return 0
    elseif self.result == TXS.ROUND_RESULT.PUSH then
        return self.txsGameSet.turnBet
    elseif self.result == TXS.ROUND_RESULT.WIN then
        return self.turnWin+self.txsGameSet.turnBet
    end
    return 0
end

--获得river区总共赢的钱
function TxsRound:getRiverRewardCoins()
    if self.result == TXS.ROUND_RESULT.NO_WIN then
        return 0
    elseif self.result == TXS.ROUND_RESULT.PUSH then
        return self.txsGameSet.riverBet
    elseif self.result == TXS.ROUND_RESULT.WIN then
        return self.riverWin+self.txsGameSet.riverBet
    end
    return 0
end

function TxsRound:toDbTable()
    self.dbTable.txsGameSet = self.txsGameSet:toDbTable()
    self.dbTable.storeIds = self.storeIds
    
    local ptab={}
    for i=1,#self.playerCardArray do
        table.insert(ptab,self.playerCardArray[i]:toDbTable())
    end
    self.dbTable.playerCardArray = ptab
    
    local btab={}
    for i=1,#self.bankerCardArray do
        table.insert(btab,self.bankerCardArray[i]:toDbTable())
    end
    self.dbTable.bankerCardArray = btab
    
    local ctab={}
    for i=1,#self.commonCardArray do
        table.insert(ctab,self.commonCardArray[i]:toDbTable())
    end
    self.dbTable.commonCardArray = ctab
    
    local pwtab={}
    for i=1,#self.playerWinCardArray do
        table.insert(pwtab,self.playerWinCardArray[i]:toDbTable())
    end
    self.dbTable.playerWinCardArray = pwtab
    
    local bwtab={}
    for i=1,#self.bankerWinCardArray do
        table.insert(bwtab,self.bankerWinCardArray[i]:toDbTable())
    end
    self.dbTable.bankerWinCardArray = bwtab

    self.dbTable.result=self.result
    self.dbTable.playerWinPattern=self.playerWinPattern
    self.dbTable.bankerWinPattern=self.bankerWinPattern
    self.dbTable.antiWin=self.antiWin
    self.dbTable.callWin=self.callWin
    self.dbTable.aaWin=self.aaWin
    self.dbTable.turnWin=self.turnWin
    self.dbTable.riverWin=self.riverWin
    self.dbTable.roundstate=self.roundstate
    return self.dbTable
end

function TxsRound:fromDbTable(dbt)
    if dbt==nil or table.isEmpty(dbt)==true then
        return self
    end

    local txsGameSet=TxsGameSet.new(1)
    txsGameSet:fromDbTable(dbt.txsGameSet)
    self.txsGameSet=txsGameSet
    
    self.storeIds = dbt.storeIds
    
    self.playerCardArray={}
    for i=1,#dbt.playerCardArray do
        local bean=TxsCard.new(1)
        bean:fromDbTable(dbt.playerCardArray[i])
        table.insert(self.playerCardArray,bean)
    end
    
    self.bankerCardArray={}
    for i=1,#dbt.bankerCardArray do
        local bean=TxsCard.new(1)
        bean:fromDbTable(dbt.bankerCardArray[i])
        table.insert(self.bankerCardArray,bean)
    end
    
    self.commonCardArray={}
    for i=1,#dbt.commonCardArray do
        local bean=TxsCard.new(1)
        bean:fromDbTable(dbt.commonCardArray[i])
        table.insert(self.commonCardArray,bean)
    end
    
    self.playerWinCardArray={}
    for i=1,#dbt.playerWinCardArray do
        local bean=TxsCard.new(1)
        bean:fromDbTable(dbt.playerWinCardArray[i])
        table.insert(self.playerWinCardArray,bean)
    end
    
    self.bankerWinCardArray={}
    for i=1,#dbt.bankerWinCardArray do
        local bean=TxsCard.new(1)
        bean:fromDbTable(dbt.bankerWinCardArray[i])
        table.insert(self.bankerWinCardArray,bean)
    end
    
    self.result=dbt.result
    self.playerWinPattern=dbt.playerWinPattern
    self.bankerWinPattern=dbt.bankerWinPattern
    self.antiWin=dbt.antiWin
    self.callWin=dbt.callWin
    self.roundstate=dbt.roundstate
    self.aaWin=dbt.aaWin
    self.turnWin=dbt.turnWin
    self.riverWin=dbt.riverWin
    return self
end

return TxsRound