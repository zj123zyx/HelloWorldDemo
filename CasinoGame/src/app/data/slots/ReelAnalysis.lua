local GameSet = require("app.data.slots.beans.GameSet")
local BonusGameSet=import("app.data.slots.beans.BonusGameSet")

local ReelAnalysis = {}

local RUND_TYPE = {
    DROP      = 'DROP',
    PUSH      = 'PUSH',
    NORMAL    = 'NORMAL',
}

local ITEM_TYPE = {
    NORMAL_MULITIPLE=1000,
    BONUS_MULITIPLE=1001,
    FREESPIN_MULITIPLE=3001,
}

local betVal = 100000

local dataCache = {}

dataCache.bet = betVal
dataCache.cols = 5
dataCache.rows = 3
dataCache.machineId = 0
dataCache.machineType = false
dataCache.winCnt = 0
dataCache.costbet = 0
dataCache.winbet = 0
dataCache.freespinCnt = 0
dataCache.freespinttCnt = 0
dataCache.freespinwinBets = 0
dataCache.bigwinCnt = 0
dataCache.bigwinBets = 0
dataCache.megawinCnt = 0
dataCache.megawinBets = 0
dataCache.bonuswinCnt = 0
dataCache.bonuswinBets = 0

dataCache.reItems = 0
dataCache.holdWilds = {}
dataCache.replaceWilds = {}
dataCache.isFreeSpin = false
dataCache.RoundResult = {}
dataCache.reelStopIdxs = {}


local function resetDataCache()

    dataCache.reItems = 0
    dataCache.replaceWilds = {}
    dataCache.isFreeSpin = false
    dataCache.RoundResult = {}

end

function isSymbolPosEqual(matSyA, matSyB)
    local rt = false
    if matSyA:getX() == matSyB:getX() and 
        matSyA:getY() == matSyB:getY() then
        rt = true
    end
    return rt
end

local function BuildWildHoldSymbol( holdWildArray )
    -- body
    for j=1, #holdWildArray do

        matHoldSyA = holdWildArray[j]

        local hasA = false

        for i=1, #dataCache.holdWilds do
            matHoldSyB = dataCache.holdWilds[i]

            if isSymbolPosEqual(matHoldSyA, matHoldSyB) == true then
                hasA = true
            end
        end

        if hasA == false then
            table.insert(dataCache.holdWilds, matHoldSyA)
        end

    end

end

local function BuildReplaceWildSymbol( replaceWildArray )
    -- body
    for j=1, #replaceWildArray do

        matRepSyA = replaceWildArray[j]

        local hasA = false

        for i=1, #dataCache.replaceWilds do
            matRepSyB = dataCache.replaceWilds[i]

            if isSymbolPosEqual(matRepSyA, matRepSyB) == true then
                hasA = true
            end
        end

        if hasA == false then
            table.insert(dataCache.replaceWilds, matRepSyA)
        end

    end

end

