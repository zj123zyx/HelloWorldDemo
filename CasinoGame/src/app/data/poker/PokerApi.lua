module("app.data.poker.PokerApi", package.seeall)
local PokerApi = app.data.poker.PokerApi
local PokerCalculation = require("app.data.poker.calculation.PokerCalculation")
local PokerCard=require("app.data.poker.beans.PokerCard")
local PokerResult=require("app.data.poker.beans.PokerResult")

--math.randomseed(os.time())

--获得未完成的结果
function PokerApi.restorePokerCards(gameId)
    local tmpGameSet=PokerGameSet.new()
    tmpGameSet.gameId=gameId
    local pokerResult=PokerResult.new(tmpGameSet)
    local dbt=PokerCalculation.getDbTable(tmpGameSet)
    pokerResult:fromDbTable(dbt)
    if pokerResult.gamestate == 0 then
       pokerResult.costCoins=0 
    end
    if dbt==nil or table.isEmpty(dbt)==true then
        pokerResult.gamestate = 1
    end
    return pokerResult
end

function PokerApi.getPokerCards(pokerGameSet)
    print("===============PokerApi.getPokerCards========================")
    local pokerResult=nil
    if table.isEmpty(pokerGameSet:getUserCardArray()) == true then
        pokerResult=PokerApi.dealPokerCards(pokerGameSet)
    else
        pokerResult=PokerApi.drawPokerCards(pokerGameSet)
    end

    --设置奖励金币
    local dicPaytable=DICT_POKER_PAYTABLE[tostring(pokerResult.winPattern)]
    if dicPaytable ~= nil then
        local multiple=tonumber(dicPaytable.multiple)
        local rewardCoins=tonumber(pokerGameSet:getBet())*multiple
        pokerResult:setRewardCoins(rewardCoins)
    else
        pokerResult:setRewardCoins(0)
    end
    return pokerResult
end

function PokerApi.dealPokerCards(pokerGameSet)
    --print("PokerApi.dealPokerCards")
    local pickCards=PokerCalculation.pickSomeCards({})
    local pokerResult=PokerResult.new(pokerGameSet)
    pokerResult:setFirstCardArray(pickCards)
    PokerCalculation.calculationPokerResult(pokerResult,0)
    pokerResult:setCostCoins(tonumber(pokerGameSet:getBet()))
    
    PokerCalculation.updateDbTable(pokerResult)
    return pokerResult
end

function PokerApi.drawPokerCards(pokerGameSet)
    --print("PokerApi.drawPokerCards")
    local pickCards=PokerCalculation.pickSomeCards(pokerGameSet:getUserCardArray())
    local pokerResult=PokerResult.new(pokerGameSet)
    pokerResult:setFirstCardArray(pokerGameSet:getUserCardArray())
    --local dbt=PokerCalculation.getDbTable(pokerGameSet)
    --pokerResult:fromDbTable(dbt)
    --pokerResult:setPokerGameSet(pokerGameSet)
    
    pokerResult:setSecondCardArray(pickCards)
    PokerCalculation.calculationPokerResult(pokerResult,1)
    pokerResult:setCostCoins(0)
    
    local replaceCards={}
    local replaceIds={}
    for i=1,#pokerGameSet.userCardArray do
        if pokerGameSet.userCardArray[i].holdSign==0 then
            table.insert(replaceIds,pokerGameSet.userCardArray[i].showIdx)
        end
    end
    for i=1,#pokerResult.secondCardArray do
        if table.indexof(replaceIds, pokerResult.secondCardArray[i].showIdx) ~= false then
            table.insert(replaceCards,pokerResult.secondCardArray[i])
        end
    end
    
    pokerResult:setReplaceCardArray(replaceCards)
    pokerResult:setGamestate(1)
    
    PokerCalculation.updateDbTable(pokerResult)
    --更新最佳卡组
    PokerApi.updateBestCardArray(pokerResult:getSecondCardArray())
    return pokerResult
end

function PokerApi.getBestCardArray()
    local dbt={}
    local pokerModel = app:getObject("PokerModel")
    local pk=pokerModel:getBestPoker()
    if table.isEmpty(pk) == true then
        return dbt
    end
    dbt=pk
    local bestCardArray={}
    for i=1,#dbt do
        local bean=PokerCard.new(1)
        bean:fromDbTable(dbt[i])
        table.insert(bestCardArray,bean)
    end

    return bestCardArray
end

function PokerApi.updateBestCardArray(playerWinCardArray)
    local bestCardArray=PokerApi.getBestCardArray()
    if table.isEmpty(bestCardArray) then
        PokerCalculation.updateBestPoker(playerWinCardArray)
        return    
    end

    local result=PokerCalculation.compareBestPoker(playerWinCardArray,bestCardArray)
    if result == true then
        PokerCalculation.updateBestPoker(playerWinCardArray)
    end
end