

local LUV = class("LevelUpView",function()
    return core.displayEX.newSwallowEnabledNode()
end)

function LUV:ctor(args)
    local viewNode = CCBReaderLoad("view/LevelUpView.ccbi",self)
    self:addChild(viewNode)

    self.level = args.level

    if args.callback then
        self.callback = args.callback
    end


    self:initUI()
    self:registerUIEvent()
end

function LUV:registerUIEvent()

    local levelCallBack = function()
        -- body
        app:getUserModel():setCoins(app:getUserModel():getCoins() + self.coin)

        local viplevelup = app:getUserModel():setVipPoint(app:getUserModel():getVipPoint() + self.vipPoint)

        if viplevelup == true then
            scn.ScnMgr.popView("VipLevelUpView")
        end
        if self.callback then
            self.callback()
        end

        EventMgr:dispatchEvent({name=EventMgr.UPDATE_LOBBYUI_EVENT})
        scn.ScnMgr.removeView(self)
    end

    core.displayEX.newButton(self.btn_share)
    :onButtonClicked(function(event)
        core.FBPlatform.shareFacebookImpl(function()
            -- body
            levelCallBack()
        end)
    end)

    core.displayEX.extendButton(self.btn_ok)
    self.btn_ok.clickedCall = function()

        levelCallBack()


        -- local callback = function()
        --     app:getUserModel():setCoins(app:getUserModel():getCoins() + self.coin)
        --     local viplevelup = app:getUserModel():setVipPoint(app:getUserModel():getVipPoint() + self.vipPoint)

        --     if viplevelup == true then
        --         scn.ScnMgr.popView("VipLevelUpView")
        --     end
        --     if self.callback then
        --         self.callback()
        --     end

        --     EventMgr:dispatchEvent({name=EventMgr.UPDATE_LOBBYUI_EVENT})
        --     scn.ScnMgr.removeView(self)
        -- end
        
        -- AnimationUtil.CollectCoins(self.coinsOBJ, app.coinSprite,callback)
    end
end

function LUV:initUI()
    local info = DICT_LEVEL[tostring(self.level)]
    local awardInfo = DICT_REWARD[tostring(info.reward_id)]
    self.coin = awardInfo.reward_coins
    self.vipPoint = info.vip_point

    self.levelLabel:setString(self.level)
    self.coinLabel:setString(self.coin)
    self.vipPointLabel:setString(self.vipPoint)

    print("level data:",self.coin,self.vipPoint)

--    local call = function() end
--    local stepDelay = cc.DelayTime:create(0.6)
--    local callStepfunc = cc.CallFunc:create(call)
--    local acSequence = cc.Sequence:create(stepDelay, callStepfunc)
--    self:runAction(acSequence)

    -- self:performWithDelay(function()
    --     self.coinsOBJ = AnimationUtil.creatCoinPack(self.coinsNode,tonumber(self.coin))

    -- end,0.5)

end

function LUV:onEnter()

end

function LUV:onExit()
    self:removeAllNodeEventListeners()
end

return LUV