local PokerApi = require("app.data.poker.PokerApi")
local PokerGameSet = require("app.data.poker.beans.PokerGameSet")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local Controller = class("PokerController", function()
    return display.newScene("PokerController")
end)

local reportData = {}

function Controller:ctor( homeinfo)
    local unit = homeinfo.info.unitdata
    self.handNum = unit.config.hands
    self.gameId = unit.dict_id
    self.betlist = unit.config.bet_list

    local ViewClass = require("app.scenes.videopoker.PokerView")
    self.pokerView =  ViewClass.new(unit)
    self.pokerView:init(homeinfo)
    self.pokerView:addTo(self)

    if not app:isObjectExists("PokerModel") then
        local ModelClass = require("app.scenes.videopoker.PokerModel")
        local pokermodel = ModelClass.new({id = "PokerModel"})
        app:setObject("PokerModel", pokermodel)
        self.model = pokermodel
    else
        self.model = app:getObject("PokerModel")
    end

    reportData.gameType = tonumber(unit.category)
    reportData.gameId = tonumber(unit.unit_id)
    reportData.handsPlayed = unit.config.hands
    reportData.gameCnt = 1
    reportData.handsWin = 0

    self.onOffDeal = true
end

function Controller:init()
    self.userModel = app:getObject("UserModel")
    self.bet = self.model:getBet()
    if self.bet  == 0 then
        self.bet = self.betlist[1]
    end
    self.coinss = self.userModel:getCoins()--coins
    local obj = {
        coins = self.coinss,
        bet = self.bet }

    self:initListener()
    self.pokerView:initUI(obj)

    self.effectArr = {}
end

