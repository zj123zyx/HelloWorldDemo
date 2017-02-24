local GiftCell = require("app.views.social.PlayerGiftCell")
local HonorCell = require("app.views.HonorCell")

local tabBase = require("app.views.TabBase")

local FriendInforView = class("FriendInforView", tabBase)

function FriendInforView:ctor(val)
    self.viewNode  = CCBReaderLoad("lobby/social/player_info.ccbi", self)
    self:addChild(self.viewNode)


    if val and val.info ~= nil then
        self.isme = false
        self.tabNum=4

        self:addChild(CCBReaderLoad("lobby/social/player_info_tab4.ccbi", self))

        self.exInfo = val.info.extendInfo
        self.baseInfo = val.info
        self.canAddFriend = val.info.canAddFriend
    else
        self.isme = true
        self.tabNum=3

        self:addChild(CCBReaderLoad("lobby/social/player_info_tab3.ccbi", self))

        local model = app:getObject("UserModel")
        local cls = model.class
        local properties = model:getProperties({cls.pid, cls.serialNo, cls.name, cls.level, cls.exp, cls.vipLevel, cls.vipPoint, cls.coins, cls.gems, cls.money, cls.liked, cls.pictureId, cls.facebookId, cls.extinfo})

        self.exInfo=properties[cls.extinfo]
        
        self.baseInfo=properties
        app:getObject("ReportModel"):sendReportBaseInfo()
    end
    if val and val.tabidx ~= nil then
        self.selectedIdx = val.tabidx
    else
        self.selectedIdx = 1
    end
    
    self:registerUIEvent()

    self.gifted = false
    self.stats = false
    self.honor = false
    self.giftSelected = false

    self:initExp()
    self:showProfile()

    local model = app:getUserModel()
    local cls   =   model.class

    local properties = model:getProperties({
            cls.pid, 
            cls.name, 
            cls.hasgift,
            cls.hashonor,
            cls.hastask,
    })

    if self.isme == true then
        if properties[cls.hasgift] == 4 then
            self.redtip_gift:setVisible(true)
        else
            self.redtip_gift:setVisible(false)
        end
    end
   
end


function FriendInforView:registerUIEvent()

    self:addTabEvent(1,function()
        self:showProfile()
    end)

    self:addTabEvent(2,function()
        self:showRecord()
    end)

    self:addTabEvent(3,function()
        self:showGift()
    end)

    if self.isme == false then

        self:addTabEvent(4,function()
            self:showHonor()
        end)
    
    end

    local pbtn = core.displayEX.newButton(self.btn_close)
        :onButtonClicked( function(event)
            scn.ScnMgr.removeView(self)
        end)

    local pbtn = core.displayEX.newButton(self.invite_btn)
        :onButtonClicked( function(event)
            net.FriendsCS:addFriend(self.baseInfo.pid)
            scn.ScnMgr.addView("CommonView",
                {
                    title="Add friend",
                    content="The request has been sent to "..self.baseInfo.name..". Please wait for the reply."
                })
        end)

    core.displayEX.newButton(self.join_btn)
    :onButtonClicked( function(event)
        print("进入好友的游戏" .. self.baseInfo.pid,self.baseInfo.gameId)
        app:joinPlayerGame({gameId = self.baseInfo.gameId,senderPid = self.baseInfo.pid,roomId = -1,siteId=-1})
    end)

    core.displayEX.newButton(self.edit_btn)
    :onButtonClicked( function(event)
        print("修改头像")
        scn.ScnMgr.addTopView("social.EditPlayerView",self, self.baseInfo,self.exInfo)

    end)

    core.displayEX.newButton(self.send_btn)
    :onButtonClicked( function(event)
        print("向好友赠送礼物")
        scn.ScnMgr.addTopView("gift.GiftsView",self,{pid=self.baseInfo.pid,sendGiftFlag = self.baseInfo.sendGiftFlag})
    end)

    core.displayEX.newButton(self.sendmsg_btn)
    :onButtonClicked( function(event)
        print("向玩家发送消息")
        scn.ScnMgr.addTopView("social.SendMessageView",self, self.baseInfo)
    end)

    EventMgr:addEventListener(EventMgr.UPDATE_LOBBYUI_EVENT, handler(self, self.doChangePlayerInfo))

