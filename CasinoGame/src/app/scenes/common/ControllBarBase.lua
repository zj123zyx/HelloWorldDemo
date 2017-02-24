

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local rewardList = {["3"]="head_bigwin",["4"]="head_megawin",["6"]="head_blackjack",["7"]="head_royalflush",
                    ["8"]="head_straightflush",["9"]="head_fourofakind",["10"]="head_fiveofakind"}


local ControllBarBase = class("ControllBarBase", function()
    return display.newNode()
end)

function ControllBarBase:ctor()
end

function ControllBarBase:init(info)
    local ccbFile = "view/shared_ctlbtn.ccbi"

    if info~=nil and info.ctr_bar_top then
        ccbFile = info.ctr_bar_top
    end

    local layer  = CCBReaderLoad(ccbFile, self)
    self:addChild(layer,10)
    -- self.lists = info.players 
    -- self.rankingRList = info.rList 
    -- self.rankingCnt = #self.rankingRList
    -- self.info = info.info --roomId gameId mysite
    -- self.slotsName = info.slotsName --roomId gameId mysite

    -- self.btnLock = false

    app.coinSprite = self.coinSprite
    -- app.gemSprite = self.gemSprite

    self:setNodeEventEnabled(true)

    -- -- head clip node
    -- self.adNode = cc.ClippingNode:create()
    -- self.myHeadImage:getParent():addChild(self.adNode)
    -- self.myHeadImage:removeFromParent(false)
    -- self.adNode:addChild(self.myHeadImage)

    -- local stencil=display.newSprite("#head_bg_radial.png")
    -- local size = stencil:getContentSize()

    -- self.adNode:setStencil(stencil)
    -- self.adNode:setInverted(false)
    -- self.adNode:setAlphaThreshold(0)

    -- local model = app:getUserModel()
    -- local cls   =   model.class

    -- local properties = model:getProperties({
    --         cls.name, 
    --         cls.level, 
    --         cls.vipLevel,
    --         cls.pictureId,
    --         cls.facebookId,
    --         cls.hasgift})

    
    -- self:initSelfHead(properties)

    -- --TODO
    -- self:initRanked()

    -- self.redtip_gift:setZOrder(100)

    -- if properties[cls.hasgift] == 4 then
    --     self.redtip_gift:setVisible(true)
    -- else
    --     self.redtip_gift:setVisible(false)
    -- end
    -- self.expEffect  = CCBuilderReaderLoad("effect/exp_add.ccbi",self)
    -- self.expEffect:setScale(0.8)
    -- self.expEffectNode:addChild(self.expEffect)
    -- self.exp_add_count:enableOutline(cc.c4b(64, 64, 64, 255), 2)
    -- self:Layout(info.animation)

    -- self.jackpot = app.jackpotLabel --label
    -- self.nowCoin = app.JackpotCoins --jackpot num

    -- -- TODO wangxuebin add
    -- if self.jackpot == nil then
    --     self.jackpot = cc.LabelTTF:create("0", "Arial", 64) 
    --     self:addChild(self.jackpot);
    --     self.jackpot:setVisible(false) 
    -- end
    -- if self.nowCoin == nil then
    --     self.nowCoin = cc.LabelTTF:create("0", "Arial", 64) 
    --     self:addChild(self.nowCoin); 
    --     self.nowCoin:setVisible(false) 
    -- end

    -- if self.nowCoin ~= -1 and self.nowCoin ~= nil then  
    --     if self.nowCoin <= 100 then
    --         self.nowCoin = math.floor(self.nowCoin / 2)
    --     else
    --         self.nowCoin = self.nowCoin - 100
    --     end
    --     self:updateJackpot({list = app.JackpotCoins})
    -- else
    --     if self.jackpot and self.jackpot:getTag() == app:getPlayerStatus().gameId  then
    --         self.jackpot:setVisible(false)
    --     end
    -- end

    -- app.changJackpot = function(num)
    --     self.jackpot:setString(num)
    --     self.nowCoin = num
    -- end
end

function ControllBarBase:initSelfHead(properties)

    local subname = properties.name
    if string.len(subname) > 5 then
        subname = string.sub(subname, 1, 5).."..."
    end
    
    self.myName:setString(subname)
    self.myLevel:setString(tostring(properties.level))

    self:setHeadImage(properties)

    local cvdict = DICT_VIP[tostring(properties.vipLevel)]

    if cvdict then

        local myHeadBgImage  = "myhead_bg_"..cvdict.alias..".png"

        if cc.SpriteFrameCache:getInstance():getSpriteFrame(myHeadBgImage) then
            self.myHeadBg:setSpriteFrame(display.newSpriteFrame(myHeadBgImage))
        end
    end
end

function ControllBarBase:setHeadImage(properties)

    if tonumber(properties.pictureId) == 0  then

        if string.len(properties.facebookId) > 0 then


            core.FBPlatform.pushDownTask(properties.facebookId,function( photoPath )
                -- body

                if io.exists(photoPath) then
                    
                    self.myHeadImage:setTexture(photoPath)
                    
                    local headsize=self.myHeadImage:getContentSize()

                    self.myHeadImage:setScale(140/headsize.width)

                end
                
            end)
        end


    else

        local image = HEAD_IMAGE[tonumber(properties.pictureId)]
        if image == nil then image = "head_00.png" end
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(image) then
            self.myHeadImage:setSpriteFrame(display.newSpriteFrame(image))
        end

        local headsize=self.myHeadImage:getContentSize()
        self.myHeadImage:setScale(140/headsize.width)

    end
end

