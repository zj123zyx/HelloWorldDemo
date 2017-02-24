local BaseRoute = class("BaseRoute")

function BaseRoute:ctor()
    
    --原始路径point数据列表 
    self.pointList = nil
    --该路径总长 
    self.len = 0
    --以speed运动该路径的时间
    self.totalTime = 0

    self.startPoint = {x=0,y=0}
    self.endPoint = {x=0,y=0}

    --以time计算在该路径的某点 
    self.curPoint = {x=0,y=0}
    --垂直直线偏移 offsetY后的点 
    self.offset = {x=0,y=0}

    --相对于该路径的垂直偏移 
    self.offsetY = 0
    --以time计算相对路径的已移动的比率 
    self.rate = 0
    --当前时间点的该端线的斜率 
    self.rotation = 0
    --插值的段数 
    self.stepNumber = 0

end
   
function BaseRoute:init( points, length, stepNum, offY)

    self.pointList = points
    self.len = length
    self.stepNumber = stepNum
    self.offsetY = offY
    self.startPoint = points[1]
    self.endPoint = points[#points]
    
end

--计算以speed运动需要的时间，必须先init 
function BaseRoute:setSpeed(speed)
    self.totalTime = self.len / speed 
end

--更新路径偏移 ,必须先init 
function BaseRoute:updateOffset(startPt, endPt)

    if startPt == nil or endPt == nil then return end
    self.offset =  ToolUtils.getRotationByPoint(startPt, endPt, self.offsetY);

end

--根据时间计算在路径的某点上 ,必须先init 
function BaseRoute:update(time)

    if time < 0 then
        time = 0
    end

    self.rate = time / self.totalTime

    if self.rate > 1 then
        self.rate = 1
    end

    return nil

end

return BaseRoute
