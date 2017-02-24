local HeadView = class("HeadView", function()
    return display.newNode()
end)

function HeadView:ctor(val)
    self.viewNode  = CCBReaderLoad("view/share_head.ccbi", self)
    self:addChild(self.viewNode)

    if val.scale then
        self:setScale(val.scale)
    else
        self:setScale(0.55)
    end

    if val.model then
        self.model = val.model
    end

    self.touchEnabled = true
    self.player = val.player
    self:setHeadImage(self.player.pictureId)

    if self.player.level then
        self.level:setString(tostring(self.player.level))
    end

    self.level:enableOutline(cc.c4b(100, 100, 100, 255), 2);

    if self.player.vipLevel then
        self:vipBG(self.player.vipLevel)
    end

end


function HeadView:vipBG(vipLevel)

    local cvdict = DICT_VIP[tostring(vipLevel)]

    local name_str = "_name"
    local lv_str = "_lv"
    local rect_str = "_rect"

    if self.model then
        name_str = "_playing"
        lv_str   = "_playing"
        rect_str = "_playing"
    end

    if cvdict then

        local currentNameImage  = "vip_"..cvdict.alias..name_str..".png"
        local currentLVImage    = "vip_"..cvdict.alias..lv_str..".png"
        local currentRectImage  = "vip_"..cvdict.alias..rect_str..".png"

        if cc.SpriteFrameCache:getInstance():getSpriteFrame(currentNameImage) then
            self.name_bg:setSpriteFrame(display.newSpriteFrame(currentNameImage))
        end
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(currentLVImage) then
            self.level_bg:setSpriteFrame(display.newSpriteFrame(currentLVImage))
        end
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(currentRectImage) then
            self.game_bg:setSpriteFrame(display.newSpriteFrame(currentRectImage))
        end
    elseif self.model then

        local image = "vip_playing.png"

        if cc.SpriteFrameCache:getInstance():getSpriteFrame(image) then
            self.name_bg:setSpriteFrame(display.newSpriteFrame(image))
        end
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(image) then
            self.level_bg:setSpriteFrame(display.newSpriteFrame(image))
        end
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(image) then
            self.game_bg:setSpriteFrame(display.newSpriteFrame(image))
        end
    end

end

function HeadView:getLevel()
    return tonumber(self.level:getString())
end

function HeadView:showWin()--展示win
    display.addSpriteFrames("lobby/lobby_head.plist","lobby/lobby_head.pvr.ccz")

    self.winTypeName:setVisible(true)
    if #app.showWinTable>0 then
        -- self.winTypeName:setSpriteFrame(display.newSpriteFrame(tostring(winName)..".png"))
        self.winTypeName:setSpriteFrame(display.newSpriteFrame(tostring(app.showWinTable[1])..".png"))
        display.getRunningScene():performWithDelay(function()
            table.remove(app.showWinTable,1)

            if #app.showWinTable > 0 then
                self:showWin()
            end
        end,5)
    else
        self.winTypeName:setVisible(false)
    end
    self.viewNode.animationManager:runAnimationsForSequenceNamed("win") 
end

function HeadView:showEnter()
    self.viewNode.animationManager:runAnimationsForSequenceNamed("enter")
end

function HeadView:showPlaying()

    --if true then self:showUserName() return end
    -- TODO
    self.nameNode:setVisible(true)
    self.levelNode:setVisible(false)
    self.gameNode:setVisible(false)
    self.name:setString("")

    self.adNode = cc.ClippingNode:create()
    self.clipNode:getParent():addChild(self.adNode)
    self.clipNode:removeFromParent(false)
    self.adNode:addChild(self.clipNode)

    local stencil=display.newSprite("#vip_cyc_bg.png")
    local size = stencil:getContentSize()
    --stencil:setPosition(pagePosX + pageWidth/2, pagePosY+pageHeight/2)

    self.adNode:setStencil(stencil)
    self.adNode:setInverted(false)
    self.adNode:setAlphaThreshold(0)
end

function HeadView:showUserLevel()
    self.nameNode:setVisible(false)
    self.levelNode:setVisible(true)
    self.gameNode:setVisible(false)

    if self.player.level then
        self.level:setString(tostring(self.player.level))
    end
end

function HeadView:showUserName()
    self.nameNode:setVisible(true)
    self.levelNode:setVisible(false)
    self.gameNode:setVisible(false)
    self.name:setString(self.player.name)
end

function HeadView:showGameName()
    self.nameNode:setVisible(false)
    self.levelNode:setVisible(false)
    self.gameNode:setVisible(true)
    self.name_icon:setString(self.player.name)
    local image = ICON_IMAGE[self.player.currentState + 1]
    if cc.SpriteFrameCache:getInstance():getSpriteFrame(image) then
        self.gameicon:setSpriteFrame(display.newSpriteFrame(image))
    end
end

function HeadView:registClickHead(isme,oldView)
    core.displayEX.newButton(self.clickBtn) 
        :onButtonClicked(function(event)

        self:onClicked(isme,oldView)

    end)  
end

function HeadView:onClicked(isme, oldView)

    if isme then
        scn.ScnMgr.addView("social.FriendInforView")
    else
        local function onComplete(infos)                
            scn.ScnMgr.addTopView("social.FriendInforView", oldView, {info=infos})
        end
        net.UserCS:getPlayerInfo(self.player.pid, onComplete)
    end
    
end

function HeadView:setButtonEnabled(val)
    self.clickBtn:setButtonEnabled(val)
end

function HeadView:replaceHead(headImage)

    local parent = headImage:getParent()

    local x, y = headImage:getPosition()
    headImage:removeFromParent()

    self:setPosition(cc.p(x, y))
    
    parent:addChild(self)

end


function HeadView:updateHeadImage(pictureId)
    self.pictureId = pictureId
    self:setHeadImage(pictureId)
end

function HeadView:updateUI()

    local model = app:getUserModel()
    local cls  =  model.class

    self.player = model:getProperties({
            cls.pid, 
            cls.name, 
            cls.level, 
            cls.exp, 
            cls.vipLevel, 
            cls.vipPoint, 
            cls.pictureId,
            cls.facebookId})

    -- body
    self.name:setString(self.player.name)
    --self.name_icon:setString(properties[cls.name])
    self:setHeadImage(self.player.pictureId)
    self.level:setString(tostring(self.player.level))

    self:vipBG(self.player.vipLevel)

end

function HeadView:setHeadImage(pictureId)

    print("setHeadImage",pictureId,self.player.facebookId)

    if tonumber(pictureId) == 0  then

        if string.len(self.player.facebookId) > 0 then


            core.FBPlatform.pushDownTask(self.player.facebookId,function( photoPath )
                -- body

                if io.exists(photoPath) then
                    
                    self.head:setTexture(photoPath)
                    
                    local headsize=self.head:getContentSize()
                    self.head:setScale(140/headsize.width)

                end
                
            end)
        end


    else

        local image = HEAD_IMAGE[tonumber(pictureId)]
        if image == nil then image = "head_00.png" end
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(image) then
            self.head:setSpriteFrame(display.newSpriteFrame(image))
        end

        local headsize=self.head:getContentSize()
        self.head:setScale(140/headsize.width)

    end

end

return HeadView