function ControllBarBase:initRanked()

    self.rankingIdx = 1
    self.nextRankingTime = 0

    self.hasRanking = false


    for i=1,self.rankingCnt do

        local rankingData = self.rankingRList[i]
        if rankingData then
            local ccbiFile = "lobby/ranking/rankingAd_"..rankingData.rankingType..".ccbi"
            local layer  = CCBReaderLoad(ccbiFile, self)
            self.rankingAdNode:addChild(layer)

            local ranking = {}
            ranking.node = layer
            ranking.leftTime = self.leftTime
            ranking.remainedTime = rankingData.remainedTime
            ranking.animationMgr = self.rootNode.animationManager

            --print("rankingData.remainedTime",rankingData.rankingType, rankingData.remainedTime)

            self["ranking_"..rankingData.rankingType] = ranking

            self.hasRanking = true

        end

    end

    self.hasUpdateTime = false

    net.TimingRankingCS:getRankingRemainedTime(self.info.gameId, self.info.roomId,function(remainedTimeList)
        -- body
        self:updateRemainedTime(remainedTimeList)
    end)


    self:showNextRankingAd()
    self:startTimer()
end

function ControllBarBase:updateRemainedTime(rlist)

    for i=1, #rlist do

        local rankingData = rlist[i]
        if rankingData then
            local ranking = self["ranking_"..rankingData.rankingType]
            if ranking then 
                ranking.remainedTime = rankingData.remainedTime
            end
            -- print("updateRemainedTime", rankingData.rankingType, ranking.remainedTime)
        end

    end
end

function ControllBarBase:showNextRankingAd()

    if #self.rankingRList < 2 and self.curRanking then return end

    local rankingData = self.rankingRList[self.rankingIdx]

    -- TODO wangxuebin add
    if rankingData == nil then
        return nil;
    end

    local preRanking = self.curRanking

    if preRanking then
        
        preRanking.animationMgr:runAnimationsForSequenceNamed("exit")
        self:performWithDelay(function()
            -- body
                self.curRanking = self["ranking_"..rankingData.rankingType]
                self.curRanking.animationMgr:runAnimationsForSequenceNamed("enter")

        end,0.5)

    else
        self.curRanking = self["ranking_"..rankingData.rankingType]
        self.curRanking.animationMgr:runAnimationsForSequenceNamed("enter")
    end

    self.rankingIdx = self.rankingIdx + 1

    if self.rankingIdx > #self.rankingRList then
        self.rankingIdx = 1
    end
end

function ControllBarBase:endTimer()
    if self.schEntryRanking  then 
        scheduler.unscheduleGlobal(self.schEntryRanking) 
        self.schEntryRanking = nil
    end
end

function ControllBarBase:startTimer()

    local tick = function(dt)
        --print(dt)
        -- TODO wangxuebin add
        if self.curRanking == nil then
            return nil;
        end

        self.nextRankingTime = self.nextRankingTime + dt

        if self.nextRankingTime > 12 and self.hasUpdateTime == false then

            self.hasUpdateTime = true

            net.TimingRankingCS:getRankingRemainedTime(self.info.gameId, self.info.roomId,function(remainedTimeList)
                -- body
                self:updateRemainedTime(remainedTimeList)
            end)

        end

        if self.nextRankingTime > 14 then
            self.hasUpdateTime = false
            self.nextRankingTime = self.nextRankingTime - 14
            self:showNextRankingAd()
        end

        for i=1,self.rankingCnt do

            local rankingData = self.rankingRList[i]
            if rankingData then

                local ranking = self["ranking_"..rankingData.rankingType]
                ranking.remainedTime = ranking.remainedTime - 1000*dt
            end

        end

        if self.curRanking.remainedTime < 0  then 
            self.curRanking.leftTime:setString("waitting for next time")

            if self.curRanking.remainedTime < -2 and self.curRanking.rankingType == 1 then

                self.curRanking.remainedTime = 0 

                net.TimingRankingCS:getRankingRemainedTime(self.info.gameId, self.info.roomId,function(remainedTimeList)
                    -- body
                    self:updateRemainedTime(remainedTimeList)
                end)
            end


        else
            self.curRanking.leftTime:setString(ToolUtils.formatTimer(self.curRanking.remainedTime*0.001))
        end

        local size = self.curRanking.leftTime:getContentSize()
        local scaleVal = 120 / size.width
        if scaleVal > 1.1 then scaleVal = 1.1 end

        self.curRanking.leftTime:setScale(scaleVal) 

    end

    self.schEntryRanking = scheduler.scheduleGlobal(tick , 0)
end

function ControllBarBase:playExpEffect(count,callback)
    if self.expEffect then
        self.exp_add_count:setString(tostring(count))
        local animationMgr = self.expEffect.animationManager
        animationMgr:runAnimationsForSequenceNamed('exp_add')
        self:performWithDelay(function( )
            -- body
            if callback then callback() end
        end,1.0)
    end
end

function ControllBarBase:fenge(num)
    num = tostring(num)
    local jackpotNum = ""
    while true do
        local nownum = string.sub(num,1,-4)
        if string.len(num) <=3 then
            jackpotNum = num  .. "," .. jackpotNum
            jackpotNum = string.sub(jackpotNum,1,-2)
            return jackpotNum
        else
            jackpotNum = string.sub(num,-3,-1)  .. "," .. jackpotNum
            num = nownum
        end
    end
end

