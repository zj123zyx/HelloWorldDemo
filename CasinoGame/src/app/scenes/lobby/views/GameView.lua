
--[[--
“Game” `s view
]]
local LobbyCell = require("app.scenes.lobby.views.LobbyCell")

local GameView = class("GameView", function()
    return display.newNode()
end)

function GameView:ctor(args)

    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    --local cls = user.class

    -- 通过代理注册事件的好处：可以方便的在视图删除时，清理所以通过该代理注册的事件，
    -- 同时不影响目标对象上注册的其他事件
    --
    -- EventProxy.new() 第一个参数是要注册事件的对象，第二个参数是绑定的视图
    -- 如果指定了第二个参数，那么在视图删除时，会自动清理注册的事件
    --cc.EventProxy.new(user, self)
    --    :addEventListener(cls.GEM_CHANGED_EVENT, handler(self, self.updateLabel_))

    self:setNodeEventEnabled(true)

    self.hasUpdate = false

    self.args=args

    self.viewCtr  = CCBuilderReaderLoad("lobby/game_ctr.ccbi", self)
    self.gameRect = cc.rect(0,0,0,0)
    self.messageHint3:setZOrder(100)
    app.coinSprite = self.coinSprite
    app.gemSprite = self.gemSprite

    local lsize = self.left:getContentSize()
    local rsize = self.right:getContentSize()
    local tsize = self.top:getContentSize()
    local bsize = self.bottom:getContentSize()

    local delatPixel = 30

    self.gameRect.x = 0
    self.gameRect.y = bsize.height + 30 - (760 - display.height) * 0.08

    self.gameRect.width = display.width
    self.gameRect.height = display.height - tsize.height - bsize.height - 60 * display.height/700

    self:addChild(self.viewCtr)

    self:loadFreeBonus()


    self:Layout()

    self:layoutBottomCtrBtn()
    --self.btn_lobby:setVisible(false)

    core.displayEX.newButton(self.coin_btn)
    :onButtonClicked(function(event)
        net.PurchaseCS:GetProductList(function(lists)
            scn.ScnMgr.popView("ProductsView",{productList=lists,tabidx=1})
        end)
    end)
    core.displayEX.newButton(self.gem_btn)
    :onButtonClicked(function(event)
        net.PurchaseCS:GetProductList(function(lists)
            scn.ScnMgr.popView("ProductsView",{productList=lists,tabidx=2})
        end)
    end)

end

function GameView:loadFreeBonus()--免费金币

    self.freebonusCCB  = CCBuilderReaderLoad("lobby/cell/cell_freebouns.ccbi", self)
    LobbyCell.extendFreeBonus(self.freebonusCCB, self)
    self.freebonusNode:addChild(self.freebonusCCB)
    
end

function GameView:layoutBottomCtrBtn()

    local sizeDist = 15

    local sideWidth = ( display.width - 350 - 20 ) / 2

    -- left
    local sizeSocial = self.btn_social:getContentSize()
    local sizeSpecialAD = self.btn_specialAD:getContentSize()

    local adCellNum = sizeSpecialAD.width/sizeSocial.width

    local seprateCellWidth = sideWidth/(1 + adCellNum)

    local posX = sizeDist + seprateCellWidth/2

    self.btn_social:setPositionX(posX)

    local posX = sizeDist + seprateCellWidth + seprateCellWidth*adCellNum/2

    self.btn_specialAD:setPositionX(posX)

    -- right

    local sizeRBottom = self.bottom_right:getContentSize()
    local sizeGifts = self.btn_gifts_labby:getContentSize()
    local sizeStore = self.btn_store_node:getContentSize()

    local adCellNum = sizeStore.width/sizeGifts.width

    local seprateCellWidth = sideWidth/(1 + adCellNum)

    local posX = sizeRBottom.width - ( sizeDist + seprateCellWidth/2 )

    self.btn_gifts_labby:setPositionX(posX)

    local posX = sizeRBottom.width - ( sizeDist + seprateCellWidth + seprateCellWidth*adCellNum/2 )

    self.btn_store_node:setPositionX(posX)


end

function GameView:onTouch(p)

    local isTouchedBtn = function( btn, anchor)
        -- body
        local tSize = btn:getContentSize()
        local tPos = btn:getParent():convertToWorldSpace(cc.p(btn:getPosition()))
      
        local rect
        if anchor then
            rect= cc.rect(tPos.x, tPos.y, tSize.width, tSize.height)
        else
            rect= cc.rect(tPos.x - tSize.width / 2, tPos.y - tSize.height / 2, tSize.width, tSize.height)
        end

        return cc.rectContainsPoint(rect, p)
    end

    if isTouchedBtn(self.btn_menus) == false and isTouchedBtn(self.btn_option) == false and 
       isTouchedBtn(self.btn_message) == false then
        
        if isTouchedBtn(self.menuBg, true) == false then
            self.menus_node:setVisible(false)
        end
        
    end
end

function GameView:onEnter()
    app.controllBar = self

    self:initExp()
    self:initHead()
    self:updateUILabel()

    EventMgr:addEventListener(EventMgr.UPDATE_LOBBYUI_EVENT, handler(self, self.updateUILabel))
    EventMgr:addEventListener(EventMgr.SERVER_NOTICE_EVENT, handler(self, self.updateNotice))
    EventMgr:addEventListener(EventMgr.UPDATE_FRIENDS_EVENT, handler(self, self.updateFriends))
end

function GameView:onExit()
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_LOBBYUI_EVENT)
    EventMgr:removeEventListenersByEvent(EventMgr.SERVER_NOTICE_EVENT)
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_FRIENDS_EVENT)
    app.controllBar = nil
end

function GameView:updateNotice(event)
    local model = app:getUserModel()
    local hasNum = tonumber(event.hasnews)
    print("游戏大厅 notify:", hasNum)

    audio.playSound(RES_AUDIO.new_message)

    if hasNum == 1 or hasNum == 2 or hasNum == 3 or hasNum == 7 then
        model:setProperties({hasnews=hasNum})
        self.messageHint:setVisible(true)
        self.messageHint1:setVisible(true)
    elseif hasNum == 4 then --礼物
        model:setProperties({hasgift=hasNum})
        self.messageHint3:setVisible(true)
    elseif hasNum == 5 then --荣誉
        model:setProperties({hashonor=hasNum})
        self.messageHint2:setVisible(true)
    elseif hasNum == 6 then --任务 
        model:setProperties({hastask=hasNum})
    end
    model:serializeModel()
end

function GameView:updateFriends(event)
    self.friends = event.list

    local getInfo =function(pid)
        -- body
        for i=1,#self.friends do
            local info = self.friends[i]
            if pid == info.pid then
                return info
            end
        end
    end

    if self.hasUpdate == false then
        -- for i=1,#self.friendsList.items_ do
        --     local item = self.friendsList.items_[i]
        --     local info = self.friends[i]
        --     if info then
        --         item.pid = info.pid
        --         item.name:setString(info.name)
        --         item.head:setSpriteFrame(HEAD_IMAGE[info.pictureId])
        --     end
        -- end
        -- self:addFriendList()
        -- self.hasUpdate = true

    else

        for i=1,#self.friendsList.items_ do
            local item = self.friendsList.items_[i]
            local info = getInfo(item.pid)
            if info then
                item.name:setString(info.name)
                if cc.SpriteFrameCache:getInstance():getSpriteFrame(HEAD_IMAGE[info.pictureId]) then
                    item.head:setSpriteFrame(display.newSpriteFrame(HEAD_IMAGE[info.pictureId]))
                end
            end
           
        end
    end

end


function GameView:initHead()
    -- body
    local model = app:getUserModel()
    local cls   =   model.class

    local properties = model:getProperties({
            cls.pid, 
            cls.name, 
            cls.level, 
            cls.vipLevel, 
            cls.pictureId,
            cls.facebookId})


    self.headview = headViewClass.new({player=properties,scale=0.5})
    self.headview:replaceHead(self.headNode)
    self.headview:showUserLevel()
    self.headview:registClickHead(true)

end

function GameView:updateUILabel(event)
    
    local model = app:getUserModel()
    local cls   =   model.class

    local properties = model:getProperties({
            cls.pid, 
            cls.name, 
            cls.level, 
            cls.exp, 
            cls.vipLevel, 
            cls.vipPoint, 
            cls.coins, 
            cls.gems, 
            cls.money,
            cls.pictureId,
            cls.hasnews,
            cls.musicSign,
            cls.soundSign,
            cls.hasgift,
            cls.hashonor,
            cls.hastask,
    })
    print("update:",properties[cls.name], properties[cls.level],properties[cls.gems],properties[cls.coins],properties[cls.exp])

    if properties[cls.gems] then
        self.gemLabel:setString(number.addCommaSeperate(core.displayEX.formatLongTextNumber(properties[cls.gems])))
    end

    if properties[cls.coins] then
        self.coinLabel:setString(number.addCommaSeperate(core.displayEX.formatLongTextNumber(properties[cls.coins])))
    end

    if properties[cls.name] then
        self.userName:setString(tostring(properties[cls.name]))
    end

    if properties[cls.level] then
        --self.levelLabel:setString(tostring(properties[cls.level]))
    end

    if properties[cls.exp] then
        self.expLabel:setString(tostring(properties[cls.exp]))
    end

    if properties[cls.soundSign] == 1 then --音效
        audio.setSoundsVolume(1)
    else
        audio.setSoundsVolume(0)
    end

    if properties[cls.musicSign] == 1 then --背景音乐
        audio.setMusicVolume(0.4)
    else
        audio.setMusicVolume(0)
    end

    if properties[cls.hasnews] >= 1 and properties[cls.hasnews] <= 3 then
        self.messageHint:setVisible(true)
        self.messageHint1:setVisible(true)
    else
        self.messageHint:setVisible(false)
        self.messageHint1:setVisible(false)
    end

    if properties[cls.hasgift] == 4 then
        self.messageHint3:setVisible(true)
    else
        self.messageHint3:setVisible(false)
    end

    if properties[cls.hashonor] == 5 then
        self.messageHint2:setVisible(true)
    else
        self.messageHint2:setVisible(false)
    end

    if properties[cls.hastask] == 6 then
    end

    if event then
        local pc1, pc2, levelup, levelcount = AnimationUtil.getTwoPercentage(
            self.expProgress:getPercentage(), 
            self.headview:getLevel(), 
            properties[cls.level], 
            model:getCurrentLvExp())
        --self:setExpProgress(pc1, pc2, levelup, 1)
        AnimationUtil.progressMoveTo(self.expProgress, pc1, pc2, levelcount)
        if levelup == true then
            local callback = function()
                local level = tonumber(properties[cls.level])
                if core.FBPlatform.getUid() == nil and level == 8 or level == 12 then
                    scn.ScnMgr.popView("FBConnectView",{coins = CONNECTFB_REWARD_COINS})
                end
                local model = app:getObject("UserModel")
                local properties = model:getProperties({model.rateSign})
                if properties.rateSign == nil or properties.rateSign == 0 then
                    if level == 4 or level == 7 or level == 9 or level == 11 then
                        scn.ScnMgr.popView("RateOnUs",{coins = 2000})
                    end
                end
            end
            scn.ScnMgr.popView("LevelUpView",{level = properties[cls.level],callback = callback})
        end
    end

    local vipdict = DICT_VIP[tostring(properties[cls.vipLevel])]
    
    if vipdict then
        local vipoImage="dating_vip_"..vipdict.alias..".png"
        local images = {}
        images.n=vipoImage
        images.s=vipoImage
        images.d=vipoImage
        
        core.displayEX.setButtonImages(self.btn_vip, images)
    end
        
    if self.headview then
        self.headview:updateUI()
    end
    
end

function GameView:initExp()
    local model = app:getUserModel()

    local exp = model:getCurrentLvExp()
    local lvl = model:getLevel()

    -- expProgress
    local expX,expY = self.expSprite:getPosition()
    local parent = self.expSprite:getParent()
    
    self.expSprite:removeFromParent(false)

    self.expProgress = display.newProgressTimer(self.expSprite, display.PROGRESS_TIMER_BAR)
        :pos(expX, expY)
        :addTo(parent)

    self.expProgress:setMidpoint(cc.p(0, 0))
    self.expProgress:setBarChangeRate(cc.p(1, 0))

    local lexp = tonumber(getNeedExpByLevel(lvl+1))
    self.expProgress:setPercentage(100 * exp / lexp)

    self.expLabel:enableOutline(cc.c4b(64, 64, 64, 255), 1);

    
end

function GameView:setExpProgress( from, to, levelup, time)
    
    if time == nil then time = 1 end

    self.expProgress:setPercentage(from)

    if levelup == true then

        local fromTo1 = cca.progressFromTo(time, from, 100)
        local fromTo2 = cca.progressFromTo(time, 0, to)

        local complete = function()
            self.expProgress:setPercentage(0)
        end
        local callfun = cc.CallFunc:create(complete)

        local seq = cc.Sequence:create(fromTo1, callfun, fromTo2)

        self.expProgress:runAction(seq)

    else

        local fromTo = cca.progressFromTo(time, from, to)
        local seq = cc.Sequence:create(fromTo)
        self.expProgress:runAction(seq)

    end

end

function GameView:getTwoPercentage(exp, lvl)

    local nextlvl = lvl + 1
    
    local pc1 = self.expProgress:getPercentage()
    local lexp = tonumber(getLevelExpByLevel(nextlvl))

    local pc2 = 100 * exp / lexp

    local pastlevel = tonumber(self.levelLabel:getString())
    local levelup = false
    if lvl > pastlevel then levelup = true end

    return pc1, pc2, levelup
end

-- will delete function
function GameView:addFriendList()

    local friendlistrect = {}

    friendlistrect.node = self.friendslistNode
    local parent = self.friendslistNode:getParent()
    friendlistrect.org = parent:convertToWorldSpace(cc.p(self.friendslistNode:getPosition()))
    friendlistrect.size = self.friendslistNode:getContentSize()

    local topheight = self.fdTopRect:getContentSize().height
    local bottomheight = self.fdBottomRect:getContentSize().height

    friendlistrect.org.y = friendlistrect.org.x + bottomheight
    friendlistrect.size.height = display.height - bottomheight - topheight

    print(friendlistrect.org.x, friendlistrect.org.y, friendlistrect.size.width, friendlistrect.size.height)

    local rect = CCRect(friendlistrect.org.x, friendlistrect.org.y, friendlistrect.size.width, friendlistrect.size.height)

    self.friendsList = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = cc.rect(friendlistrect.org.x, friendlistrect.org.y, friendlistrect.size.width, friendlistrect.size.height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onFriendlistListener))
        :addTo(self.friendslistNode)


    local cellnum = 0
    if self.friends ~= nil then
        cellnum = #(self.friends)
    end
    
    for i=1, cellnum do
        local item = self.friendsList:newItem()

        local cell = CCBuilderReaderLoad(RES_CCBI.cell_friend, self)

        item.name = self.name
        item.head = self.head
        item.pid = -1

        if self.friends then
            local friend = self.friends[i]
            item.pid = friend.pid
            item.name:setString(friend.name)
            if cc.SpriteFrameCache:getInstance():getSpriteFrame(HEAD_IMAGE[friend.pictureId]) then
                item.head:setSpriteFrame(display.newSpriteFrame(HEAD_IMAGE[friend.pictureId]))
            end
        end

        local itemsize = cell:getContentSize()

        item:addContent(cell)
        item:setPositionX(friendlistrect.size.width/2)
        item:setItemSize(itemsize.width, itemsize.height*1.02)

        self.friendsList:addItem(item)
    end

    self.friendsList:setDelegate(handler(self, self.gameListDelegate))
    self.friendsList:reload()

end

function GameView:onFriendlistListener(event)

    local listView = event.listView
    if "clicked" == event.name then

        self:dispatchEvent({name = "onTapFriendCell", cell=event.item})

    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        print("event name:" .. event.name)
    end

end

function GameView:friendListDelegate(listView, tag, idx)
    -- print(string.format("TestUIListViewScene tag:%s, idx:%s", tostring(tag), tostring(idx)))
    -- if cc.ui.UIListView.COUNT_TAG == tag then
    --     return 50
    -- elseif cc.ui.UIListView.CELL_TAG == tag then
    --     local item
    --     local content

    --     item = self.friendsList:dequeueItem()
    --     if not item then
    --         item = self.friendsList:newItem()
    --         content = cc.ui.UILabel.new(
    --                 {text = "item"..idx,
    --                 size = 20,
    --                 align = cc.ui.TEXT_ALIGN_CENTER,
    --                 color = display.COLOR_WHITE})
    --         item:addContent(content)
    --     else
    --         content = item:getContent()
    --     end
    --     content:setString("item:" .. idx)
    --     item:setItemSize(120, 80)

    --     return item
    -- else
    -- end
end

return GameView
