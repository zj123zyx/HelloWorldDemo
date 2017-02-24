module("app.data.poker.calculation.PokerCalculation", package.seeall)
local PokerCalculation = app.data.poker.calculation.PokerCalculation
local PokerCard=require("app.data.poker.beans.PokerCard")

function PokerCalculation.pickSomeCards(excludeCards)
    local pickCards={}
    local pickIds={}
    if excludeCards==nil or table.isEmpty(excludeCards)==true then
        pickIds=PokerCalculation.pickCardIds(5,nil)
    else
        local tmpPickIds={}
        local excludeIds={}
        local num=0
        for i=1,#excludeCards do
            table.insert(excludeIds,excludeCards[i].cardId)
            if excludeCards[i].holdSign==0 then
                num=num+1
            end
        end
        tmpPickIds=PokerCalculation.pickCardIds(num,excludeIds)
        local tmpCnt=1
        --确保是以showIdx生序排列
        local function comps(a,b)
            return tonumber(a.showIdx) < tonumber(b.showIdx)
        end
        table.sort(excludeCards,comps)
        for i=1,#excludeCards do
            if excludeCards[i].holdSign==0 then
                table.insert(pickIds,tmpPickIds[tmpCnt])
                tmpCnt=tmpCnt+1
            else    
                table.insert(pickIds,excludeCards[i].cardId)
            end
        end
    end
    --print("pickIds",sz_T2S(pickIds))
    for i=1,#pickIds do
        local cid=tostring(pickIds[i])
        local dicCard=DICT_POKER_CARD[cid]
        local pokerCard=PokerCard.new(cid)
        pokerCard:setShowIdx(i)
        pokerCard:setCardColor(dicCard.card_color)
        pokerCard:setCardType(dicCard.card_type)
        pokerCard:setCardNumber(dicCard.card_number)
        table.insert(pickCards,pokerCard)
        --print(pokerCard:toString())
    end
    

    return pickCards
end

