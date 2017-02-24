local ExtraCoinView = class("ExtraCoinView", function()
    return display.newNode()
end)

function ExtraCoinView:ctor(args)
    self.viewNode  = CCBuilderReaderLoad("view/extra_coins.ccbi", self)
    self:addChild(self.viewNode)

    --self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

    self:registerEvent()
    self.coins_number:setString(args.coins)
    if args.callback then
        self.callback = args.callback
    end

    local item = DICT_VIP[tostring(app:getUserModel():getVipLevel())]
    if item ~= nil and cc.SpriteFrameCache:getInstance():getSpriteFrame(item.picture) then
        self.text_vip:setSpriteFrame(item.picture)
    end
end


function ExtraCoinView:registerEvent()
    core.displayEX.newButton(self.btn_collect)
    :onButtonClicked(function(event)
        if self.callback then
            self.callback()
        end
        self:removeFromParent()
    end)

    core.displayEX.newButton(self.btn_close)
    :onButtonClicked(function(event)
        if self.callback then
            self.callback()
        end
        self:removeFromParent()
    end)
end

return ExtraCoinView
