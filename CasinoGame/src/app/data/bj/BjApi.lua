module("app.data.bj.BjApi", package.seeall)
local BjApi = app.data.bj.BjApi
local BjCard = require("app.data.bj.beans.BjCard")
local BjRound=require("app.data.bj.beans.BjRound")
local BjHand=require("app.data.bj.beans.BjHand")
local BjHandSet=require("app.data.bj.beans.BjHandSet")
local BjCalculation = require("app.data.bj.calculation.BjCalculation")
local BjBankerHand=require("app.data.bj.beans.BjBankerHand")

math.newrandomseed()

--新开始一局游戏
function BjApi.newGame(bjGameSet)
    print("============BjApi.newGame==================")
    local bjRound=BjRound.new(bjGameSet)
    bjRound.storeIds=BjCalculation.genStoreCards(bjGameSet.pokerPackNum)
    --初始化给两张牌
    for i=1,2 do 
        for j=1,#BJ.HAND_SEQ do
            local tmpHandId=BJ.HAND_SEQ[j]
            local tmpHandSet=bjGameSet.handSets[tmpHandId]
            if  tmpHandSet ~= nil then
                local bjhand=bjRound.userHands[tmpHandId]
                if bjhand == nil then
                    bjhand=BjHand.new(tmpHandSet)
                end
                local tmpCadrId=table.remove(bjRound.storeIds,1)
                local tmpCard=BjCard.new(tmpCadrId)
                bjhand:hitCard(tmpCard)
                bjRound.userHands[tmpHandId]=bjhand
            end
        end
        --设置庄家手牌
        local tmpbHand=bjRound.bankerHand
        if tmpbHand == nil then
            tmpbHand=BjBankerHand.new(BJ.HAND_ID.BANKER)
        end
        local tmpbCadrId=table.remove(bjRound.storeIds,1)
        local tmpbCard=BjCard.new(tmpbCadrId)
        tmpbHand:hitCard(tmpbCard)
        bjRound.bankerHand=tmpbHand
    end


    --[[local tmpCard1=BjCard.new(1)
    local tmpCard2=BjCard.new(11)
    bjRound.userHands["1"].cardArray[1]=tmpCard1
    bjRound.userHands["1"].cardArray[2]=tmpCard2
    local tmpCard3=BjCard.new(14)
    local tmpCard4=BjCard.new(24)
    bjRound.userHands["3"].cardArray[1]=tmpCard3
    bjRound.userHands["3"].cardArray[2]=tmpCard4]]

   --[[ local tmpbHand=BjBankerHand.new(BJ.HAND_ID.BANKER)
    tmpbHand:hitCard(BjCard.new(1))
    tmpbHand:hitCard(BjCard.new(11))
    bjRound.bankerHand=tmpbHand]]
    
    --结算J区投注
    for key, val in pairs(bjRound.userHands) do
        local tmplHand=val
        local card1=tmplHand.cardArray[1]
        local card2=tmplHand.cardArray[2]
        if tmplHand.bjHandSet.jbet > 0 then
            if card1.cardNumber=="J" and card1.cardColor==BJ.CARD_COLOR.spade and card2.cardNumber=="J" and card2.cardColor==BJ.CARD_COLOR.spade then
                tmplHand.doubleJackWin=tmplHand.bjHandSet.jbet*100
            elseif card1.cardNumber=="J" and card2.cardNumber=="J" then
                tmplHand.doubleJackWin=tmplHand.bjHandSet.jbet*25
            elseif card1.cardNumber=="J" then
                tmplHand.doubleJackWin=tmplHand.bjHandSet.jbet*10
            end
        end
        bjRound.userHands[key]=tmplHand
    end
    
    local gameId=bjGameSet.gameId
    BjCalculation.updateDbTable(gameId,bjRound)
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end

