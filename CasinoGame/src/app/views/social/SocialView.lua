local FriendCell = require("app.views.social.FriendCell")

local tabBase = require("app.views.TabBase")

local View = class("SocialView", tabBase)

local margin = 40

function View:ctor(args)
    self.viewNode  = CCBReaderLoad("lobby/social/social.ccbi", self)
    self:addChild(self.viewNode)
    self:setNodeEventEnabled(true)
   
    if args.tabidx then
        self.selectedIdx = args.tabidx
    else
        self.selectedIdx = 1
    end

    self.tabNum=2


    self:initUI()
    self:registerUIEvent()
end


function View:initUI()

    if core.FBPlatform.getIsLogin() == true then
        
        self.fbStatus:setVisible(false)
        self.inviteStatus:setVisible(true)

    else

        self.fbStatus:setVisible(true)
        self.inviteStatus:setVisible(false)

    end

end

function View:registerUIEvent()

    self:addTabEvent(1,function()
        self:showFriends()
    end)

    self:addTabEvent(2,function()
        self:showPlayers()
    end)

    core.displayEX.extendButton(self.closeBtn)
    self.closeBtn.clickedCall = function()
        scn.ScnMgr.removeView(self)
    end

    core.displayEX.extendButton(self.fbBtn)
    self.fbBtn.clickedCall = function()

        core.FBPlatform.onLoginImpl(function()
                -- body
                print("----onLoginImpl-EnterGame------")
    
                net.UserCS:EnterGame(function()
                    -- body
                    app.logining = false
                    self.fbStatus:setVisible(false)
                    self.inviteStatus:setVisible(true)
                    EventMgr:dispatchEvent({name=EventMgr.UPDATE_LOBBYUI_EVENT})
                end)

            end)
    end

    core.displayEX.extendButton(self.inviteBtn)
    self.inviteBtn.clickedCall = function()
        self:doInvite()
    end

    core.displayEX.extendButton(self.prepageBtn)
    self.prepageBtn.clickedCall = function()


        if true then             
            self.pageView:getPageCount(2, true)
            return
        end

        local pageIdx = self.pageView:getCurPageIdx()

        print("pageIdx",pageIdx)

        if pageIdx - 1 > 0 then

            pageIdx = pageIdx - 1

            self.pageView:getPageCount(pageIdx, true)

            local x = self.indicator_.firstX_ + pageIdx * margin
            transition.moveTo(self.indicator_, {x = x, time=0.1})

        else
            return
        end

    end

    core.displayEX.extendButton(self.nextpageBtn)
    self.nextpageBtn.clickedCall = function()
            

        if true then             
            self.pageView:getPageCount(2, true)
            return
        end

        local pageIdx = self.pageView:getCurPageIdx()
        local pageCnt = self.pageView:getPageCount() 

        print("pageIdx",pageIdx, pageCnt)

        if pageIdx + 1 <= pageCnt then
            pageIdx = pageIdx + 1

            self.pageView:getPageCount(pageIdx, true)

            local x = self.indicator_.firstX_ + pageIdx * margin
            transition.moveTo(self.indicator_, {x = x, time=0.1})

        else
            return
        end


    end

end

function View:doInvite()
    local params = {
        message = "Play new vegas casino game, Go Go!!!!",
        title   = "Invite friend & reward lots of coins",
    }

    core.FBPlatform.appRequest(params, function( ret, msg )
        local invite = json.decode(msg)
        table.dump(invite, "invite")
        if invite.error_message then
        else
            local model = app:getObject("UserModel")
            local noRepeatFriendNum = 0
            
            for _,pid in pairs(invite.to) do
                if model:InviteFrendsMgr(pid) == 0 then
                    noRepeatFriendNum = noRepeatFriendNum + 1
                end
            end
            
            table.dump(model:InviteFrends(),"-------InviteFrends--"..noRepeatFriendNum)
            if noRepeatFriendNum > 0 then
                model:serializeModel()
                local totalCoins = app:getUserModel():getCoins() + 1000 * noRepeatFriendNum
                app:getUserModel():setCoins(totalCoins)
                EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
            end
        end
    end)
