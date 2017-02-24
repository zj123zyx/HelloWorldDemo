module("app.data.txspoker.calculation.TxsCalculation", package.seeall)
local TxsCalculation = app.data.txspoker.calculation.TxsCalculation

--生成一副牌库
function TxsCalculation.genStoreCards()
    local storeIds={}
    for key, val in pairs(TXS.DICT_TXS_CARD) do
        table.insert(storeIds,key)
    end
    table.RandShuffle(storeIds)
    return storeIds
end

--比较当前牌组和最佳牌组
function TxsCalculation.compareBestPoker(playerCardArray,bestCardArray)
    for j=1,table.nums(playerCardArray) do
        playerCardArray[j].winSign=0
    end
    for j=1,table.nums(bestCardArray) do
        bestCardArray[j].winSign=0
    end

    local winPattern,winCards,analyzeResult= TxsCalculation.calculationCardArray(playerCardArray)
    local singlePatternArray={}
    singlePatternArray.cardArray=playerCardArray
    singlePatternArray.winPattern=winPattern
    singlePatternArray.winCards=winCards
    singlePatternArray.analyzeResult=analyzeResult
    
    local winPattern2,winCards2,analyzeResult2= TxsCalculation.calculationCardArray(bestCardArray)
    local singlePatternArray2={}
    singlePatternArray2.cardArray=bestCardArray
    singlePatternArray2.winPattern=winPattern2
    singlePatternArray2.winCards=winCards2
    singlePatternArray2.analyzeResult=analyzeResult2

    if singlePatternArray.winPattern < singlePatternArray2.winPattern then
        return TXS.ROUND_RESULT.WIN
    elseif singlePatternArray.winPattern == singlePatternArray2.winPattern then
        return TxsCalculation.comparePushPattern(singlePatternArray,singlePatternArray2)
    end

    return TXS.ROUND_RESULT.NO_WIN
end

--比较玩家和庄家中奖模式相同时的胜负
function TxsCalculation.comparePushPattern(playerPatternArray,bankerPatternArray)
    --从左往右，一张一张比较
    local result=0
    for i=1,5 do
        local num1=tonumber(playerPatternArray.cardArray[i].cardNumber)
        local num2=tonumber(bankerPatternArray.cardArray[i].cardNumber)    
        if num1==1 then
            num1=14
        end
        if num2==1 then
            num2=14
        end
        if num1 > num2 then
            result = TXS.ROUND_RESULT.WIN
            break
        elseif num1 < num2 then
            result =  TXS.ROUND_RESULT.NO_WIN
            break
        end
        
        if i==5 and num1==num2 then
            result =  TXS.ROUND_RESULT.PUSH
        end
    end
    
    return result
end

function TxsCalculation.genPlayerCardArray(txsRound)
    local singlePatternArray=TxsCalculation.pickMaxCardArray(txsRound.playerCardArray,txsRound.commonCardArray)
    
    txsRound.playerWinCardArray=singlePatternArray.cardArray
    txsRound.playerWinPattern=tonumber(singlePatternArray.winPattern)
    
    return singlePatternArray
end

function TxsCalculation.genBankerCardArray(txsRound)
    local singlePatternArray=TxsCalculation.pickMaxCardArray(txsRound.bankerCardArray,txsRound.commonCardArray)

    txsRound.bankerWinCardArray=singlePatternArray.cardArray
    txsRound.bankerWinPattern=tonumber(singlePatternArray.winPattern)

    return singlePatternArray
end

