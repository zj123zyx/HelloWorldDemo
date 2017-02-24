module("app.data.txspoker.TxsApi", package.seeall)
local TxsApi = app.data.txspoker.TxsApi

local TxsCard=require("app.data.txspoker.beans.TxsCard")
local TxsGameSet=require("app.data.txspoker.beans.TxsGameSet")
local TxsRound=require("app.data.txspoker.beans.TxsRound")
local TxsCalculation = require("app.data.txspoker.calculation.TxsCalculation")

math.newrandomseed()

function TxsApi.deal(txsGameSet)
    --print("============TxsApi.deal==================")
    local txsRound =TxsRound.new(txsGameSet)
    txsRound.storeIds=TxsCalculation.genStoreCards()
    --第一轮发牌
    for i=1,2 do 
        local tmpCardId=table.remove(txsRound.storeIds,1)
        local tmpCard=TxsCard.new(tmpCardId)
        table.insert(txsRound.playerCardArray,tmpCard)
        
        local bankerCardId=table.remove(txsRound.storeIds,1)
        local bankerCard=TxsCard.new(bankerCardId)
        bankerCard.isShow=0
        table.insert(txsRound.bankerCardArray,bankerCard)
    end
    --公共区发三张牌
    for i=1,3 do
        local tmpCardId=table.remove(txsRound.storeIds,1)
        local tmpCard=TxsCard.new(tmpCardId)
        table.insert(txsRound.commonCardArray,tmpCard)
    end
    
    TxsCalculation.updateDbTable(txsRound)
   -- print(table.serialize(txsRound:toDbTable()))
    return txsRound
end

function TxsApi.call(txsGameSet)
    --print("============TxsApi.call==================")
    local gameId=txsGameSet.gameId
    local txsRound=TxsRound.new(txsGameSet)
    local dbt=TxsCalculation.getDbTable(gameId)
    txsRound:fromDbTable(dbt)
    
    --设置call区筹码
    txsRound.txsGameSet.callBet =  txsRound.txsGameSet.anteBet*2


    local AABonusPatternArray=TxsCalculation.genPlayerCardArray(txsRound)
    --计算AA-Bonus
    if txsRound.playerWinPattern >=TXS.PATTERN_ID.Royal_Straight_Flush and txsRound.playerWinPattern <= TXS.PATTERN_ID.Flush then
        txsRound.aaWin=txsRound.txsGameSet.aaBet * 25
    elseif txsRound.playerWinPattern >=TXS.PATTERN_ID.Straight and txsRound.playerWinPattern <= TXS.PATTERN_ID.Two_Pairs then
        txsRound.aaWin=txsRound.txsGameSet.aaBet * 7
    elseif txsRound.playerWinPattern==TXS.PATTERN_ID.One_Pair then
        local jackNum=AABonusPatternArray.analyzeResult.kind2nums[1]
        if jackNum=="1" then
            txsRound.aaWin=txsRound.txsGameSet.aaBet * 7
        end
    end

    --公共区发两张牌
    for i=1,2 do
        local tmpCardId=table.remove(txsRound.storeIds,1)
        local tmpCard=TxsCard.new(tmpCardId)
        table.insert(txsRound.commonCardArray,tmpCard)
    end
    
    --生成玩家的五张卡组
    local playerPatternArray=TxsCalculation.genPlayerCardArray(txsRound)
    --生成庄家五张卡组
    local bankerPatternArray=TxsCalculation.genBankerCardArray(txsRound)
    
    --比较胜负
    if txsRound.playerWinPattern < txsRound.bankerWinPattern then
           txsRound.result=TXS.ROUND_RESULT.WIN
    elseif txsRound.playerWinPattern == txsRound.bankerWinPattern then
           txsRound.result=TxsCalculation.comparePushPattern(playerPatternArray,bankerPatternArray)
    else
           txsRound.result=TXS.ROUND_RESULT.NO_WIN
    end

    if txsRound.bankerWinPattern == TXS.PATTERN_ID.High_Card then
        txsRound.result=TXS.ROUND_RESULT.WIN
        txsRound.notCompare = true
    elseif txsRound.bankerWinPattern == TXS.PATTERN_ID.One_Pair then
        local cardValue = tonumber(bankerPatternArray.cardArray[1].cardNumber)
        if cardValue == 2 or cardValue == 3 then
            txsRound.result=TXS.ROUND_RESULT.WIN
            txsRound.notCompare = true
        end
    end

    
    --计算奖金
    if txsRound.result == TXS.ROUND_RESULT.WIN then
        local dicPayTable=TXS.DICT_TXS_PAYTABLE[tostring(txsRound.playerWinPattern)]
        local multiple=tonumber(dicPayTable.multiple)
        txsRound.antiWin=txsRound.txsGameSet.anteBet * multiple
        if txsRound.notCompare then
            txsRound.callWin=0
        else
            txsRound.callWin=txsRound.txsGameSet.callBet * 1
        end
    end

    TxsApi.updateBestCardArray(txsRound.playerWinCardArray)
    txsRound.roundstate=1
    TxsCalculation.updateDbTable(txsRound)
   -- print(table.serialize(txsRound:toDbTable()))
    return txsRound
