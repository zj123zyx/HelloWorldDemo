local baseRoute       = require("app.scenes.fish.base.BaseRoute")

-----------------------------------------------------------
-- Line 
-----------------------------------------------------------
local Curve = class("Curve", baseRoute)

function Curve:ctor()
    self.super.ctor(self)

    self.radius = 0

end

-----------------------------------------------------------
-- init 
-- /**
--  * 初始数据   
--  * @param data 原始点数据
--  * @param len 路径长
--  * @param stepNumber 线段个数
--  * @param offsetY 垂直线段偏移
--  * 
--  */ 
-----------------------------------------------------------
function Curve:init( points, length, stepNum, offY )
    self.super.init(self, points,length,stepNum,offY)
    self.offset.x = 0;
    self.offset.y = offY;
end

-----------------------------------------------------------
-- update 
-----------------------------------------------------------

function Curve:update(time)

    self.rate = time / self.totalTime
    if self.rate > 1 then
        self.rate = 1
        self.curPoint.x = self.endPoint.x + self.offset.x
        self.curPoint.y = self.endPoint.y + self.offset.y
        return self.curPoint
    end

    -- 该时间对应的点索引
    local curStep = self.rate * self.stepNumber

    --取整的索引
    local index = math.ceil(curStep)
    local indexPoint = self.pointList[index]
    local nextPoint = self.pointList[index+1]

    --取出超出整索引的比率
    local decimal = curStep - index

    if nextPoint ~= nil and decimal ~= 0 then
        
        local dx = nextPoint.x - indexPoint.x
        local dy = nextPoint.y - indexPoint.y

        self.curPoint.x = decimal*dx + indexPoint.x
        self.curPoint.y = decimal*dy + indexPoint.y

    else

        self.curPoint.x = indexPoint.x;
        self.curPoint.y = indexPoint.y;

    end

    --插值计算该段的角度
    local dirPoint = self.pointList[index+5]
    if dirPoint ~= nil and dirPoint ~= self.endPoint then
        self.rotation = ToolUtils.getRotation(indexPoint.x,indexPoint.y,dirPoint.x,dirPoint.y)
    end   

    self.curPoint.y =  self.curPoint.y - self.offsetY;

    return self.curPoint

end

return Curve