--购买保险
function BjApi.insurance(bjGameSet,handId)
    print("============BjApi.insurance==================")
    local gameId=bjGameSet.gameId
    local bjRound=BjRound.new(bjGameSet)
    local dbt=BjCalculation.getDbTable(gameId)
    bjRound:fromDbTable(dbt)
    bjRound.userHands[tostring(handId)]:buyInsurance()
    
    BjCalculation.updateDbTable(gameId,bjRound)
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end

--checking for blackjack
function BjApi.checkBlackJack(bjGameSet)
    print("============BjApi.checkBlackJack==================")
    local gameId=bjGameSet.gameId
    local bjRound=BjRound.new(bjGameSet)
    local dbt=BjCalculation.getDbTable(gameId)
    bjRound:fromDbTable(dbt)
    
    local bankerBlack=bjRound.bankerHand:isBlackJack()
    for key, val in pairs(bjRound.userHands) do
        local tmpHand=val
        local tBlack=tmpHand:isBlackJack()
        --庄家时黑杰克
        if bankerBlack == true then
            --玩家购买了保险
            if tmpHand.bjHandSet.insuranceBet > 0 then
                tmpHand.insuranceWin=tmpHand.bjHandSet.insuranceBet*2
                --玩家也是黑杰克
                if tBlack==true then
                    tmpHand.handState=BJ.HAND_RESULT.PUSH
                else
                    tmpHand.handState=BJ.HAND_RESULT.NO_WIN
                end
            else
                --玩家也是黑杰克
                if tBlack==true then
                    tmpHand.handState=BJ.HAND_RESULT.PUSH 
                else
                    tmpHand.handState=BJ.HAND_RESULT.NO_WIN 
                end
            end
        else
            --玩家是黑杰克
            if tBlack==true then
                tmpHand.blackJackWin=tmpHand.bjHandSet.bet*1.5
                tmpHand.handState=BJ.HAND_RESULT.WIN 
            end
        end
    end
    BjCalculation.updateDbTable(gameId,bjRound)
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end

--抽牌
function BjApi.hit(bjGameSet,handId)
    print("============BjApi.hit==================")
    local gameId=bjGameSet.gameId
    local bjRound=BjRound.new(bjGameSet)
    local dbt=BjCalculation.getDbTable(gameId)
    bjRound:fromDbTable(dbt)
    --庄家抽牌
    if handId==BJ.HAND_ID.BANKER then
        local bankerHand=bjRound.bankerHand
        local tmpCadrId=table.remove(bjRound.storeIds,1)
        local tmpCard=BjCard.new(tmpCadrId)
        bankerHand:hitCard(tmpCard)
        if bankerHand:isBust() == true then
            bankerHand.handState=BJ.HAND_RESULT.BUST
        else
            if bankerHand:hitEnabled() == false then
                bankerHand.handState=BJ.HAND_RESULT.WAIT_FOR_COMPARE 
            else    
                bankerHand.handState=BJ.HAND_RESULT.HIT_ING
            end
        end
    else
        local bjhand=bjRound.userHands[tostring(handId)]
        local tmpCadrId=table.remove(bjRound.storeIds,1)
        local tmpCard=BjCard.new(tmpCadrId)
        bjhand:hitCard(tmpCard)
        bjhand.handState=BJ.HAND_RESULT.HIT_ING
        if bjhand:isBust() == true then
            bjhand.handState=BJ.HAND_RESULT.BUST
        else
            local num=bjhand:getFinalCardNum()
            if num == BJ.STANDARD_NUM then
                bjhand.handState=BJ.HAND_RESULT.WAIT_FOR_COMPARE 
            end  

            if bjhand.hasDouble==1 then
                bjhand.handState=BJ.HAND_RESULT.WAIT_FOR_COMPARE 
            end

            if bjhand.hasSplit==2 then
                bjhand.handState=BJ.HAND_RESULT.WAIT_FOR_COMPARE 
            end 
        end
        bjRound.userHands[tostring(handId)]=bjhand
    end
    BjCalculation.updateDbTable(gameId,bjRound)
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end

