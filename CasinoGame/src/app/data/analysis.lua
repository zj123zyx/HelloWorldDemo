local analysis = {}

analysis.test = false

local GameSet = require("app.data.slots.beans.GameSet")  

local bet = 1

analysis.totalcost = 0
analysis.totalreward = 0

analysis.holdWilds = {}
analysis.replaceWilds = {}


analysis.RD_TYPE = {}

analysis.RD_TYPE.DROP      = 'DROP'
analysis.RD_TYPE.PUSH      = 'PUSH'
analysis.RD_TYPE.NORMAL    = 'NORMAL'

function producerandomseed()
    math.randomseed(os.time())
    math.random()
    math.random()
    math.random()
    math.random()
end

function analysis.settleFreeSpinOrBonus(rdResult, apiType) 

    -- if true then return true end

    local redItems = rdResult:getRewardItems()
    
    local bsCount = redItems[ITEM_TYPE.BONUS_MULITIPLE]
    local frCount = redItems[ITEM_TYPE.FREESPIN_MULITIPLE]

    if bsCount ~= nil then

        print("enter bonus")   

    elseif frCount ~= nil and rdResult.freeBeSettled ~= true then
        print("enter freeSpin")   

        for i=1,frCount do
            analysis.printWinResult(rdResult:getRunMachineId(), true, apiType)
        end
    end

end

function analysis.afterBuild(rdResult)
    
    analysis.holdWilds = rdResult:getHoldWilds()
    analysis.replaceWilds = rdResult:getReplaceWilds()
end

function analysis.printWinResult(machineId, isFreeSpin, apiType, nocost)
	
    if isFreeSpin then
        machineId = DICT_MACHINE[tostring(machineId)].f_machine_id
    end

    local gameSet = GameSet.new(tonumber(machineId), bet)

    if analysis.holdWilds and #analysis.holdWilds >0 then 
        gameSet:setHoldWilds(analysis.holdWilds)
    elseif analysis.replaceWilds and #analysis.replaceWilds > 0 then
        gameSet:setHoldWilds(analysis.replaceWilds)
    end

    local rdResult

    if apiType == analysis.RD_TYPE.DROP then
        rdResult = data.slots.MachineApi.getNormalDropResult(gameSet)  
    else
        rdResult = data.slots.MachineApi.getNormalRoundResult(gameSet) 
    end

    analysis.settleFreeSpinOrBonus( rdResult ) 
    analysis.afterBuild( rdResult )

    if isFreeSpin == false or nocost and nocost == true then
        analysis.totalcost = analysis.totalcost + rdResult:getCostCoins()
    end
    
    analysis.totalreward = analysis.totalreward + rdResult:getRewardCoins()


    if analysis.holdWilds and #analysis.holdWilds >0 then 
        analysis.printWinResult(machineId, false, apiType, true)
    end

    --rdResult:print()

end

function analysis.reset()
    -- body
    analysis.totalcost = 0
    analysis.totalreward = 0

end

function analysis.oneSpinReset()
    -- body
    analysis.holdWilds = {}
    analysis.replaceWilds = {}

end

function analysis.printAnalysis(count)
    -- body
    print("run count:", count)
    print("totalcost :", analysis.totalcost)
    print("totalreward :", analysis.totalreward)

    print("RTS:", analysis.totalreward/analysis.totalcost)

end

function analysis.runTest(count, machineId, apiType)
    print("----------------------------------analysis.runTest----------------------------------")
    print("count, machineId, apiType :", count, machineId, apiType)
    
    analysis.reset()

    for i=1,count do
        analysis.oneSpinReset()
        analysis.printWinResult(machineId, false, apiType)
    end

    analysis.printAnalysis(count)
    
    print("----------------------------------analysis.runTest----------------------------------")
end

--analysis.printWinResult("1", false, RD_TYPE.NORMAL)


return analysis

