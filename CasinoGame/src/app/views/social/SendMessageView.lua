local View = class("SendMessageView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function View:ctor(baseInfo)
    self.viewNode  = CCBReaderLoad("lobby/social/sendmessage.ccbi", self)
    self:addChild(self.viewNode)
    
    self:initInputText()

    self.baseInfo = baseInfo

    self.action = "writeTip"

    self.msgTitle:setString("Hello "..baseInfo.name)

    self:registerUIEvent()

end


function View:registerUIEvent()

    core.displayEX.extendButton(self.btn_close)
    self.btn_close.clickedCall = function()
        scn.ScnMgr.removeTopView(self)
    end


    core.displayEX.extendButton(self.ok_btn)
    self.ok_btn.clickedCall = function()
        self:sendMsg()
    end

end

function View:sendMsg()

    local sendMsg={}

    sendMsg.title =  app:getUserModel():getName()
    sendMsg.content = self.message_input:getText()
    sendMsg.shortContent = string.sub(sendMsg.content,1,20).."..."
    sendMsg.toPid = self.baseInfo.pid

    net.NotifyCS:sendMessageToPlayer(sendMsg)

    scn.ScnMgr.removeTopView(self)
end

function View:initInputText()

    local input = cc.ui.UIInput.new({
        image = "dating_shuzhi_kuang.png",
        size = cc.size(580.0, 45),
        fontSize = 8,
        listener = function(event,editbox)
            if event == "changed" then
                local str = editbox:getText()
                if string.len(str)> 100 then
                    editbox:setText(string.sub(str,1,100))
                end
                
            end
        end
    })
    input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    local parent = self.message_bg:getParent()
    parent:addChild(input)

    local x, y = self.message_bg:getPosition()
    input:setPosition(x, y)

    self.message_input = input

end


function View:onExit()
end


return View
