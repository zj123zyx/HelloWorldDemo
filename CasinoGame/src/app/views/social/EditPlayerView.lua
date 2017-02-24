local View = class("EditPlayerView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function View:ctor(baseInfo,exInfo)
    self.viewNode  = CCBReaderLoad("lobby/social/edit_player.ccbi", self)
    self:addChild(self.viewNode)
    self:initInputText()

    self.baseInfo = baseInfo

    if baseInfo ~= nil then

        -- self.headview = headViewClass.new({player=self.baseInfo,    scale=0.8})
        -- self.headview:replaceHead(self.headBg)
        -- self.headview:showUserName()

        self.name_input:setText(baseInfo.name)
    end

    if exInfo ~= nil then
        --self.age_input:setText(exInfo.age)
        self.message_input:setText(exInfo.signature)
    end

    self:registerUIEvent()

    self:addHeadListView()
end


function View:registerUIEvent()
    core.displayEX.extendButton(self.btn_close)
    self.btn_close.clickedCall = function()
        scn.ScnMgr.removeTopView(self)
    end

    -- core.displayEX.extendButton(self.head_portrait_btn)
    -- self.head_portrait_btn.clickedCall =function()
    --     scn.ScnMgr.addView("social.EditHeadView")
    --     self:setVisible(false)
    -- end

    core.displayEX.extendButton(self.ok_btn)
    self.ok_btn.clickedCall = function()
        self:requestModify()
    end

end

local margin = 24

function View:touchHeadListener(event)
    
    if "pageChange" ==  event.name then

        local x = self.indicator_.firstX_ + (self.pv:getCurPageIdx() - 1) * margin
        transition.moveTo(self.indicator_, {x = x, time=0.1})

    elseif "clicked" == event.name then

        if event.item then


            local vipLevel = self.baseInfo.vipLevel

            if vipLevel >= event.item.unlockVipLevel then
                
                audio.playSound("audio/TapButton.mp3")

                for i,v in ipairs(self.pv.items_) do
                    if v then
                        v.cell.rectImage:setColor(cc.c4b(255,255,255,255))
                    end
                end

                event.item.cell.rectImage:setColor(cc.c4b(255,128,0,255))

                self.headIdx = event.item.pictureId
            else

            end

        end

    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        --print("event name:" .. event.name)
    end
end


function View:addHeadListView()
   
    local rect = self.headsNode:getCascadeBoundingBox()

    self.pv = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = cc.rect(rect.x, rect.y, rect.width, rect.height),
        direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
        scrollbarImgH = "#head_scroll.png"}
        :onTouch(handler(self, self.touchHeadListener))
        :addTo(self)



    -- add items
    local numHeads = #HEAD_IMAGE

    local vipLevel = self.baseInfo.vipLevel


    local addHeadItem = function(picIdx, preIdx)
        -- body
        local item = self.pv:newItem()

        local headView = CCBReaderLoad("lobby/social/head_sel.ccbi", self)
        headView.rectImage=self.rectImage

        local imagehead

        if picIdx == 0 then -- face book head

            local imagepath = device.writablePath..self.baseInfo.facebookId.."_square.png"
           
            if io.exists(imagepath) then
                self.headImage:setTexture(imagepath)
                self.headImage:setScale(140/100)
            end

        else
            imagehead = HEAD_IMAGE[picIdx]
            self.headImage:setSpriteFrame(imagehead)
        end


        local headsize=self.headImage:getContentSize()
        self.headImage:setScale(140/headsize.width)
        
        local unlockImageName
        local unlockVipLevel = 0

        if picIdx > 2 and picIdx < 5 and vipLevel < 1  then
            unlockImageName = "head_"..DICT_VIP[tostring(1)].alias..".png"
            unlockVipLevel = 1
        elseif picIdx > 4 and picIdx < 7 and vipLevel < 2 then
            unlockImageName = "head_"..DICT_VIP[tostring(2)].alias..".png"
            unlockVipLevel = 2
        elseif picIdx > 6 and picIdx < 9 and vipLevel < 3 then
            unlockImageName = "head_"..DICT_VIP[tostring(3)].alias..".png"
            unlockVipLevel = 3
        elseif picIdx > 8 and picIdx < 11  and vipLevel < 4 then
            unlockImageName = "head_"..DICT_VIP[tostring(4)].alias..".png"
            unlockVipLevel = 4
        elseif picIdx == 11 and vipLevel < 5 then
            unlockImageName = "head_"..DICT_VIP[tostring(5)].alias..".png"
            unlockVipLevel = 5
        end

        if unlockImageName then
            self.lockImage:setSpriteFrame(unlockImageName)
        else
            self.lockImage:setVisible(false)
        end

        headView:setScale(0.9)

        local itemsize = headView:getContentSize()

        if picIdx==preIdx then
            self.headIdx = preIdx
            self.rectImage:setColor(cc.c4b(255,128,0,255))
        end

        --headView:setPositionX(itemsize.width/2)
        headView:setPositionY(5)

        item.unlockVipLevel=unlockVipLevel
        item.cell=headView
        item.pictureId=picIdx

        item:addContent(headView)
        item:setItemSize(itemsize.width, itemsize.height)

        print(picIdx, itemsize.width, itemsize.height, unlockImageName)

        self.pv:addItem(item)

    end

    local model = app:getUserModel()
    local properties = model:getProperties({model.class.facebookId})
    local startIdx = 1

    if core.FBPlatform.getIsLogin() == true and  properties[model.class.facebookId] ~= nil  then
        startIdx = 0
    end

    for i=startIdx,  numHeads do
        addHeadItem(i,self.baseInfo.pictureId)
    end
    
    self.pv:reload()
