local PokerResult = class("PokerResult")
local PokerCard=require("app.data.poker.beans.PokerCard")
local PokerGameSet=require("app.data.poker.beans.PokerGameSet")
function PokerResult:ctor(pokerGameSet)
    self.pokerGameSet=pokerGameSet
    self.costCoins=0
    self.rewardCoins=0
    self.rewardExp=0
    self.winPattern=0 --获胜模式 默认为0，即不中奖，>0即为dict_poker_paytable的id
    self.firstCardArray={} --首次获得的牌组
    self.secondCardArray={} --替换非hold以后的牌组
    self.replaceCardArray={} --用于替换的牌组
    self.winCardArray={} --中奖的牌
    self.gamestate = 0 --本局是否结束 1 是 0 否
    self.dbTable={}
end

function PokerResult:setPokerGameSet(pokerGameSet)
    self.pokerGameSet = pokerGameSet
end

function PokerResult:getPokerGameSet()
    return self.pokerGameSet
end

function PokerResult:setCostCoins(costCoins)
    self.costCoins = costCoins
end

function PokerResult:getCostCoins()
    return self.costCoins
end

function PokerResult:setRewardCoins(rewardCoins)
    self.rewardCoins = rewardCoins
end

function PokerResult:getRewardCoins()
    return self.rewardCoins
end

function PokerResult:setRewardExp(rewardExp)
    self.rewardExp = rewardExp
end

function PokerResult:getRewardExp()
    return self.rewardExp
end

function PokerResult:setWinPattern(winPattern)
    self.winPattern = winPattern
end

function PokerResult:getWinPattern()
    return self.winPattern
end

function PokerResult:setFirstCardArray(firstCardArray)
    self.firstCardArray = firstCardArray
end

function PokerResult:getFirstCardArray()
    return self.firstCardArray
end

function PokerResult:setSecondCardArray(secondCardArray)
    self.secondCardArray = secondCardArray
end

function PokerResult:getSecondCardArray()
    return self.secondCardArray
end

function PokerResult:setReplaceCardArray(replaceCardArray)
    self.replaceCardArray = replaceCardArray
end

function PokerResult:getReplaceCardArray()
    return self.replaceCardArray
end

function PokerResult:setWinCardArray(winCardArray)
    self.winCardArray = winCardArray
end

function PokerResult:getWinCardArray()
    return self.winCardArray
end

function PokerResult:setGamestate(gamestate)
    self.gamestate = gamestate
end

function PokerResult:getGamestate()
    return self.gamestate
end

function PokerResult:toDbTable()
    self.dbTable.pokerGameSet=self.pokerGameSet:toDbTable()
    self.dbTable.costCoins=self.costCoins
    self.dbTable.rewardCoins=self.rewardCoins
    self.dbTable.rewardExp=self.rewardExp
    self.dbTable.winPattern=self.winPattern
    local ftab={}
    for i=1,#self.firstCardArray do
        local pk=self.firstCardArray[i]
        table.insert(ftab,pk:toDbTable())
    end
    self.dbTable.firstCardArray=ftab
    local stab={}
    for i=1,#self.secondCardArray do
        local pk=self.secondCardArray[i]
        table.insert(stab,pk:toDbTable())
    end
    self.dbTable.secondCardArray=stab
    local rtab={}
    for i=1,#self.replaceCardArray do
        local pk=self.replaceCardArray[i]
        table.insert(rtab,pk:toDbTable())
    end
    self.dbTable.replaceCardArray=rtab
    local wtab={}
    for i=1,#self.winCardArray do
        local pk=self.winCardArray[i]
        table.insert(wtab,pk:toDbTable())
    end
    self.dbTable.winCardArray=wtab
    self.dbTable.gamestate=self.gamestate
    return self.dbTable
end

function PokerResult:fromDbTable(dbt)
    if dbt==nil or table.isEmpty(dbt)==true then
        return self
    end

    local gameset=PokerGameSet.new()
    self.pokerGameSet=gameset:fromDbTable(dbt.pokerGameSet)
    
    self.costCoins=dbt.costCoins
    self.rewardCoins=dbt.rewardCoins
    self.rewardExp=dbt.rewardExp
    self.winPattern=dbt.winPattern
    
    local ftab=dbt.firstCardArray
    self.firstCardArray={}
    for i=1,#ftab do
        local pkt=ftab[i]
        local pc=PokerCard.new(1)
        pc:fromDbTable(pkt)
        table.insert(self.firstCardArray,pc)
    end
    
    local stab=dbt.secondCardArray
    self.secondCardArray={}
    for i=1,#stab do
        local pkt=stab[i]
        local pc=PokerCard.new(1)
        pc:fromDbTable(pkt)
        table.insert(self.secondCardArray,pc)
    end
    
    local rtab=dbt.replaceCardArray
    self.replaceCardArray={}
    for i=1,#rtab do
        local pkt=rtab[i]
        local pc=PokerCard.new(1)
        pc:fromDbTable(pkt)
        table.insert(self.replaceCardArray,pc)
    end
    
    local wtab=dbt.winCardArray
    self.winCardArray={}
    for i=1,#wtab do
        local pkt=wtab[i]
        local pc=PokerCard.new(1)
        pc:fromDbTable(pkt)
        table.insert(self.winCardArray,pc)
    end
    
    self.gamestate=dbt.gamestate
    return self
end

return PokerResult