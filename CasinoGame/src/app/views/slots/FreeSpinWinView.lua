
-----------------------------------------------------------
-- FreeSpinWinView 
-----------------------------------------------------------
local FreeSpinWinView = class("FreeSpinWinView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

-----------------------------------------------------------
-- Construct 
-- args.coins
-- args.okHandle
-----------------------------------------------------------
function FreeSpinWinView:ctor(args) 

    local freespin_ccbi = DICT_MAC_RES[tostring(args.model:getMachineId())].freespin_ccbi

    self.coins = args.model:getFrCoins()
    self.okHandle = args.okHandle

    self.ccbNode = CCBuilderReaderLoad(freespin_ccbi.freespin_reward, self)
    self:addChild(self.ccbNode)
    self:setNodeEventEnabled(true)


    self.coinLabel:setString(self.coins)

    
    self:performWithDelay(function()

        SlotsMgr.setLabelStepCounter(self.coinLabel, 0, self.coins, 1.5)

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
function FreeSpinWinView:init()

    core.displayEX.newButton(self.okBtn)
        :onButtonClicked(function() 

            local callback = function()
                -- body
                self.okHandle()
                scn.ScnMgr.removeView(self)
                
            end
            callback()
    end)

end

-----------------------------------------------------------
-- onExit 
-----------------------------------------------------------
function FreeSpinWinView:onExit()
    self:removeAllNodeEventListeners()
end

return FreeSpinWinView
