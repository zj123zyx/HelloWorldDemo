-----------------------------------------------------------
-- Cubic 
-----------------------------------------------------------
local Cubic = class("Cubic")

local BEZIER = {    
    {-1  ,  3  , -3  , 1  },
    { 3  , -6  ,  3  , 0  },
    {-3  ,  3  ,  0  , 0  },
    { 1  ,  0  ,  0  , 0  } 
}


function Cubic:ctor()
    self.a = 0
    self.b = 0
    self.c = 0
    self.d = 0
end

function Cubic:init(G)
    
    for k=1,4 do
        a = a + BEZIER[1][k]*G[k]
        b = b + BEZIER[2][k]*G[k]
        c = c + BEZIER[3][k]*G[k]
        d = d + BEZIER[4][k]*G[k]
    end

end

function Cubic:eval(t)
    return t * (t * (t * a + b) + c) + d;
end

return Cubic
