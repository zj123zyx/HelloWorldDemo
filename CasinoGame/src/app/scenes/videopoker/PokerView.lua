local function scaleFun(target, scaleX,scaleY, time, onComplete)
    transition.scaleTo(target, {scaleX=scaleX,scaleY= scaleY,time= time,onComplete = onComplete})
end

local PokerView = class("PokerView", controllBase)

function PokerView:ctor(args)
    
    self.handNum = args.config.hands

    local ccbiFile
    local node

    if self.handNum > 1 then
        ccbiFile = "poker_vedio/poker_02_machine.ccbi"
        node = CCBReaderLoad(ccbiFile, self)
        self.id = tonumber(args.unit_id)-300  

        if self.id > 2 then
            local plistFile="poker_vedio/poker_vedio_bj"..tostring(self.id)..".plist"
            local pvrFile="poker_vedio/poker_vedio_bj"..tostring(self.id)..".pvr.ccz"
            display.addSpriteFrames(plistFile,pvrFile)
            self.vpoker_bg:setSpriteFrame("ddpk_puke_zhuomian0"..tostring(self.id)..".png")
        end

        self.isMore = true
    else
        ccbiFile = "poker_vedio/poker_01_machine.ccbi"
        node = CCBReaderLoad(ccbiFile, self)
    end
    
    self:addChild(node)
    app.jackpotLabel = self.jackpot
    app.jackpotLabel:setTag(app:getPlayerStatus().gameId)
    
    local row,column = 0,0 --行和列
    if self.handNum == 5 then
        row = 2
    elseif self.handNum == 10 then
        row = 3
    elseif self.handNum == 25 then
        row = 4
    end
    column = math.modf((self.handNum -1) /row)
    self.rowNum = row
    self.columnNum = column

    local size = self.bottom_bar:getContentSize()
    local bottomBarH = size.height*display.width / size.width
    local imageBg = 650
    local sunHeight = display.height - bottomBarH

    local bgScaleX = display.width / 1136
    local bgScaleY = sunHeight / imageBg

    self.vpoker_bg:setScaleX(bgScaleX)
    self.vpoker_bg:setScaleY(bgScaleY)

    self:layoutCtr(true)
    self.actionNode = display.newNode()
    self:addChild(self.actionNode)
end


function PokerView:initUI(obj)
    --self.coin_text:setString(obj.coins)
    self:setNodeEventEnabled(true)

    self.win_text:setString(0)
    self:updateBet(obj.bet)

    self.btn_draw:setVisible(false)
    self.btn_draw:setButtonEnabled(false)

    for i = 1, 5 do
        local hold = self["hold1_"..i] --hold标签
        hold:setVisible(false)
        hold:setLocalZOrder(10)

        self["hoidtip1_"..i]:setVisible(false)

        local spFront = self["poker1_"..i]
        spFront:setVisible(false)
        spFront:setTouchEnabled(true)
        spFront:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                return true
            elseif event.name == "ended" and self.isHold then
                local isv = hold:isVisible()
                hold:setVisible(not isv)
                self["hoidtip1_"..i]:setVisible(isv)
                self:moreHandHold(i,hold:isVisible())
            end
            
        end)
    end
    if self.isMore  then
        self.totalbet_text:setString(obj.bet * self.handNum)
        local node = CCBReaderLoad("poker_vedio/"..self.handNum.."hands.ccbi", self)
        self.container:addChild(node)

        -- caculte the position of poker 

        local scale = display.width / 1080
        local screenTopH = 70
        local screenBottomH = 114 * scale
        local screenH = display.height - screenBottomH - screenTopH

        local sizeHands = node:getContentSize()
        local sizeChoose = self.poker_choose:getContentSize()

        local cellSPW = (screenH-sizeHands.height-sizeChoose.height) / 3

        local positionY = screenBottomH + cellSPW + sizeChoose.height/2

        self.poker_choose:setPositionY(positionY)
        
        local positionY = screenBottomH + cellSPW * 2 + sizeChoose.height +sizeHands.height/2 + 10
        self.container:setPositionY(positionY)

        -- end

        for i = 2, self.handNum do
            for j = 1, 5 do
                self["poker"..i.."_"..j]:setVisible(false)
            end
        end
    end

    self.btn_double:setVisible(false)
end

function PokerView:moreHandHold(index,flag)
    local spFront = self["poker1_"..index]
    local image = spFront.resName..".png"
    if self.handNum == 25 then
        image =  spFront.resName.."_small.png"
    end
    local frame = display.newSpriteFrame(image)
    for i = 2, self.handNum do
        local poker = self["poker"..i.."_"..index]
        poker:setVisible(flag)
        self["back"..i.."_"..index]:setVisible(not flag)
        if flag and frame then
            poker:setSpriteFrame(frame)
        end
    end
end

function PokerView:setBtnState(flag)
    self.btn_deal:setButtonEnabled(false)
    self.btn_draw:setButtonEnabled(false)
    self.btn_deal:setVisible(not flag)
    self.btn_draw:setVisible(flag)

end

function PokerView:setBetBtnState(flag)
    if flag then
        self:unlockBTN()
    else
        self:lockBTN()
    end
