local Bezier = class("Bezier")

--Bezier basis matrix
local BEZIER = {    
    {-1  ,  3  , -3  , 1  },
    { 3  , -6  ,  3  , 0  },
    {-3  ,  3  ,  0  , 0  },
    { 1  ,  0  ,  0  , 0  } 
}

local STEP = 0.01
local xSpline = Bezier.new()
local ySpline = Bezier.new()
local GX = {}
local GY = {}

function Bezier:ctor()
    
    self.a = 0
    self.b = 0
    self.c = 0
    self.d = 0
    
end
   
function Bezier:init(G)
    
    for k=1,4 do
        a = a + BEZIER[1][k]*G[k]
        b = b + BEZIER[2][k]*G[k]
        c = c + BEZIER[3][k]*G[k]
        d = d + BEZIER[4][k]*G[k]
    end

end

function Bezier:eval(t)
    return t * (t * (t * a + b) + c) + d;
end

function Bezier.interpolation(points)
    local path = {}
    local curveNumber = 0
    local length = 0

    local oldPoint = {}

    local ptsLen = #points

    local i = 1

    while i <= ptsLen and ptsLen - i >= 4 do

        local a = points[i+0]
        local b = points[i+1]
        local c = points[i+2]
        local d = points[i+3]

        GX[1] = a.x
        GX[2] = b.x
        GX[3] = c.x
        GX[4] = d.x

        GY[1] = a.y
        GY[2] = b.y
        GY[3] = c.y
        GY[4] = d.y

        xSpline.init(GX);
        ySpline.init(GY);

        local t=0

        while t<1 do

            local newX = xSpline:eval(t+STEP)
            local newY = ySpline:eval(t+STEP)

            table.insert(path, {x=newX, y=newY})

            if #path > 1 then
                length = length + Point.distance(oldPoint,path[#path])
            end

            oldPoint.x = newX
            oldPoint.y = newY

            t=t+STEP

        end

        curveNumber = curveNumber + 1
        i=i+3
                
    end
    
    curveNumber = curveNumber * 1 / STEP

    return {path,length,curveNumber}
end

return Bezier