end

function FriendInforView:doChangePlayerInfo()
    if self.isme == false then
        print("===不是自己 不用更新===")
        return
    end
    print("doChangePlayerInfo")    
    if self.headView then
        self.headView:updateUI()
    end

    local model = app:getUserModel()
    local cls   =   model.class

    self.exInfo = model:getProperties({cls.extinfo}).extinfo
    self.baseInfo = model:getProperties({
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
            cls.facebookId,
            cls.hasnews,
            cls.hasgift})

    print("self.exInfo", self.exInfo.signature)

    if self.exInfo[cls.ei.signature] and self.signature_text then
        self.signature_text:setString(tostring(self.exInfo[cls.ei.signature]))
    end

end

function FriendInforView:initProfile()
    print('self.baseInfo = ' .. self.baseInfo.pid,self.baseInfo.pictureId)
    
    self.level_text:setString(self.baseInfo.level)
    self.pid_text:setString(self.baseInfo.pid)
    -- print("--friend---gameId--",self.baseInfo.gameId)
    self.coin_text:setString(number.addCommaSeperate(self.baseInfo.coins))
    self.gem_text:setString(number.addCommaSeperate(self.baseInfo.gems))

    if self.exInfo and self.exInfo.signature then
        self.signature_text:setString(tostring(self.exInfo.signature))
    end

    -- header
    if self.baseInfo.pictureId == nil then
        self.baseInfo.pictureId = 1
    end

    -- vip
    local from  = DICT_VIP[tostring(self.baseInfo.vipLevel)]
    local to  = DICT_VIP[tostring(self.baseInfo.vipLevel +1)]

    local currVipPoint = nil
    if self.isme then
        currVipPoint = app:getUserModel():getCurrentVipLvExp()
    else
        currVipPoint = app:getUserModel():getFriendVipLvExp(self.baseInfo.vipPoint,self.baseInfo.vipLevel)
    end
    local nextPoints = getNeedVipPointByLevel(self.baseInfo.vipLevel+1) --980

    if from then
        self.vip_from_sp:setSpriteFrame("dating_vip_"..from.alias..".png")
        self.vip_from_text:setString(currVipPoint)
    else
        currVipPoint = 0
        self.vip_from_text:setString(currVipPoint)
    end

    if to then
        self.vip_to_sp:setSpriteFrame("dating_vip_"..to.alias..".png")
        self.vip_to_text:setString("/"..nextPoints)
    else
        self.vip_progress:setVisible(false)
        self.highestLevelNode:setVisible(true)
    end

    -- vip Progress
    if  self.vipProgress == nil then
        local vipX,vipY = self.vip_progress_sp:getPosition()
        local parent = self.vip_progress_sp:getParent()
        self.vip_progress_sp:removeFromParent(false)
        self.vipProgress = display.newProgressTimer(self.vip_progress_sp, display.PROGRESS_TIMER_BAR)
        :pos(vipX, vipX)
        :addTo(parent)
        self.vipProgress:setMidpoint(cc.p(0, 0))
        self.vipProgress:setBarChangeRate(cc.p(1, 0))
    end
    
    self.vipProgress:setPercentage(100 * currVipPoint / nextPoints)

    if self.isme == true then
        self.player_node:setVisible(false)--好友node隐藏
        self.me_node:setVisible(true)--自己node显示

        if self.headView == nil then
            self.headView = headViewClass.new({player=self.baseInfo, scale=1.0})
            self.headView:replaceHead(self.player_head_sp)
            self.headView:showUserName()
        end

    else

        self.player_node:setVisible(true)--好友node显示
        self.me_node:setVisible(false)--自己node隐藏
        if self.canAddFriend == false then--已经是好友
            self.invite_btn:setVisible(false)
            self.viewNode.animationManager:runAnimationsForSequenceNamed("idle")
        else
            self.send_btn:setButtonEnabled(false)
        end
        --无论是不是好友均可以加入游戏
        if self.baseInfo.currentState == nil then
            self.baseInfo.currentState = 0
        end
        if self.baseInfo.currentState and  self.baseInfo.currentState + 1 < 2 or  self.baseInfo.currentState + 1 > 6  then
            self.join_btn:setButtonEnabled(false)
        end
        if app:getPlayerStatus().gaming == true and app:getPlayerStatus().roomId == self.baseInfo.roomId then
            self.join_btn:setButtonEnabled(false)
        end

        if self.headView == nil then
            self.headView = headViewClass.new({player=self.baseInfo, scale=1.0})
            self.headView:replaceHead(self.player_head_sp)
            self.headView:showGameName()
        end
        
        local gameName = ConstantTable.game[self.baseInfo.currentState + 1]
        if self.baseInfo.currentState == 0 then
            gameName = "In the "..gameName
            self.minbetText:setString("")
        else
            gameName = "Playing "..gameName.." game"
            if DICT_UNIT[tostring(self.baseInfo.gameId)].config.min_bet then
                self.minbetText:setString("Min bet " .. DICT_UNIT[tostring(self.baseInfo.gameId)].config.min_bet)
            else
                self.minbetText:setString("Min bet " .. DICT_UNIT[tostring(self.baseInfo.gameId)].config.cost_gems)
            end
        end
        self.gameText:setString(gameName)
    end