--num 要取的数目
--excludeIds 除外的id
function PokerCalculation.pickCardIds(num,excludeIds)
    local ids={}
    for key, val in pairs(DICT_POKER_CARD) do
        if excludeIds==nil or table.indexof(excludeIds, key)==false then
            --print("aa",key)
            table.insert(ids,key)
        end
    end
    table.RandShuffle(ids)
    --print("#ids",#ids)
    local pickIds={}
    for i=1,num do
        table.insert(pickIds,ids[i])
    end
    
    
    return pickIds
end

--计算扑克牌结果
function PokerCalculation.calculationPokerResult(pokerResult,sign)
    local cardArray=nil
    if sign==0 then
        cardArray=pokerResult:getFirstCardArray()
    else
        cardArray=pokerResult:getSecondCardArray()
    end
    local winPattern,winCards,analyzeResult= PokerCalculation.calculationCardArray(cardArray)
    
    pokerResult:setWinPattern(winPattern)
    pokerResult:setWinCardArray(winCards)
end

--结算牌组
function PokerCalculation.calculationCardArray(cardArray)
    local winPattern=11
    local analyzeResult=PokerCalculation.analyzeCardArray(cardArray)
    local winCards={}
    
    --计算Jacks or better
    if analyzeResult.kind2==1 then
        local jackNum=analyzeResult.kind2nums[1]
        if table.indexof(VP.PATTERN_RULE.Jacks_or_better.card_nums, jackNum) ~= false then
            print("============Jacks or better")
            winPattern=VP.PATTERN_ID.Jacks_or_better
            --添加中奖牌
            for i=1,#cardArray do
                if jackNum==cardArray[i].cardNumber then
                    cardArray[i].holdSign=1
                    table.insert(winCards,cardArray[i])
                end
            end
        end
    end
    
    --计算Two Pairs
    if analyzeResult.kind2==2 then
        print("============Two Pairs")
        winPattern=VP.PATTERN_ID.Two_Pairs
        --添加中奖牌
        winCards={}
        --print("analyzeResult.kind2nums=",table.serialize(analyzeResult.kind2nums))
        for i=1,#cardArray do
            if table.indexof(analyzeResult.kind2nums, cardArray[i].cardNumber) ~= false then
                --print("cardArray[i].cardNumber=",cardArray[i].cardNumber)
                cardArray[i].holdSign=1
                table.insert(winCards,cardArray[i])
            end
        end
    end
    
    --计算Three of a kind
    if analyzeResult.kind3==1 then
        print("============Three of a kind")
        winPattern=VP.PATTERN_ID.Three_of_a_Kind
        --添加中奖牌
        winCards={}
        for i=1,#cardArray do
            if analyzeResult.kind3num==cardArray[i].cardNumber then
                cardArray[i].holdSign=1
                table.insert(winCards,cardArray[i])
            end
        end
    end
    
    --计算Straight
    if table.indexof(VP.PATTERN_RULE.Straight.card_nums, analyzeResult.straightKey) ~= false then
        print("============Straight")
        winPattern=VP.PATTERN_ID.Straight
        for i=1,#cardArray do
            cardArray[i].holdSign=1
        end
        winCards=cardArray
    end
    
    --计算Flush
    if analyzeResult.flush == 1 then
        print("============Flush")
        winPattern=VP.PATTERN_ID.Flush
        for i=1,#cardArray do
            cardArray[i].holdSign=1
        end
        winCards=cardArray
    end
    
    --计算Full house
    if analyzeResult.kind3==1 and analyzeResult.kind2==1 then
        print("============Full house")
        winPattern=VP.PATTERN_ID.Full_house
        for i=1,#cardArray do
            cardArray[i].holdSign=1
        end
        winCards=cardArray
    end
    
    --计算Four of a Kind
    if analyzeResult.kind4==1 then
        print("============Four of a Kind")
        winPattern=VP.PATTERN_ID.Four_of_a_Kind
        --添加中奖牌
        winCards={}
        for i=1,#cardArray do
            if analyzeResult.kind4num==cardArray[i].cardNumber then
                cardArray[i].holdSign=1
                table.insert(winCards,cardArray[i])
            end
        end
    end
    
    --计算Straight Flush
    if table.indexof(VP.PATTERN_RULE.Straight_Flush.card_nums, analyzeResult.straightKey) ~= false and analyzeResult.flush == 1 then
        print("============Straight Flush")
        winPattern=VP.PATTERN_ID.Straight_Flush
        for i=1,#cardArray do
            cardArray[i].holdSign=1
        end
        winCards=cardArray
    end
    
    --计算Royal Straight Flush
    if table.indexof(VP.PATTERN_RULE.Royal_Straight_Flush.card_nums, analyzeResult.straightKey) ~= false and analyzeResult.flush == 1 then
        print("============Royal Straight Flush")
        winPattern=VP.PATTERN_ID.Royal_Straight_Flush
        for i=1,#cardArray do
            cardArray[i].holdSign=1
        end
        winCards=cardArray
    end
    
    return winPattern,winCards,analyzeResult
end

--简单的分析下牌组
function PokerCalculation.analyzeCardArray(cardArray)
    local analyzeResult={}
    analyzeResult.flush=1 --是否同花
    analyzeResult.straightKey=PokerCalculation.buildStraightKey(cardArray)
    analyzeResult.cardCnt={} --存放cardNum-Cnt键值对
    analyzeResult.kind4=0 --四条的个数
    analyzeResult.kind4num="" --四条的牌数字
    analyzeResult.kind2=0 --两对的个数
    analyzeResult.kind2nums={} --两对的牌数字
    analyzeResult.kind3=0 --三条的个数
    analyzeResult.kind3num="" --三条的牌数字
    
    for i=1,#cardArray do
        local tmpCard=cardArray[i]
        local tmpNum=tostring(tmpCard.cardNumber)
        if cardArray[1].cardColor ~= tmpCard.cardColor then
            analyzeResult.flush=0
        end
        if analyzeResult.cardCnt[tmpNum] ~= nil then
            analyzeResult.cardCnt[tmpNum]=analyzeResult.cardCnt[tmpNum]+1
        else
            analyzeResult.cardCnt[tmpNum]=1
        end 
    end
    
    for key, val in pairs(analyzeResult.cardCnt) do
        if val==2 then
            analyzeResult.kind2=analyzeResult.kind2+1
            table.insert(analyzeResult.kind2nums,key)
        end
        
        if val==3 then
            analyzeResult.kind3=analyzeResult.kind3+1
            analyzeResult.kind3num=key
        end
        
        if val==4 then
            analyzeResult.kind4=analyzeResult.kind4+1
            analyzeResult.kind4num=key
        end
    end
    
    return analyzeResult
end

function PokerCalculation.buildStraightKey(cardArray)
    local cardNums={}
    for i=1,#cardArray do
        cardNums[i]=cardArray[i].cardNumber
    end
    local function comps(a,b)
        return tonumber(a) < tonumber(b)
    end
    table.sort(cardNums,comps)
    local str=""
    for i=1,#cardNums do
        if i==1 then
            str=str..cardNums[i]
        else
            str=str.."_"..cardNums[i]
        end
    end
    return str
end

--获得该gameId所存储的deal结果
function PokerCalculation.getDbTable(pokerGameSet)
    local dbt={}
    local pokerModel = app:getObject("PokerModel")
    local pk=pokerModel:getPokerResult()
    if table.isEmpty(pk)==true then
        return dbt
    end
    dbt=pk[tostring(pokerGameSet.gameId)]
    return dbt
end

--更新上一把结果
function PokerCalculation.updateDbTable(pokerResult)
    local pokerModel = app:getObject("PokerModel")
    local pk=pokerModel:getPokerResult()
    pk[tostring(pokerResult.pokerGameSet.gameId)]=pokerResult:toDbTable()
    pokerModel:updatePokerResult(pk)
end

function PokerCalculation.updateBestPoker(bestCardArray)
    local pokerModel = app:getObject("PokerModel")
    local pk={}
    for i=1,#bestCardArray do
        table.insert(pk,bestCardArray[i]:toDbTable())
    end
    pokerModel:updateBestPoker(pk)
end

--比较当前卡组是否优于最佳卡组
function PokerCalculation.compareBestPoker(playerCardArray,bestCardArray)
    local winPattern,winCards,analyzeResult= PokerCalculation.calculationCardArray(playerCardArray)
    local bwinPattern,bwinCards,banalyzeResult= PokerCalculation.calculationCardArray(bestCardArray)
    if winPattern < bwinPattern then
        return true
    elseif winPattern == bwinPattern then
        return PokerCalculation.comparePushPattern(winPattern,analyzeResult,banalyzeResult,playerCardArray,bestCardArray)
    end 
    
    return false
end

--比较牌型相同牌的大小
function PokerCalculation.comparePushPattern(Pattern,analyzeResult,banalyzeResult,playerCardArray,bestCardArray)
    analyzeResult.kind4num = tonumber(analyzeResult.kind4num)
    analyzeResult.kind3num = tonumber(analyzeResult.kind3num)
    if analyzeResult.kind4num == 1 then
        analyzeResult.kind4num = 14
    end
    if analyzeResult.kind3num == 1 then
        analyzeResult.kind3num = 14
    end
    local result= false
    if Pattern == VP.PATTERN_ID.Straight_Flush or
            Pattern == VP.PATTERN_ID.Straight  or
            Pattern == VP.PATTERN_ID.Jacks_or_better or
            Pattern == VP.PATTERN_ID.Flush         then
        local aSum,bSum =0,0
        for i=1,#playerCardArray do
            aSum = aSum + playerCardArray[i].cardNumber
            bSum = bSum + bestCardArray[i].cardNumber
        end
        return aSum < bSum
    elseif Pattern == VP.PATTERN_ID.Four_of_a_Kind then
        return tonumber(analyzeResult.kind4num) < tonumber(banalyzeResult.kind4num)
    elseif Pattern == VP.PATTERN_ID.Three_of_a_Kind or
            Pattern == VP.PATTERN_ID.Full_house then
        return tonumber(analyzeResult.kind3num) < tonumber(banalyzeResult.kind3num)
    elseif Pattern == VP.PATTERN_ID.Two_Pairs then
        local aSum,bSum = 0,0
        for i=1,#analyzeResult.kind2nums do
            aSum = aSum + analyzeResult.kind2nums[i]
            bSum = bSum + banalyzeResult.kind2nums[i]
        end
        return aSum < bSum
    end
    return result
end