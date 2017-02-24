local ChargeGiftCell = require("app.views.gift.ChargeGiftCell")
local CollectGiftCell = require("app.views.gift.CollectGiftCell")

local tabBase = require("app.views.TabBase")
local View = class("GiftsView", tabBase)

function View:ctor(args) --物品

    local cbbi = "lobby/present/givegifts.ccbi"
    if args.tabidx then
        self.selectedIdx = args.tabidx
        cbbi = "lobby/present/roomgifts.ccbi"
    else
        self.selectedIdx = 1
    end

    self.viewNode  = CCBReaderLoad(cbbi, self)--加载ccb文件
    self:addChild(self.viewNode)
    self.tabNum = 3
    self.messageHint:setVisible(false)
    

    self.data = args

    if app:getPlayerStatus().gaming == false then  --游戏外
        self:registerUIEvent()
        self:showTab(self.selectedIdx)
        self:init() 
    else
        if args.shortTouch ~= 1 then
            self:registerUIEvent()
            self:showTab(self.selectedIdx)
            self:init()  
        else
            self:initGifts() --游戏内
        end
    end
end

function View:initGifts()
    print("游戏内 赠送 物品")
    core.displayEX.extendButton(self.closeBtn)--扩展button
    self.closeBtn.clickedCall = function() --关闭按钮事件
        scn.ScnMgr.removeView(self)
    end
    
    self:addGiftList()
end

function View:init()
    print("游戏外 金币 宝石")
    self.freeGiftCoinValue:setString(DICT_GIFT["1"].item_cnt)
    self.freeGiftGemsValue:setString(DICT_GIFT["2"].item_cnt)

    local model = app:getUserModel()
    local cls   =   model.class

    local properties = model:getProperties({
            cls.pid, 
            cls.name, 
            cls.hasgift,
            cls.hashonor,
            cls.hastask,
    })
end

function View:registerUIEvent() 
    core.displayEX.extendButton(self.freeGiftCoinBtn)
    self.freeGiftCoinBtn.clickedCall = function()
        self:selectFreeCoinGift()
    end

    core.displayEX.extendButton(self.freeGiftGemsBtn)
    self.freeGiftGemsBtn.clickedCall = function()
        self:selectFreeGemsGift()
    end

    core.displayEX.extendButton(self.closeBtn)
    self.closeBtn.clickedCall = function()
        scn.ScnMgr.removeView(self)
    end
end

function View:selectFreeGemsGift() --选择免费宝石礼物
     if self.data.islabby == true then
         local function onComplete(lists)
            if #lists > 0 then
                scn.ScnMgr.addView("social.FriendsSelectView", lists,"2",DICT_GIFT["2"])
            else
                scn.ScnMgr.removeView(self)
                scn.ScnMgr.popView("social.SocialView",{tabidx=1})
            end
         end
         --net.FriendsCS:getFriendsList(onComplete)
         net.FriendsCS:getAllFriends(1,onComplete)
     else
         self:sendGift({{pid =self.data.pid}},"2",DICT_GIFT["2"])
     end
end

function View:selectFreeCoinGift() --选择免费金币礼物
    if self.data.islabby == true then
        local function onComplete(lists)
            if #lists > 0 then
                scn.ScnMgr.addView("social.FriendsSelectView", lists,"1",DICT_GIFT["1"])
            else
                scn.ScnMgr.removeView(self)
                scn.ScnMgr.popView("social.SocialView",{tabidx=1})
            end
        end
        --net.FriendsCS:getFriendsList(onComplete)
        net.FriendsCS:getAllFriends(1,onComplete)
    else
        self:sendGift({{pid = self.data.pid}},"1",DICT_GIFT["1"])
    end
end