end

function View:addHeadPagesView()

    -- body
    local rect = self.headsNode:getCascadeBoundingBox()
    local c,r = 4,1

    self.pv = cc.ui.UIPageView.new {
        viewRect = cc.rect(rect.x, rect.y, rect.width, rect.height),
        column = c, row = r,bCirc=true}
        :onTouch(handler(self, self.touchHeadListener))
        :addTo(self)


    -- add items
    local numHeads = #HEAD_IMAGE

    local vipLevel = self.baseInfo.vipLevel


    local addHeadItem = function(picIdx, preIdx)
        -- body
        local item = self.pv:newItem()

        local imagehead = HEAD_IMAGE[picIdx]

        local headView = CCBReaderLoad("lobby/social/head_sel.ccbi", self)

        headView.rectImage=self.rectImage

        self.headImage:setSpriteFrame(imagehead)
        
        local unlockImageName
        local unlockVipLevel = 0

        if picIdx > 6 and picIdx < 11 and vipLevel < 2  then
            unlockImageName = "head_"..DICT_VIP[tostring(2)].alias..".png"
            unlockVipLevel = 2
        elseif picIdx > 10 and picIdx < 14 and vipLevel < 3 then
            unlockImageName = "head_"..DICT_VIP[tostring(3)].alias..".png"
            unlockVipLevel = 3
        elseif picIdx > 13 and picIdx < 16  and vipLevel < 4 then
            unlockImageName = "head_"..DICT_VIP[tostring(4)].alias..".png"
            unlockVipLevel = 4
        elseif picIdx == 16 and vipLevel < 5 then
            unlockImageName = "head_"..DICT_VIP[tostring(5)].alias..".png"
            unlockVipLevel = 5
        end

        if unlockImageName then
            self.lockImage:setSpriteFrame(unlockImageName)
        else
            self.lockImage:setVisible(false)
        end

        headView:setScale(0.9)

        local itemsize = item:getContentSize()

        if picIdx==preIdx then
            self.headIdx = preIdx
            self.rectImage:setColor(cc.c4b(255,128,0,255))
        end

        headView:setPositionX(itemsize.width/2)
        headView:setPositionY(itemsize.height/2)

        item.unlockVipLevel=unlockVipLevel
        item.cell=headView
        item.pictureId=picIdx

        item:addChild(headView)
        self.pv:addItem(item)

    end

    --addHeadItem(self.baseInfo.pictureId, self.baseInfo.pictureId)

    for i=1,  numHeads do
        addHeadItem(i,self.baseInfo.pictureId)
        -- if i ~= self.baseInfo.pictureId then
        -- end
    end


    local pageNum,f = math.modf(numHeads/(c*r))
    if f > 0 then pageNum = pageNum +1 end

    -- add indicators
    local x = rect.width / 2 - ( margin * pageNum) / 2
    local y = 0

    self.indicator_ = display.newSprite(IMAGE_PNG.pageindacator_sel)
    self.indicator_:setPosition(x, y)
    self.indicator_:setScale(0.8)
    self.indicator_.firstX_ = x

    for pageIndex = 1, pageNum do
        local icon = display.newSprite(IMAGE_PNG.pageindacator_bg)
        icon:setPosition(x, y)
        icon:setScale(0.8)
        self.headsNode:addChild(icon)
        x = x + margin
    end

    self.headsNode:addChild(self.indicator_)

    
    self.pv:reload()

    -- local goPageIdx,f = math.modf(self.baseInfo.pictureId/(c*r))
    -- if f > 0 then goPageIdx = goPageIdx +1 end

    -- self.pv:gotoPage(goPageIdx)


