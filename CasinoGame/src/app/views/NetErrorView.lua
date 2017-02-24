local NetErrorView = class("NetErrorView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function NetErrorView:ctor(msg)
    self.viewNode  = CCBuilderReaderLoad("view/ConnectView.ccbi", self)
    self:addChild(self.viewNode)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self, self.onTouch_))

    --if self.title then self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3)end
    -- self.content:enableOutline(cc.c4b(64, 64, 64, 255), 2);

    if msg then
        if msg.title then
            self.title:setString(msg.title)
        end
        if msg.content then
            self.content:setString(msg.content)
        end

        self.callback = msg.callback
        self.delayPopCall = msg.delayPopCall
    end

end


function NetErrorView:onTouch_(event)

    if event.name == "ended" then
        
        if self.callback ~= nil then
            self.callback()
        end

        if self.delayPopCall ~= nil then
            self:delayPopCall()
        end
        
        scn.ScnMgr.removeView(self)

    end

    return true
end

return NetErrorView
