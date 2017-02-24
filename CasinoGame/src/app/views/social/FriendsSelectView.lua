local View = class("FriendsSelectView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

local cell_path = "lobby/social/select_player_cell.ccbi"

function View:ctor(list, giftType, gift)
    self.viewNode  = CCBReaderLoad("lobby/social/select_player.ccbi", self)
    self:addChild(self.viewNode)

    self.flist = list
    self.gift = gift
    self.giftType = giftType
    self:registerEvent()
    self:initUI()
end

function View:registerEvent()
    core.displayEX.newButton(self.btn_close)
        :onButtonClicked(function(event)
            scn.ScnMgr.removeView(self)
        end)

    core.displayEX.newButton(self.btn_sendgifts)
        :onButtonClicked(function(event)
            self:doSend()
        end)

    core.displayEX.addSpriteEvent(self.off_select_all_sp,function()
        self:doChangeSelectAll()
    end)
end

function View:doSend()
    local list = self:getSlected()
    if #list > 0 then
        local callback = function()
            net.GiftsCS:sendGift(list, self.giftType, tonumber(self.gift.gift_id), function( msg )
                if msg.result == 1 then
                    scn.ScnMgr.addView("CommonView",
                        {
                            onlyContent=true,
                            content="Success!",
                        })
                    local totalCoins = app:getUserModel():getCoins() - msg.costCoins
                    local totalGems = app:getUserModel():getGems() - msg.costGems
                    app:getUserModel():setCoins(totalCoins)
                    app:getUserModel():setGems(totalGems)
                    EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                else
                    scn.ScnMgr.addView("CommonView",
                        {
                            onlyContent=true,
                            content="Gift giving failure.",
                        })
                end
            end)
            scn.ScnMgr.removeView(self)
        end

        if tonumber(self.gift.gift_id) == 1 or tonumber(self.gift.gift_id) == 2 then
            callback()
        else
            self:SendGiftCostMoneyTip(self.gift,#list,callback)
        end
    else
        scn.ScnMgr.addView("CommonView",
                            {                        
                                onlyContent=true,
                                content="Please choose your friends!!!"
                            })
    end
end


function View:doChangeSelectAll(event)
    local allvisible = self.on_select_all_sp:isVisible()
    self.on_select_all_sp:setVisible(not allvisible)
    if self.friendsList then
        for i=1,#self.friendsList.items_ do
            local it = self.friendsList.items_[i]
            for j=1,#it.cells do
                local cell = it.cells[j]
                cell.on_select_sp:setVisible(not allvisible)
            end
        end
    end
end

function View:initUI()
    self.on_select_all_sp:setVisible(false)
    if #self.flist > 0 then
        self:addFriendsList()
    end
end

function View:getSlected()
    local selfriendlist = {}
    if self.friendsList then
        for i=1,#self.friendsList.items_ do
            local it = self.friendsList.items_[i]
            for j=1,#it.cells do
                local cell = it.cells[j]
                local visible = cell.on_select_sp:isVisible()
                if visible == true then
                    selfriendlist[#selfriendlist + 1] = cell.info
                end
            end
        end
    end
    return selfriendlist
end

function View:addFriendsList()
    self.rect = self.content_rect:getBoundingBox()
    self.friendsList = cc.ui.UIListView.new {
        bg = nil,
        bgScale9 = false,
        viewRect = self.rect,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onFriendslistListener))
        :addTo(self.content_rect:getParent())

    -- add items
    local rownum = math.ceil((#self.flist )/2)
    for i=1, rownum do
        local item = self.friendsList:newItem()
        local content = display.newNode()
        item.cells = {}

        local numCells = 4
        local size
        for cellidx = 1, numCells do
            local idx = (i-1)*2 + cellidx
            local fdata = self.flist[idx]

            print("fdata", fdata,rownum,numCells)

            if fdata then
                local cellOwner = {}
                local cell  = CCBReaderLoad(cell_path, cellOwner)
                size = cell:getContentSize()
                local posX = 5
                if cellidx == 1 then
                    posX = -size.width -5
                end

                local headView = headViewClass.new({player=fdata,scale=0.8})
                headView:replaceHead(cellOwner.headImage)
                headView:showGameName()

                cell.on_select_sp = cellOwner.on_select_sp
                cell.info = fdata

                cellOwner.name_text:setString(fdata.name)
                cellOwner.on_select_sp:setVisible(false)

                cell:setPositionX(posX)
                cell:setPositionY(-size.height/2)
                content:addChild(cell)
                cell.idx = idx
                item.cells[cellidx] = cell

            end

        end
        item:addContent(content)
        item:setItemSize(self.rect.width+10, size.height + 10)
        self.friendsList:addItem(item)
    end

    self.friendsList:setDelegate(handler(self, self.friendsListDelegate))
    self.friendsList:reload()
end

function View:onFriendslistListener(event)

    if "clicked" == event.name and event.item then
        for i=1,#event.item.cells do
            local cell = event.item.cells[i]

            if cell:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) then
                local visible = cell.on_select_sp:isVisible()
                cell.on_select_sp:setVisible(not visible)
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

function View:friendsListDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
    elseif cc.ui.UIListView.CELL_TAG == tag then
    else
    end
end

function View:SendGiftCostMoneyTip(data,frendNum,callback)
    local unit
    local totalCoins = app:getUserModel():getCoins()
    local totalGems = app:getUserModel():getGems()
    local costMoney = tonumber(data.price)*frendNum
    if data.currency == "1000" then
        if costMoney > 1 then
            unit = " coins"
        else
            unit = " coin"
        end
        if totalCoins < costMoney then
            scn.ScnMgr.addView("ShortCoinsView",{})
            return
        end
    else
        if costMoney > 1 then
            unit = " gems"
        else
            unit = " gem"
        end
        if totalGems < costMoney then
            scn.ScnMgr.addView("ShortGemsView",{})
            return
        end
    end
    local money = costMoney .. unit
    local str = "Would you like to spend " .. money..
            " buying " .. data.name .." to your friends?"
    scn.ScnMgr.addView("CommonTip",{ok_callback = callback,
        content=str})
end

return View