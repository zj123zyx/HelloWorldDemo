local BjGameSet = class("BjGameSet")
local BjHandSet=require("app.data.bj.beans.BjHandSet")
function BjGameSet:ctor(gameId)
    self.gameId=gameId
    self.pokerPackNum=1 --几幅牌
    self.handSets={}
    self.dbTable={}
end

function BjGameSet:insertHandSet(bjHandSet)
    self.handSets[bjHandSet.handId]=bjHandSet
end

function BjGameSet:toDbTable()
    self.dbTable.gameId=self.gameId
    self.dbTable.pokerPackNum=self.pokerPackNum
    local tab={}
    for key, val in pairs(self.handSets) do
        tab[key]=val:toDbTable()
    end
    self.dbTable.handSets=tab
    return self.dbTable
end

function BjGameSet:fromDbTable(dbt)
    self.gameId=dbt.gameId
    self.pokerPackNum=dbt.pokerPackNum
    self.handSets={}
    for key, val in pairs(dbt.handSets) do
        local hs=BjHandSet.new(1,1)
        hs:fromDbTable(val)
        self.handSets[key]=hs
    end
    return self
end

return BjGameSet