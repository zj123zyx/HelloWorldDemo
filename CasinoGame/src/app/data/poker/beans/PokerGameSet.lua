local PokerCard = require("app.data.poker.beans.PokerCard")
local PokerGameSet = class("PokerGameSet")

function PokerGameSet:ctor()
    self.gameId=201
    self.bet=0
    self.hands=1
    self.userCardArray={}
    self.dbTable={}
end

function PokerGameSet:setBet(bet)
    self.bet = bet
end

function PokerGameSet:getBet()
    return self.bet
end

function PokerGameSet:setUserCardArray(userCardArray)
    self.userCardArray = userCardArray
end

function PokerGameSet:getUserCardArray()
    return self.userCardArray
end

function PokerGameSet:toDbTable()
    self.dbTable.bet=self.bet
    self.dbTable.gameId=self.gameId
    self.dbTable.hands=self.hands
    local tab={}
    for i=1,#self.userCardArray do
        local pk=self.userCardArray[i]
        table.insert(tab,pk:toDbTable())
    end
    self.dbTable.userCardArray=tab
    return self.dbTable
end

function PokerGameSet:fromDbTable(dbt)
    self.bet=dbt.bet
    self.gameId=dbt.gameId
    self.hands=dbt.hands
    local tab=dbt.userCardArray
    self.userCardArray={}
    for i=1,#tab do
        local pkt=tab[i]
        local pc=PokerCard.new(1)
        pc:fromDbTable(pkt)
        table.insert(self.userCardArray,pc)
    end
    return self
end


return PokerGameSet