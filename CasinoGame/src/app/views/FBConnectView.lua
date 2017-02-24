local FBConnectView = class("FBConnectView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function FBConnectView:ctor(args)
    self.viewNode  = CCBuilderReaderLoad("view/facebook_connect.ccbi", self)
    self:addChild(self.viewNode)

    --self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

    self:registerEvent()

    self.isConnect = false

    self.coinLabel:setString(args.coins)
--    self:performWithDelay(function()
        -- SlotsMgr.setLabelStepCounter(self.coinLabel, 0, args.coins, 1.5)
        -- local handle = audio.playSound(RES_AUDIO.number, false)
        -- self:performWithDelay(function() audio.stopSound(handle) end,1.5)
--        self.coinsOBJ = AnimationUtil.creatCoinPack(self.coinsNode,tonumber(args.coins))
--    end,0.5)
end


function FBConnectView:registerEvent()

    core.displayEX.newButton(self.fbBtn) 
        :onButtonClicked(function(event)
--            local callback = function()
--                -- body--
                if self.isConnect then return end
                self.isConnect = true
                local function onComplete()
                    self.isConnect = false
                    if self.callback then
                        self.callback(true)
                    end

                    EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                    EventMgr:dispatchEvent({name  = EventMgr.UPDATE_TOPFB_EVENT})

                    app.logining = false
                    scn.ScnMgr.removeView(self)
                end
                core.FBPlatform.onLoginImpl(onComplete)
--            end
--            AnimationUtil.CollectCoins(self.coinsOBJ, app.coinSprite,callback)
        end)

    core.displayEX.newButton(self.fbLaterBtn) 
        :onButtonClicked(function(event)
            if self.isConnect then return end
            --AnimationUtil.DeleteCoinPack(self.coinsOBJ)
            scn.ScnMgr.removeView(self)
        end)
end

return FBConnectView
