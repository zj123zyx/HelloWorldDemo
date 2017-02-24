
local BjCard = require("app.data.bj.beans.BjCard")
local BjRound=require("app.data.bj.beans.BjRound")
local BjHand=require("app.data.bj.beans.BjHand")
local BjHandSet=require("app.data.bj.beans.BjHandSet")
local BjCalculation = require("app.data.bj.calculation.BjCalculation")
local BjBankerHand=require("app.data.bj.beans.BjBankerHand")
local BjGameSet=require("app.data.bj.beans.BjGameSet")
local BjApi = require("app.data.bj.BjApi")

function testnewGame()

    print("TestCase testnewGame()")
    
    local bjGameSet=BjGameSet.new(300)
    local handset1=BjHandSet.new(BJ.HAND_ID.HAND1,5)
    local handset2=BjHandSet.new(BJ.HAND_ID.HAND2,5)
    bjGameSet:insertHandSet(handset1)
    bjGameSet:insertHandSet(handset2)
    
    local ss = BjApi.newGame(bjGameSet)
    
    print(table.serialize(ss:toDbTable()))
    print(ss:tostring())
    print("TestCase BjApi.insurance()")
    ss=BjApi.insurance(bjGameSet,BJ.HAND_ID.HAND1)
    print(ss:tostring())
    
    print("TestCase BjApi.checkBlackJack()")
    ss=BjApi.checkBlackJack(bjGameSet)
    print(ss:tostring())
    --[[
    print("TestCase BjApi.hit()")
    ss=BjApi.hit(bjGameSet,BJ.HAND_ID.HAND1)
    print(ss:tostring())
    ]]
    print("TestCase BjApi.stand()")
    ss=BjApi.stand(bjGameSet,BJ.HAND_ID.HAND1)
    print(ss:tostring())
end

function testhand()
    
end

