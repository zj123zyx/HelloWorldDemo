local PokerCalculation = require("app.data.poker.calculation.PokerCalculation")
local PokerGameSet=require("app.data.poker.beans.PokerGameSet")
local PokerCard=require("app.data.poker.beans.PokerCard")
local PokerApi = require("app.data.poker.PokerApi")

function testpickSomeCards()

    print("TestCase testpickSomeCards()")
    local pokerCard1=PokerCard.new(1)
    pokerCard1:setShowIdx(1)
    local pokerCard2=PokerCard.new(2)
    pokerCard2:setShowIdx(2)
    local pokerCard3=PokerCard.new(3)
    pokerCard3:setShowIdx(3)
    local pokerCard4=PokerCard.new(4)
    pokerCard4:setShowIdx(4)
    local pokerCard5=PokerCard.new(5)
    pokerCard5:setShowIdx(5)
    pokerCard5:setHoldSign(1)
    local excludeCards={}
    table.insert(excludeCards,pokerCard1)
    table.insert(excludeCards,pokerCard2)
    table.insert(excludeCards,pokerCard3)
    table.insert(excludeCards,pokerCard4)
    table.insert(excludeCards,pokerCard5)
    PokerCalculation.pickSomeCards(excludeCards)
    --PokerCalculation.pickSomeCards({})
    --print(PokerCalculation.buildStraightKey(excludeCards))
end

function testgetPokerCards()
    local gameset=PokerGameSet.new()
    gameset.bet=3
    local presult=PokerApi.getPokerCards(gameset)
    --[[
    for i=1,100 do
        PokerApi.getPokerCards(gameset)
    end
    ]]
    local gameset2=PokerGameSet.new()
    gameset2.bet=5
    gameset2.userCardArray=presult.firstCardArray
    gameset2.userCardArray[1].holdSign=1
    PokerApi.getPokerCards(gameset2)
end