function ControllBarBase:updateJackpot(data)
    -- if self.nowCoin > tonumber(data.list) then
    --     self.jackpot:setString(app.baseJackpot)
    --     self.nowCoin = app.baseJackpot 
    -- end
    if self.nowCoin == nil then
        core.SocketNet:stop()
        self.nowCoin = data.list
    end
    local addCoin = tonumber(data.list) - self.nowCoin
    print("addJackpot  old      new      add = " .. self.jackpot:getString(),data.list,addCoin)  
        

    local timeLength = 10-- 10 seconds for server sned the jackpot date 

    local time = timeLength/addCoin
    local addNum = 1
    if addCoin >= 100 and addCoin < 1000 then --  >=100 就另一个走法
        time = timeLength/35
        addNum = math.floor(addCoin/35)
    elseif addCoin >=1000 then
        time = timeLength/125
        addNum = math.floor(addCoin/125)
    end

    local onTime = function()
        if self.jackpot then
            local oldcoin = self.jackpot:getString()
            oldcoin = string.gsub(oldcoin,",","")
            local str = self:fenge(tonumber(oldcoin)+addNum)
            self.jackpot:setString(str)
            if tonumber(oldcoin)+1 >= data.list then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerJackpot)
            end
        end
    end 
    if self.schedulerJackpot then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerJackpot)
    end
    self.jackpot:setString(self:fenge(self.nowCoin)) 
    self.schedulerJackpot = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onTime,time, false) 
    self.nowCoin = data.list
end

function ControllBarBase:layoutCtr(val)

    local size = self.bottom_bar:getContentSize()
    local scale = display.width / size.width

    self.bottom_bar:setScale(scale)
    self.bottom_bar:setPositionX(0)
    self.bottom_bar:setPositionY(0)

    if self.poker_bg then self.poker_bg:setScale(1/scale) end
    if val ~= nil then
        local posX, posY = self.bottom_bar:getPosition()
        self.bottom_bar:setPositionY(posY-150)
        transition.moveTo(self.bottom_bar, {x=posX, y=posY, time=0.5, delay = 1.0,
            onComplete=function()
            end})
    end

    local posX, posY = self.chatbtn:getPosition()
    local size = self.chatbtn:getContentSize()

    -- body
    self.chatBox = cc.ui.UIInput.new({
        image = "EditBoxBg.png",
        size = cc.size(600, 50),
        x = display.cx,
        y = display.cy,
        listener = function(event, editbox)
            if event == "began" then
                printf("editBox1 event began : text = %s", editbox:getText())
            elseif event == "ended" then
                printf("editBox1 event ended : %s", editbox:getText())
            elseif event == "return" then
                printf("editBox1 event return : %s", editbox:getText())
                local str = editbox:getText()
                if string.trim(str) ~= "" then
                    if string.len(str) <=5 then
                        str = "  " .. str .. "  "
                    end
                    net.ChatCS:chatMessage(str)
                end
                self.chatBox:setVisible(false)

            elseif event == "changed" then
                printf("editBox1 event changed : %s", editbox:getText())
            else
                printf("EditBox event %s", tostring(event))
            end
        end
    })

    self.chatBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    self:addChild(self.chatBox)
    self.chatBox:setPosition(display.cx, 120)
    self.chatBox:setText("")
    self.chatBox:setVisible(false)

    core.displayEX.newButton(self.chatbtn) 
        :onButtonClicked(function(event)
            -- EventMgr:dispatchEvent({name  = EventMgr.STOP_LINEEFF_EVENT})
            --scn.ScnMgr.popView("ChatView")
            self.chatBox:setText("")
            self.chatBox:setVisible(true)
            self.chatBox:touchDownAction(self.chatBox, ccui.TouchEventType.ended)
        end)

end

function ControllBarBase:onTouch(p)

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

    if isTouchedBtn(self.btn_menus) == false and isTouchedBtn(self.btn_lobby) == false and 
       isTouchedBtn(self.btn_achievement) == false and isTouchedBtn(self.btn_message) == false and    
       isTouchedBtn(self.btn_option) == false then

        if isTouchedBtn(self.menuBg, true) == false then
            self:setMenusVisible(false)
        end
    
    end

end

function ControllBarBase:lockBTN()
    self.btnLock = true
   -- if self.btn_vip then self.btn_vip:setButtonEnabled(false) end
    if self.btn_lobby then self.btn_lobby:setButtonEnabled(false) end
    if self.btn_shop_gem then self.btn_shop_gem:setButtonEnabled(false) end
    if self.btn_shop_coin then self.btn_shop_coin:setButtonEnabled(false) end
    if self.subBetBtn then self.subBetBtn:setButtonEnabled(false) end
    if self.addBetBtn then self.addBetBtn:setButtonEnabled(false) end
    -- if self.btn_allplayer then self.btn_allplayer:setButtonEnabled(false) end
    -- if self.btn_allplayer_opened then self.btn_allplayer_opened:setButtonEnabled(false) end
    if self.paytableBtn then self.paytableBtn:setButtonEnabled(false) end
    if self.chatbtn then self.chatbtn:setButtonEnabled(false) end
    if self.btn_menus then self.btn_menus:setButtonEnabled(false) end
    if self.myHeadBtn then self.myHeadBtn:setButtonEnabled(false) end
    if self.maxBetBTN then self.maxBetBTN:setButtonEnabled(false) end
    if self.btn_rank_room then self.btn_rank_room:setButtonEnabled(false) end
    if self.btn_rank_daily then self.btn_rank_daily:setButtonEnabled(false) end
    if self.btn_rank_weekly then self.btn_rank_weekly:setButtonEnabled(false) end

end

function ControllBarBase:unlockBTN()
    self.btnLock = false
    --if self.btn_vip then self.btn_vip:setButtonEnabled(true) end
    if self.btn_lobby then self.btn_lobby:setButtonEnabled(true) end
    if self.btn_shop_gem then self.btn_shop_gem:setButtonEnabled(true) end
    if self.btn_shop_coin then self.btn_shop_coin:setButtonEnabled(true) end
    if self.subBetBtn then self.subBetBtn:setButtonEnabled(true) end
    if self.addBetBtn then self.addBetBtn:setButtonEnabled(true) end
    -- if self.btn_allplayer then self.btn_allplayer:setButtonEnabled(true) end
    -- if self.btn_allplayer_opened then self.btn_allplayer_opened:setButtonEnabled(true) end
    if self.paytableBtn then self.paytableBtn:setButtonEnabled(true) end
    if self.chatbtn then self.chatbtn:setButtonEnabled(true) end
    if self.btn_menus then self.btn_menus:setButtonEnabled(true) end
    if self.myHeadBtn then self.myHeadBtn:setButtonEnabled(true) end
    if self.maxBetBTN then self.maxBetBTN:setButtonEnabled(true) end
    if self.btn_rank_room then self.btn_rank_room:setButtonEnabled(true) end
    if self.btn_rank_daily then self.btn_rank_daily:setButtonEnabled(true) end
    if self.btn_rank_weekly then self.btn_rank_weekly:setButtonEnabled(true) end
