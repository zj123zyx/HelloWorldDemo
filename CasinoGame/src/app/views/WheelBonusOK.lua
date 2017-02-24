
local WheelBonusOK = class("WheelBonusOK", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function WheelBonusOK:ctor(args)
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.wheelbonus_tb, self)
    self:addChild(self.viewNode)


    self.winCount = args.coins*args.vipbet

    if args.is_dragon then
        self.expressStr:setString("Dragon's treasure won = coins X VIP bet")
        if self.dragonSprite then
            self.dragonSprite:setVisible(true)
        end
        --self.luckyWheelSprite:setVisible(false)
    else
        self.expressStr:setString("Lucky wheel won = coins X VIP bet")
        if self.dragonSprite then
            self.dragonSprite:setVisible(false)
        end
        --self.luckyWheelSprite:setVisible(true)
    end


    local express = tostring(self.winCount).." = "..tostring(args.coins).." X "..tostring(args.vipbet)
    self.expressNum:setString(express)

    self:performWithDelay(function()

        SlotsMgr.setLabelStepCounter(self.totalLabel, 0, self.winCount, 1.5)
        
        local handle = audio.playSound(RES_AUDIO.number, false)
        
        self:performWithDelay(function() audio.stopSound(handle) end,1.5)

        self.coinsOBJ = AnimationUtil.creatCoinPack(self.coinsNode,tonumber(self.winCount))


    end,0.5)


    if args.delayCall ~= nil then
        self.delayCall = args.delayCall
    end

    self:performWithDelay(function()
        self:registerUIEvent()
    end,2.5)

end

function WheelBonusOK:registerUIEvent()

    core.displayEX.newButton(self.okBtn)
        :onButtonClicked(function(event)
            -- body
            AnimationUtil.CollectCoins(self.coinsOBJ, app.coinSprite,function()
                -- body
                app:getUserModel():setCoins(app:getUserModel():getCoins() + self.winCount)
                EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                
                local fun = self.delayCall
                scn.ScnMgr.removeView(self)
                if fun ~= nil then
                    fun()
                end

            end)
            
        end)

end

function WheelBonusOK:onEnter()
end

function WheelBonusOK:onExit()
end

return WheelBonusOK
