local MessageShowView = require("app.views.MessageShowView")

local MessageCell = class("MessageCell", function()
    return display.newNode()
end)
local msgtype ={
    system = 1,
    reward = 2,
    invite = 3,
    note = 7,
}
function MessageCell:ctor(msg)
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.message_cell, self)
    self:addChild(self.viewNode)
    -- print(tostring(msg))
    self.msg = msg.msg
    self.parent = msg.parent
    self.closeBtn = msg.closeBtn
    self:initUI()
    self.count = 0
end

function MessageCell:initUI()
    self.btns = {}
    if self.msg.type == msgtype.system then
        self:initSystemUI()
    elseif self.msg.type == msgtype.reward then
        self:initRewardUI()
    elseif self.msg.type == msgtype.invite then
        self:initInviteUI()
    elseif self.msg.type == msgtype.note then
        self:initNoteUI()
    end
end

function MessageCell:initSystemUI()
end

function MessageCell:initSystemUI()
    self.note:setVisible(false)
    self.reward:setVisible(false)
    self.invite:setVisible(false)
    self.system:setVisible(true)
    
    self.title_system:setString(self.msg.title)

    self.text_system:setString(ToolUtils.shortContent(self.msg.shortContent, 80))

    if self.msg.state > 0 then
        self.readSign_system:setVisible(false)
    end

    self.btns[#self.btns+1] = {btn=self.btn_system,
    
    call=function()
        -- body
        net.MessageCS:receiveMsg(self.msg.id, 1, function( msg )
                -- body

                scn.ScnMgr.addTopView("MessageShowView",self.parent, {message=self.msg, callback=function()
                    -- body
                    --self:removeSelf()
                    self.readSign_system:setVisible(false)

                end})
                
            end)
    end

    }
end

function MessageCell:initRewardUI()

    self.note:setVisible(false)
    self.reward:setVisible(true)
    self.invite:setVisible(false)
    self.system:setVisible(false)

    self.title_reward:setString(self.msg.title)
    self.text_reward:setString(self.msg.content)


    if self.msg.state > 0 then
        self.readSign_reward:setVisible(false)
    end

    if  tonumber(self.msg.itemId) == ITEM_TYPE.GEMS_MULITIPLE then
        self.image_reward:setSpriteFrame("liwu_tubiao_baoshi.png")
    end

    self.btns[#self.btns+1] = {btn=self.btn_reward,
    
    call=function()
        -- body
        if self.count == 1 then
            return 
        end
        self.count = 1
        net.MessageCS:receiveMsg(self.msg.id, 2, function( msg ) --读完一条消息
                -- body
                if msg.result == 1 then

                    local image = "gold.png"
                    local coinsprite = app.coinSprite
                    if  tonumber(self.msg.itemId) == ITEM_TYPE.NORMAL_MULITIPLE  then --奖励金币
                        image = "gold.png"
                        coinsprite = app.coinSprite
                    else
                        image = "gems.png"
                        coinsprite = app.gemSprite
                    end
                    self.closeBtn:setButtonEnabled(false)
                    AnimationUtil.CollectRewards("#"..image,5,self.image_reward,coinsprite,function()
                        self.closeBtn:setButtonEnabled(true)
                        local totalCoins = app:getUserModel():getCoins() + msg.rewardCoins
                        local totalGems = app:getUserModel():getGems() + msg.rewardGems
                        app:getUserModel():setCoins(totalCoins)
                        app:getUserModel():setGems(totalGems)
                        EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})
                        self:removeSelf() 
                        -- EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                    end)
                end
            end)
    end

    }
end

function MessageCell:initInviteUI()

    self.note:setVisible(false)
    self.invite:setVisible(true)
    self.system:setVisible(false)
    self.reward:setVisible(false)

    --self.name_invite:setString(self.msg.title)
    -- self.image_invite:setSpriteFrame(HEAD_IMAGE[math.newrandom(6)])

    if self.msg.state > 0 then
        self.readSign_invite:setVisible(false)
    end

    local headview = headViewClass.new({player={name=self.msg.title, facebookId=self.msg.facebookId,pictureId=self.msg.picture}})
    headview:replaceHead(self.image_invite)
    headview:showUserName()

    self.btns[#self.btns+1] = {btn=self.btn_accept,
    
        call=function()
            net.MessageCS:receiveMsg(self.msg.id, 2, function( msg )
                -- body
                headview:removeFromParent()
                self:removeSelf()
            end)
        end
    }

    self.btns[#self.btns+1] = {btn=self.btn_refusal,
    
        call=function()
            -- body
            net.MessageCS:receiveMsg(self.msg.id, 3, function( msg )
                -- body
                headview:removeFromParent()
                self:removeSelf()
            end)
        end
    }
end

function MessageCell:removeSelf()
    if self.msgsListNode and self.item then
        self.msgsListNode:removeItem(self.item,true)
    end
end

function MessageCell:initNoteUI()

    self.note:setVisible(true)
    self.invite:setVisible(false)
    self.system:setVisible(false)
    self.reward:setVisible(false)

    local timeStr = os.date("%x %X",tonumber(self.msg.sendTime)/1000)    

    local senderName = self.msg.title

    self.msg.title = "Message From "..self.msg.title

    self.sendTime:setString("Send Time: "..timeStr)
    self.title_note:setString(self.msg.title)
    self.text_note:setString(self.msg.shortContent)

    if self.msg.state > 0 then
        self.readSign_note:setVisible(false)
    end

    local pic = self.msg.picture
    local headview = headViewClass.new({player={pid=self.msg.fromPid,name=senderName, pictureId=pic, facebookId=self.msg.facebookId, vipLevel=self.msg.viplevel}})
    headview:replaceHead(self.senderHead)
    headview:showUserName()
    headview:registClickHead(false, self.parent)


    self.btns[#self.btns+1] = {btn=self.btn_note,
    
    call=function()
        -- body
        net.MessageCS:receiveMsg(self.msg.id, 1, function( msg )
                -- body
                scn.ScnMgr.addTopView("MessageShowView",self.parent, {message=self.msg, callback=function()
                    -- body
                    self.readSign_note:setVisible(false)

                end})

            end)
    end

    }


end

function MessageCell:onTouched(event)
    if event.name == "clicked" then

        for i=1,#self.btns do
            local btnevent = self.btns[i]
            print("clicked",event.x, event.y,btnevent.btn:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)))
            if btnevent.btn:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) then
                btnevent.call()
                return true
            end
        end
    elseif event.name == "ended" then

        if self.clicked == false then return true end

        for i=1,#self.btns do
            local btnevent = self.btns[i]
            if btnevent.btn:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) then
                btnevent.btn:setHighlighted(false)
                btnevent.call()
                return true
            end
        end

    end
    return true
end

return MessageCell