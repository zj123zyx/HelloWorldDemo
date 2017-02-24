
local FreeBonusWin = class("FreeBonusWin", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function FreeBonusWin:ctor(args)
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.freebonusWin, self)
    self:addChild(self.viewNode)

    self:performWithDelay(function()

        SlotsMgr.setLabelStepCounter(self.totalLabel, 0, args.coins, 1.0)
        
        local handle = audio.playSound(RES_AUDIO.number, false)
        
        self:performWithDelay(function() audio.stopSound(handle) end,1.0)

        self.coinsOBJ = AnimationUtil.creatCoinPack(self.coinsNode,tonumber(args.coins))

    end,0.3)

    if args.delayCall ~= nil then
        self.delayCall = args.delayCall
    end

    self:performWithDelay(function()
        self:registerUIEvent()
    end,2.0)

end

function FreeBonusWin:registerUIEvent()

    core.displayEX.newButton(self.okBtn)
        :onButtonClicked(function(event)
            -- body
            local function callback()
                local fun = self.delayCall
                app:getObject("ReportModel"):sendReportBaseInfo()
                scn.ScnMgr.removeView(self)
                if fun ~= nil then
                    fun()
                end
            end
            AnimationUtil.CollectCoins(self.coinsOBJ, app.coinSprite,callback)
        end)

end

function FreeBonusWin:onEnter()
end

function FreeBonusWin:onExit()
end

return FreeBonusWin
