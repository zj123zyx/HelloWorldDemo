-----------------------------------------------------------
-- Cubic 
-----------------------------------------------------------
local Fish = class("Fish",function()
    return display.newNode()
end)

function Fish:ctor(sourceID)

    local f_dict = DICT_FISH[tostring(sourceID)]

    self.sourceID=sourceID

    self.actionType = MOVE_TYPE.MOVE
    self.startTime=0
    self.isActive=true
    self.globalPos={}
    self.pathIndex = 0
    self.loopMoveTotal = -1
    self.curLoopMove = 0
    self.weaponHitRate={}

    self.speed = f_dict.speed
    self.resPath="fish/fishanim/fishanim_"..f_dict.ccb..".ccbi"
    self.name=f_dict.name
    self.value=f_dict.value
    self.expvalue=f_dict.expvalue
    self.reward_type=f_dict.reward_type
    self.die_cnt=f_dict.die_cnt

    self.offset = {x=0,y=0}

    self:setNodeEventEnabled(true)
    self:initHitrate()
    self:load()
end

function Fish:initHitrate()

    local hr_dict = DICT_HITRATE[tostring(self.sourceID)]

    for i=1,9 do
        local rate=hr_dict["weapon_"..i.."_hitrate"]
        rate = string.sub(rate,3)

        -- print("fish rate:",self.sourceID, i, rate)

        if rate == nil then
            self.weaponHitRate[i]=0
        else
            self.weaponHitRate[i]=ToolUtils.getTenThousandPer( tonumber(rate) )
        end

    end

end

function Fish:getHitRate(weaponLevel)
    return self.weaponHitRate[tonumber(weaponLevel)]
end

function Fish:load()
    self.fishNode = CCBuilderReaderLoad(self.resPath, self)
    self.fishNode:setScale(1.4)
    self.animationMgr = self.rootNode.animationManager
    self:addChild(self.fishNode)

    -- 由于Pos是在update中动态设置的，故初始化时使其暂时不可见 jjf
    self:setVisible(false)
end

function Fish:getBBox()

    local x,y = self:getPosition()
    local size = self.fishNode:getContentSize()

    return cc.rect( x-size.width/2, y-size.height/2, size.width, size.height)
end

function Fish:reset()

    self.actionType = MOVE_TYPE.MOVE
    self.speed = 100
    self.startTime=0
    self.isActive=false
    self.globalPos={}
    self.pathIndex = 0
    self.loopMoveTotal = -1
    self.curLoopMove = 0

end

function Fish:setRoute(rt, runedTime)
    self.route  = rt
    self.runedTime  = runedTime
    self.route:setSpeed(self.speed)
    self:moveInit()

end

function Fish:moveInit()
    self.actionType = MOVE_TYPE.MOVE;
    self.startTime = socket.gettime() - self.runedTime;
    self.isActive = true;
end

function Fish:moveEnd()
    print("Fish:moveEnd()",self.loopMoveTotal)
    --循环路径运动
    if self.loopMoveTotal > 0 then
        self.curLoopMove = self.curLoopMove + 1
        if self.curLoopMove > self.loopMoveTotal then
            self:loopMoveEndHandler()
            return
        end

        self.runedTime = 0
        self:moveInit()
    else
        self.actionType = MOVE_TYPE.STOP
        self:destroy()
    end

end

function Fish:loopMoveEndHandler()
    self.curLoopMove = 0
    self.loopMoveTotal = -1

    if self.route ~= nil and iskindof(self.route,"Circle") then
        local line = GEM.Line.new()
        local pointData = {{x=this.x,y=this.y},{x=display.width+100,this.y}}
        local len = ToolUtils.dist2(pointData[1],pointData[2])
        line:init(pointData,len,2,0)
        self.loopTotal = 0
        self:setRoute(line)

    end

end

