local RateOnUs = class("RateOnUs", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function RateOnUs:ctor(args)
    self.viewNode  = CCBuilderReaderLoad("view/rate.ccbi", self)
    self:addChild(self.viewNode)
    --self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

    self:registerEvent()
    self.coins = args.coins
    self.coins_number:setString(args.coins)
--    self:performWithDelay(function()
--        SlotsMgr.setLabelStepCounter(self.coins_number, 0, args.coins, 1.5)
--        local handle = audio.playSound(RES_AUDIO.number, false)
--        self:performWithDelay(function() audio.stopSound(handle) end,1.5)
--        self.coinsOBJ = AnimationUtil.creatCoinPack(self.coinsNode,tonumber(args.coins))
--    end,0.5)
end


function RateOnUs:registerEvent()

    core.displayEX.newButton(self.btn_ok)
    :onButtonClicked(function(event)
--        local callback = function()
            local model = app:getUserModel()
            local cls = model.class
            local properties = model:getProperties({cls.rateSign})
            properties[cls.rateSign] = 1
            model:setProperties(properties)
            model:serializeModel()
            local totalCoins = app:getUserModel():getCoins() + self.coins
            app:getUserModel():setCoins(totalCoins)
            EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})

            AppLuaApi:downloadNewApp()
            net.UserCS:RateUsBack()
            self:removeFromParent()
--        end
--        AnimationUtil.CollectCoins(self.coinsOBJ, app.coinSprite,callback)
    end)

    core.displayEX.newButton(self.btn_cancel)
    :onButtonClicked(function(event)
        --AnimationUtil.DeleteCoinPack(self.coinsOBJ)
        scn.ScnMgr.removeView(self)
    end)
end

return RateOnUs