end

function TxsApi.fold(txsGameSet)
    local gameId=txsGameSet.gameId
    local txsRound=TxsRound.new(txsGameSet)
    local dbt=TxsCalculation.getDbTable(gameId)
    txsRound:fromDbTable(dbt)
    
    txsRound.result=TXS.ROUND_RESULT.NO_WIN
    txsRound.roundstate=1
    TxsCalculation.updateDbTable(txsRound)
    return txsRound
end

-- texas-holdem-pro-series 的api接口

function TxsApi.texasDeal(txsGameSet)
    local txsRound =TxsRound.new(txsGameSet)
    txsRound.storeIds=TxsCalculation.genStoreCards()
    --第一轮发牌
    for i=1,2 do 
        local tmpCardId=table.remove(txsRound.storeIds,1)
        local tmpCard=TxsCard.new(tmpCardId)
        table.insert(txsRound.playerCardArray,tmpCard)

        local bankerCardId=table.remove(txsRound.storeIds,1)
        local bankerCard=TxsCard.new(bankerCardId)
        bankerCard.isShow=0
        table.insert(txsRound.bankerCardArray,bankerCard)
    end

    TxsCalculation.updateDbTable(txsRound)

    return txsRound
end

function TxsApi.texasCall(txsGameSet)
    local gameId=txsGameSet.gameId
    local txsRound=TxsRound.new(txsGameSet)
    local dbt=TxsCalculation.getDbTable(gameId)
    txsRound:fromDbTable(dbt)

    --设置call区筹码
    txsRound.txsGameSet.callBet =  txsRound.txsGameSet.anteBet*2

    --公共区发三张牌
    for i=1,3 do
        local tmpCardId=table.remove(txsRound.storeIds,1)
        local tmpCard=TxsCard.new(tmpCardId)
        table.insert(txsRound.commonCardArray,tmpCard)
    end

    --结算当前的获胜模式
    local sevenCardArray={}
    for i=1,#txsRound.playerCardArray do
        table.insert(sevenCardArray,txsRound.playerCardArray[i])
    end
    for i=1,#txsRound.commonCardArray do
        table.insert(sevenCardArray,txsRound.commonCardArray[i])
    end
    local winPattern,winCards,analyzeResult= TxsCalculation.calculationCardArray(sevenCardArray)
    txsRound.playerWinPattern = winPattern
    
    TxsCalculation.updateDbTable(txsRound)
    return txsRound
end