--停牌
function BjApi.stand(bjGameSet,handId)
    print("============BjApi.stand==================")
    local gameId=bjGameSet.gameId
    local bjRound=BjRound.new(bjGameSet)
    local dbt=BjCalculation.getDbTable(gameId)
    bjRound:fromDbTable(dbt)
    local bjhand=bjRound.userHands[tostring(handId)]
    bjhand.handState=BJ.HAND_RESULT.WAIT_FOR_COMPARE
    bjRound.userHands[tostring(handId)]=bjhand
    BjCalculation.updateDbTable(gameId,bjRound)
    
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end

--拆牌
function BjApi.split(bjGameSet,handId)
    print("============BjApi.split==================")
    local gameId=bjGameSet.gameId
    local splitHandId=""
    local hasSplit=1
    if handId==BJ.HAND_ID.HAND1 then
        splitHandId=BJ.HAND_ID.HAND1_SPLIT
    elseif handId==BJ.HAND_ID.HAND2 then
        splitHandId=BJ.HAND_ID.HAND2_SPLIT
    elseif handId==BJ.HAND_ID.HAND3 then
        splitHandId=BJ.HAND_ID.HAND3_SPLIT
    end
    
    local bjRound=BjRound.new(bjGameSet)
    local dbt=BjCalculation.getDbTable(gameId)
    bjRound:fromDbTable(dbt)
    local bjHand=bjRound.userHands[tostring(handId)]
    --把第二张牌取出来
    local scard=table.remove(bjHand.cardArray,2)
    if scard.cardNumber1 == 1 then
        hasSplit=2
    end
    bjHand.hasSplit=hasSplit
    bjRound.userHands[tostring(handId)]=bjHand
    
    local sHandSet=BjHandSet.new(splitHandId,bjHand.bjHandSet.bet)
    local sbjhand=BjHand.new(sHandSet)
    sbjhand.hasSplit=hasSplit
    sbjhand:hitCard(scard)
    bjRound.userHands[tostring(splitHandId)]=sbjhand
    
    --更新gameset
    bjRound.bjGameSet:insertHandSet(sHandSet)
    
    BjCalculation.updateDbTable(gameId,bjRound)
    
    
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end

--double
function BjApi.double(bjGameSet,handId)
    print("============BjApi.double==================")
    local gameId=bjGameSet.gameId
    local bjRound=BjRound.new(bjGameSet)
    local dbt=BjCalculation.getDbTable(gameId)
    bjRound:fromDbTable(dbt)
    local bjhand=bjRound.userHands[tostring(handId)]
    bjhand.handState=BJ.HAND_RESULT.HIT_ING
    bjhand.bjHandSet.bet=bjhand.bjHandSet.bet*2
    bjhand.hasDouble=1
    bjRound.userHands[tostring(handId)]=bjhand
    BjCalculation.updateDbTable(gameId,bjRound)
    
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end

--最后比牌
function BjApi.compare(bjGameSet)
    print("============BjApi.compare==================")
    local gameId=bjGameSet.gameId
    local bjRound=BjRound.new(bjGameSet)
    local dbt=BjCalculation.getDbTable(gameId)
    bjRound:fromDbTable(dbt)
    
    local bankerHand=bjRound.bankerHand
    local bhNum=bankerHand:getFinalCardNum()
    for key, val in pairs(bjRound.userHands) do
        local tmpHand=val
        local tmpNum=val:getFinalCardNum()
        local tBlack=tmpHand:isBlackJack()
        if tmpHand.handState == BJ.HAND_RESULT.WAIT_FOR_COMPARE then
            local result=BjCalculation.compareCardNum(tmpNum,bhNum)
            if result==BJ.HAND_RESULT.WIN then
                if tBlack then
                    tmpHand.blackJackWin=tmpHand.bjHandSet.bet * 1.5
                else
                    tmpHand.blackJackWin=tmpHand.bjHandSet.bet
                end
            end
            tmpHand.handState = result
        end
    end
    bjRound.roundState=BJ.ROUND_STATE.END
    
    BjCalculation.updateDbTable(gameId,bjRound)
    
    print(table.serialize(bjRound:toDbTable()))
    return bjRound
end
