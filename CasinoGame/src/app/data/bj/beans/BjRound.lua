local BjRound = class("BjRound")
local BjGameSet=require("app.data.bj.beans.BjGameSet")
local BjHand=require("app.data.bj.beans.BjHand")
local BjBankerHand=require("app.data.bj.beans.BjBankerHand")
--黑杰克回合结果
function BjRound:ctor(bjGameSet)
    self.bjGameSet=bjGameSet
    self.storeIds={} --牌库
    self.bankerHand=nil --庄家手牌
    self.userHands={} --玩家手牌 {"1"=bjHand1,"2"=bjHand2}
    self.roundState=BJ.ROUND_STATE.INIT --0 初始化 1 进行中 2 结束
    self.dbTable={}
end

--判断是否可以购买保险
function BjRound:insuranceEnabled()
    if self.bankerHand==nil then
        return false
    end
    
    if self.bankerHand.cardArray[1].cardNumber1==1 then
        return true
    end
    
    return false
end

function BjRound:toDbTable()
    self.dbTable.bjGameSet = self.bjGameSet:toDbTable()
    self.dbTable.storeIds = self.storeIds
    self.dbTable.bankerHand = self.bankerHand:toDbTable()
    
    local utab={}
    for key, val in pairs(self.userHands) do
        utab[key]=val:toDbTable()
    end
    
    self.dbTable.userHands=utab
    self.dbTable.roundState = self.roundState
    return self.dbTable
end

function BjRound:fromDbTable(dbt)
    if dbt==nil or table.isEmpty(dbt)==true then
        return self
    end
    local bjGameSet=BjGameSet.new(0,0)
    self.bjGameSet=bjGameSet:fromDbTable(dbt.bjGameSet)
    
    self.storeIds=dbt.storeIds
    local bh=BjBankerHand.new(BJ.HAND_ID.BANKER)
    self.bankerHand=bh:fromDbTable(dbt.bankerHand)

    self.userHands={} 
    for key, val in pairs(dbt.userHands) do
        local bc=BjHand.new(nil)
        bc:fromDbTable(val)
        self.userHands[key]=bc
    end
    
    self.roundState=dbt.roundState
    return self
end  

function BjRound:tostring()
    local s=""
    local num1,num2=self.bankerHand:getTotalCardNum()
    s=s.."banker:"..num1.."/"..num2
    
    for key, val in pairs(self.userHands) do
        local num1,num2=val:getTotalCardNum()
        s=s.." | "..key..":"..num1.."/"..num2
    end
    
    return s
end  

return BjRound