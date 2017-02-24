
local PathPool = {}

PathPool.pathList = {}
PathPool.pathIDList = {}

PathPool.designWidth = 1136
PathPool.designHeight = 768

--------------------------------------
-- addPath 
--------------------------------------

function PathPool.loadPath()

    for pathId,v in pairs(DICT_FISH_PATH) do
        PathPool.addPath( pathId )
    end
    
end
--------------------------------------
-- addPath 
--------------------------------------

function PathPool.getPathData( pathId )
    
    local pathData={}
    
    local path = DICT_FISH_PATH[tostring(pathId)]

    if path == nil then return nil end

    pathData.pathId = tonumber(path.id)
    pathData.pathType = tonumber(path.type)

    pathData.point = {}
    local cnt = (#path.poits)/2

    for i=1, cnt do
        pathData.point[#pathData.point + 1] = {
            x=path.poits[2*i-1] * display.width / PathPool.designWidth,
            y=display.height-path.poits[2*i]* display.height / PathPool.designHeight,
        }
    end

    pathData.point.length = #pathData.point

    return pathData
end

function PathPool.addPath( pathId )

    if PathPool.pathList[tostring(pathId)] ~= nil then return end

    local path = PathPool.getPathData(pathId)

    if path == nil then 
        print("path is nil:",pathId)
        return false 
    end

        -- print("add path is:",pathId,path.pathType)

    table.insert(PathPool.pathIDList, path.pathId)

    if path.pathType == PATH_TYPE.CURVE then

        local interData = GEM.BezierThree.interpolation(path.point);
        path.point = interData[1];
        path.length = interData[2];
        path.stepNumber = interData[3];

    elseif path.pathType == PATH_TYPE.LINE then

        if path.point.length == 2 then--2点直线
            path.point = path.point;
            path.length = ToolUtils.dist2(path.point[1],path.point[2]);
            path.stepNumber = 2;
        else
            --LogView.Instance.addLog("路径错误:"+pathData.pathId);
        end

    elseif path.pathType == PATH_TYPE.CIRCLE then

        if path.point.length == 2 then--2点圆
            path.point = path.point;
            local r = ToolUtils.dist2(path.point[1],path.point[2]);
            path.length = 2*math.pi*r;
            path.stepNumber = 2;
        else
            
        end
    end

    PathPool.pathList[tostring(path.pathId)] = path

    return true

end

--------------------------------------
-- getPath 
--------------------------------------

function PathPool.getPath( pathId, offsetY )
    
    local path = PathPool.pathList[tostring(pathId)]

    local route = nil

    if path ~= nil and path.point.length ~= 0 then
        if path.pathType == PATH_TYPE.LINE then
            route = GEM.Line.new()
        elseif path.pathType == PATH_TYPE.CURVE then
            route = GEM.Curve.new()
        elseif path.pathType == PATH_TYPE.CIRCLE then
            route = GEM.Circle.new()
        end
    end

    route:init(path.point, path.length, path.stepNumber, offsetY)

    return route
end

function PathPool.getLinePathByCenter( centerPoint )
    
    local path = PathPool.pathList[tostring(pathId)]

    local route = nil
    route = GEM.Line.new()

    local point = {}
    point[1]={
        x=centerPoint.x-800,
        y=centerPoint.y-0
    }
    point[2]={
        x=centerPoint.x+800,
        y=centerPoint.y+0
    }

    route:init(point, 1600, 2, 0)

    return route
end

--------------------------------------
-- release 
--------------------------------------
function PathPool.getPathType(pathId)

    local path = PathPool.pathList[tostring(pathId)];

    if path ~= nil then
        return path.pathType
    end
    return -1

end


--------------------------------------
-- release 
--------------------------------------
function PathPool.hasPath(pathId)

    local path = PathPool.pathList[tostring(pathId)];

    if path ~= nil then
        return  true
    end
    return false

end

--------------------------------------
-- release 
--------------------------------------
function PathPool.getRandom()

    local index = ToolUtils.randRange(1, #pathIDList)

    local pathId = PathPool.pathIDList[index]

    local path = PathPool.getPath(pathId, ToolUtils.randRange(1, 100))

    return path

end

return PathPool