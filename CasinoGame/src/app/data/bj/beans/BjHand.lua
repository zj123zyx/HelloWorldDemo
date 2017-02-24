local BjHand = class("BjHand")
local BjHandSet=require("app.data.bj.beans.BjHandSet")
local BjCard = require("app.data.bj.beans.BjCard")

function BjHand:ctor(bjHandSet)
    self.bjHandSet = bjHandSet --位子编码
    self.cardArray={}
    self.hasDouble=0 --是否已double 1 是 0 否
    self.hasSplit=0 --拆牌状态 0 未拆牌 1 正常拆牌 2 拆开一对
    self.handState=BJ.HAND_RESULT.INIT--默认初始发两张牌状态
    
    self.insuranceWin=0 --保险赢的钱
    self.blackJackWin=0 --黑杰克奖金
    self.doubleJackWin=0 --双杰克奖金
    
    self.dbTable={}
end

--抽一张牌
function BjHand:hitCard(blackJackCard)
    table.insert(self.cardArray,blackJackCard)
end

--购买保险
function BjHand:buyInsurance()
    self.bjHandSet.insuranceBet = self.bjHandSet.bet/2
end

--判断是否黑杰克
function BjHand:isBlackJack()
    if #self.cardArray < 2 then
        return false
    end
    local card1= self.cardArray[1]
    local card2= self.cardArray[2]

    if card1.cardNumber1==1 and card2.cardNumber1==10  then
        return true
    end
    if (card1.cardNumber1==10 and card2.cardNumber1==1 ) then
        return true
    end
    return false
end

--判断是否bust
function BjHand:isBust()
    local num1,num2=self:getTotalCardNum()
    if num1 > BJ.STANDARD_NUM and num2 > BJ.STANDARD_NUM then
        return true
    end
    return false
end

--判断是否可以split
function BjHand:splitEnabled()
    --不为0说明已拆过
    if self.hasSplit ~= 0 then
        return false
    end
    
    if table.nums(self.cardArray) ~= 2 then
        return false
    end
    
    local card1= self.cardArray[1]
    local card2= self.cardArray[2]
    if card1.cardNumber1 == card2.cardNumber1 then 
        return true
    end 
    return false
end

--判断是否可double
function BjHand:doubleEnabled()
    if self.hasDouble ~= 0 then
        return false
    end
    
    if table.nums(self.cardArray) ~= 2 then
        return false
    end
    
    if self:hitEnabled() == true then
        return true
    end
    return false
end

--判断是否可叫牌
function BjHand:hitEnabled()
    if self.handState ~= BJ.HAND_RESULT.INIT and self.handState ~= BJ.HAND_RESULT.HIT_ING then
        return false
    end
    local num1,num2=self:getTotalCardNum()
    if num1<BJ.STANDARD_NUM or num2<BJ.STANDARD_NUM then
        return true
    end
    return false
end

--判断是否可停牌
function BjHand:standEnabled()
    if self.handState == BJ.HAND_RESULT.INIT or self.handState == BJ.HAND_RESULT.HIT_ING then
        return true
    end
    return false
end

--计算当前牌面数
function BjHand:getTotalCardNum()
    local num1=0
    local num2=0
    local flag=false
    for i=1,#self.cardArray do
        local tmpCard=self.cardArray[i]
        if tmpCard.cardNumber1==1 and flag == false then
            num1=num1+tonumber(tmpCard.cardNumber1)
            num2=num2+tonumber(tmpCard.cardNumber2)
            flag=true
        else
            num1=num1+tonumber(tmpCard.cardNumber1)
            num2=num2+tonumber(tmpCard.cardNumber1)
        end
    end
    return num1,num2
end

--获得最终用来比对的牌值
function BjHand:getFinalCardNum()
    local num1,num2=self:getTotalCardNum()
    if num2<=BJ.STANDARD_NUM then
        return num2
    else
        return num1
    end
end

function BjHand:getDisplayNum()
    local num1,num2 = self:getTotalCardNum()
    local str = num1
    if num1 == num2 then
        str = num1
    elseif num2<=BJ.STANDARD_NUM then
        str =  num1.."/"..num2
    else
        str = num1
    end
    return str
end

--获得保险总共奖励金额
function BjHand:getInsuranceWinCoins()
    if self.insuranceWin > 0 then
        return self.insuranceWin+self.bjHandSet.insuranceBet
    end
    return 0
end

--获得黑杰克总共奖励金额
function BjHand:getBlackJackWinCoins()
    if self.handState == BJ.HAND_RESULT.WIN then
        return self.blackJackWin+self.bjHandSet.bet
    elseif self.handState == BJ.HAND_RESULT.PUSH then
        return self.bjHandSet.bet
    end
    return 0
end

--获得双杰克总共奖励金额
function BjHand:getDoubleJackWinCoins()
    if self.doubleJackWin > 0 then
        return self.doubleJackWin+self.bjHandSet.jbet
    end
    return 0
end

function BjHand:toDbTable()
    self.dbTable.bjHandSet = self.bjHandSet:toDbTable()
    local ctab={}
    for i=1,#self.cardArray do
        local pk=self.cardArray[i]
        table.insert(ctab,pk:toDbTable())
    end
    self.dbTable.cardArray=ctab
    self.dbTable.hasDouble = self.hasDouble
    self.dbTable.hasSplit = self.hasSplit
    self.dbTable.handState = self.handState
    self.dbTable.blackJackWin = self.blackJackWin
    self.dbTable.doubleJackWin = self.doubleJackWin
    self.dbTable.insuranceWin = self.insuranceWin
    return self.dbTable
end

function BjHand:fromDbTable(dbt)
    if dbt==nil or table.isEmpty(dbt)==true then
        return self
    end
    local bjHandSet=BjHandSet.new(0,0)
    self.bjHandSet=bjHandSet:fromDbTable(dbt.bjHandSet)
     
    local ctab=dbt.cardArray
    self.cardArray={}
    for i=1,#ctab do
        local pkt=ctab[i]
        local bc=BjCard.new(0)
        bc:fromDbTable(pkt)
        table.insert(self.cardArray,bc)
    end 
    self.hasDouble=dbt.hasDouble
    self.hasSplit=dbt.hasSplit
    self.handState=dbt.handState
    self.blackJackWin=dbt.blackJackWin
    self.doubleJackWin=dbt.doubleJackWin
    self.insuranceWin=dbt.insuranceWin
    return self
end

return BjHand

