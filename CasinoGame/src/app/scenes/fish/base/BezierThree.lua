local BezierThree = {}

BezierThree.p1 = nil
BezierThree.p2 = nil
BezierThree.p3 = nil
BezierThree.step=nil

BezierThree.ax=0
BezierThree.ay=0
BezierThree.bx=0
BezierThree.by=0

BezierThree.A=0
BezierThree.B=0
BezierThree.C=0

BezierThree.total_length=0


function BezierThree.s(t)
    return math.sqrt(BezierThree.A * t * t + BezierThree.B * t + BezierThree.C)
end

function BezierThree.L(t)
    local temp1 = math.sqrt(BezierThree.C + t * (BezierThree.B + BezierThree.A * t))
    local temp2 = (2 * BezierThree.A * t * temp1 + BezierThree.B *(temp1 - math.sqrt(BezierThree.C)))
    local temp3 = math.log(BezierThree.B + 2 * math.sqrt(BezierThree.A) * math.sqrt(BezierThree.C))
    local temp4 = math.log(BezierThree.B + 2 * BezierThree.A * t + 2 * math.sqrt(BezierThree.A) * temp1)
    local temp5 = 2 * math.sqrt(BezierThree.A) * temp2
    local temp6 = (BezierThree.B * BezierThree.B - 4 * BezierThree.A * BezierThree.C) * (temp3 - temp4)
            
    return (temp5 + temp6) / (8 * math.pow(BezierThree.A, 1.5))
end

function BezierThree.InvertL(t, l)
    local t1 = t
    local t2

    local whileend = true
    
    while whileend do

        t2 = t1 - (BezierThree.L(t1) - l)/BezierThree.s(t1);
        if math.abs(t1-t2) < 0.000001 then  
            whileend = false 
            break
        end
        t1 = t2;

    end

    return t2
end

function BezierThree.init(p1,p2,p3,speed)
	
    BezierThree.p1   = p1
    BezierThree.p2   = p2
    BezierThree.p3   = p3
    --step = 30;
    
    BezierThree.ax = BezierThree.p1.x - 2 * BezierThree.p2.x + BezierThree.p3.x
    BezierThree.ay = BezierThree.p1.y - 2 * BezierThree.p2.y + BezierThree.p3.y
    BezierThree.bx = 2 * BezierThree.p2.x - 2 * BezierThree.p1.x
    BezierThree.by = 2 * BezierThree.p2.y - 2 * BezierThree.p1.y
    
    BezierThree.A = 4*(BezierThree.ax * BezierThree.ax + BezierThree.ay * BezierThree.ay)
    BezierThree.B = 4*(BezierThree.ax * BezierThree.bx + BezierThree.ay * BezierThree.by)
    BezierThree.C = BezierThree.bx * BezierThree.bx + BezierThree.by * BezierThree.by
    
    --  计算长度
    BezierThree.total_length = BezierThree.L(1)
    
    --  计算步数
    BezierThree.step = math.floor(BezierThree.total_length / speed)

    local modval = math.fmod(BezierThree.total_length,speed)

    if modval > speed / 2 then 
        BezierThree.step = BezierThree.step + 1 
    end
    
    return BezierThree.step

end

function BezierThree.interpolation(points)
    local path = {}

    local i = 1
    local ptsLen = #points

    while i < ptsLen + 1 and ptsLen - i >= 2 do

        local a = points[i+0]
        local b = points[i+1]
        local c = points[i+2]


        local _totalStep = BezierThree.init(a, b, c, 5)

        for k=1,_totalStep do
            local data = BezierThree.getAnchorPoint(k)
            local pt={x=data[1],y=data[2]}
            table.insert(path, pt)
        end

        i=i+2
    end

    local pathLen = #path

    return {path,pathLen*5,pathLen}

end

--    根据指定nIndex位置获取锚点：返回坐标和角度

function BezierThree.getAnchorPoint(nIndex)

    if nIndex >= 0 and nIndex <= BezierThree.step then
        local t = nIndex/BezierThree.step
        --  如果按照线行增长，此时对应的曲线长度
        local l = t*BezierThree.total_length
        --  根据L函数的反函数，求得l对应的t值
        t = BezierThree.InvertL(t, l)
        
        --  根据贝塞尔曲线函数，求得取得此时的x,y坐标
        local xx = (1 - t) * (1 - t) * BezierThree.p1.x + 2 * (1 - t) * t * BezierThree.p2.x + t * t * BezierThree.p3.x
        local yy = (1 - t) * (1 - t) * BezierThree.p1.y + 2 * (1 - t) * t * BezierThree.p2.y + t * t * BezierThree.p3.y
        
        --  获取切线
        local Q0 = {x=(1 - t) * BezierThree.p1.x + t * BezierThree.p2.x, y=(1 - t) * BezierThree.p1.y + t * BezierThree.p2.y}
        local Q1 = {x=(1 - t) * BezierThree.p2.x + t * BezierThree.p3.x, y=(1 - t) * BezierThree.p2.y + t * BezierThree.p3.y}
        
        --  计算角度
        local dx = Q1.x - Q0.x
        local dy = Q1.y - Q0.y
        local radians = math.atan2(dy, dx)
        local degrees = radians * 180 / math.pi
        
        return {xx, yy, degrees}
    end

    return {}

end

return BezierThree
