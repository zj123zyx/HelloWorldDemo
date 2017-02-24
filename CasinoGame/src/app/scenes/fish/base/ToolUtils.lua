local ToolUtils = {}

function ToolUtils.rtd(r)
	return r * 180 / math.pi
end

function ToolUtils.dta(d)
	return d * math.pi / 180
end

function ToolUtils.randRange(min, max)

    math.randomseed(tostring(socket.gettime()*10000):reverse():sub(1, 6))  

    math.random()
    math.random()
    math.random()
    
    return math.floor(math.random() * (max - min + 1)) + min
end

function ToolUtils.getRotationByPoint(p1, p2, length)

    local angle = math.atan2(p2.y-p1.y, p2.x-p1.x)
    local ox = math.sin(angle)*length
    local oy = math.cos(angle)*length

    return {x=ox, y=oy}
end

function ToolUtils.getRotation(x1, y1, x2, y2)

    local angle = math.atan2(y2-y1, x2-x1)
    local degree = ToolUtils.rtd(angle)

    return degree
end

--二点距离，未开方 
function ToolUtils.dist(x1, y1, x2, y2)
    return (y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1)
end

--二点距离，开方 
function ToolUtils.dist2(p1, p2)
    local dist = ToolUtils.dist(p1.x,p1.y,p2.x,p2.y)
    return math.sqrt(dist)
end

return ToolUtils