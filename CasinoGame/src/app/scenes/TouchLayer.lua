local TouchLayer = class("TouchLayer", function()
    return display.newLayer()
end)

local stopTime = 180

function TouchLayer:ctor(msg)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            return self:onTouch_(event)
        end)
    self:setNodeEventEnabled(true)

end


function TouchLayer:onTouch_(event)

    if event.name == "began" then
        self.time = 0
        if app.controllBar then
            return app.controllBar:onTouch(cc.p(event.x,event.y))
        end
        
        -- self.touchEffect:setVisible(true)
        -- self.touchEffect:setPosition(event.x,event.y)
        -- self.touchEffect.animationManager:runAnimationsForSequenceNamed("idle")
    elseif event.name == "ended" then
        
    end

    return true
end


function TouchLayer:onEnter()
    self.time = 0

    local onTick = function(dt)
        
        self.time = self.time + dt
        
        if self.time > stopTime then

            if app.slotAutoSpin == false then
                core.SocketNet:stop()
            end

            self.time = 0
        end
    end
    
    self.schedulerEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onTick, 1, false)
end

function TouchLayer:onExit()
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerEntry)
end


return TouchLayer
