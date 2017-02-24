local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local playerCell = require("app.views.ranking.PlayerCell")

local tabBase = require("app.views.TabBase")

local rankingName = {"Room","Daily","Weekly"}
local num_desc = {
    "Room:",
    "Daily:",    
    "Weekly:"
}


local View = class("RankingView", tabBase)

function View:ctor(args)

    self.viewNode  = CCBReaderLoad("lobby/ranking/rankingView.ccbi", self)
    self:addChild(self.viewNode)
    self:setNodeEventEnabled(true)

    self.info = args.info
    self.rankingType=args.rType
    self.rankingRList = args.rtList

    local rCnt = 1+#self.rankingRList
    
    self:addChild(CCBReaderLoad("lobby/ranking/rankingView_tab"..rCnt..".ccbi", self))

    self:registerUIEvent()

    self:show(self.rankingType)

end

function View:registerUIEvent()

    local rCnt = #self.rankingRList


    -- for i=2,4 do

    --     if rCnt+1 ~= i  then

    --         self["menu"..i]:removeFromParent(true)
    --     else
    --         self["menu"..i]:setVisible(true)

    --     end

    -- end

    self.callIdx = {}

    self.tabNum=rCnt + 1

    for i=1,rCnt do

        local rankingData = self.rankingRList[i]
        local name = rankingName[rankingData.rankingType]

        self["tab_name_"..i.."_1"]:setString(name)
        self["tab_name_"..i.."_2"]:setString(name)

        if rankingData.rankingType == 1 then
            self:addTabEvent(i,function()
                self:showRoomRanking(i)
            end)
        elseif rankingData.rankingType == 2 then
            self:addTabEvent(i,function()
                self:showDailyRanking(i)
            end)
        elseif rankingData.rankingType == 3 then
            self:addTabEvent(i,function()
                self:showWeeklyRanking(i)
            end)
        end

        self.callIdx[rankingData.rankingType] = i


    end

    self["tab_name_"..self.tabNum.."_1"]:setString("Help")
    self["tab_name_"..self.tabNum.."_2"]:setString("Help")
    self:addTabEvent(self.tabNum,function()
        self:showHelp(self.tabNum)
    end)

    -- for i=self.tabNum, 4 do
    --     self["tab"..i]:setVisible(false)
    --     self["selTab"..i]:setVisible(false)
    -- end

    core.displayEX.extendButton(self.closeBtn)
    self.closeBtn.clickedCall = function()
        scn.ScnMgr.removeView(self)
    end
   
end

function View:show(rType)

    if rType == 1 then
        self:showRoomRanking(self.callIdx[rType])
    elseif rType == 2 then
        self:showDailyRanking(self.callIdx[rType])
    elseif rType == 3 then
        self:showWeeklyRanking(self.callIdx[rType])
    end

end

function View:showRoomRanking(idx)
    self:showTab(idx)

    self.txtNode:setVisible(true)
    self.helpTxtNode:setVisible(false)
    self.helpDescBg:setVisible(false)
    self.playerRectBg:setVisible(true)
    self.completeTxt:setVisible(false)

    net.TimingRankingCS:getRankingListInRoom(self.info.gameId, self.info.roomId, function( rankingList, remainedTimeLimit )
        -- body
        self:addPlayersList(rankingList)
        self.remainedTimeLimit = remainedTimeLimit * 0.001

        if tonumber(self.remainedTimeLimit) <= 0 then
            self.completeTxt:setVisible(true)
            self.leftTime:setVisible(false)
        else
            self.leftTime:setVisible(true)
            self:startTimer()
        end

    end) 

    if self.helpDescList then 
        self.helpDescList:onCleanup() 
        self.helpDescList:removeAllItems()
        self.helpDescList:removeFromParent()
        self.helpDescList = nil
    end
end