function Fish:update(dt)
    -- 计算对象的坐标
    if (self.actionType == MOVE_TYPE.MOVE or self.actionType == MOVE_TYPE.ESCAPE) and self.route ~= nil then
        --运动结束
        if self.route.rate == 1 then
            self.route.rate = 0
            self:moveEnd()
            return
        end
        local updataTime = socket.gettime() - self.startTime
        if self.actionType == MOVE_TYPE.ESCAPE then
            -- updataTime = updataTime*2
            -- updataTime = updataTime - (COUGHT_TIME - self.coughtTime)*2
            self.route:setSpeed(self.speed*3)
            updataTime = self.route.rate * self.route.totalTime 
            updataTime=updataTime+dt 
        else
            self:setVisible(true)
        end
        self.globalPos = self.route:update(updataTime);
        -- print("Line:update", socket.gettime(), self.startTime, socket.gettime()- self.startTime, self.route.totalTime)
        self:setPositionX(self.globalPos.x + self.offset.x)
        self:setPositionY(self.globalPos.y + self.offset.y)
        
        --角度
        if self.route.rotation ~= self:getRotation() then
            self:setRotation(360-self.route.rotation);
        end
        if self.uiId == 0 then
            --trace(this.uiId,this.x,this.y,this._route.rate);
        end
    end
    -- if self.actionType == MOVE_TYPE.COUGHT then
    --     if self.coughtTime > 0 then
    --         self.coughtTime = self.coughtTime - dt
    --     else
    --         self:escape()
    --     end
    -- end
end

function Fish:onEnter()
    -- body
    self.scheduleObj = scheduler.scheduleGlobal(function(dt)
        self:update(dt)
    end, 0)

end

-----------------------------------------------------------
-- 
-----------------------------------------------------------
function Fish:onExit() 
    scheduler.unscheduleGlobal(self.scheduleObj)
end


function Fish:getRoute()
    return self.route 
end

function Fish:stop()
    --self:removeFromParent(false)
end

function Fish:play()
    self.scnNode:addChild(self)
end

function Fish:die(delay)

    self.actionType = MOVE_TYPE.DIE

    self.animationMgr:runAnimationsForSequenceNamed('die')

    self:performWithDelay(function()

        local startPos = self:getParent():convertToWorldSpace(cc.p(self:getPosition()))
        local destPos = app.coinSprite:getParent():convertToWorldSpace(cc.p(app.coinSprite:getPosition()))

        local coinsEffect  = CCBReaderLoad("fish/effect/coins_gold.ccbi", self)
        coinsEffect:setPosition(startPos)
        display.getRunningScene():addChild(coinsEffect)

        local mTime = ToolUtils.dist2(startPos, destPos)/600
        local angle = ToolUtils.getRotation(startPos.x,startPos.y,destPos.x,destPos.y)
        
        if mTime < 0.5 then mTime = 0.5 end

        coinsEffect:setRotation(-angle)

        transition.scaleTo(coinsEffect, {time = mTime, scale = 0.65,easing = "BACKIN"})
        coinsEffect:runAction(cc.Sequence:create(
            cc.MoveBy:create(mTime,cc.p(destPos.x-startPos.x,destPos.y-startPos.y)),
            cc.CallFunc:create(function()

                audio.playSound("fish/audio/coin_effect.mp3")

                -- add coins

                EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                coinsEffect:removeFromParent()

        end)))
    
        self:destroy()

    end, 0.8 + delay)
end

function Fish:destroy()

    self.stop();
    self.isActive = false;
    self.curLoopMove = 0;
    self.loopMoveTotal = -1;
    self.runedTime = 0;
    self.route = nil;

    FishManager.push(self)

    self:removeFromParent(false)

end

function Fish:release()

    print("Fish:release()")
    
    self.stop();
    self.isActive = false;
    self.curLoopMove = 0;
    self.loopMoveTotal = -1;
    self.runedTime = 0;
    self.route = nil;

    self:removeFromParent(true)

end

function Fish:cought(delay)
    self.actionType = MOVE_TYPE.COUGHT
    self.coughtTime = COUGHT_TIME
    self.animationMgr:runAnimationsForSequenceNamed('cought')
end

function Fish:escape()

    self.actionType = MOVE_TYPE.ESCAPE
    self.animationMgr:runAnimationsForSequenceNamed('escape')
    
    self:performWithDelay(function()
        self.animationMgr:runAnimationsForSequenceNamed('dismiss')
    end, ESCAPE_TIME-0.5)

    self:performWithDelay(function()
        self:destroy()
    end, ESCAPE_TIME)
end

return Fish
