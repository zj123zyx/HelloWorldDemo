local BjBankerHand = class("BjBankerHand")
local BjCard = require("app.data.bj.beans.BjCard")

--装家手牌
function BjBankerHand:ctor(handId)
    self.handId=handId --位子编码
    self.cardArray={}
    self.handState=BJ.HAND_RESULT.INIT--默认初始发两张牌状态
    self.dbTable={}
end

--抽一张牌
function BjBankerHand:hitCard(blackJackCard)
    table.insert(self.cardArray,blackJackCard)
end

--判断是否黑杰克
function BjBankerHand:isBlackJack()
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

--庄家是否可以要牌
function BjBankerHand:hitEnabled()
    local num=self:getFinalCardNum()
    if num < BJ.BANKER_NUM then
        return true
    end
    return false
end

--判断是否bust
function BjBankerHand:isBust()
    local num1,num2=self:getTotalCardNum()
    if num1 > BJ.STANDARD_NUM and num2 > BJ.STANDARD_NUM then
        return true
    end
    return false
end

--计算当前牌面数
function BjBankerHand:getTotalCardNum()
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
function BjBankerHand:getFinalCardNum()
    local num1,num2=self:getTotalCardNum()
    if num2<=BJ.STANDARD_NUM then
        return num2
    else
        return num1
    end
end

function BjBankerHand:getDisplayNum()
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

function BjBankerHand:toDbTable()
    local ctab={}
    for i=1,#self.cardArray do
        local pk=self.cardArray[i]
        table.insert(ctab,pk:toDbTable())
    end
    self.dbTable.cardArray=ctab
    self.dbTable.handId = self.handId
    self.dbTable.handState = self.handState
    return self.dbTable
end

function BjBankerHand:fromDbTable(dbt)
    if dbt==nil or table.isEmpty(dbt)==true then
        return self
    end
    local ctab=dbt.cardArray
    self.cardArray={}
    for i=1,#ctab do
        local pkt=ctab[i]
        local bc=BjCard.new(0)
        bc:fromDbTable(pkt)
        table.insert(self.cardArray,bc)
    end 
    self.handId=dbt.handId
    self.handState=dbt.handState
    return self
end

return BjBankerHand