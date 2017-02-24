
local MessageShowView = class("MessageShowView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function MessageShowView:ctor(val)
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.message_tb, self)
    self:addChild(self.viewNode)
    --self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

    self.title:setString(val.message.title)
    self.content:setString(val.message.content)

    self.callback = val.callback
    
    self:registerEvent()

end

function MessageShowView:registerEvent()
    -- on close
    core.displayEX.newButton(self.btn_ok) 
        :onButtonClicked(function(event)
            self.callback()
            scn.ScnMgr.removeView(self)
        end)

   
end

return MessageShowView