end

function View:showFriends(isUpdate)
    self:showTab(1)
    if isUpdate and self.friendList ~= nil then
        self.friendList:removeAllItems()
        self.friendList:removeSelf(true)
        self.friendList = nil
    end

    if  self.friendList == nil then
        local function onComplete(lists)

            print("friend num:", #lists)
            if 0 == #lists then
                self.infoTxt:setVisible(true)
            else
                self.infoTxt:setVisible(false)
                self:addFriendList(lists)
            end
        end
        net.FriendsCS:getFriendsList(onComplete)
    end
end

function View:showPlayers()
    self:showTab(2)

    if self.pageView == nil then
        local function onComplete(lists)
            self:addPlayerList(lists)
        end
        net.FriendsCS:getOnlinePlayers(onComplete)
    end
end


function View:addPlayerList(list)
    local container = self.playerRect:getParent()
    local box = self.playerRect:getBoundingBox()
    local c,r = 4,2
    self.pageView = cc.ui.UIPageView.new {
        viewRect = box,
        column = c, row = r,
    }
    :onTouch(handler(self, self.onPlayerlistListener))
    :addTo(container)

    local len = #list

    for i=1,len do
        local item = self.pageView:newItem()
        local cell = headViewClass.new({player=list[i],scale=1.0})
        cell:showGameName()
        cell:setTag(99)

        local itemsize = item:getContentSize()

        cell:setPositionX(itemsize.width/2)
        cell:setPositionY(itemsize.height/2)

        item:addChild(cell)
        self.pageView:addItem(item)
    end

    local pageNum,f = math.modf(len/(c*r))
    if f > 0 then pageNum = pageNum +1 end

    -- add indicators
    local x = -( margin * (pageNum-1) )/ 2
    local y = -box.height/2 - 65

    self.indicator_ = display.newSprite(IMAGE_PNG.pageindacator_sel)
    self.indicator_:setPosition(x, y)
    self.indicator_.firstX_ = x

    for pageIndex = 1, pageNum do
        local icon = display.newSprite(IMAGE_PNG.pageindacator_bg)
        icon:setPosition(x, y)
        container:addChild(icon)
        x = x + margin
    end

    container:addChild(self.indicator_)

    self.pageView:reload()
end

function View:onPlayerlistListener(event)

    print("player page view 1")

   if "pageChange" ==  event.name then
       local x = self.indicator_.firstX_ + (self.pageView:getCurPageIdx() - 1) * margin
       transition.moveTo(self.indicator_, {x = x, time=0.1})
   elseif "clicked" == event.name then

        print("player page view 2")

        if event.item then
            print("player page view 3")

            local cell = event.item:getChildByTag(99)
            cell:onClicked(false, self)
        end

   elseif "moved" == event.name then
       self.bListViewMove = true
   elseif "ended" == event.name then
       self.bListViewMove = false
   else
       --print("event name:" .. event.name)
   end
end

function View:addFriendList(list)

    local box = self.friendRect:getBoundingBox()
    self.friendList = cc.ui.UIListView.new {
        bg = nil,
        bgScale9 = false,
        viewRect = box,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onFriendlistListener))
    self.friendList:addTo(self.friendRect:getParent())

    -- add items
    local listnum = #list
    --listnum = 5
    for i=1, listnum do
        local data = list[i]
        local item = self.friendList:newItem()
        local cell = FriendCell.new(data,self)
        local itemsize = cell:getContentSize()

        item:addContent(cell)
        item:setItemSize(itemsize.width, itemsize.height+10)
        item:setTouchSwallowEnabled(false)
        self.friendList:addItem(item)
    end
    self.friendList:reload()
end


function View:onFriendlistListener(event)
    if "clicked" == event.name and event.item then
        local cell = event.item:getContent()
        cell:checkClick(cc.p(event.x, event.y))
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        --print("event name:" .. event.name)
    end
end


function View:onEnter()
    self:showFriends()
end

function View:onExit()
    self = {}
end

return View