function View:sendGift(friends,type,gift) --赠送礼物
    local callback = function()
        if app:getUserModel():getGems()<tonumber(gift.price) then
            scn.ScnMgr.removeView(self)
            scn.ScnMgr.popView("ShortGemsView",{})
            return
        end
        net.GiftsCS:sendGift(friends, type, tonumber(gift.gift_id), function( msg )
            if tonumber(msg.result) == 1 then --赠送成功

                local totalCoins = app:getUserModel():getCoins() - msg.costCoins
                local totalGems = app:getUserModel():getGems() - msg.costGems
                app:getUserModel():setCoins(totalCoins)
                app:getUserModel():setGems(totalGems)
                EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                
                if self.data.sendbackCall then self.data.sendbackCall(gift.gift_id) end
                scn.ScnMgr.removeView(self)
            else     --已经送过了
                -- scn.ScnMgr.addView("CommonView",
                --     {
                --         onlyContent=true,
                --         content="You have already sent a gift to this friend.",
                --         callback=function( )
                --             -- body
                --             scn.ScnMgr.removeView(self)
                --         end
                --     })

                self.rootNode.animationManager:runAnimationsForSequenceNamed("tip")

            end
        end)
    end
    if tonumber(gift.type) == 1  then --礼物免费
        callback()
    else
        self:JudgeVipLevelForSendGift(gift,callback) --vip等级限制
    end
end

local margin = 40
function View:addGiftList() --加载礼物列表
    local box = self.giftRect:getBoundingBox()
    local c,r = 3,2  -- 2*2 方格
    self.giftsPage = cc.ui.UIPageView.new {
        viewRect = box,
        column = c, row = r,
    }
    :onTouch(handler(self, self.onGiftlistListener))
    :addTo(self.tabPanel2)

    local listData = DICT_GIFT_MENU["2"].contain_gifts
    local len = #listData

    for i=1,len do

        local item = self.giftsPage:newItem()
        local idx = listData[i]

        local data = DICT_GIFT[tostring(idx)]
        local content = ChargeGiftCell.new(data)
        content:setTag(2000)
        
        local itemsize = item:getContentSize()
        content:setPositionX(itemsize.width/2)
        content:setPositionY(itemsize.height/2)
        item:addChild(content)
        self.giftsPage:addItem(item)
    end

    local pageNum,f = math.modf(len/(c*r))
    if f > 0 then pageNum = pageNum +1 end
    -- add indicators
    local x = -( margin * (pageNum-1) ) / 2
    local y = -box.height/2 - 80

    self.indicator_ = display.newSprite(IMAGE_PNG.pageindacator_sel)
    self.indicator_:setPosition(x, y)
    self.indicator_.firstX_ = x

    for pageIndex = 1, pageNum do
        local icon = display.newSprite(IMAGE_PNG.pageindacator_bg)
        icon:setPosition(x, y)
        self.tabPanel2:addChild(icon)
        x = x + margin
    end
    self.tabPanel2:addChild(self.indicator_)

    self.giftsPage:reload()
end


function View:onGiftlistListener(event)
    local listView = event.listView
    if "pageChange" ==  event.name then
        local x = self.indicator_.firstX_ + (self.giftsPage:getCurPageIdx() - 1) * margin
        transition.moveTo(self.indicator_, {x = x, time=0.1})

    elseif "clicked" == event.name and event.item then
        local cell = event.item:getChildByTag(2000)
        if cell then
            for i, v in ipairs(self.giftsPage.items_) do
                local gcell = v:getChildByTag(2000)
                if cell == gcell then 
                    gcell.bg_s:setVisible(true)
                else
                    gcell.bg_s:setVisible(false)
                end
            end
            self:sendGift({{pid=self.data.pid}},"4",cell.gift) --赠送礼物
        end

    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else

    end
end

function View:JudgeVipLevelForSendGift(data,callback) --vip不足提醒
    local playerVipLevel = app:getUserModel():getVipLevel()
    local limitVipLelel = DICT_GIFT[tostring(data.gift_id)]["vipLevel"]
    --if playerVipLevel < tonumber(limitVipLelel) then
    if false then   -- cost gem not viplevel
        local str = "Vip grade deficiency."
        scn.ScnMgr.addView("CommonTip",{ok_callback = function()
            scn.ScnMgr.removeView(self)
        end,content = str})
    else
        callback()
    end
end


return View