end

function ControllBarBase:updateBaseUILabel(event)

    local model = app:getUserModel()
    local cls   =   model.class

    local properties = model:getProperties({
            cls.name, 
            cls.level, 
            cls.exp, 
            cls.vipLevel, 
            cls.vipPoint, 
            cls.coins, 
            cls.gems, 
            cls.pictureId,
            cls.facebookId,
            cls.hasnews,
            cls.hashonor,
            cls.hasgift,
    })

    if properties[cls.hasnews] >= 1 and properties[cls.hasnews] <= 3 or properties[cls.hashonor] == 5 then
        self.messageHint1:setVisible(true)
    else
        self.messageHint1:setVisible(false)
    end

    if properties[cls.hasnews] >= 1 and properties[cls.hasnews] <= 3 then
        self.messageHint:setVisible(true)
    else
        self.messageHint:setVisible(false)
    end

    if properties[cls.hasgift] == 4 then
        self.redtip_gift:setVisible(true)
    else
        self.redtip_gift:setVisible(false)
    end

    if properties[cls.hashonor] == 5 then
        self.messageHint2:setVisible(true)
    else
        self.messageHint2:setVisible(false)
    end

    if properties[cls.coins] then
        self.coinsNum:setString(number.addCommaSeperate((properties[cls.coins])))
    end

    if properties[cls.gems] then
        self.gemsNum:setString(number.addCommaSeperate((properties[cls.gems])))
    end

    if properties[cls.name] then

        local subname = properties[cls.name]
        if string.len(subname) > 5 then
            subname = string.sub(subname, 1, 5).."..."
        end
    
        self.myName:setString(subname)
    end

    -- compare level now to level up event 
    -- if properties[cls.level] then
    --     self.myLevel:setString(tostring(properties[cls.level]))
    -- end

    -- if properties[cls.exp] then
    --     self.expLabel:setString(tostring(properties[cls.exp]))
    -- end

    -- local pc1, pc2, levelup = self:getTwoPercentage(properties[cls.exp], properties[cls.level])

    -- if pc1 ~= pc2 and event then
    --     self:setExpProgress(pc1, pc2, levelup, 1)
    -- end


    if event then
        local pc1, pc2, levelup, levelcount = AnimationUtil.getTwoPercentage(
            self.expProgress:getPercentage(), 
            tonumber(self.myLevel:getString()), 
            properties[cls.level], 
            model:getCurrentLvExp(), 
            self.angleRatio)

        print("levelup event:", levelup, self.myLevel:getString(), properties[cls.level])

        AnimationUtil.progressMoveTo(self.expProgress, pc1, pc2, levelcount, 0.5, self.angleRatio)
        if levelup == true then
            local callback = function()
                local level = tonumber(properties[cls.level])
                if core.FBPlatform.getUid() == nil and level == 8 or level == 12 then
                    scn.ScnMgr.popView("FBConnectView",{coins = CONNECTFB_REWARD_COINS})
                end
                local model = app:getObject("UserModel")
                local properties = model:getProperties({model.class.extinfo})
                if properties.rateSign == nil or properties.rateSign == 0 then
                    if level == 4 or level == 7 or level == 9 or level == 11 then
                        scn.ScnMgr.popView("RateOnUs",{coins = 2000})
                    end
                end
            end
            scn.ScnMgr.popView("LevelUpView",{level = properties[cls.level],callback=callback})
        end
    end

    -- local vipdict = DICT_VIP[tostring(properties[cls.vipLevel])]
    -- if vipdict then
    --     local vipoImage="dating_vip_"..vipdict.alias..".png"
    --     local images = {}
    --     images.n=vipoImage
    --     images.s=vipoImage
    --     images.d=vipoImage

    --     core.displayEX.setButtonImages(self.btn_vip, images)
    -- end

    self:initSelfHead(properties)

end

function ControllBarBase:setMenusVisible(val)
    if self.menus_node then self.menus_node:setVisible(val) end
    if self.menusGreyLayer then self.menusGreyLayer:setVisible(val) end
end