end

function PokerView:dealCard(card,callback)
    local hold =  self["hold1_"..card.showIdx]
    local spBack = self["back1_"..card.showIdx]
    local spFront = self["poker1_"..card.showIdx]
    spFront:setVisible(true)
    spBack:setVisible(true)
    local frame = display.newSpriteFrame(card.resName..".png")
    if frame then
        spFront:setSpriteFrame(frame)
    end
    spFront:setScaleX(0)
    spFront.resName = card.resName
    local tip =  self["hoidtip1_"..card.showIdx]
    tip:setVisible(true)
    local flipComplete = function()
        spBack:setScaleX(1)
        spBack:setVisible(false)
        
        if card.holdSign == 1 then
            hold:setVisible(true)
            tip:setVisible(false)
            if self.isMore then
                for i = 2, self.handNum do
                    self["back"..i.."_"..card.showIdx]:setVisible(false)
                    local sp = self["poker"..i.."_"..card.showIdx]
                    sp:setVisible(true)
                    local image = self:matchCardImage(card.resName)
                    local newFrame = display.newSpriteFrame(image)
                    if newFrame then
                        sp:setSpriteFrame(newFrame)
                    end
                end
            end
        end
        callback()
    end

    scaleFun(spBack, 0,1, 0.3, function()
        scaleFun(spFront, 1,1, 0.3, flipComplete)
    end)
end

function PokerView:drawCard(card,callback)
    local spBack = self["back1_"..card.showIdx]
    local spFront = self["poker1_"..card.showIdx]
    spFront:setScaleX(0)
    spBack:setVisible(true)
    local frame = display.newSpriteFrame(card.resName..".png")
    if frame then
        spFront:setSpriteFrame(frame)
    end
    scaleFun(spBack, 0,1, 0.3, function()
        scaleFun(spFront, 1,1, 0.3,function()
            spBack:setScaleX(1)
            spBack:setVisible(false)
            callback()
        end)
    end)
end

function PokerView:hideHold()
    local hold
    for i = 1, 5 do
        hold =  self["hold1_"..i]
        hold:setVisible(false)
    end
end

function PokerView:setHoldTipVisible(flag)
    local hold
    for i = 1, 5 do
        hold =  self["hoidtip1_"..i]
        hold:setVisible(flag)
    end
end

function PokerView:hidePoker()
    local sp
    for i = 1, self.handNum do
        for j = 1, 5 do
            sp =  self["poker"..i.."_"..j]
            sp:setColor(cc.c4b(255,255,255,255))
            sp:setVisible(false)
            self["back"..i.."_"..j]:setVisible(true)
        end
    end
end

function PokerView:setPokerColor(color)
    local sp
    for i = 2, self.handNum do
        for j = 1, 5 do
            sp =  self["poker"..i.."_"..j]
            sp:setColor(color)
        end
    end
end

function PokerView:matchCardImage(name)
    local image = name..".png"
    if self.handNum == 25 then
        image =  name.."_small.png"
    end
    return image
end

function PokerView:showCard(card,hand,index,column,isReplace,isWin)
    local spFront = self["poker"..hand.."_"..index]
    local spBack = self["back"..hand.."_"..index]
    local delay =  cc.DelayTime:create((column-1)*0.25 + 0.05*index)
    local call = cc.CallFunc:create(function()
        spFront:setVisible(true)
        if isReplace then
            local image = self:matchCardImage(card.resName)
            local frame = display.newSpriteFrame(image)
            if frame then
                spFront:setSpriteFrame(frame)
            end
        end
        if isWin then
            spFront:setColor(cc.c4b(255,255,255,255))
        else
            spFront:setColor(cc.c4b(128,128,128,255))
        end
        spFront:setOpacity(0)
    end)

    local hidecall =  cc.CallFunc:create(function()
        spBack:setVisible(false)
    end)

    local fadein = cc.FadeIn:create(0.1)
    local action = cc.Sequence:create(delay,call,fadein,hidecall)
    spFront:runAction(action)
end

function PokerView:showWinCard(card,hand)
    local spFront = self["poker"..hand.."_"..card.showIdx]
    local color = cc.c4b(255,255,255,255)
    spFront:setColor(color)
end

function PokerView:updateCoin(value)
    --self.coin_text:setString(value)
end

function PokerView:updateWin(value)
    self.win_text:setString(value)
    self.winCoin = value
end

function PokerView:updateBet(value)
    self.bet_text:setString(value)
    if self.isMore then
        self.totalbet_text:setString(value * self.handNum)
    end
end

function PokerView:showGlow(id)
    if self.isMore then return end
    local glow = CCBReaderLoad("poker_vedio/kuang_win.ccbi")
    self["guangquan"..id]:addChild(glow)
    self.glow = glow
end

function PokerView:removeGlow()
    if self.glow ~= nil then
        self.glow:removeSelf()
        self.glow = nil
    end
end

function PokerView:onEnter()
    self.super.onEnter(self)
    audio.playSound(RES_AUDIO.poker_goroom, false)
end

function PokerView:onExit()
    self.super.onExit(self)
end

return PokerView
