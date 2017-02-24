local HonorCell = class("HonorCell", function()
    return display.newNode()
end)

function HonorCell:ctor(honor, isme)
    self.viewNode  = CCBReaderLoad("lobby/honor/honor_cell.ccbi", self)
    self:addChild(self.viewNode)

    local size = self.viewNode:getContentSize()
    self:setContentSize(size)
    self.honor = honor
    self.isme = isme
    self:initUI()
end

function HonorCell:initUI()

    self.honor_name:setString(self.honor.title)
    self.honor_progress:setString(tostring(self.honor.currentPoint).."/"..tostring(self.honor.targetPoint))

    if self.expProgress == nil then
        local expX,expY = self.exp_sp:getPosition()
        local parent = self.exp_sp:getParent()
        self.exp_sp:removeFromParent(false)
        self.expProgress = display.newProgressTimer(self.exp_sp, display.PROGRESS_TIMER_BAR)
        :pos(expX, expY)
        :addTo(parent)
        self.expProgress:setMidpoint(cc.p(0, 0))
        self.expProgress:setBarChangeRate(cc.p(1, 0))
    end

    self.expProgress:setPercentage(100*(self.honor.currentPoint) / self.honor.targetPoint)


    self.reward_count:setString(tostring(self.honor.rewardCnt))

    --self.honorPic:setSpriteFrame(self.honor.picture)

    for i=1,5 do
        if i > self.honor.level then
            self["star"..tostring(i)]:setVisible(false)
        else
            self["star"..tostring(i)]:setVisible(true)
        end
    end

    if self.honor.level >= 5 then 
        self.honor_progress:setVisible(false)
    end

    if self.honor.state == 0 or self.isme == false then
        self.completeAsign:setVisible(false)
        self.rewardBtn:setVisible(false)
        self.rewardnoBtn:setVisible(true)
    elseif self.honor.state == 1 then
        self.completeAsign:setVisible(false)
        self.rewardBtn:setVisible(true)
        self.rewardnoBtn:setVisible(false)
    elseif self.honor.state == 2 then
        self.completeAsign:setVisible(true)
        self.rewardBtn:setVisible(false)
        self.rewardnoBtn:setVisible(true)
    end

    if self.honor.rewardType == ITEM_TYPE.NORMAL_MULITIPLE then
        self.rewardIcon:setSpriteFrame("gold.png")
    elseif self.honor.rewardType == ITEM_TYPE.GEMS_MULITIPLE then
        self.rewardIcon:setSpriteFrame("gems.png")
    end

    
end


function HonorCell:onClicked(event)

    if self.rewardBtn:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) then

        if self.honor.state == 1 then

            net.HonorCS:receiveHonorReward(self.honor.honorId, function(backdata)
                    -- body
                if backdata.result == 1 then

                    local image = "gems.png"
                    local rewardSprite = app.gemSprite
                    if backdata.rewardType == ITEM_TYPE.NORMAL_MULITIPLE then
                        image = "gold.png"
                        rewardSprite = app.coinSprite
                    end

                    AnimationUtil.CollectRewards("#"..image, 5, self.rewardIcon, rewardSprite,function()
                        -- body

                        if backdata.rewardType == ITEM_TYPE.NORMAL_MULITIPLE then
                            local coins = app:getUserModel():getCoins()
                            app:getUserModel():setCoins(coins + self.honor.rewardCnt)
                            EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                        elseif backdata.rewardType == ITEM_TYPE.GEMS_MULITIPLE then
                            local gems = app:getUserModel():getGems()
                            if self.honor then
                                app:getUserModel():setGems(gems + self.honor.rewardCnt)
                            end
                            EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                        end
                                

                        local starIdx = 0

                        if backdata.newLevel > self.honor.level then
                            starIdx = backdata.newLevel
                            local star = self["star"..tostring(starIdx)]
                            star:setScale(16)
                            star:setOpacity(0)
                            transition.scaleTo(star, {time = 0.5, scale = 1.0, easing = "BACKOUT",onComplete = function()
                                -- body
                                local effectNode = CCBuilderReaderLoad("effect/coin_effect.ccbi", self)
                                effectNode:setPosition(star:getPosition())
                                star:getParent():addChild(effectNode)

                                self:performWithDelay(function() 
                                    effectNode:removeFromParent(true)
                                end,0.3)

                            end})
                            transition.fadeIn(star, {time = 0.5, easing = "BACKOUT"})
                        end

                        self.honor.level        = backdata.newLevel
                        self.honor.targetPoint  = backdata.newTargetPoint
                        self.honor.rewardCnt    = backdata.newLevelReward
                        self.honor.state        = backdata.newState

                        self:initUI()

                    end)

                end

            end)
        end 

    end

end

return HonorCell