end

function FriendInforView:initExp()
    local exp = self.baseInfo.exp - getLevelExpByLevel(self.baseInfo.level)
    local lvl = self.baseInfo.level

    -- expProgress
    if  self.expProgress == nil then
        local expX,expY = self.exp_sp:getPosition()
        local parent = self.exp_sp:getParent()

        self.exp_sp:removeFromParent(false)
        self.expProgress = display.newProgressTimer(self.exp_sp, display.PROGRESS_TIMER_BAR)
        :pos(expX, expY)
        :addTo(parent)

        self.expProgress:setMidpoint(cc.p(0, 0))
        self.expProgress:setBarChangeRate(cc.p(1, 0))
    end
    self.expProgress:setPercentage(100 * exp / tonumber(getNeedExpByLevel(lvl+1)))
end

function FriendInforView:showProfile()
    self:showTab(1)
    self:initProfile()
end

function FriendInforView:showRecord()
    self:showTab(2)

    if self.stats == false then
        net.GameCS:getGameStat(self.baseInfo.pid,function(stats)
            self.stats = true
            self:addRecordList(stats)
        end)
    end

end

function FriendInforView:showGift()
    self:showTab(3)

    if self.gifted == false then
        local isReceive = 0 --自己
        if self.isme == false then
            isReceive = 1 --好友礼物列表
        end
        net.GiftsCS:getGiftList(self.baseInfo.pid, isReceive, function(gifts)
            self.gifted = true
            self:addGiftList(gifts)
        end)
    end

end

function FriendInforView:showHonor()
    self:showTab(4)

    if self.honor == false then
        net.HonorCS:getHonorList(self.baseInfo.pid,function(honorlist)
            self.honor = true
            self:addHonorList(honorlist)

        end)
    end

end

function FriendInforView:addHonorList(honorlist)

    local box = self.contentRect:getBoundingBox()
    
    self.honorsList = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = box,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onHonorlistListener))
        :addTo(self.tabPanel4)

