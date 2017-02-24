
-----------------------------------------------------------
-- BonusWinView 
-----------------------------------------------------------
local BonusWinView = class("BonusWinView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

-----------------------------------------------------------
-- Construct 
-- args.numexpress
-- args.strexpress
-- args.totalcoins
-- args.onComplete
-----------------------------------------------------------
function BonusWinView:ctor(args) 

    local bonus_ccbi = DICT_MAC_RES[tostring(args.model:getMachineId())].bonus_ccbi

    self.ccbNode = CCBuilderReaderLoad(bonus_ccbi.bonus_reward, self)
    self:addChild(self.ccbNode)
    self:setNodeEventEnabled(true)


    self.onComplete = args.onComplete
    
    self.expressNum:setString(args.numexpress)
    self.expressStr:setString(args.strexpress)
    self.winCoinsLabel:setString(args.totalcoins)


    self:performWithDelay(function()

        SlotsMgr.setLabelStepCounter(self.winCoinsLabel, 0, args.totalcoins, 1.5)

        local handle = audio.playSound(RES_AUDIO.number, false)

        self:performWithDelay(function() audio.stopSound(handle) end,1.5)

    end,0.5)


    self:performWithDelay(function()
        self:init()
    end,2.2)


end

-----------------------------------------------------------
-- init 
-----------------------------------------------------------
function BonusWinView:init()

    core.displayEX.newButton(self.okBtn)
        :onButtonClicked(function() 
            
            local callback = function()
                -- body
                self.onComplete()
                scn.ScnMgr.removeView(self)

            end

            callback()
            
        end)

end

-----------------------------------------------------------
-- onExit 
-----------------------------------------------------------
function BonusWinView:onExit()
    self:removeAllNodeEventListeners()
end

return BonusWinView
