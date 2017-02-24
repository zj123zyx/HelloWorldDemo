local AdListCell = import(".AdListCell")

local AdPopView = class("AdPopView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function AdPopView:ctor(args)
    self.viewNode  = CCBuilderReaderLoad("lobby/ad/adPopView.ccbi", self)
    self:addChild(self.viewNode)
    self:initAdView(args.ad)
    self:registerEvent()
end

function AdPopView:initAdView(adInfo)

    self.cell = AdListCell.new(cc.size(display.width, display.height), adInfo)
    self:addChild(self.cell)
end

function AdPopView:registerEvent()
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self, self.onTouch_))
	-- on close
    core.displayEX.newButton(self.btn_close) 
        :onButtonClicked(function(event)
            scn.ScnMgr.removeView(self)
        end)
end

function AdPopView:onTouch_(event)

    if event.name == "ended" then
        self.cell:onTap(event.x, event.y)
    end

    return true
end

return AdPopView