function ControllBarBase:initBaseButton()

    -- on menus
    core.displayEX.newButton(self.btn_menus) 
        :onButtonClicked(function(event)
            if self.menus_node:isVisible() == true then
                self:setMenusVisible(false)
            else
                self:setMenusVisible(true)
            end
        end)

    -- on message
    core.displayEX.newButton(self.btn_message) 
        :onButtonClicked(function(event)
            
            self:setMenusVisible(false)

            net.MessageCS:getMessageList(function(body)
                -- body
                if type(body) == "table" and #body < 1 then
                    self.messageHint:setVisible(false)
                    self.messageHint1:setVisible(false)
                end
                scn.ScnMgr.popView("MessageView",body)
            end)

        end)

    -- on lobby
    core.displayEX.newButton(self.btn_lobby) 
        :onButtonClicked(function(event)
            -- EventMgr:dispatchEvent({name  = EventMgr.STOP_LINEEFF_EVENT})
            self:setMenusVisible(false)

            local contentStr = "Are you sure you want to leave the room ?"

            if self.hasRanking == true then
                contentStr = "Are you sure you want to relinquish the chance of tournaments prize and leave the room?"
            end

            scn.ScnMgr.addView("CommonTip",{ok_callback = function()
                    app.jackpotLabel = nil
                    net.GameCS:leaveGame()
                    scn.ScnMgr.replaceScene("lobby.LobbyScene", {2}, true)
                end,
                title="LEAVE ROOM",
                content=contentStr})

        end)

    -- on setting
    core.displayEX.newButton(self.btn_option)
        :onButtonClicked(function(event)
            -- EventMgr:dispatchEvent({name  = EventMgr.STOP_LINEEFF_EVENT})
            self:setMenusVisible(false)

            scn.ScnMgr.popView("SettingView")
        end)


    -- on ranking
    if self.btn_rank_room then
        core.displayEX.newButton(self.btn_rank_room)
            :onButtonClicked(function(event)
            self:setMenusVisible(false)

                scn.ScnMgr.popView("ranking.RankingView",{rType=1,rtList=self.rankingRList, info= self.info})

            end)
    end

        -- on ranking
    if self.btn_rank_daily then
        core.displayEX.newButton(self.btn_rank_daily)
            :onButtonClicked(function(event)
            self:setMenusVisible(false)

                scn.ScnMgr.popView("ranking.RankingView",{rType=2,rtList=self.rankingRList, info= self.info})

            end)
    end

         -- on ranking
    if self.btn_rank_weekly then
        core.displayEX.newButton(self.btn_rank_weekly)
            :onButtonClicked(function(event)
                self:setMenusVisible(false)

                scn.ScnMgr.popView("ranking.RankingView",{rType=3,rtList=self.rankingRList, info= self.info})

            end)
    end

    -- on achievement
    core.displayEX.newButton(self.btn_achievement) 
        :onButtonClicked(function(event)
            -- EventMgr:dispatchEvent({name  = EventMgr.STOP_LINEEFF_EVENT})
            --scn.ScnMgr.popView("social.FriendInforView",{tabidx=4})
            self:setMenusVisible(false)

            app:getObject("ReportModel"):forceSendReportGameData()
            net.HonorCS:getHonorList(app:getUserModel():getPid(),function(honorlist)
                app:getUserModel():setProperties({hashonor=-1})
                app:getUserModel():serializeModel()
                scn.ScnMgr.popView("HonorsView", honorlist)
            end)
        end)

    --on head
    core.displayEX.newButton(self.myHeadBtn) 
        :onButtonClicked(function(event)
            scn.ScnMgr.popView("social.FriendInforView")
        end)

    -- core.displayEX.newButton(self.btn_vip) 
    --     :onButtonClicked(function(event)

    --         scn.ScnMgr.popView("VipView")

    --     end)

    core.displayEX.newButton(self.btn_shop_coin) 
        :onButtonClicked(function(event)

            net.PurchaseCS:GetProductList(function(lists)
               scn.ScnMgr.popView("ProductsView",{productList=lists,tabidx=1})
            end)

        end)

    core.displayEX.newButton(self.btn_shop_gem) 
        :onButtonClicked(function(event)

            net.PurchaseCS:GetProductList(function(lists)
               scn.ScnMgr.popView("ProductsView",{productList=lists,tabidx=2})
            end)

        end)
        
end

function ControllBarBase:initBaseUI()
    
    local model = app:getUserModel()

    local exp = model:getCurrentLvExp()
    local lvl = model:getLevel()

    self.angleRatio = 248 / 360

    -- expProgress
    local expX,expY = self.exp_bar_image:getPosition()
    local parent = self.exp_bar_image:getParent()
    
    self.exp_bar_image:removeFromParent(false)

    self.expProgress = display.newProgressTimer(self.exp_bar_image, display.PROGRESS_TIMER_RADIAL)
        :pos(expX, expY)
        :addTo(parent)

    -- self.expProgress:setType(display.PROGRESS_TIMER_RADIAL)

    self.expProgress:setAnchorPoint(cc.p(0.5, 0.5))
    self.expProgress:setMidpoint(cc.p(0.5, 0.5))
    self.expProgress:setBarChangeRate(cc.p(1, 1))

    self.expProgress:setRotation(-116)

    local lexp = tonumber(getNeedExpByLevel(lvl+1))

    local percentVal = 100 * self.angleRatio * exp / lexp

    self.expProgress:setPercentage(percentVal)

end

-- function ControllBarBase:setExpProgress( from, to, levelup, time)
    
--     if time == nil then time = 1 end

--     if levelup == true then

--         local fromTo1 = cca.progressFromTo(time, from, 100)
--         local fromTo2 = cca.progressFromTo(time, 0, to)

--         local complete = function()
--             self.expProgress:setPercentage(0)
--         end
--         local callfun = cc.CallFunc:create(complete)

--         local seq = cc.Sequence:create(fromTo1, callfun, fromTo2)

--         self.expProgress:runAction(seq)

--         print(from, 100, to)

--     else

--         local fromTo = cca.progressFromTo(time, from, to)
--         local seq = cc.Sequence:create(fromTo)
--         self.expProgress:runAction(seq)

--     end

-- end

-- function ControllBarBase:getTwoPercentage(exp, lvl)

--     local nextlvl = lvl + 1

--     local pc1 = self.expProgress:getPercentage()
--     local lexp = tonumber(getLevelExpByLevel(nextlvl))

--     local pc2 = 100 * exp / lexp

--     local pastlevel = self.headView:getLevel()
--     local levelup = false

--     if lvl > pastlevel then levelup = true end

--     return pc1, pc2, levelup
-- end

