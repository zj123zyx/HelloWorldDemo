module("app.data.bj.calculation.BjCalculation", package.seeall)
local BjCalculation = app.data.bj.calculation.BjCalculation

--生成一副牌库
function BjCalculation.genStoreCards(num)
    local storeIds={}
    
    for i=1 ,num do
        for key, val in pairs(BJ.DICT_BJ_CARD) do
            table.insert(storeIds,key)
        end 
    end
    
    table.RandShuffle(storeIds)

    return storeIds
end

--比较玩家和庄家牌
function BjCalculation.compareCardNum(tmpNum,bhNum)
    -- 21>=tmpNum>bhNum
    if BJ.STANDARD_NUM >= tmpNum and tmpNum > bhNum then
        return BJ.HAND_RESULT.WIN
    end
    
    -- bhNum>21>=tmpNum
    if BJ.STANDARD_NUM >= tmpNum and BJ.STANDARD_NUM < bhNum then
        return BJ.HAND_RESULT.WIN
    end
    
    -- 21>=tmpNum=bhNum
    if BJ.STANDARD_NUM >= tmpNum and tmpNum == bhNum then
        return BJ.HAND_RESULT.PUSH
    end
    
    return BJ.HAND_RESULT.NO_WIN
end
--获得该gameId所存储的deal结果
function BjCalculation.getDbTable(gameId)
    local dbt={}
    local pokerModel = app:getObject("BJModel")
    local pk=pokerModel:getPokerResult()
    if table.isEmpty(pk) == true then
        return dbt
    end
    dbt=pk[tostring(gameId)]
    return dbt
end

--更新上一把结果
function BjCalculation.updateDbTable(gameId,bjRound)
    local pokerModel = app:getObject("BJModel")
    local pk=pokerModel:getPokerResult()
    pk[tostring(gameId)]=bjRound:toDbTable()
    pokerModel:updatePokerResult(pk)
end


