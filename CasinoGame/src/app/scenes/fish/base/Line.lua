local baseRoute       = require("app.scenes.fish.base.BaseRoute")

-----------------------------------------------------------
-- Line 
-----------------------------------------------------------
local Line = class("Line", baseRoute)

function Line:ctor()
    self.super.ctor(self)
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
function Line:init( points, length, stepNum, offY )
    
    self.super.init(self, points, length, stepNum, offY)
    
    --相对于该线的垂直偏移
    self.updateOffset(self.startPoint,self.endPoint)
    --该线段的倾斜角度
    self.rotation = ToolUtils.getRotation(self.startPoint.x,self.startPoint.y,self.endPoint.x,self.endPoint.y);
end

-----------------------------------------------------------
-- update 根据时间计算在该直线的某点上 
-----------------------------------------------------------
function Line:update(time)

    self.rate = time / self.totalTime

    if self.rate > 1 then
        self.rate = 1
        self.curPoint.x = self.endPoint.x + self.offset.x
        self.curPoint.y = self.endPoint.y + self.offset.y
        return self.curPoint
    end

    local dx = self.endPoint.x - self.startPoint.x
    local dy = self.endPoint.y - self.startPoint.y

    self.curPoint.x = self.rate * dx + self.startPoint.x + self.offset.x
    self.curPoint.y = self.rate * dy + self.startPoint.y + self.offset.y

    return self.curPoint

end

return Line