function TxsCalculation.pickMaxCardArray(userCardArray,commonCardArray)
    local sevenCardArray={}
    --print("TxsCalculation.pickMaxCardArray sevenCardArray")
    local s=""
    for i=1,#userCardArray do
        table.insert(sevenCardArray,userCardArray[i])
        s=s.." "..userCardArray[i].cardNumber
    end

    for i=1,#commonCardArray do
        table.insert(sevenCardArray,commonCardArray[i])
        s=s.." "..commonCardArray[i].cardNumber
    end
    
    --print(s)

    local patternHashTable=TxsCalculation.calculationPatternArray(sevenCardArray)
    --取出最大的winpattern
    local keys=table.keys(patternHashTable)
    --从小到大排序
    local function comps(a,b)
        return tonumber(a) < tonumber(b)
    end
    table.sort(keys,comps)
    local maxWinPattern=keys[1]
    --print("TxsCalculation.pickMaxCardArray maxWinPattern",maxWinPattern)
    --获得该中奖模式下的所有卡组
    local winPatternArray=patternHashTable[maxWinPattern]
    
    --print("TxsCalculation.pickMaxCardArray winPatternArray len",#winPatternArray)
    
    --排序同一中奖模式下的多个卡组，取最大的，比如A,A,K,K,10  A,A,2,2,10 ,应该取第一个 
    --print("TxsCalculation.pickMaxCardArray winPatternArray 排序前")
    for i=1,#winPatternArray do
        --print("axiba"..i,table.nums(winPatternArray[i].cardArray))
        --print("TxsCalculation.pickMaxCardArray winPatternArray[i]",winPatternArray[i].cardArray[1].cardNumber,winPatternArray[i].cardArray[2].cardNumber,winPatternArray[i].cardArray[3].cardNumber,winPatternArray[i].cardArray[4].cardNumber,winPatternArray[i].cardArray[5].cardNumber)
    end
    --[[TxsCalculation.sortWinPatternArray(winPatternArray)
    print("TxsCalculation.pickMaxCardArray winPatternArray 排序后")
    for i=1,#winPatternArray do
        print("TxsCalculation.pickMaxCardArray winPatternArray[i]",winPatternArray[i].cardArray[1].cardNumber,winPatternArray[i].cardArray[2].cardNumber,winPatternArray[i].cardArray[3].cardNumber,winPatternArray[i].cardArray[4].cardNumber,winPatternArray[i].cardArray[5].cardNumber)
    end
    ]]
    local singlePatternArray=TxsCalculation.pickMaxWinPattern(winPatternArray)
   -- print("TxsCalculation.pickMaxCardArray result",singlePatternArray.cardArray[1].cardNumber,singlePatternArray.cardArray[2].cardNumber,singlePatternArray.cardArray[3].cardNumber,singlePatternArray.cardArray[4].cardNumber,singlePatternArray.cardArray[5].cardNumber)
    return singlePatternArray
end

-- patternHashTable {"winPattern"={singlePatternArray1={winPattern,winCards,analyzeResult},singlePatternArray2={winPattern,winCards,analyzeResult}}}
function TxsCalculation.calculationPatternArray(sevenCardArray)
    local patternHashTable={}
    --七选五，找出所有组合
    local fiveArrays=table.combine(sevenCardArray,5)
    --计算所有卡组的中奖模式
    for i=1,#fiveArrays do
        local tmpCardArray=fiveArrays[i]
        for j=1,table.nums(tmpCardArray) do
            tmpCardArray[j].winSign=0
        end
        local winPattern,winCards,analyzeResult= TxsCalculation.calculationCardArray(tmpCardArray)
        local singlePatternArray={}
        singlePatternArray.cardArray=tmpCardArray
        singlePatternArray.winPattern=winPattern
        singlePatternArray.winCards=winCards
        singlePatternArray.analyzeResult=analyzeResult
        
        --对牌组进行排序
        TxsCalculation.sortSinglePatternArray(singlePatternArray)
        
        local tmpPattern=patternHashTable[tostring(winPattern)]
        if tmpPattern == nil then
            tmpPattern={}
        end
        
        table.insert(tmpPattern,singlePatternArray)
        patternHashTable[tostring(winPattern)]=tmpPattern
    end
    return patternHashTable
end

--对牌组本身进行排序
function TxsCalculation.sortSinglePatternArray(singlePatternArray)
    local wp=singlePatternArray.winPattern
    --print("TxsCalculation.sortSinglePatternArray================")
    --print("winPattern",wp)
    local tmpCardArray=singlePatternArray.cardArray
   -- print("tmpCardArray len",table.nums(tmpCardArray))

    for i=1,#tmpCardArray do
     --   print("cardArray[i]",tmpCardArray[i].cardId,tmpCardArray[i].cardNumber,tmpCardArray[i].cardColor)
    end
    
    --高牌，同花，顺子，皇家同花顺，同花顺 都采用这种排序
    if wp == TXS.PATTERN_ID.High_Card  or wp == TXS.PATTERN_ID.Royal_Straight_Flush or wp == TXS.PATTERN_ID.Straight_Flush or wp == TXS.PATTERN_ID.Flush or wp == TXS.PATTERN_ID.Straight then
        local cardArray=singlePatternArray.cardArray
        
        local function comps(a,b)
            return TxsCalculation.compareLess(a.cardNumber,b.cardNumber)
        end
        
        quick_sort_DESC(cardArray,comps)

        if singlePatternArray.analyzeResult.straightKey == "1_2_3_4_5" then
            local aceCard=table.remove(cardArray,1)
            table.insert(cardArray,aceCard)
        end
        
        singlePatternArray.cardArray=cardArray
        return
    else --包含对子的牌，对子按大小排序,其余的牌按大小排序
        local newArray={}
        local cardArray=singlePatternArray.cardArray
        local winCards=singlePatternArray.winCards
        
        local function comps(a,b)
            return TxsCalculation.compareLess(a.cardNumber,b.cardNumber)
        end
        --从大到小排序
        quick_sort_DESC(winCards,comps)
        --将排序过的对子牌插入进去
        for i=1,table.nums(winCards) do
            table.insert(newArray,winCards[i])
        end
        --处理未获胜的牌
        if table.nums(newArray) < 5 then
           local noneWinArray={}
           for i=1, table.nums(cardArray) do
                if cardArray[i].winSign == 0 then
                    table.insert(noneWinArray,cardArray[i])
                end
           end
           --table.sort(noneWinArray,comps)
            quick_sort_DESC(noneWinArray,comps)
            --将未获胜的牌排序后插入进去
           for i=1,table.nums(noneWinArray) do
                table.insert(newArray,noneWinArray[i])
           end
        end
        singlePatternArray.cardArray=newArray
        return
    end
end

--找出对同一中奖模式下的多组牌中最大的一个
function TxsCalculation.pickMaxWinPattern(winPatternArray)

    local function comps(a,b)
        local flag=false
        --从左往右，一张一张比较
        for i=1,5 do
            local n1=tonumber(a.cardArray[i].cardNumber)
            local n2=tonumber(b.cardArray[i].cardNumber)  
            if n1==1 then
                n1=14
            end
            if n2==1 then
                n2=14
            end  
            if n1 < n2 then
                flag=true
                break
            end
        end
        return flag
    end

    local maxPattern=winPatternArray[1]

    for i=2,table.nums(winPatternArray) do
        local flag=comps(maxPattern,winPatternArray[i])
        if flag==true then
            maxPattern= winPatternArray[i]
        end
    end

    return maxPattern
end

--[[对同一中奖模式下的多组牌进行排序
function TxsCalculation.sortWinPatternArray(winPatternArray)
    --从大到小排序
    local function comps(a,b)
        local flag=false
        --从左往右，一张一张比较
        for i=1,5 do
            local n1=tonumber(a.cardArray[i].cardNumber)
            local n2=tonumber(b.cardArray[i].cardNumber)  
            if n1==1 then
                n1=14
            end
            if n2==1 then
                n2=14
            end  
            if n1 < n2 then
                flag=true
                break
            end
        end
        return flag
    end
    quick_sort_DESC(winPatternArray,comps)
end
]]

--结算牌组
function TxsCalculation.calculationCardArray(cardArray)
    local winPattern=0
    local analyzeResult=TxsCalculation.analyzeCardArray(cardArray)
    local winCards={}

    --计算High Card
    winPattern=TXS.PATTERN_ID.High_Card


    --计算One Pair
    if analyzeResult.kind2==1 then
       -- print("============One Pair")
        winPattern=TXS.PATTERN_ID.One_Pair
        local jackNum=analyzeResult.kind2nums[1]
        --添加中奖牌
        for i=1,#cardArray do
            if jackNum==cardArray[i].cardNumber then
                cardArray[i].winSign=1
                table.insert(winCards,cardArray[i])
            end
        end
    end

    --计算Two Pairs
    if analyzeResult.kind2==2 then
       -- print("============Two Pairs")
        winPattern=TXS.PATTERN_ID.Two_Pairs
        --添加中奖牌
        winCards={}
        for i=1,#cardArray do
            if table.indexof(analyzeResult.kind2nums, cardArray[i].cardNumber) ~= false then
                cardArray[i].winSign=1
                table.insert(winCards,cardArray[i])
            end
        end
    end

    --计算Three of a kind
    if analyzeResult.kind3==1 then
       -- print("============Three of a kind")
        winPattern=TXS.PATTERN_ID.Three_of_a_Kind
        --添加中奖牌
        winCards={}
        for i=1,#cardArray do
            if analyzeResult.kind3num==cardArray[i].cardNumber then
                cardArray[i].winSign=1
                table.insert(winCards,cardArray[i])
            end
        end
    end

    --计算Straight
    if table.indexof(VP.PATTERN_RULE.Straight.card_nums, analyzeResult.straightKey) ~= false then
      --  print("============Straight")
        winPattern=TXS.PATTERN_ID.Straight
        for i=1,#cardArray do
            cardArray[i].winSign=1
        end
        winCards=cardArray
    end

    --计算Flush
    if analyzeResult.flush == 1 then
      --  print("============Flush")
        winPattern=TXS.PATTERN_ID.Flush
        for i=1,#cardArray do
            cardArray[i].winSign=1
        end
        winCards=cardArray
    end

    --计算Full house
    if analyzeResult.kind3==1 and analyzeResult.kind2==1 then
       -- print("============Full house")
        winPattern=TXS.PATTERN_ID.Full_house
        for i=1,#cardArray do
            cardArray[i].winSign=1
        end
        winCards=cardArray
    end

    --计算Four of a Kind
    if analyzeResult.kind4==1 then
    --    print("============Four of a Kind")
        winPattern=TXS.PATTERN_ID.Four_of_a_Kind
        --添加中奖牌
        winCards={}
        for i=1,#cardArray do
            if analyzeResult.kind4num==cardArray[i].cardNumber then
                cardArray[i].winSign=1
                table.insert(winCards,cardArray[i])
            end
        end
    end

    --计算Straight Flush
    if table.indexof(TXS.PATTERN_RULE.Straight_Flush.card_nums, analyzeResult.straightKey) ~= false and analyzeResult.flush == 1 then
    --    print("============Straight Flush")
        winPattern=TXS.PATTERN_ID.Straight_Flush
        for i=1,#cardArray do
            cardArray[i].winSign=1
        end
        winCards=cardArray
    end

    --计算Royal Straight Flush
    if table.indexof(TXS.PATTERN_RULE.Royal_Straight_Flush.card_nums, analyzeResult.straightKey) ~= false and analyzeResult.flush == 1 then
      --  print("============Royal Straight Flush")
        winPattern=TXS.PATTERN_ID.Royal_Straight_Flush
        for i=1,#cardArray do
            cardArray[i].winSign=1
        end
        winCards=cardArray
    end
    
    if winPattern==TXS.PATTERN_ID.High_Card then
      --  print("============High_Card")
    end

    return winPattern,winCards,analyzeResult
end

--简单的分析下牌组
function TxsCalculation.analyzeCardArray(cardArray)
    local analyzeResult={}
    analyzeResult.flush=1 --是否同花
    analyzeResult.straightKey=TxsCalculation.buildStraightKey(cardArray)
    analyzeResult.cardCnt={} --存放cardNum-Cnt键值对
    analyzeResult.kind4=0 --四条的个数
    analyzeResult.kind4num="" --四条的牌数字
    analyzeResult.kind2=0 --两对的个数
    analyzeResult.kind2nums={} --两对的牌数字
    analyzeResult.kind3=0 --三条的个数
    analyzeResult.kind3num="" --三条的牌数字
    analyzeResult.highCardNum="" --最大的牌数字
    local tmpHighCnt=0
    for i=1,#cardArray do
        local tmpCard=cardArray[i]

        --判断是否小于临时牌
        local flag=TxsCalculation.compareLess(tonumber(tmpCard.cardNumber),tmpHighCnt)
        if flag == false then
            tmpHighCnt=tonumber(tmpCard.cardNumber)
        end

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

    analyzeResult.highCardNum=tostring(tmpHighCnt)

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

function TxsCalculation.buildStraightKey(cardArray)
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

--比较牌面数字num1小于等于num2
function TxsCalculation.compareLess(num1,num2)
    local n1 = tonumber(num1)
    local n2 = tonumber(num2)
    if n1==1 then
        n1=14
    end
    if n2==1 then
        n2=14
    end

    return n1 <= n2
end

--获得该gameId所存储的deal结果
function TxsCalculation.getDbTable(gameId)
    local dbt={}
    local pokerModel = app:getObject("TexasModel")
    local pk=pokerModel:getPokerResult()
    if table.isEmpty(pk) == true then
        return dbt
    end
    dbt=pk[tostring(gameId)]
    return dbt
end

--更新上一把结果
function TxsCalculation.updateDbTable(txsRound)
    local pokerModel = app:getObject("TexasModel")
    local pk=pokerModel:getPokerResult()
    pk[tostring(txsRound.txsGameSet.gameId)]=txsRound:toDbTable()
    pokerModel:updatePokerResult(pk)
end

function TxsCalculation.updateBestPoker(bestCardArray)
    local pokerModel = app:getObject("TexasModel")
    local pk={}
    for i=1,#bestCardArray do
        table.insert(pk,bestCardArray[i]:toDbTable())
    end
    pokerModel:updateBestPoker(pk)
end