function ControllBarBase:initPlayers()
    if self.lists == nil then return end

    self.playerList = {}
    -- body
    local getPlayer = function(idx)
        -- body
        local site_sub = 7 - self.info.mysite
        for i=1,#self.lists do
            local player = self.lists[i]
            local ui_pos = player.siteId + site_sub
            if ui_pos > 7 then
                ui_pos = ui_pos - 7
            end
            if idx == ui_pos  then
                return player
            end
        end
        return nil
    end

    local getPPos = function(ui_pos)
        local ui_sub = 7 - ui_pos
        local ppos = self.info.mysite - ui_sub + 7
        if ppos > 7 then
            ppos = ppos - 7
        end
        return ppos
    end

    for i=1,6 do
        local player = getPlayer(i)
        
        local headnode = self["headportrait_pg_"..tostring(i)]
        local parent = headnode:getParent()
        local x,y = headnode:getPosition()

        local pnode = display.newNode()

        if i > 3 then
            pnode.side = 2
        else
            pnode.side = 1
        end

        if player then
            self.playerList["players"..tostring(player.siteId)] = pnode
            pnode.siteId = player.siteId
            --printInfo("init i=%s,pnode.siteId=%s,player.siteId=%s",i,pnode.siteId,player.siteId)
        else
            self.playerList["players"..tostring(getPPos(i))] = pnode
            pnode.siteId = getPPos(i)
            --printInfo("init i=%s,getPPos=%s",i,pnode.siteId)
        end

        pnode:setPosition(cc.p(x,y))

        parent:addChild(pnode)

        self:initPlayerSet(pnode, player)

        headnode:removeFromParent(true)

    end        

    self:headNodeAction()

end