local function buildRoundResult()

    local bet = dataCache.bet
    local machineId = dataCache.machineId

    local holdWilds = dataCache.holdWilds
    local replaceWilds= dataCache.replaceWilds

    if dataCache.isFreeSpin then
        machineId = DICT_MACHINE[tostring(machineId)].f_machine_id
    end

    local gameSet = GameSet.new(tonumber(machineId), bet)
    
    --table.dump(gameSet,"gameSet")

    if holdWilds and #holdWilds >0 then 
        gameSet:setHoldWilds(holdWilds)
    elseif replaceWilds and #replaceWilds > 0 then
        gameSet:setHoldWilds(replaceWilds)
    end

    local rdResult = data.slots.MachineApi.getSlotsRResult(dataCache.machineType, gameSet)

    if dataCache.machineType ~= RUND_TYPE.DROP and dataCache.isFreeSpin == false then

        local holdWildArray = rdResult:getHoldWilds()
        BuildWildHoldSymbol(holdWildArray)

        local replaceWildArray = rdResult:getReplaceWilds()
        BuildReplaceWildSymbol(replaceWildArray)

        --print("wild num:",#holdWildArray, #replaceWildArray)

    end

    --table.dump(rdResult,"RoundResult")

    --local serialWildArray = rdResult:getSerialWilds()

    -- stop reel idx analysis

    if dataCache.isFreeSpin == false then

        local onceRd = rdResult

        if dataCache.machineType == RUND_TYPE.DROP then 
            onceRd = rdResult[1] 
        end

        local reelStopIdxs = onceRd:getReelStopIdxs()


        for col=1, dataCache.cols do

            local syIndex = reelStopIdxs[col]
            if dataCache.reelStopIdxs[col] == nil then 
                dataCache.reelStopIdxs[col] = {}      

                local reels = DICT_MACHINE[tostring(dataCache.machineId)].reels
                local reelsymbols = DICT_REELS[tostring(reels[col])].symbol_ids

                dataCache.reelStopIdxs["reelCnt"..tostring(col)] = #reelsymbols

                for i=1, #reelsymbols  do
                    dataCache.reelStopIdxs[col][i] = 0
                end

            end

            dataCache.reelStopIdxs[col][syIndex] = dataCache.reelStopIdxs[col][syIndex] + 1

        end

    end


    dataCache.RoundResult=clone(rdResult)

end

local function enterBonus(rdResult) 

    local bet = dataCache.bet
    local bonusidx = DICT_MACHINE[tostring(dataCache.machineId)].bonus_id
    local bonus_type = DICT_BONUS_CONFIG[tostring(dataCache.machineId)].bonus_type


    local reItems = rdResult:getRewardItems()

    -- local initData = {bet=bet, rewardItems=dataCache.reItems, callback=callback}

    local bonusResult
    local bonusGameSet

    local wincoins=0

    if bonus_type == "1" then
        
        local basebet = reItems[ITEM_TYPE.BONUS_MULITIPLE]

        bonusResult = data.slots.MachineApi.getBonusBoxLife3Display(bonusidx)

        bonusGameSet = BonusGameSet.new(bonusidx, dataCache.bet)

        local deadlifecount = 0
        local selectBox = {}
        local totalMoney = 0

        for idx=1, 20 do bonusResult[math.newrandom(20)].hasSelected = false end

        for idx=1, 20 do

            local selectNode = bonusResult[math.newrandom(20)]

            while selectNode.hasSelected == true do
                selectNode = bonusResult[math.newrandom(20)]
            end

            selectNode.hasSelected = true

            if tonumber(selectNode.flag) == 1 then
                deadlifecount = deadlifecount + 1
            else
                totalMoney = totalMoney + selectNode.value * basebet
                table.insert(selectBox, { type=selectNode.type, id=selectNode.id, value=selectNode.value, flag=selectNode.flag} )
            end

            if deadlifecount >= 3 then
                break
            end

        end

        bonusGameSet:setUsedItems(reItems)
        local wincoin = data.slots.MachineApi.calculatBoxes(bonusGameSet, selectBox)

        wincoins = wincoin[ITEM_TYPE.NORMAL_MULITIPLE]

        --print("bonus: ", totalMoney, wincoins)


    elseif bonus_type == "2" then

        local basebet = reItems[ITEM_TYPE.BONUS_MULITIPLE]

        bonusResult = data.slots.MachineApi.getBonusBox5LevelsDisplay(bonusidx)

        bonusGameSet = BonusGameSet.new(bonusidx, dataCache.bet)

        local deadlifeCnt = 0
        local selectBox = {}
        local totalMoney = 0

        local idx = 0

        for i=1,5 do

            idx = idx + 1
            local stepResult = bonusResult[i]
            local selectOne = stepResult[math.newrandom(6)]

            if tonumber(selectOne.flag) == 1 then
                deadlifeCnt = deadlifeCnt + 1
            else
                table.insert(selectBox, {type=selectOne.type,id=selectOne.id,value=selectOne.value,flag=selectOne.flag})
            end

            if deadlifeCnt >= 1 then
                break
            end

            totalMoney = totalMoney + selectOne.value*basebet

        end

        bonusGameSet:setUsedItems(reItems)
        local wincoin = data.slots.MachineApi.calculatBoxes(bonusGameSet, selectBox)

        wincoins = wincoin[ITEM_TYPE.NORMAL_MULITIPLE]

        --print("bonus: ", totalMoney, wincoins)

    elseif bonus_type == "3" then

        local basebet = reItems[ITEM_TYPE.BONUS_MULITIPLE]

        bonusResult = data.slots.MachineApi.getBonusMatch3Display(bonusidx)

        bonusGameSet = BonusGameSet.new(bonusidx, dataCache.bet)

        local totalMoney = 0
        local selectBox = {}

        local check = {}
        for idx=1, 18 do 
            check[bonusResult[idx].value] = {}
            check[bonusResult[idx].value].count = 0
            bonusResult[idx].hasSelected = false
        end

        for idx=1, 18 do


            local selectNode = bonusResult[math.newrandom(18)]

            while selectNode.hasSelected == true do
                selectNode = bonusResult[math.newrandom(18)]
            end

            selectNode.hasSelected = true

            local cnt = check[selectNode.value].count
            check[selectNode.value].count = cnt + 1

            if check[selectNode.value].count >= 3 then
                totalMoney = totalMoney + selectNode.value*basebet
                table.insert(selectBox, {type=selectNode.type,id=selectNode.id,value=selectNode.value,flag=selectNode.flag})
                break
            end

        end

        bonusGameSet:setUsedItems(reItems)
        local wincoin = data.slots.MachineApi.calculatBoxes(bonusGameSet, selectBox)

        wincoins = wincoin[ITEM_TYPE.NORMAL_MULITIPLE]

        --print("bonus: ", totalMoney, wincoins)

    elseif bonus_type == "4" then

        local basebet = reItems[ITEM_TYPE.BONUS_MULITIPLE]

        bonusResult = data.slots.MachineApi.getBonusJourneyDisplay(bonusidx)
       
        bonusGameSet = BonusGameSet.new(bonusidx, dataCache.bet)


        local ptsnum = 12
        local ptsIdx = 0
        local totalMoney = 0
        local selectBox = {}

        local stepValue = {1,2,3,1,2,3}
        local stopValue = {1,1,1,1,1,1}

        local stepOne = nil

        for idx = 1, ptsnum do
            
            local stopIdx = math.newrandom(6)

            if stopValue[stopIdx] == 1 then
                stopValue[stopIdx] = 0
                local stepNum = stepValue[stopIdx]
                ptsIdx = ptsIdx + stepNum

                stepOne = bonusResult[ptsIdx]
                totalMoney = totalMoney + stepOne.value*basebet

            else
                break
            end
            
        end
        
        table.insert(selectBox, {type=stepOne.type,id=stepOne.id,value=stepOne.value,flag=stepOne.flag})

        bonusGameSet:setUsedItems(reItems)
        local wincoin = data.slots.MachineApi.calculatBoxes(bonusGameSet, selectBox)

        wincoins = wincoin[ITEM_TYPE.NORMAL_MULITIPLE]

        --print("bonus: ", totalMoney, wincoins)

    end

    --print("----------Bonus Result----------")

    --table.dump(bonusGameSet,"bonusGameSet")

    --table.dump(bonusResult,"bonusResult")
    if wincoins == nil then wincoins = 0 end

    return wincoins

end

local function enterFreeSpin() 
end

local function setFreespinAndBonus( rdResult ) 

    local redItems = rdResult:getRewardItems()

    local bsCount = redItems[ITEM_TYPE.BONUS_MULITIPLE]
    local frCount = redItems[ITEM_TYPE.FREESPIN_MULITIPLE]

    if bsCount ~= nil and rdResult.bonusBeSettled ~= true then

        rdResult.bonusBeSettled = true

    elseif frCount ~= nil and rdResult.freeBeSettled ~= true then

        dataCache.freespinCnt = dataCache.freespinCnt + frCount
        dataCache.freespinttCnt = dataCache.freespinttCnt + 1

        if dataCache.isFreeSpin == false then
            rdResult.freeBeSettled = true
        end
    end

end


local function printDictData(data, symbols_name)
    -- body
    for i=1,#symbols_name do


        local k = symbols_name[i]

        local v = data[tostring(k)]

        if v then

            local str ="['"..k.."']".."={"

            for i=1,5 do
                str=str.."reel"..tostring(i).."="..tostring(v["reel"..tostring(i)])..", "
            end

            str = str.."},"

            print(str)
            
        end

    end
    
end


local function getReelsSymbolDistribution(idx)


    local symbols={}
    
    reels = {}


    local reels = DICT_MACHINE[idx].reels
    local symbols_name = DICT_MACHINE[idx].used_symbols

    for i=1,#symbols_name do
        print("symbol1", i, symbols_name[i])
    end

    for i=1,5 do

        local reelsymbols = DICT_REELS[tostring(reels[i])].symbol_ids

        reels["reel"..tostring(i)] = reelsymbols

        for j=1, #reelsymbols do

            local symbol = reelsymbols[j]
            
            if symbols[tostring(symbol)] == nil then
                symbols[tostring(symbol)] = {reel5=0,   reel4=0,    reel3=0,    reel2=0,    reel1=0}
            end

            symbols[tostring(symbol)]["reel"..tostring(i)] = symbols[tostring(symbol)]["reel"..tostring(i)] + 1
        end

    end

    print("---------------------Symbol Distribution----------------------")
    printDictData(symbols, symbols_name)

    return symbols, reels
end

local function initData(midx)
    -- body
    
    dataCache.machineId = midx

    dataCache.bet = betVal
    dataCache.tbet = dataCache.bet * #DICT_MACHINE[tostring(dataCache.machineId)].used_lines
    dataCache.cols = tonumber(DICT_MACHINE[tostring(dataCache.machineId)].reel_size)
    dataCache.rows = tonumber(DICT_MACHINE[tostring(dataCache.machineId)].max_row) 
    dataCache.machineType = DICT_MACHINE[tostring(dataCache.machineId)].machine_type

    dataCache.winCnt = 0
    dataCache.costbet = 0
    dataCache.winbet = 0
    dataCache.freespinCnt = 0
    dataCache.freespinttCnt = 0
    dataCache.freespinwinBets = 0
    dataCache.bigwinCnt = 0
    dataCache.bigwinBets = 0
    dataCache.megawinCnt = 0
    dataCache.megawinBets = 0
    dataCache.bonuswinCnt = 0
    dataCache.bonuswinBets = 0
    dataCache.reelStopIdxs = {}

    --table.dump(dataCache,"dataCache")
    getReelsSymbolDistribution(midx)

end

function ReelAnalysis.onceGame()

    buildRoundResult()

    local onceRoundResult = function(rdResult)
        -- body

        --rdResult:print()

        setFreespinAndBonus( rdResult ) 

        if rdResult.bonusBeSettled then

            local wincoins = enterBonus(rdResult)
            dataCache.winbet = dataCache.winbet + wincoins
            dataCache.bonuswinBets = dataCache.bonuswinBets + wincoins
            dataCache.bonuswinCnt = dataCache.bonuswinCnt + 1

        end

        if rdResult.freeBeSettled then

            dataCache.isFreeSpin = true
            
            for i=1, dataCache.freespinCnt do
                ReelAnalysis.onceGame()
            end

            dataCache.isFreeSpin = false
            dataCache.freespinCnt = 0
        end

        local winCoin = rdResult:getRewardCoins()

        dataCache.winbet = dataCache.winbet + winCoin

        if winCoin >= 10 * dataCache.tbet then
            dataCache.megawinBets = dataCache.megawinBets + winCoin
            dataCache.megawinCnt = dataCache.megawinCnt + 1
        end

        if winCoin >= 5 * dataCache.tbet and winCoin < 10 * dataCache.tbet then
            dataCache.bigwinBets = dataCache.bigwinBets + winCoin
            dataCache.bigwinCnt = dataCache.bigwinCnt + 1
        end

        if dataCache.isFreeSpin == true then
            dataCache.freespinwinBets = dataCache.freespinwinBets + winCoin
        end

        --print("winCoin:", dataCache.winbet, winCoin)

        return rdResult:getIsWin()

    end
    
    local iswin=0

    if dataCache.machineType == RUND_TYPE.DROP then

        for k,rdResult in pairs(dataCache.RoundResult) do
            local bwin = onceRoundResult(rdResult)
            if bwin == 1 then  iswin = 1 end
        end

    else

        local rdResult = dataCache.RoundResult
        local iswin = onceRoundResult(rdResult)

    end

    if tonumber(dataCache.machineId) == 7 then
    
        if #dataCache.holdWilds >= 1 then

            local matSy
            for i = #dataCache.holdWilds, 1, -1 do
                matSy = dataCache.holdWilds[i]
                matSy.x = (matSy:getX() - 1)

                if matSy:getX() <= -1 then
                    table.remove(dataCache.holdWilds, i)
                end
                --print("holdWilds posX:", matSy:getX())

            end

            --print("holdWilds num:",#dataCache.holdWilds)

           -- table.dump(dataCache.holdWilds,"holdWildArray")

            ReelAnalysis.onceGame()
        end
    elseif tonumber(dataCache.machineId) == 10 then

        if #dataCache.holdWilds >= 1 then

            local matSy

            for i = #dataCache.holdWilds, 1, -1 do
                matSy = dataCache.holdWilds[i]

                holdCount = matSy:getStayRounds()
                matSy:setStayRounds(holdCount-1)
                --print("holdCount",holdCount)

                if holdCount < 0 then
                    table.remove(dataCache.holdWilds, i)
                end

            end

            --print("holdWilds num:",#dataCache.holdWilds)

           -- table.dump(dataCache.holdWilds,"holdWildArray")

        end

    end

end

function ReelAnalysis.analysis(midx,spincount)

    initData(midx)
    
    for i=1,spincount do

        dataCache.costbet = dataCache.costbet + dataCache.tbet

        local preWinBet = dataCache.winbet

        resetDataCache()

        ReelAnalysis.onceGame()

        if dataCache.winbet > preWinBet then
            dataCache.winCnt = dataCache.winCnt + 1
        end

    end

    print("---------------------------------------- Analysis results --------------------------------------")

    print("DATA:   ", dataCache.winbet, dataCache.costbet)


    print("RUN COUNT:   ", spincount)

    print("RTP  :",         dataCache.winbet / dataCache.costbet)
    print("Hit Frequency:",             dataCache.winCnt / spincount)
    print("FREESPIN Hit Frequency:",   dataCache.freespinttCnt, dataCache.freespinttCnt/spincount)
    print("FREESPIN RTP Frequency:",   dataCache.freespinwinBets, dataCache.freespinwinBets/dataCache.costbet)
    print("Bonus Hit Frequency:",   dataCache.bonuswinCnt, dataCache.bonuswinCnt/spincount)
    print("Bonus RTP Frequency:",   dataCache.bonuswinBets, dataCache.bonuswinBets/dataCache.costbet)
    print("BigWin Hit Frequency:",   dataCache.bigwinCnt, dataCache.bigwinCnt/spincount)
    print("BigWin RTP Frequency:",   dataCache.bigwinBets, dataCache.bigwinBets/dataCache.costbet)
    print("MegaWin Hit Frequency:",   dataCache.megawinCnt, dataCache.megawinCnt/spincount)
    print("MegaWin RTP Frequency:",   dataCache.megawinBets, dataCache.megawinBets/dataCache.costbet)
    

    if false then return end
    
    print("Reel Stop Idxs")

    for col=1,dataCache.cols do

        local reelIdx = dataCache.reelStopIdxs[col]

        for i=1,dataCache.reelStopIdxs["reelCnt"..tostring(col)] do

            local idxstr = ""
            if i<10 then 
                idxstr = "00"..tostring(i)
            elseif i>9 and i<100 then
                idxstr = "0"..tostring(i)
            else
                idxstr = tostring(i)
            end

            for i=1,reelIdx[i] do
                if i%10 == 0 then
                    idxstr=idxstr.."|"
                end
            end

            print("Idx: ",idxstr)

        end
        
    end
    print("---------------------------------------- symbols distribution --------------------------------------")

end


return ReelAnalysis