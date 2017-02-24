
-----------------------------------------------------------
-- BigWinView 
-----------------------------------------------------------
local BigWinView = class("BigWinView", function()
    return display.newNode()
end)

-----------------------------------------------------------
-- Construct 
-- args.winCoin
-----------------------------------------------------------
function BigWinView:ctor(args) 

    local ccb = "view/bigwin.ccbi"

    if args.ccbi then 
        ccb = args.ccbi
    end

    self.ccbNode = CCBuilderReaderLoad(ccb, self)

    self:addChild(self.ccbNode)
    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)

    self.coinLabel:setString("")

    local time = 4.0
    local setLabelStep = function()
        SlotsMgr.setLabelStepCounter(self.coinLabel, 0, args.winCoin, 2.0)
        local handle = audio.playSound(RES_AUDIO.number, false)
        self:performWithDelay(function() audio.stopSound(handle) end,2.0)
    end

    local stepDelay = cc.DelayTime:create(0.6)
    local callStepfunc = cc.CallFunc:create(setLabelStep)
    local acSequence = cc.Sequence:create(stepDelay, callStepfunc)
    self:runAction(acSequence)

    self:performWithDelay(function()
        scn.ScnMgr.removeView(self)
    end,time)

    --SlotsMgr.setAllChildrensZorder(self, 15)

end


-----------------------------------------------------------
-- onExit 
-----------------------------------------------------------
function BigWinView:onExit()
    self:removeAllNodeEventListeners()
end

return BigWinView
