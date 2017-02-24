
local SceneManager = class("SceneManager")

local pathConfigLen = 54
local pathFishConfigLen = 61
local cycleUpTime = 12

SceneManager.cycleId=1
SceneManager.scnTotalTime=0
--------------------------------------
--  
--------------------------------------
function SceneManager.buildPath( pathConfigId )
    
    local pathConfigData = DICT_PATH_CONFIG[tostring(pathConfigId)]

    local pathList = {}

    for i=1,pathConfigLen do

        local pathId = pathConfigData["path"..tostring(i)]

        if pathId ~= nil and string.len(pathId) > 0 then
            local pathData = DICT_PATHFISH_CONFIG[pathId]
            pathList[#pathList+1]={id = pathId, weight=pathData.weight}
        end

    end

    local idx = SceneManager.rolette( pathList )

    return pathList[idx].id
end

function SceneManager.buildClusterByPathId( pathId )


    local pathFishConfigData = DICT_PATHFISH_CONFIG[tostring(pathId)]

    local fishClusterList = {}

    for i=1,pathFishConfigLen do

        local fishClusterId = pathFishConfigData["fish_id"..tostring(i)]

        if fishClusterId ~= nil and string.len(fishClusterId) > 0 then
            local fishClusterData = DICT_FISHCLUSTER_WEIGHT[fishClusterId]
            fishClusterList[#fishClusterList+1]={id = fishClusterId, weight=fishClusterData.weight}
        end

    end

    local idx = SceneManager.rolette( fishClusterList )

    return fishClusterList[idx].id

end

function SceneManager.createFishCluster( pathId, clusterId, fishNode )

    local clusterData = DICT_FISH_CLUSTER[tostring(clusterId)]

    local runedTime = math.newrandom() * 10
    if PathPool.hasPath(pathId) == true then

        for i = 1, #clusterData.fishcluster do

            local fishData = clusterData.fishcluster[i]

            local fish = FishManager.create(4)--fishData.id

            fish.offset.x = fishData.offsetX * display.width/768
            fish.offset.y = fishData.offsetY * display.height/560

            local path = PathPool.getPath( pathId, 0)

            fish:setRoute(path, runedTime)
            
            fishNode:addChild(fish)

        end

        return true
    end
    
    return false
end

function SceneManager.createFishClusterByTrap(weaponTrap, fishNode)
    local runedTime = math.newrandom() * 10
    local fish = FishManager.create(4)--fishData.id
    -- fish.offset.x = fishData.offsetX * display.width/768
    -- fish.offset.y = fishData.offsetY * display.height/560
    local centerPoint = weaponTrap.endPoint
    local path = PathPool.getLinePathByCenter(centerPoint)
    fish:setRoute(path, runedTime)
    fishNode:addChild(fish)
end

function SceneManager.rolette( weightList )

    local wLen = #weightList
    local weightPerList = {}

    weightPerList[1] = tonumber(weightList[1].weight)

    for i=2, wLen do

        local weightData = weightList[i] 
        weightPerList[i] = weightPerList[i-1] + tonumber(weightData.weight)
        
    end

    local perLen = #weightPerList
    local maxper = weightPerList[perLen]

    local per = ToolUtils.randRange(1, maxper)

    local idx = 1

    if per >= 1 and per < weightPerList[1] then
        idx = 1
    else
        for i=2,perLen do
            if per >= weightPerList[i-1] and per < weightPerList[i] then
                idx = i
                break
            end
        end
    end

    return idx
end

function SceneManager.getCycleRate()-- random (up, down) by min

    local totalTime = math.ceil(SceneManager.scnTotalTime/60)

    local min = math.fmod(totalTime, cycleUpTime) + 1

    local cyc_dict = DICT_CYCLE[tostring(SceneManager.cycleId)]
    local up_limit = cyc_dict["min_"..min.."_up"]
    local down_limit = cyc_dict["min_"..min.."_low"]

    local randomVal = ToolUtils.randRange(tonumber(down_limit), tonumber(up_limit))

    return ToolUtils.getTenThousandPer(randomVal)
end

function SceneManager.shake(shakeNum)

    if shakeNum >= 1 then
        return true
    end

    if shakeNum <= 0 then
        return false
    end

    local a = ToolUtils.randRange()

    -- print("shake :",a, shakeNum, a < shakeNum)

    return a < shakeNum

end

function SceneManager.checkDieCnt(shootFishs, fish)
    -- body
    local dieCnt = 0
    for i=1, #shootFishs do
        local weightData = shootFishs[i] 
        if shootFishs[i].sourceID == fish.sourceID then
            dieCnt = dieCnt + 1
        end
    end

    print("checkDieCnt:",fish.sourceID,fish.die_cnt, dieCnt)

    if dieCnt >= tonumber(fish.die_cnt) then
        return false
    end 

    return true
end

function SceneManager.checkCollision(movingPos, weapon)
    
    weapon.fishCnt = 0
    local collision = false

    local rect = cc.rect(
        movingPos.x-weapon.range/2,
        movingPos.y-weapon.range/2,
        weapon.range, weapon.range)

    local shootFishs = {}

    for k,v in pairs(FishManager.moveingFishPool) do

        for i=1,#v do
            local fish = v[i]

            if fish.actionType == MOVE_TYPE.MOVE then

                local fishRect = fish:getBBox()
                if cc.rectIntersectsRect(fishRect, rect) and weapon.fishCnt < weapon.upper_limit then

                    local fishRate = fish:getHitRate(weapon.sourceID)
                    local cycleRate = SceneManager.getCycleRate()

                    -- print("shake :",fishRate,cycleRate)

                    if SceneManager.shake(fishRate * cycleRate) == true then

                        if SceneManager.checkDieCnt(shootFishs, fish) then

                            shootFishs[#shootFishs + 1] = fish
                            weapon.fishCnt = weapon.fishCnt + 1
                            collision = true
                        end

                    end

                end

            end
            
        end

    end

    return collision, shootFishs

end

return SceneManager