function TxsApi.texasCheck(txsGameSet)
    local gameId=txsGameSet.gameId
    local txsRound=TxsRound.new(txsGameSet)
    local dbt=TxsCalculation.getDbTable(gameId)
    txsRound:fromDbTable(dbt)
    
    --抽一张牌到公共区
    local tmpCardId=table.remove(txsRound.storeIds,1)
    local tmpCard=TxsCard.new(tmpCardId)
    table.insert(txsRound.commonCardArray,tmpCard)
    
    --check第四张牌
    if #txsRound.commonCardArray == 4 then
        local singlePatternArray=TxsCalculation.pickMaxCardArray(txsRound.playerCardArray,txsRound.commonCardArray)
        txsRound.playerWinPattern=tonumber(singlePatternArray.winPattern)
    elseif #txsRound.commonCardArray == 5 then
        --生成玩家的五张卡组
        local playerPatternArray=TxsCalculation.genPlayerCardArray(txsRound)
        --生成庄家五张卡组
        local bankerPatternArray=TxsCalculation.genBankerCardArray(txsRound)

        --比较胜负
        if txsRound.playerWinPattern < txsRound.bankerWinPattern then
            txsRound.result=TXS.ROUND_RESULT.WIN
        elseif txsRound.playerWinPattern == txsRound.bankerWinPattern then
            txsRound.result=TxsCalculation.comparePushPattern(playerPatternArray,bankerPatternArray)
        else
            txsRound.result=TXS.ROUND_RESULT.NO_WIN
        end

        --计算奖金
        if txsRound.result == TXS.ROUND_RESULT.WIN then
            --[[
            local dicPayTable=TXS.DICT_TXS_PAYTABLE[tostring(txsRound.playerWinPattern)]
            local multiple=tonumber(dicPayTable.multiple)
            if txsRound.playerWinPattern <= TXS.PATTERN_ID.Straight then
                txsRound.antiWin=txsRound.txsGameSet.anteBet * multiple
            end
            txsRound.callWin=txsRound.txsGameSet.callBet * multiple
            ]]
            if txsRound.playerWinPattern <= TXS.PATTERN_ID.Straight then
                txsRound.antiWin=txsRound.txsGameSet.anteBet * 1
            end
            txsRound.callWin=txsRound.txsGameSet.callBet * 1
            txsRound.turnWin=txsRound.txsGameSet.turnBet * 1
        end
        txsRound.roundstate=1
        TxsApi.updateBestCardArray(txsRound.playerWinCardArray)
    end
    
    TxsCalculation.updateDbTable(txsRound)
    return txsRound
end

function TxsApi.texasBetUp(txsGameSet)
    local txsRound=TxsApi.texasCheck(txsGameSet)
    if #txsRound.commonCardArray == 4 then
        txsRound.txsGameSet.turnBet = txsRound.txsGameSet.anteBet
    elseif #txsRound.commonCardArray == 5 then
        txsRound.txsGameSet.riverBet = txsRound.txsGameSet.anteBet
        --计算奖金
        if txsRound.result == TXS.ROUND_RESULT.WIN then
            --[[
            local dicPayTable=TXS.DICT_TXS_PAYTABLE[tostring(txsRound.playerWinPattern)]
            local multiple=tonumber(dicPayTable.multiple)
            txsRound.turnWin=txsRound.txsGameSet.turnBet * multiple
            txsRound.riverWin=txsRound.txsGameSet.riverBet * multiple
            ]]
            if txsRound.playerWinPattern <= TXS.PATTERN_ID.Straight then
                txsRound.antiWin=txsRound.txsGameSet.anteBet * 1
            end
            txsRound.turnWin=txsRound.txsGameSet.turnBet * 1
            txsRound.riverWin=txsRound.txsGameSet.riverBet * 1
        end
        txsRound.roundstate=1
        TxsApi.updateBestCardArray(txsRound.playerWinCardArray)
    end
    
    TxsCalculation.updateDbTable(txsRound)
    
    return txsRound
end

function TxsApi.getBestCardArray()
    local dbt={}
    local pokerModel = app:getObject("TexasModel")
    local pk=pokerModel:getBestPoker()
    if table.isEmpty(pk) == true then
        return dbt
    end
    dbt=pk
    local bestCardArray={}
    for i=1,#dbt do
        local bean=TxsCard.new(1)
        bean:fromDbTable(dbt[i])
        table.insert(bestCardArray,bean)
    end
    
    return bestCardArray
end

function TxsApi.updateBestCardArray(playerWinCardArray)
    local bestCardArray=TxsApi.getBestCardArray()
    if table.isEmpty(bestCardArray) then
        TxsCalculation.updateBestPoker(playerWinCardArray)
        return    
    end
    
    local result=TxsCalculation.compareBestPoker(playerWinCardArray,bestCardArray)
    if result==TXS.ROUND_RESULT.WIN then
        TxsCalculation.updateBestPoker(playerWinCardArray)
    end
end

