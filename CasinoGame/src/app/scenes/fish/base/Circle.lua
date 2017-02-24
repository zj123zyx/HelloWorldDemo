local baseRoute       = require("app.scenes.fish.base.BaseRoute")

-----------------------------------------------------------
-- Line 
-----------------------------------------------------------
local Circle = class("Circle", baseRoute)

function Circle:ctor()
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
function Circle:init( points, length, stepNum, offY )
    self.super.init(self, points,length,stepNum,offY)
    self.radius = ToolUtils.dist2(self.startPoint,self.endPoint);
end

--计算以speed运动需要的时间，必须先init 
function Circle:setSpeed(speed)
    self.totalTime = self.len / speed
end

-----------------------------------------------------------
-- update 根据时间计算在该直线的某点上 
-----------------------------------------------------------

function Circle:update(time)

    if self.super.update(self,time) == nil then
        
        local degree = self.rate*360
        local angle = ToolUtils.dta(degree)
        --local angle = degree
        self.curPoint.x = self.startPoint.x + math.sin(angle)*(self.radius+self.offsetY)
        self.curPoint.y = self.startPoint.y + math.cos(angle)*(self.radius+self.offsetY)
        self.rotation = ToolUtils.getRotation(self.startPoint.x,self.startPoint.y,self.curPoint.x,self.curPoint.y)+270
    end

    return self.curPoint

end

return Circle