-- add items

    local listnum = #honorlist

    local honorsAll = {}
    honorsAll["COMMON"] = {}
    honorsAll["SLOTS"] = {}
    honorsAll["VIDEO_POKER"] = {}
    honorsAll["TEXAS_HOLDEM"] = {}
    honorsAll["BLACK_JACK"] = {}

    for i=1,#honorlist do
        local categoryHonor = honorsAll[honorlist[i].category]
        if categoryHonor then
            categoryHonor[#categoryHonor + 1] = honorlist[i]
        end
    end

    local addSubHonor = function(key, subhonorsList)
        -- body
        local item = self.honorsList:newItem()
        local cell = CCBReaderLoad("lobby/honor/honor_cell_sp.ccbi", self)

        self.hTitle:setSpriteFrame(gameTitleTxt[key])

        local itemsize = cell:getContentSize()
        cell:setPositionX(box.width/2)

        item:addContent(cell)
        item:setItemSize(itemsize.width, itemsize.height)
        self.honorsList:addItem(item)

        local num = #subhonorsList

        for i=1, num do

            local honor = subhonorsList[i]
            
            local item = self.honorsList:newItem()
            local cell = HonorCell.new(honor, self.isme)
            local itemsize = cell:getContentSize()
            cell:setPositionX(box.width/2)
            item:addContent(cell)
            item:setItemSize(itemsize.width, itemsize.height)
            self.honorsList:addItem(item)

        end
    end

    addSubHonor("SUMMARY", honorsAll["COMMON"])
    addSubHonor("SLOTS", honorsAll["SLOTS"])
    addSubHonor("VIDEO_POKER", honorsAll["VIDEO_POKER"])
    addSubHonor("TEXAS_HOLDEM", honorsAll["TEXAS_HOLDEM"])
    addSubHonor("BLACK_JACK", honorsAll["BLACK_JACK"])

    self.honorsList:reload()

end


function FriendInforView:onHonorlistListener(event)

    local listView = event.listView
    if "clicked" == event.name then

        --local cell = event.item:getContent()
        --if cell then cell:onClicked(event) end

    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        print("event name:" .. event.name)
    end

end

function FriendInforView:addRecordList(stats)

    local box = self.contentRect:getBoundingBox()
    self.recordsList = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = box,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :addTo(self.tabPanel2)

-- add items
    for i=1, 4 do
        local item = self.recordsList:newItem()
        local record = self["record"..i]
        record:setVisible(true)
        record:removeFromParent(false)

        local itemsize = record:getContentSize()

        item:addContent(record)

        item:setItemSize(itemsize.width, itemsize.height)

        self.recordsList:addItem(item)
    end

    self.recordsList:reload()
    for i=1,#stats do
        self:initrecord(stats[i])
    end

end

function FriendInforView:initrecord(stat)

    if stat.gameType == 1 then

        self["game_1_totalwinings_num"]:setString(tostring(stat.totalWin))
        self["game_1_biggestwin_num"]:setString(tostring(stat.maxWin))
        self["game_1_spinswon_num"]:setString(tostring(stat.winCnt))
        self["game_1_totalspins_num"]:setString(tostring(stat.gameCnt))
        --self["game_1_comvp"]:setString(tostring(stat.totalWin))

    elseif stat.gameType == 2 then
        
        self["game_2_handsplayed_num"]:setString(tostring(stat.handsPlayed))
        self["game_2_blackjack_num"]:setString(tostring(stat.blackJack))
        self["game_2_handspushed_num"]:setString(tostring(stat.handsPushed))
        self["game_2_handslots_num"]:setString(tostring(stat.handsLost))
        --self["game_2_comvp"]:setString(tostring(stat.totalWin))

    elseif stat.gameType == 3 then

        self["game_3_totalwinings_num"]:setString(tostring(stat.totalWin))
        self["game_3_biggestwin_num"]:setString(tostring(stat.maxWin))
        self["game_3_spinswon_num"]:setString(tostring(stat.winCnt))
        self["game_3_totalspins_num"]:setString(tostring(stat.gameCnt))
        
        print("===========stat.bestSuit=====33333=======")
        print(stat.bestSuit)
        if stat.bestSuit ~= nil then
            local bestsuit = json.decode(stat.bestSuit)
            --local bestsuit = stat.bestSuit
            if bestsuit then
                display.addSpriteFrames("poker/poker_card_big.plist", "poker/poker_card_big.pvr.ccz")
                local i = 1 
                for k,v in pairs(bestsuit) do
                    local resName = v
                    if resName then
                        resName = resName..".png"
                        if cc.SpriteFrameCache:getInstance():getSpriteFrame(resName) then
                            self["v_poker"..tostring(i)]:setSpriteFrame(resName)
                            self["v_poker"..tostring(i)]:setVisible(true)
                        end
                    end
                    i = i + 1
                end
            end
        end
        --self["game_3_comvp"]:setString(tostring(stat.totalWin))
    elseif stat.gameType == 4 then

        self["game_4_handswon_num"]:setString(tostring(stat.handsWin))
        self["game_4_handsplayed_num"]:setString(tostring(stat.handsPlayed))
        self["game_4_totalwinings_num"]:setString(tostring(stat.totalWin))
        --self["game_3_comvp"]:setString(tostring(stat.totalWin))
        print("===========stat.bestSuit====4444=======")
        print(stat.bestSuit)
        if stat.bestSuit ~= nil then
            local bestsuit = json.decode(stat.bestSuit)
            if bestsuit ~= nil then
                display.addSpriteFrames("poker/poker_card_big.plist","poker/poker_card_big.pvr.ccz")
                local i = 1 
                for k,v in pairs(bestsuit) do
                    local resName = v
                    if resName then
                        if cc.SpriteFrameCache:getInstance():getSpriteFrame(resName) then
                            self["d_poker"..tostring(i)]:setSpriteFrame(resName)
                            self["d_poker"..tostring(i)]:setVisible(true)
                        end
                    end

                    i = i + 1

                end

            end

        end

    elseif stat.gameType == 5 then

    end

end

function FriendInforView:addGiftList(gifts)--礼物列表 收到 
    self.redtip_gift:setVisible(false)
    app:getUserModel():setProperties({hasgift=-1})
    app:getUserModel():serializeModel()
    EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})
  
    gifts = gifts or {}
    local num = #gifts
    if num < 1 then
        self.no_gift_label:setVisible(true)--没有礼物
        self.titleShow:setVisible(false)
        return
    end
    self.no_gift_label:setVisible(false)

    local box = self.giftRect:getBoundingBox()
    self.giftsList = cc.ui.UIListView.new {
        bg = nil,
        bgScale9 = false,
        viewRect = box,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onGiftlistListener))
        :addTo(self.tabPanel3)
    -- 添加礼物
    for i=1, num do
        local item = self.giftsList:newItem()
        local gift = gifts[i]
        local giftcell = GiftCell.new(gift)
        local itemsize = giftcell.viewNode:getContentSize()
        item:setPositionX(box.width/2)
        item:addContent(giftcell)
        item:setItemSize(itemsize.width, itemsize.height)
        self.giftsList:addItem(item)
    end

    self.giftsList:setDelegate(handler(self, self.giftListDelegate))
    self.giftsList:reload()
    self.gifts_num_text:setString(num)