function View:showDailyRanking(idx)
    self:showTab(idx)

    self.txtNode:setVisible(true)
    self.helpTxtNode:setVisible(false)
    self.helpDescBg:setVisible(false)
    self.completeTxt:setVisible(false)
    self.playerRectBg:setVisible(true)


    net.TimingRankingCS:getRankingListInGame(self.info.gameId, 2, function( rankingList, remainedTimeLimit )
        -- body
        self:addPlayersList(rankingList)
        self.remainedTimeLimit = remainedTimeLimit * 0.001

        if tonumber(self.remainedTimeLimit) <= 0 then
            self.completeTxt:setVisible(true)
            self.leftTime:setVisible(false)
        else
            self.leftTime:setVisible(true)
            self:startTimer()
        end

    end) 

    if self.helpDescList then 
        self.helpDescList:onCleanup() 
        self.helpDescList:removeAllItems()
        self.helpDescList:removeFromParent()
        self.helpDescList = nil
    end

end

function View:showWeeklyRanking(idx)
    self:showTab(idx)

    self.txtNode:setVisible(true)
    self.helpTxtNode:setVisible(false)
    self.helpDescBg:setVisible(false)
    self.completeTxt:setVisible(false)
    self.playerRectBg:setVisible(true)


    net.TimingRankingCS:getRankingListInGame(self.info.gameId, 3, function( rankingList, remainedTimeLimit )
        -- body
        self:addPlayersList(rankingList)
        self.remainedTimeLimit = remainedTimeLimit * 0.001

        if tonumber(self.remainedTimeLimit) <= 0 then
            self.completeTxt:setVisible(true)
            self.leftTime:setVisible(false)
        else
            self.leftTime:setVisible(true)
            self:startTimer()
        end

    end) 


    if self.helpDescList then 
        self.helpDescList:onCleanup() 
        self.helpDescList:removeAllItems()
        self.helpDescList:removeFromParent()
        self.helpDescList = nil
    end

end

function View:showHelp(idx)
    self:showTab(idx)

    self.txtNode:setVisible(false)
    self.helpTxtNode:setVisible(true)
    self.helpDescBg:setVisible(true)
    self.completeTxt:setVisible(false)
    self.playerRectBg:setVisible(false)

    net.TimingRankingCS:getSelfRankings(self.info.gameId, self.info.roomId, function(selfRankings, rewardMapping)
        -- body
        self:addRankingNum(selfRankings)
        self:addHelpTxt(rewardMapping)

    end) 

    if self.playersList then 
        self.playersList:onCleanup() 
        self.playersList:removeAllItems()
        self.playersList:removeFromParent()
        self.playersList = nil
    end

end

function View:addPlayersList(list)

    if self.playersList then 
        self.playersList:onCleanup() 
        self.playersList:removeAllItems()
    else

        local box = self.playersRect:getBoundingBox()
        self.playersList = cc.ui.UIListView.new {
            bg = nil,
            bgScale9 = false,
            viewRect = box,
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            scrollbarImgV = nil}
            :onTouch(handler(self, self.onFriendlistListener))

        self.playersList:addTo(self.playersRect:getParent())

    end

    -- add items
    local listnum = #list

    for i=1, listnum do
        local data = list[i]

        local info = {name=data.name, 
            pid=data.pid, rankNum=data.rank, rewardCnt=data.itemCnt, rewardId=data.itemId, 
            totalBet=data.totalBetForPeriod,level=data.level,pictureId=data.pictureId,vipLevel=data.vipLevel
        }

        local item = self.playersList:newItem()
        local cell = playerCell.new(info,self)
        local itemsize = cell:getContentSize()

        item:addContent(cell)
        item:setItemSize(itemsize.width, itemsize.height)
        item:setTouchSwallowEnabled(false)
        self.playersList:addItem(item)
    end
    self.playersList:reload()
end

function View:addRankingNum(selfRankings)
    local rCnt = #selfRankings


    -- add items
    for i=1, rCnt do

        local rankingData = selfRankings[i]
        local desc = num_desc[rankingData.rankingType]
        self["num_desc_"..i]:setString(desc)
        self["num_val_"..i]:setString(tostring(rankingData.rank))

        self["num_desc_"..i]:setVisible(true)
        self["num_val_"..i]:setVisible(true)

    end

    rCnt = rCnt + 1

    for i=rCnt,3 do
        self["num_desc_"..i]:setVisible(false)
        self["num_val_"..i]:setVisible(false)
    end

