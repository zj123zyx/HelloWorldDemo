local BezierTwo = class("BezierTwo")

local bezier = BezierTwo.new()


function BezierTwo:ctor()
    
    self.num = 200
    self.distance = 5
    
end
   
function BezierTwo:P_BEZ(t, sz)
    
    local x_p = 0
    local y_p = 0
    local n = #sz

    for i=1,n do
    	local b = self:BEZ(n, i, t)
    	x_p = x_p + sz[i].x*b
    	y_p = y_p + sz[i].y*b
    end

    return {x = x_p, y = y_p}

end

function BezierTwo:BEZ(n, k, t)
    return self:C(n,k)*math.pow(t,k)*math.pow(1-t,n-k);
end

function BezierTwo:C(n, k)
    local son = self:fac(n)
    local mother = self:fac(k)*self:fac(n-k)
    return son/mother
end

function BezierTwo:fac(i)
	local n = 1

	local j = 1

	while j<=i do
		n = n * j
		j = j + 1
	end

	return n
end

function BezierTwo.interpolation(points)
    local path = {}

    local i = 1
    local ptsLen = #points

    while i <= ptsLen and ptsLen - i >= 4 do

        local sz = {points[i+0],points[i+1],points[i+2],points[i+3]}
        local pl =  bezier:draw_points(sz);

        for k=1,#pl do
            table.insert(path, pl[k])
        end

        i=i+3
    end

    local pathLen = #path

    return {path,pathLen*bezier.distance,pathLen}

end
      
function BezierTwo:draw_points(sz)
    
    local pointList = {}
    local p = self:P_BEZ(0,sz)
    local sep = 1/self.num
    local knum = 0

    local j = sep

    while j<1 do

        local p2 = self:P_BEZ(j,sz)

        while Point.distance(p,p2)>1 do
            
            knum = knum + 1

            if (p2.x-p.x)>0 then
                p.x = p.x + 0.7
            else
                p.x = p.x - 0.7
            end

            if (p2.y-p.y)>0 then
                p.y = p.y + 0.7
            else
                p.y = p.y - 0.7
            end

            if knum > self.distance then

                table.insert(pointList, p)
                p = p2
                knum = 0
                break
            end

        end

        j=j+sep
    end

end

return BezierTwo
