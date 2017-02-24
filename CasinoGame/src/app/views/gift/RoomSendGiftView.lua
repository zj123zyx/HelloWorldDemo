local RoomSendGiftView = class("RoomSendGiftView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function RoomSendGiftView:ctor(val)

    self.viewNode  = CCBReaderLoad("view/gifts_listview.ccbi", self)
    self:addChild(self.viewNode)
    

    self.playerNode = val.playerNode

    self:registerUIEvent()

    self:addGiftsListView()

end

function RoomSendGiftView:registerUIEvent()

    local pbtn = core.displayEX.newButton(self.btn_close)
        :onButtonClicked( function(event)
            scn.ScnMgr.removeView(self)
        end)

    core.displayEX.newButton(self.send_btn)
    :onButtonClicked( function(event)
        

        print("self.sendGIdx:",self.sendGIdx)

        self:setVisible(false)

        self:performWithDelay(function()

            local effect  = CCBReaderLoad(GIFTS_EFFECT[tonumber(self.sendGIdx)], self)
            effect:setScale(0.3)
            self.playerNode:addChild(effect)
        
            self:performWithDelay(function()

                effect:removeFromParent(true)
                scn.ScnMgr.removeView(self)

            end,1.0)

        end,0.5)


    end)

end

function RoomSendGiftView:addGiftsListView()
   
   display.addSpriteFrames("shared/shared_gifts1.plist",
                    "shared/shared_gifts1.pvr.ccz")

    local rect = self.giftsNodes:getCascadeBoundingBox()

    self.pv = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = cc.rect(rect.x, rect.y, rect.width, rect.height),
        direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
        --scrollbarImgH = "#head_scroll.png"
        }
        :onTouch(handler(self, self.toucGiftsListener))
        :addTo(self)



    -- add items
    local numGifts = #GIFTS_BTN_IMAGE


    local addGiftItem = function(giftid)
        -- body
        local item = self.pv:newItem()

        local imagegift = GIFTS_BTN_IMAGE[giftid]

        local giftItem = display.newSprite("#"..imagegift)

        giftItem:setScale(0.8)

        local itemsize = giftItem:getContentSize()

        giftItem:setPositionY(5)

        if giftid==1 then
            self.sendGIdx = 1
            giftItem:setColor(cc.c4b(255,128,0,255))
        end

        item.costGems=1
        item.cell=giftItem
        item.gId=giftid

        item:addContent(giftItem)
        item:setItemSize(itemsize.width, itemsize.height)

        self.pv:addItem(item)

    end

    for i=1,  numGifts do
        addGiftItem(i)
    end
    
    self.pv:reload()
end

function RoomSendGiftView:toucGiftsListener(event)
    
    if "clicked" == event.name then

        if event.item then

            audio.playSound("audio/TapButton.mp3")

            for i,v in ipairs(self.pv.items_) do
                if v then
                    v.cell:setColor(cc.c4b(255,255,255,255))
                end
            end

            event.item.cell:setColor(cc.c4b(255,128,0,255))

            self.sendGIdx = event.item.gId
        end

    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        --print("event name:" .. event.name)
    end
end

function RoomSendGiftView:onExit()
end

return RoomSendGiftView