end

function View:addHelpTxt(rewardMapping)

    local rewardList = {}

    for i=1,#rewardMapping do
        
        local rewardItem = rewardMapping[i]

        local reward = rewardList[tostring(rewardItem.rankingType)]

        if reward == nil then
            reward = {}
        end

        table.insert(reward, rewardItem.rank, rewardItem)

        rewardList[tostring(rewardItem.rankingType)] = reward

    end

    local rCnt = #self.rankingRList


    if self.helpDescList then 
        self.helpDescList:onCleanup() 
        self.helpDescList:removeAllItems()
    else

        local box = self.helpDescRect:getBoundingBox()

        self.helpDescList = cc.ui.UIListView.new {
            bg = nil,
            bgScale9 = false,
            viewRect = box,
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            scrollbarImgV = nil}
       --     scrollbarImgV = "#scroll_imge_v.png"}
            :addTo(self.tabPanel)
    end

-- add items

    -- add rule
    local item = self.helpDescList:newItem()
    local ruleDescNode = self["rankingRule"]
    ruleDescNode:setVisible(true)
    ruleDescNode:removeFromParent(false)
    local itemsize = ruleDescNode:getContentSize()
    item:addContent(ruleDescNode)
    item:setItemSize(itemsize.width, itemsize.height)
    self.helpDescList:addItem(item)


    for i=1, rCnt do

        local rankingData = self.rankingRList[i]

        local rewards = rewardList[tostring(rankingData.rankingType)]

        for i=1, 6 do

            local rewardItem = rewards[i]

            local kekstr = rankingData.rankingType.."_"..i

            if rewardItem then

                if tonumber(rewardItem.itemId) == ITEM_TYPE.NORMAL_MULITIPLE then --奖励金币
                    image = "gold.png"
                else
                    image = "gems.png"
                end

                self["topRewardVal_"..kekstr]:setString(ToolUtils.formatLongTextNumber(rewardItem.itemCnt))
                self["topRewardIcon_"..kekstr]:setSpriteFrame(image)

            else
                if self["topNode_"..kekstr] then
                    self["topNode_"..kekstr]:setVisible(false)
                end
            end

        end

        local item = self.helpDescList:newItem()
        local ruleDescNode = self["rankingRule_"..rankingData.rankingType]
        ruleDescNode:setVisible(true)
        ruleDescNode:removeFromParent(false)

        local itemsize = ruleDescNode:getContentSize()

        item:addContent(ruleDescNode)

        item:setItemSize(itemsize.width, itemsize.height)

        self.helpDescList:addItem(item)
    end

    self.helpDescList:reload()
    -- for i=1,#stats do
    --     self:initrecord(stats[i])
    -- end
end

function View:onFriendlistListener(event)
    if "clicked" == event.name and event.item then

        local cell = event.item:getContent()
        cell:checkClickHead(cc.p(event.x, event.y),false, self)

    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        --print("event name:" .. event.name)
    end
end


function View:endTimer()
    if self.schEntryRanking  then 
        scheduler.unscheduleGlobal(self.schEntryRanking) 
        self.schEntryRanking = nil
    end
end

function View:startTimer()

    if self.schEntryRanking then return end

    local tick = function(dt)
        --print(dt)
        self.remainedTimeLimit = self.remainedTimeLimit - dt

        self.leftTime:setString("Remaining time: "..ToolUtils.formatTimer(self.remainedTimeLimit))

        if self.remainedTimeLimit < 0 then 
            self.remainedTimeLimit=0
            self.leftTime:setString("Remaining time: "..ToolUtils.formatTimer(self.remainedTimeLimit))
            self:endTimer()
        end

    end

    self.schEntryRanking = scheduler.scheduleGlobal(tick , 0)
end


function View:onEnter()
end

function View:onExit()
    self:endTimer()
end

return View