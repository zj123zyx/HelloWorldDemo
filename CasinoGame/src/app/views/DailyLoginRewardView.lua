local DailyLoginRewardView = class("DailyLoginRewardView", function()
    return core.displayEX.newSwallowEnabledNode()
end)


local day_nocollect     = "day_nocollect"
local day_collected     = "day_collected"
local day_collectting   = "day_collectting"

local daylable          = "daylable"

local claimed   = "claimed"
local rewardNumber   = "rewardNumber"

local coinsIcon   = "coinsIcon"
local gemsIcon   = "gemsIcon"

function DailyLoginRewardView:ctor(args)
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.dailybonus, self)
    self:addChild(self.viewNode)

    self.args = args.dailyLoginData
    self.callback = args.showPopViews
    self.days = 7
    self.isAnimation = false

    print("logindays:", self.args.loginDays, self.days, math.floor( self.args.loginDays / self.days ))
    if self.args.loginDays > 7 then 
        self.args.loginDays = self.args.loginDays - self.days * math.floor( self.args.loginDays / self.days )+1
    end
    self:init()

    self:registerEvent()

    scheduler.performWithDelayGlobal(function()
        core.Waiting.hide()-- 登陆游戏时始终显示waiting 等待直到广告弹出
        end,0.1)

end

function DailyLoginRewardView:init()
    
    for i=1,self.days do

        self[daylable..tostring(i)]:enableOutline(cc.c4b(32, 32, 32, 255), 2);
        self[rewardNumber..tostring(i)]:enableOutline(cc.c4b(32, 32, 32, 255), 2);

        if i > self.args.loginDays then
            self[day_nocollect..tostring(i)]:setVisible(true)
            self[day_collected..tostring(i)]:setVisible(false)
            self[day_collectting..tostring(i)]:setVisible(false)

            self[claimed..tostring(i)]:setVisible(false)

        elseif i < self.args.loginDays then

            self[day_nocollect..tostring(i)]:setVisible(false)
            self[day_collected..tostring(i)]:setVisible(true)
            self[day_collectting..tostring(i)]:setVisible(false)
            self[claimed..tostring(i)]:setVisible(true)

            self[coinsIcon..tostring(i)]:setOpacity(64)
            self[gemsIcon..tostring(i)]:setOpacity(64)

        else
            self[day_nocollect..tostring(i)]:setVisible(false)
            self[day_collected..tostring(i)]:setVisible(false)
            self[day_collectting..tostring(i)]:setVisible(true)

            if self.args.loginRewardState == 0 then
                self[claimed..tostring(i)]:setVisible(true)
            else
                self[claimed..tostring(i)]:setVisible(false)
            end
        end
    end
end

function DailyLoginRewardView:registerEvent()
    -- on close
    core.displayEX.newButton(self.collectRewardBtn) 
        :onButtonClicked(function(event)

            if self.isAnimation then return end

            if self.args.loginRewardState == 0 then
                scn.ScnMgr.removeView(self)
                return
            end
            
            print("-------:loginDays",rewardNumber, tostring(self.args.loginDays))
            local count = tonumber(self[rewardNumber..tostring(self.args.loginDays)]:getString())

            local rtype = ITEM_TYPE.NORMAL_MULITIPLE 

            if self[coinsIcon..tostring(self.args.loginDays)]:isVisible() == true then
                rtype = ITEM_TYPE.NORMAL_MULITIPLE
            elseif self[gemsIcon..tostring(self.args.loginDays)]:isVisible() == true then
                rtype = ITEM_TYPE.GEMS_MULITIPLE
            end

            local function onCallBack(msg)

                if msg.result == 1 then
                    self.isAnimation = true

                    self.args.loginRewardState = 0

                    app.dailyLoginData = nil

                    local claimed_ = self[claimed..tostring(self.args.loginDays)]
                    local day_collected_ = self[day_collected..tostring(self.args.loginDays)]
                    local day_collectting_ = self[day_collectting..tostring(self.args.loginDays)]
                    local day_nocollect_ = self[day_nocollect..tostring(self.args.loginDays)]
                    local coinsIcon_ = self[coinsIcon..tostring(self.args.loginDays)]
                    local gemsIcon_ = self[gemsIcon..tostring(self.args.loginDays)]
                    
                    day_collected_:setVisible(true)
                    claimed_:setVisible(true)

                    day_collected_:setOpacity(0)
                    claimed_:setScale(10)
                    claimed_:setOpacity(0)

                    transition.fadeIn(claimed_, {time = 0.5, easing = "BACKOUT"})

                            transition.scaleTo(claimed_, {time = 0.5, scale = 1.0, easing = "BACKOUT",onComplete = function()
                                    -- body
                                    coinsIcon_:setOpacity(64)
                                    gemsIcon_:setOpacity(64)

                                    local effectNode = CCBuilderReaderLoad("effect/coin_effect.ccbi", self)
                                    effectNode:setPosition(claimed_:getPosition())
                                    effectNode:setScale(2)
                                    claimed_:getParent():addChild(effectNode)

                                    local image = "gems.png"
                                    local rewardSprite = app.gemSprite
                                    local rewardIcon = gemsIcon_
                                    if rtype == ITEM_TYPE.NORMAL_MULITIPLE then
                                        image = "gold.png"
                                        rewardSprite = app.coinSprite
                                        rewardIcon = coinsIcon_
                                    end

                                    AnimationUtil.CollectRewards("#"..image, 5, rewardIcon, rewardSprite,function()
                                        -- body
                                        if rtype == ITEM_TYPE.NORMAL_MULITIPLE then
                                            local totalCoins = app:getUserModel():getCoins() + msg.rewardCoins
                                            app:getUserModel():setCoins(totalCoins)
                                        elseif rtype == ITEM_TYPE.GEMS_MULITIPLE then
                                            --app:getUserModel():setGems(msg.totalGems)
                                            local totalGems = app:getUserModel():getGems() + msg.rewardGems
                                            app:getUserModel():setGems(totalGems)
                                        end

                                        self:performWithDelay(function() 
                                            
                                            
                                            core.Waiting.show()-- 登陆游戏时始终显示waiting 等待直到广告弹出

                                            self:performWithDelay(function()
                                                
                                                effectNode:removeFromParent(true)
                                                scn.ScnMgr.removeView(self)

                                                if self.callback then
                                                    self.callback()
                                                end
                                            end,0.1)


                                    end,0.3)

                                    EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})

                            end)
                                             

                    end})


                end
                
            end
            net.DailyLoginCS:receiveLoginReward(onCallBack)

        end)
end

return DailyLoginRewardView
