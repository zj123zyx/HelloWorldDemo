local LuckyWheelView = class("LuckyWheelView", function()
    return display.newNode()
end)

function LuckyWheelView:ctor(args)
    self.viewNode  = CCBuilderReaderLoad("view/LuckyWheel.ccbi", self)
    self:addChild(self.viewNode)
    --self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

    self.cost_gems:setString(args.cost_gems)
    self:registerEvent()
    if args.callback then
        self.callback = args.callback
    end
end


function LuckyWheelView:registerEvent()
    core.displayEX.newButton(self.btn_ok)
    :onButtonClicked(function(event)
        if self.callback then
            self.callback()
        end
        self:removeFromParent()
    end)

    core.displayEX.newButton(self.btn_cancel)
    :onButtonClicked(function(event)
        self:removeFromParent()
    end)
end

return LuckyWheelView