function ControllBarBase:initPlayerSet(pnode, playerInfo)

    local images = {
            normal = "#slots_neibu_touxiangbeijing.png",
            pressed = "#slots_neibu_touxiangbeijing.png",
            disabled = "#slots_neibu_touxiangbeijing.png",
        }
    

    if self.slotsName 
        and cc.SpriteFrameCache:getInstance():getSpriteFrame(self.slotsName.."_invite.png") then
    
        local image = "#"..self.slotsName.."_invite.png"

        images = {
            normal = image,
            pressed = image,
            disabled = image,
        }
    end

    local btn = cc.ui.UIPushButton.new(images, {scale9 = false})
        :align(display.CENTER)
        :addTo(pnode)


    if playerInfo ~= nil then

        local cell = headViewClass.new({player=playerInfo})
        --cell:registClickHead(false)
        cell:showUserName()
        pnode.head=cell
        pnode:addChild(cell)

        local headbtn = core.displayEX.newButton(cell.clickBtn) 

        headbtn:onButtonPressed(function(event)  
            if self.btnLock == true then return end

            headbtn.pressTime = 0   
            headbtn.scEntry = scheduler.scheduleGlobal(function(dt)
                headbtn.pressTime = headbtn.pressTime + dt
                if headbtn.pressTime > 1 then
                    scheduler.unscheduleGlobal(headbtn.scEntry)
                    local function onComplete(infos)                
                        scn.ScnMgr.popView("social.FriendInforView",{info=infos})
                    end
                    net.UserCS:getPlayerInfo(playerInfo.pid, onComplete)
                end

            end , 0)

         end)
                
        headbtn:onButtonClicked(function(event)  

            if self.btnLock == true then return end

            scheduler.unscheduleGlobal(headbtn.scEntry)
        
            if headbtn.pressTime < 0.5 then
                scn.ScnMgr.popView("gift.GiftsView",{shortTouch=1,
                    tabidx=1,
                    pid=playerInfo.pid,
                    sendGiftFlag = playerInfo.sendGiftFlag,
                    sendbackCall=function(giftId)
                        self:performWithDelay(function()

                            local startPos = self.myHeadBtn:getParent():convertToWorldSpace(cc.p(self.myHeadBtn:getPosition()))
                            local destPos = pnode.head:getParent():convertToWorldSpace(cc.p(pnode.head:getPosition()))
    
                            self:showGiftEffect(giftId,startPos,destPos,0.65)
                        end,0.2)
                    end})
            end
        end)
            
    else

        btn:onButtonClicked(function(event)
            
            if self.btnLock == true then return end

            local function onComplete(lists)
                if self.info == nil then
                    return
                end
                -- local temp = {}
                -- for i =1,#lists do
                --     local flag = false
                --     for j = 1,#self.lists do
                --         if lists[i].pid == self.lists[j].pid then
                --             flag = true
                --             break
                --         end
                --     end
                --     if flag == false then
                --         temp[#temp+1] = lists[i]
                --     end
                -- end
                if #lists > 0 then
                    local gameinfo = {
                        friendlists = lists,
                        gameId = self.info.gameId,
                        roomId = self.info.roomId,
                        siteId = pnode.siteId
                    }
                    scn.ScnMgr.popView("IniteFriendPlayView", gameinfo)
                else
                    scn.ScnMgr.popView("social.SocialView",{tabidx=1})
                end
            end
            net.FriendsCS:getFriendsList(onComplete)

        end)

    end
end

function ControllBarBase:updatePlayersStates(event)--关于player事件
    
    if self.lists == nil then return end

    local playerList = event.playerList
    local getPPos = function(ui_pos)
        local ui_sub = 7 - ui_pos
        local ppos = self.info.mysite - ui_sub + 7
        if ppos > 7 then
            ppos = ppos - 7
        end
        return ppos
    end
    local getUIPos = function(ppos)
        -- body
        local site_sub = 7 - self.info.mysite
        local ui_pos = ppos + site_sub
        if ui_pos > 7 then
            ui_pos = ui_pos - 7
        end
        return ui_pos
    end

    local getPlayer = function(pid)

        for k,v in pairs(self.playerList) do
            if v and v.head and  v.head.player and v.head.player.pid == pid then
                return v
            end
        end

        return nil
    end

    for i=1,#playerList do

        local player = playerList[i]

        print("updatePlayersStates",player.siteId, player.giftId,player.senderId)

        local pnode = self.playerList["players"..tostring(player.siteId)]
        print("=========player.notifyType  = " .. player.notifyType)
        if player.notifyType == 1 then
            if pnode then
                pnode:removeAllChildren()
                pnode.siteId = player.siteId
            end
            self:initPlayerSet(pnode, player)
            self:updateHeadState()
            self:showEnter(pnode)

        elseif player.notifyType == 2 then
            
            if pnode then
                pnode:removeAllChildren()
                pnode.siteId = player.siteId
            end
            self:initPlayerSet(pnode)
            
        elseif player.notifyType == 3 or player.notifyType == 4 or player.notifyType >= 6 and player.notifyType <=10 then
            self:showAwardInfo(pnode,player.notifyType)
            self:updateHeadState()

        elseif player.notifyType == 5 then
            if player.pid == app:getUserModel():getPid() then

                local startPnode = getPlayer(player.senderId)
                local startPos = startPnode:getParent():convertToWorldSpace(cc.p(startPnode:getPosition()))
                local destPos = {x=display.cx,y=display.cy}
                self:showGiftEffect(player.giftId, startPos, destPos, 1.5)


            else
                if pnode.head then
                    local startPnode = getPlayer(player.senderId)
                    local startPos = startPnode:getParent():convertToWorldSpace(cc.p(startPnode:getPosition()))
                    local destPos = pnode.head:getParent():convertToWorldSpace(cc.p(pnode.head:getPosition()))

                    self:showGiftEffect(player.giftId,startPos, destPos, 0.65)
                end
            end
        end

    end
end

function ControllBarBase:registChatEvent()
    
    if self.lists == nil then return end

    print("Controllbar:registChatEvent")
    -- body
    core.SocketNet:registEvent(GC_CHAT_MESSAGE, function(body)
        -- body
        local msg = Chat_pb.GCChatMessage()
        msg:ParseFromString(body)

        print(tostring(msg))

        self:showChat(msg)

    end)
end

function ControllBarBase:showChat( msg )

    local node = self.playerList["players"..tostring(msg.siteId)]

    if node then

        local chatNode = nil
        local chatBg = nil
        local chatTxt = nil

        if node.side == 1 then

            chatNode = self.chatLeftNode
            chatBg = self.chat_left_bg
            chatTxt = self.chat_left_content

        elseif node.side == 2 then

            chatNode = self.chatRightNode
            chatBg = self.chat_right_bg
            chatTxt = self.chat_right_content

        end

        local pos = node:getParent():convertToWorldSpace(cc.p(node:getPosition()))
        chatNode:setPosition(pos)


        chatNode:setVisible(true)

        chatTxt:setString(msg.content)

        local size = chatTxt:getContentSize()

        chatBg:size(size.width+30, 44)

        transition.fadeOut(chatTxt, {time = 0.5,delay = 2.0,
            onComplete = function()
                chatNode:setVisible(false)
                chatTxt:setOpacity(255)
            end}
        )

        self:updateHeadState()

    else

        self.chatLeftNode:setVisible(true)
        self.chat_left_content:setString(msg.content)

        local size = self.chat_left_content:getContentSize()

        self.chat_left_bg:size(size.width+30, 44)

        transition.fadeOut(self.chat_left_content, {time = 0.5,delay = 2.0,
            onComplete = function()
                self.chatLeftNode:setVisible(false)
                self.chat_left_content:setOpacity(255)
            end}
        )
    end

end

function ControllBarBase:headNodeAction()
    
    self.left_pnode:setVisible(true)

    local lposX, lposY = self.left_pnode:getPosition()
    self.left_pnode:setPositionX(lposX - 102)

    transition.moveTo(self.left_pnode, {
        x = lposX,
        y = lposY,
        time = 0.65,
        delay = 1.0
    })

    self.right_pnode:setVisible(true)

    local rposX, rposY = self.right_pnode:getPosition()
    self.right_pnode:setPositionX(rposX + 102)

    transition.moveTo(self.right_pnode, {
        x = rposX,
        y = rposY,
        time = 0.65,
        delay = 1.0,
        onComplete=function()
            -- body
            -- if btn_allplayer_opened then
            --     self.btn_allplayer_opened:setVisible(true)
            --     self.btn_allplayer_opened:setButtonEnabled(true)
            -- end
            -- if btn_allplayer then
            --     self.btn_allplayer:setVisible(false)
            --     self.btn_allplayer:setButtonEnabled(false)
            -- end
         
        end
    })



end

function ControllBarBase:updateHeadState()


    local flag = self.left_pnode:isVisible()

    if flag == false then
    
        --self.btn_allplayer:setButtonEnabled(false)

        self.left_pnode:setVisible(true)

        local lposX, lposY = self.left_pnode:getPosition()
        self.left_pnode:setPositionX(lposX - 102)

        transition.moveTo(self.left_pnode, {
            x = lposX,
            y = lposY,
            time = 0.5,
            delay = 1.0
        })

        self:performWithDelay(function()

            transition.moveTo(self.left_pnode, {
                x = lposX - 102,
                y = lposY,
                time = 0.5,
                onComplete=function()
                    self.left_pnode:setVisible(flag)
                    self.left_pnode:setPositionX(lposX)
                    --self.btn_allplayer:setButtonEnabled(true)
                end
            })

        end,5.5)

    end


    local flag = self.right_pnode:isVisible()

    if flag == false then

        self.right_pnode:setVisible(true)

        local rposX, rposY = self.right_pnode:getPosition()
        self.right_pnode:setPositionX(rposX + 102)

        transition.moveTo(self.right_pnode, {
            x = rposX,
            y = rposY,
            time = 0.5,
            delay = 1.0
        })

        self:performWithDelay(function()

            transition.moveTo(self.right_pnode, {
                x = rposX + 102,
                y = rposY,
                time = 0.5,
                onComplete=function()
                    self.right_pnode:setVisible(flag)
                    self.right_pnode:setPositionX(rposX)
                end
            })

        end,5.5)

    end
end

function ControllBarBase:updateWinCoinLabel( value )
    --self.winCoinsLabel:setString(value)
end

function ControllBarBase:updateGems( value )
    self.gemsNum:setString(number.addCommaSeperate(value))
end

function ControllBarBase:updateNotice(event) --更新信息
    local model = app:getUserModel()
    local hasNum = tonumber(event.hasnews)
    print("游戏内 notify:", hasNum)--1nofity 2reward 3invite 4gift 5honor 6task

    audio.playSound(RES_AUDIO.new_message)

    if hasNum == 1 or hasNum == 2 or hasNum == 3 or hasNum == 7 then
        model:setProperties({hasnews=hasNum})
        self.messageHint:setVisible(true)
        self.messageHint1:setVisible(true)
    elseif hasNum == 4 then
        model:setProperties({hasgift=hasNum})
        self.redtip_gift:setVisible(true)
    elseif hasNum == 5 then
        self.messageHint2:setVisible(true)
        self.messageHint1:setVisible(true)
        model:setProperties({hashonor=hasNum})
    elseif hasNum == 6 then
        model:setProperties({hastask=hasNum})
    end
    model:serializeModel()

end

function ControllBarBase:showDouble()

end

function ControllBarBase:hideDouble()

end


function ControllBarBase:addSmallWinEff(eff)

end

function ControllBarBase:upTTCoinsByStep(value)
    local frNum = tonumber(number.deleteCommaSeperate(self.totalCoinsLabel:getString()))
    --SlotsMgr.setLabelStepCounter(self.totalCoinsLabel, frNum, value, 0.5)
end


function ControllBarBase:setTTCoins(value)
    --SlotsMgr.stopLabelStepCounter(self.totalCoinsLabel)
    self.coinsNum:setString(number.addCommaSeperate(value))
end


function ControllBarBase:upWinCoinsByStep(value)
    local frNum = tonumber(number.deleteCommaSeperate(self.winCoinsLabel:getString()))
    --SlotsMgr.setLabelStepCounter(self.winCoinsLabel, frNum, value, 0.5)
end

function ControllBarBase:setWinCoins(value)
    --SlotsMgr.stopLabelStepCounter(self.winCoinsLabel)
    self.coinsNum:setString(number.addCommaSeperate(value))
end


function ControllBarBase:onEnter()

    print("ControllBarBase:onEnter()")
    
    app.controllBar = self

    self:initBaseUI()
    self:updateBaseUILabel()
    self:initBaseButton()
    self:initPlayers()
    self:registChatEvent()

    EventMgr:addEventListener(EventMgr.UPDATE_LOBBYUI_EVENT, handler(self, self.updateBaseUILabel))
    EventMgr:addEventListener(EventMgr.SERVER_NOTICE_EVENT, handler(self, self.updateNotice))
    EventMgr:addEventListener(EventMgr.UPDATE_PSTATES_EVENT, handler(self, self.updatePlayersStates))
    EventMgr:addEventListener(EventMgr.UPDATE_JACKPOT, handler(self, self.updateJackpot))

    --app:showAds()

end


function ControllBarBase:onExit()
    print("ControllBarBase:onExit()")
    
    self:endTimer()

    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_LOBBYUI_EVENT)
    EventMgr:removeEventListenersByEvent(EventMgr.SERVER_NOTICE_EVENT)
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_PSTATES_EVENT)
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_JACKPOT)
    --core.SocketNet:unregistEvent(GC_GET_ONLINE_PLAYERS)
    --self:removeAllChildren()
    collectgarbage("collect")

    app.controllBar = nil

    --app:hideAds()