function Controller:initListener()

    core.displayEX.newButton(self.pokerView.btn_deal,RES_AUDIO.poker_card_flip)
        :onButtonClicked(function() self:doPreDeal() end)

    core.displayEX.newButton(self.pokerView.btn_draw,RES_AUDIO.poker_card_flip)
        :onButtonClicked(function() 
            self.pokerView:setBtnState(false)
            self:doDraw()
        end)

    core.displayEX.newButton(self.pokerView.maxBetBTN)
        :onButtonClicked(function() 
            self.bet = self.betlist[#self.betlist]
            self.pokerView:updateBet(self.bet)

            self:doPreDeal()
        end)

    core.displayEX.newButton(self.pokerView.addBetBtn)
        :onButtonClicked(function() 

            local i = table.indexof(self.betlist,self.bet)
            i = (i+1 > #self.betlist and 1) or i+1
            self.bet = self.betlist[i]
            self.pokerView:updateBet(self.bet)

        end)

    core.displayEX.newButton(self.pokerView.subBetBtn)
        :onButtonClicked(function() 

            local j = table.indexof(self.betlist,self.bet)
            j = (j-1 < 1  and #self.betlist) or j-1
            self.bet = self.betlist[j]
            self.pokerView:updateBet(self.bet)

        end)


    core.displayEX.newButton(self.pokerView.btn_double)
        :onButtonClicked(function() 
            self:doDouble()
        end)

    core.displayEX.newButton(self.pokerView.paytableBtn)
        :onButtonClicked(function() 

            local ccbi = "poker_vedio/paytable_videopoker.ccbi"
            scn.ScnMgr.addView("PaytableView",{ccbi = ccbi, page = 1})
        end)
end

function Controller:doDouble()
    self.pokerView.btn_double:setVisible(false)
    local DoubleClass = require("app.scenes.common.DoublePoker")
    local coin = self.pokerView.winCoin
    local layer = DoubleClass.new({wincoins=coin, callback=function(win)
        self:updateCoin(self.userModel:getCoins())
        self.pokerView:setWinCoins(self.userModel:getCoins())
        if win < 0 then win = 0 end
        self.pokerView:updateWin(win)
        audio.playMusic(RES_AUDIO.bg_poker)
    end})
    self:addChild(layer)
end

function Controller:doPreDeal()
    if self.onOffDeal == false then
        return
    end
    self.onOffDeal = false
    local cost = self.bet * self.handNum
    if cost > self.coinss then --------
        scn.ScnMgr.popView("ShortCoinsView",{})
        return
    end

    self.pokerView:setBtnState(true)
    self.pokerView:setBetBtnState(false)
    self.pokerView.btn_double:setVisible(false)
    self.pokerView:updateWin(0)
    self.pokerView:hidePoker()
    self.pokerView:removeGlow()
    for k, ef in pairs( self.effectArr) do
        ef:removeSelf()
    end
    self.effectArr = {}
    scheduler.performWithDelayGlobal(function()
        self:doDeal()
    end,0.1)
end

function Controller:updateCoin(value)
    self.coinss =  value
    self.userModel:setCoins(value)
    self.pokerView:updateCoin(value)
end

function Controller:doDeal()

    self:updateCoin(self.coinss - self.bet * self.handNum)

    local gameset = PokerGameSet.new()
    gameset.bet = self.bet
    gameset.gameId = self.gameId
    local presult = PokerApi.getPokerCards(gameset)
    local i = 0
    local dealCallBack = function()
        i = i+1
        if i == 5 then
            self.pokerView.btn_draw:setButtonEnabled(true)
            self.pokerView.isHold = true
        end
    end
    for k, card in pairs(presult.firstCardArray) do
        self.pokerView:dealCard(card,dealCallBack)
    end
    self.firstResult = presult
end

function Controller:doDraw()
    self.pokerView.isHold = false
    self.pokerView:setHoldTipVisible(false)
    local gameset = PokerGameSet.new()
    gameset.bet = self.bet
    gameset.userCardArray = self.firstResult.firstCardArray
    for k, v in pairs( gameset.userCardArray) do
        local hold =  self.pokerView["hold1_"..v.showIdx]
        if hold:isVisible() then
            v.holdSign = 1
        else
            v.holdSign = 0
        end
    end
    self.firstResult = nil
    
    local result = PokerApi.getPokerCards(gameset)
    local c,len = 0, #result.replaceCardArray

    if len == 0 then
        self:doDrawAfter(gameset,result)
    else
        for k, card in pairs(result.replaceCardArray) do
            self.pokerView:drawCard(card,function()
                c = c + 1
                if c == len then
                    self:doDrawAfter(gameset,result)
                end
            end)
        end
    end
end

function Controller:doDrawAfter(gameset,result)    
    local winCoin = result.rewardCoins
    local totalBet = self.bet * self.handNum
    self.pokerView:hideHold()
    result.h = 1
    local resultArr = {result}
    local delay = 0.2

    if self.pokerView.isMore then
        local rowNum = self.pokerView.rowNum
        local columnNum =  self.pokerView.columnNum
        for column = 1, columnNum do
            for r = 1, rowNum do
                local iResult = PokerApi.getPokerCards(clone(gameset))
                local h = (r-1) * columnNum + column +1
                iResult.h = h
                table.insert(resultArr,iResult)
                for pi = 1, 5 do
                    local isr, rcard =  self:findCardByIndex(pi,iResult.replaceCardArray)
                    local isw, wcard =  self:findCardByIndex(pi,iResult.winCardArray)
                    self.pokerView:showCard(rcard,h,pi,column,isr,isw)
                end
                winCoin = winCoin + iResult.rewardCoins
                reportData.handsWin = reportData.handsWin + 1
            end
        end
        delay = columnNum * 0.3
    end
    scheduler.performWithDelayGlobal(function()
        local rf,sf,fk = 0,0,0
        for _, result in pairs(resultArr) do
            self:playWinEffect(result.winPattern,result.h)
            local pattern = tonumber(result.winPattern)
            if pattern == VP.PATTERN_ID.Royal_Straight_Flush then
                rf  = rf + 1

            elseif pattern == VP.PATTERN_ID.Straight_Flush then
                sf = sf + 1

            elseif pattern == VP.PATTERN_ID.Four_of_a_Kind then
                fk = fk + 1
                
            end
        end
        self.pokerView.btn_deal:setButtonEnabled(true)
        self.pokerView:setBetBtnState(true)
        self.pokerView:updateWin(winCoin)
        self:updateCoin(self.coinss + winCoin)
        reportData.winCnt = 0

        if winCoin > totalBet then
            reportData.winCnt = 1
            audio.playSound(RES_AUDIO.poker_win)
        end
        if winCoin > 0 then
            self.pokerView.btn_double:setVisible(true)
        end

        self:playEffByWinCoins(winCoin,totalBet)

        reportData.bigWin = self.bigwin
        reportData.mageWin = self.magwin 
        reportData.royalFlush = rf
        reportData.straightFlush = sf
        reportData.fourOfAKind = fk
        reportData.winCoins = winCoin
        reportData.costCoins = self.bet * self.handNum --消耗金币
        reportData.pokerSuit = json.encode(self.model:getPokerSuit())
        net.UserCS:dataReport(reportData)
        print("videopoker pokerSuit", reportData.pokerSuit)

        local onCallBack = function()
            local exp = reportData.costCoins + self.userModel:getExp()
            self.userModel:setExp(exp)
            EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})
        end
        self.pokerView:playExpEffect(reportData.costCoins,onCallBack)
        self.onOffDeal = true  

        local callback = function()
        end

        local gameid = app:getPlayerStatus().gameId 
        local maxBet = DICT_UNIT[tostring(gameid)].config.max_bet
        local bet = false
        if tonumber(totalBet) >= tonumber(maxBet) then
            bet = true
        end

        if  rf == 1 and bet==true then
            net.JackpotCS:rewardJackpot(app.JackpotCoins,function(rewardCoins)
                scn.ScnMgr.popView("JackPotView",{rewardCoins = rewardCoins,callBack = callback})
                local totalCoins = app:getUserModel():getCoins() + rewardCoins
                app:getUserModel():setCoins(totalCoins)
                print("====rewardJackpot=====" .. rewardCoins )
            end)
        else
            callback()
        end

    end,delay)
end

function Controller:findCardByIndex(i,array)
    for k, card in pairs(array) do
        if card.showIdx == i then
            return true,card
        end
    end
    return false,nil
end

function Controller:playWinEffect(id,h)
    if id == 11 then return end
    self.pokerView:showGlow(id)
    local item = poker_reward_effect[tostring(id)]
    local ccb = "poker_vedio/"
    if self.handNum == 25 then
        ccb = ccb..item.ccb3
    elseif self.handNum == 10 or self.handNum == 5 then
        ccb = ccb..item.ccb2
    elseif self.handNum == 1 then
        ccb = ccb..item.ccb1
    end

    local effect = CCBReaderLoad(ccb)
    if self.pokerView.isMore then
        local target = self.pokerView["poker"..h.."_"..3]
        local x,y = target:getPosition()
        local pos = target:getParent():convertToWorldSpace(cc.p(x,y))
        effect:setPosition(pos.x, pos.y)
    else
        effect:setPosition(display.cx,display.cy)
    end

    local sp = effect:getChildByTag(10)
    if sp ~= nil then
        local frame
        if self.handNum == 25 then
           frame = display.newSpriteFrame(item.small_image)
        else
            frame = display.newSpriteFrame(item.image)
        end
        if frame then
            sp:setSpriteFrame(frame)
        end
    end
    self:addChild(effect)

   table.insert(self.effectArr,effect)
end

function Controller:getViewPos(target)
    local x,y = target:getPosition()
    local pos = target:getParent():convertToWorldSpace(cc.p(x,y))
    pos = self:convertToNodeSpace(pos)
    return pos
end

function Controller:onEnter()
    self:init()
    audio.playMusic(RES_AUDIO.bg_poker)
end

function Controller:onExit()
    self.pokerView = nil
    self.model = nil
    self.userModel = nil
    self = {}
    audio.stopMusic()
end

function Controller:playEffByWinCoins(winCoin,totalBet)
    self.bigwin = 0
    self.magwin = 0
    local mega = winCoin >= 10 * totalBet
    local bigw = winCoin >= 5 * totalBet and winCoin < 10 * totalBet
    if mega == false and bigw == false then
        return
    else
        if mega then
            self.magwin = 1
        end
        if bigw then
            self.bigwin = 1
        end
    end

    scheduler.performWithDelayGlobal(function( )
        -- body
        if mega == true then
            scn.ScnMgr.addView("MegaWinView", {winCoin = winCoin})
        elseif bigw == true then
            scn.ScnMgr.addView("BigWinView", {winCoin = winCoin})
        end

    end,1.0)




end

return Controller