local VipView = class("VipView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function VipView:ctor()
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.vip, self)

    self:addChild(self.viewNode)

    self:registerEvent()
    self:initUI()
end

function VipView:registerEvent()
    -- on close
    core.displayEX.newButton(self.btn_close) 
        :onButtonClicked(function(event)
            scn.ScnMgr.removeView(self)
        end)
end

function VipView:initUI()
    local model = app:getUserModel()

    local vipPoint = model:getCurrentVipLvExp()
    local vipLevel = model:getVipLevel()

	local nextPoints = getNeedVipPointByLevel(vipLevel+1)

    self.currentVipPoints:setString(tostring(vipPoint))
    self.nextVipPoints:setString(tostring(nextPoints))

    local cvdict = DICT_VIP[tostring(vipLevel)]
    if cvdict then
    	local currentImage = "vip_"..cvdict.alias..".png"
    	self.currentStatus:setSpriteFrame(currentImage)

        if cc.SpriteFrameCache:getInstance():getSpriteFrame(cvdict.picture) then
            self.curStateSprite:setSpriteFrame(cvdict.picture)
        end
    else
        self.curStateSprite:setVisible(false)
    end

    local nvdict  = DICT_VIP[tostring(vipLevel+1)]
    if nvdict then
    	local nextImage = "vip_"..nvdict.alias..".png"
   		self.nextStatus:setSpriteFrame(nextImage)

        if cc.SpriteFrameCache:getInstance():getSpriteFrame(nvdict.picture) then
            self.nextStateSprite:setSpriteFrame(nvdict.picture)
        end
        self.highestLevelNode:setVisible(false)
        self.levelNode:setVisible(true)
    else
        self.levelNode:setVisible(false)
        self.highestLevelNode:setVisible(true)
    end

    print("vip:", vipPoint, vipLevel)
    for i=1,5 do

        local cvdict = DICT_VIP[tostring(i)]
        local name = cvdict.alias.."_highlight"

        if i < vipLevel then
            self["noReach"..tostring(i)]:setVisible(true)
            self[name]:setVisible(true)
        else
            self["noReach"..tostring(i)]:setVisible(false)
            self[name]:setVisible(false)
        end

        if vipLevel == i then
            
            self["noReach"..tostring(i)]:setVisible(false)
            self[name]:setVisible(true)

            local parentNode = self[name]:getParent()

            local posx = 76
            local posy = 140

            local baseBg = display.newSprite("#vip_gaoguang_xuazhong.png")
            baseBg:setPosition(posx, posy)

            -- local topLare = display.newSprite("#vip_gaoguang_xuazhong.png")
            -- topLare:setPosition(posx, posy)

            parentNode:addChild(baseBg, -10)
            --parentNode:addChild(topLare, 10)

        end
    end


    local barX,barY = self.progressBar:getPosition()
    local parent = self.progressBar:getParent()

    self.progressBar:removeFromParent(false)
    local progress = display.newProgressTimer(self.progressBar, display.PROGRESS_TIMER_BAR)
    :pos(barX, barY)
    :addTo(parent)

    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))

    progress:setPercentage(100 * vipPoint / nextPoints)

end

return VipView