end

function FriendInforView:onGiftlistListener(event)

    local listView = event.listView
    if "clicked" == event.name then
        local cell = event.item:getContent()
        if self.isme == true and cell:checkClickHead(cc.p(event.x, event.y),false, self) == false then --点击非头像
            if cell:checkGiftCollected() and self.giftSelected == false then --领取礼物
                self.giftSelected = true
                net.GiftsCS:receiveGift(cell.data.id,function( msg )
                    self.giftSelected = false
                    if msg.result == 1 then
                        local totalCoins = app:getUserModel():getCoins() + msg.rewardCoins
                        local totalGems = app:getUserModel():getGems() + msg.rewardGems
                        app:getUserModel():setCoins(totalCoins)
                        app:getUserModel():setGems(totalGems)
                        EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                        -- self.giftsList:removeItem(event.item,true)
                        cell:showEffect()
                    else
                        print("领取礼物失败")
                    end
                end)
            end
        else
            print("==不是自己==")
        end

       
    end
end

function FriendInforView:giftListDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
        return 50
    elseif cc.ui.UIListView.CELL_TAG == tag then
        local item
        local content

        item = self.friendsList:dequeueItem()
        if not item then
            item = self.friendsList:newItem()
            content = cc.ui.UILabel.new(
                    {text = "item"..idx,
                    size = 20,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = display.COLOR_WHITE})
            item:addContent(content)
        else
            content = item:getContent()
        end
        content:setString("item:" .. idx)
        item:setItemSize(120, 80)

        return item
    else
    end
end

function FriendInforView:onExit()
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_LOBBYUI_EVENT)
    self.baseInfo = nil
    self = {}
end

return FriendInforView
