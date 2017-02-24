local JackPotView = class("JackPotView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

local callbackFuc = nil
function JackPotView:ctor(args)
    self.ccbNode = CCBuilderReaderLoad("view/JackPotView.ccbi", self)
	self:addChild(self.ccbNode)
    callbackFuc = args.callBack
    self.getcoins:setString(args.rewardCoins)
    self:registerEvent()
end

function JackPotView:registerEvent()
    core.displayEX.newButton(self.btn_share)
    :onButtonClicked(function(event)
        core.FBPlatform.shareFacebookImpl(function()
            -- body
            if self.callback then self.callback() end
            scn.ScnMgr.removeView(self)
        end)
    end)

    core.displayEX.newButton(self.btn_close)
    :onButtonClicked(function(event)
        if self.callback then self.callback() end

        EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})

        scn.ScnMgr.removeView(self)
    end)
end

return JackPotView