end

function View:requestModify()

    local nameStr = self.name_input:getText()
    if string.trim(nameStr) == 0 then
        nameStr = "guest"
    end
    nameStr = string.trim(nameStr)
    
    --local ageStr = self.age_input:getText()
    local ageStr = "18"

    local messageStr = self.message_input:getText()
    messageStr = string.trim(messageStr)
    if string.len(messageStr) > 40 then
        messageStr = string.sub(messageStr,1,40)
    elseif string.len(messageStr) == 0 then
        messageStr = "No Status Message"
    end

    local model = app:getObject("UserModel")
    local cls = model.class
    local properties = model:getProperties({cls.extinfo})

    local ei = properties[cls.extinfo]
    ei[cls.ei.signature]   = messageStr
    ei[cls.ei.age]   = ageStr
    ei[cls.pictureId] = self.headIdx
    local properties = {}
    properties[cls.extinfo] = ei
    properties[cls.pictureId] = self.headIdx

    model:setProperties(properties)
    model:setName(nameStr)--内部已经有了model:serializeModel()
    local pid = model:getPid()

    --修改玩家信息，及时传递给服务器就可以了，不需要等待服务器传回返回值，才进行下面的操作，
    --把数据保存的本地就行了，这样界面会流畅许多
--    net.UserCS:modifyPlayerInfo(pid,nameStr,ei,function(rdata)
--        EventMgr:dispatchEvent({name=EventMgr.UPDATE_LOBBYUI_EVENT})
--        scn.ScnMgr.removeTopView(self)
--    end)
    net.UserCS:modifyPlayerInfo(pid,nameStr,ei)
    EventMgr:dispatchEvent({name=EventMgr.UPDATE_LOBBYUI_EVENT})
    scn.ScnMgr.removeTopView(self)
end

function View:initInputText()

    local model = app:getObject("UserModel")
    local cls = model.class
    local properties = model:getProperties({cls.extinfo,cls.name})


    local input = cc.ui.UIInput.new({
        image = "dating_shuzhi_kuang.png",
        size = cc.size(675, 40),
        fontSize = 12,
        listener = function(event,editbox)
            if event == "changed" then
                local str = editbox:getText()
                if string.len(str)> 40 then
                    editbox:setText(string.sub(str,1,40))
                end
            end
        end
    })
    input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    local parent = self.message_bg:getParent()
    parent:addChild(input)

    local x, y = self.message_bg:getPosition()
    input:setPosition(x, y)
    print("--message:", properties[cls.extinfo][cls.ei.signature])
    local message=properties[cls.extinfo][cls.ei.signature]
    if message == nil then message = "No Status Message" end
    input:setText(message)
    self.message_input = input

    input = cc.ui.UIInput.new({
        image = "dating_shuzhi_kuang.png",
        size = cc.size(200, 30),
        fontSize = 12,
        listener = function(event,editbox)
            if event == "changed" then
                local str = editbox:getText()
                if string.len(str)> 15 then
                    editbox:setText(string.sub(str,1,15))
                end
            end
        end
    })
    input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    parent = self.name_bg:getParent()
    parent:addChild(input)

    x, y = self.name_bg:getPosition()
    input:setPosition(x, y)
    input:setText(properties[cls.name])
    self.name_input = input

    -- input = cc.ui.UIInput.new({
    --     image = "dating_shuzhi_kuang.png",
    --     size = cc.size(138, 30),
    --     fontSize = 12,
    --     listener = function(event,editbox)
    --         if event == "changed" then
    --             local str = editbox:getText()
    --             print("age:",str,tonumber(str))
    --             if tonumber(str) ~= nil and string.len(str) > 5 then
    --                 editbox:setText(string.sub(str,1,-2))
    --             end
    --         end
    --     end
    -- })
    -- input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    -- input:setMaxLength(3)
    -- input:setInputMode(cc.EDITBOX_INPUT_MODE_DECIMAL)
    -- parent = self.age_bg:getParent()
    -- parent:addChild(input)

    -- x, y = self.age_bg:getPosition()
    -- input:setPosition(x, y)

    -- print("--age:", properties[cls.extinfo][cls.ei.age])
    -- local age=properties[cls.extinfo][cls.ei.age]
    -- if age == nil then age = "18" end
    -- input:setText(age)
    -- self.age_input = input
end


function View:onExit()
end


return View
