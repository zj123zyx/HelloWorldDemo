 
local PokerWinView = class("PokerWinView", function()
    return display.newNode()
end)
 
function PokerWinView:ctor(args)

    local ccb = "poker/megawin.ccbi"
    if args.isBigwin then
        ccb = "poker/bigawin.ccbi"
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

    local stepDelay = cc.DelayTime:create(1.0)
    local callStepfunc = cc.CallFunc:create(setLabelStep)
    local acSequence = cc.Sequence:create(stepDelay, callStepfunc)
    self:runAction(acSequence)

    local func = function()
        scn.ScnMgr.removeView(self)
    end

    local delay = cc.DelayTime:create(time)
    local callfunc = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delay, callfunc)
    self:runAction(sequence)

    --SlotsMgr.setAllChildrensZorder(self, 15)

end
 
function PokerWinView:onExit()
    self:removeAllNodeEventListeners()
end

return PokerWinView