end

function ControllBarBase:showAwardInfo(pnode, type)
    if pnode and pnode.head then
        table.insert(app.showWinTable,rewardList[tostring(type)])
        if #app.showWinTable==1 then
            pnode.head:showWin()
        end
    end
end

function ControllBarBase:showEnter(pnode)
    if pnode and pnode.head then
        pnode.head:showEnter()
    end
end

function ControllBarBase:showGiftEffect(sendGIdx,startPos,destPos, scale)
    
    local movebox  = CCBReaderLoad("effect/gifts_movebox.ccbi", self)
    local moveBoxAnimationMgr = self.rootNode.animationManager
    local moveBoxTuoweiSp = self.tuoweiSp

    local dist = ToolUtils.dist2(startPos, destPos)
    local time = dist/1000
    local angle = ToolUtils.getRotation(startPos.x,startPos.y,destPos.x,destPos.y)
    
    if time < 0.5 then time = 0.5 end

    movebox:setPosition(startPos)  
    moveBoxTuoweiSp:setRotation(-angle)

    display.getRunningScene():addChild(movebox)

    movebox:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.33),
        cc.MoveBy:create(time,cc.p(destPos.x-startPos.x,destPos.y-startPos.y)),
        cc.CallFunc:create(function()
        
            moveBoxAnimationMgr:runAnimationsForSequenceNamed('end')

            self:performWithDelay(function()

                local gifteffect  = CCBReaderLoad(GIFTS_EFFECT[tonumber(sendGIdx)], self)
                gifteffect:setScale(scale)
                gifteffect:setPosition(destPos)
                display.getRunningScene():addChild(gifteffect)

                gifteffect:runAction(cc.Sequence:create(
                    cc.DelayTime:create(2.0),
                    cc.CallFunc:create(function()
                        gifteffect:removeFromParent()
                        movebox:removeFromParent()
                end)))

            end,0.3)

    end)))
    
end

return ControllBarBase
