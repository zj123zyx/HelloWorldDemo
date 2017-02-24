
-----------------------------------------------------------
-- MegaWinView 
-----------------------------------------------------------
local MegaWinView = class("MegaWinView", function()
    return display.newNode()
end)

-----------------------------------------------------------
-- Construct 
-- args.winCoin
-----------------------------------------------------------
function MegaWinView:ctor(args) 

    local ccb = "view/megawinshare.ccbi"
    
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

    local time = 4.5
    local setLabelStep = function()
        SlotsMgr.setLabelStepCounter(self.coinLabel, 0, args.winCoin, 2.5)
        local handle = audio.playSound(RES_AUDIO.number, false)
        self:performWithDelay(function() audio.stopSound(handle) end,2.5)
    end

    local stepDelay = cc.DelayTime:create(0.6)
    local callStepfunc = cc.CallFunc:create(setLabelStep)
    local acSequence = cc.Sequence:create(stepDelay, callStepfunc)
    self:runAction(acSequence)

    local func = function()
        scn.ScnMgr.removeView(self)
    end

    self:performWithDelay(function()
        scn.ScnMgr.removeView(self)
    end,time)
   
end

function MegaWinView:registerEvent()
    core.displayEX.newButton(self.btn_share)
    :onButtonClicked(function(event)
        core.FBPlatform.shareFacebookImpl(function()
            -- body
            scn.ScnMgr.removeView(self)
        end)
    end)

    core.displayEX.newButton(self.btn_ok)
    :onButtonClicked(function(event)
        scn.ScnMgr.removeView(self)
    end)
end
-----------------------------------------------------------
-- onExit 
-----------------------------------------------------------
function MegaWinView:onExit()
    self:removeAllNodeEventListeners()
end

return MegaWinView
