local GameController = class("GameController", function()
    return display.newNode()
end)

function GameController:ctor()

    self.user_ = app:getObject("UserModel")

    if app.freeBonusData then
        local onComplete = function(msg)
            --app.freeBonusData = {}
            app.freeBonusData.index = msg.index
            app.freeBonusData.rewardCoins = msg.rewardCoins
            app.freeBonusData.timeLeft = msg.timeLeft
            app.freeBonusData.totalTime = msg.totalTime
            app.freeBonusData.state = msg.state
            if self.ctr_ and self.ctr_.freebonusCCB and self.ctr_.freebonusCCB.timeLeft then
                self.ctr_.freebonusCCB.timeLeft = msg.timeLeft
            end
        end
        net.TimingRewardCS:getTimingRewardState(onComplete)
    end

    local ViewClass = require("app.scenes.lobby.views.GameView")
    local obj =  {coins=self.user_:getGems()}
    self.ctr_ = ViewClass.new(obj):addTo(self)

    self.ctr_:addEventListener("onTapFriendCell", handler(self, self.onTapFriendCell), self)

    self.ctr_:setLocalZOrder(100)
    
    self:setNodeEventEnabled(true)

    audio.playMusic(RES_AUDIO.bg_lobby)

    -- 注册UI事件
    self:registerUIEvent()
end

function GameController:onBackLobby()
end

function GameController:onExit()
    self.user_:getComponent("components.behavior.EventProtocol"):dumpAllEventListeners()
    audio.stopMusic()
end

function GameController:registerUIEvent()

    -- on free bonus
    core.displayEX.newButton(self.ctr_.btn_freebonus) 
        :onButtonClicked(function(event)

     
        if self.ctr_.freebonusCCB.state == 1 then

            if self.ctr_.freebonusCCB.index == 4 then
                self.ctr_.freebonusCCB.dating = true
                scn.ScnMgr.popView("WheelBonus",self.ctr_.freebonusCCB)
            else

                local callfunction = function(msg)

                    print("pickTimingReward: ",tostring(msg))

                    if msg.result == 1 then

                        Notification.registType2()

                        app.freeBonusData = {}
                        
                        app.freeBonusData.index = msg.index
                        app.freeBonusData.timeLeft = msg.timeLeft
                        app.freeBonusData.totalTime = msg.totalTime
                        app.freeBonusData.rewardCoins = msg.rewardCoins
--                        app.freeBonusData.totalCoins = msg.totalCoins
--                        app.freeBonusData.totalGems = msg.totalGems
                        app.freeBonusData.state = 0

                        scn.ScnMgr.addView("FreeBonusWin", {coins=msg.rewardCoins, delayCall=function()
                            local totalCoins = app:getUserModel():getCoins() + msg.rewardCoins
                            app:getUserModel():setCoins(totalCoins)
                            EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})

                            print("Free Bonus Win !!!!")

                            self.ctr_.freebonusCCB:initReward(app.freeBonusData)

                        end} )


                    end
                end

                net.TimingRewardCS:pickTimingReward(callfunction)

            end
        else
            --scn.ScnMgr.popView("WheelBonus",event.cell)

            -- local callfunction = function(msg)

            --         msg ={}
            --             msg.state = 1
            --             msg.rewardCoins = 1000
            --             msg.totalCoins = 1000000
            --             msg.timeLeft = 10000
            --             msg.totalTime = 20000

            --          if msg.state == 1 then
                        
            --             self.freeBonusData = msg
            --             self.freeBonusData.state = 0
                     
            --             scn.ScnMgr.addView("FreeBonusWin", {coins=msg.rewardCoins, delayCall=function()

            --                 app:getUserModel():setCoins(msg.totalCoins)
            --                 EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})

            --                 self.ctr_.freebonusCCB:initReward(app.freeBonusData)

            --             end} )


            --         end
            --     end

            -- net.TimingRewardCS:pickTimingReward(callfunction)

        end

        end)

    -- on menus
    core.displayEX.newButton(self.ctr_.btn_menus) 
        :onButtonClicked(function(event)
            if self.ctr_.menus_node:isVisible() == true then
                self.ctr_.menus_node:setVisible(false)
            else
                self.ctr_.menus_node:setVisible(true)
            end
        end)

    -- on message
    core.displayEX.newButton(self.ctr_.btn_message) 
        :onButtonClicked(function(event)
            net.MessageCS:getMessageList(function(body)
                self.ctr_.menus_node:setVisible(false)
                -- if type(body) == "table" and #body < 1 then
                self.ctr_.messageHint1:setVisible(false)
                self.ctr_.messageHint:setVisible(false)

                app:getUserModel():setProperties({hasnews=-1})
                app:getUserModel():serializeModel()
                -- end
                scn.ScnMgr.popView("MessageView",body)
            end)

        end)

    -- on lobby
    core.displayEX.newButton(self.ctr_.btn_lobby) 
        :onButtonClicked(function(event)

            self.ctr_.menus_node:setVisible(false)
            self:onBackLobby()
            --scn.ScnMgr.replaceScene("LobbyScene")
            --scn.ScnMgr.popView("CommonView")

        end)

    -- on setting
    core.displayEX.newButton(self.ctr_.btn_option)
        :onButtonClicked(function(event)
            self.ctr_.menus_node:setVisible(false)
            scn.ScnMgr.popView("SettingView")
        end)

    -- on achievement
    core.displayEX.newButton(self.ctr_.btn_achievement) 
        :onButtonClicked(function(event)
            self.ctr_.menus_node:setVisible(false)
            net.HonorCS:getHonorList(app:getUserModel():getPid(),function(honorlist)
                app:getUserModel():setProperties({hashonor=-1})
                app:getUserModel():serializeModel()
                scn.ScnMgr.popView("HonorsView", honorlist)
            end)

        end)

    -- on vip
    core.displayEX.newButton(self.ctr_.btn_vip)
        :onButtonClicked(function(event)
            scn.ScnMgr.popView("VipView")
        end)

    -- -- on head
    -- self.ctr_.btn_headBtn = core.displayEX.newButton(self.ctr_.headBtn) 
    --     :onButtonClicked(function(event)
    --         scn.ScnMgr.popView("social.FriendInforView")
    --     end)

    -- -- on invite
    -- core.displayEX.newButton(self.ctr_.btn_invite) 
    --     :onButtonClicked(function(event)

    --         if CCAccountManager:sharedAccountManager():isLogged() then

    --             local facebookCallBack = function(event)
    --                 -- body
    --                 if event.inviteFriends and event.inviteFriends == "1" then
    --                     scn.ScnMgr.popView("CommonView",{title="Invite",content="Success Invited"})
    --                 else
    --                     scn.ScnMgr.popView("CommonView",{title="Invite",content="Error Invited"})
    --                 end
    --             end
                
    --             CCAccountManager:sharedAccountManager():postFBListenerLua(facebookCallBack);
    --             CCAccountManager:sharedAccountManager():inviteFriends();

    --         else
    --             scn.ScnMgr.popView("CommonView",{title="Invite",content="No Logined Facebook"})
    --         end
    --     end)

    -- shopping
    core.displayEX.newButton(self.ctr_.btn_store) 
        :onButtonClicked(function(event)
            
            net.PurchaseCS:GetProductList(function(lists)
               scn.ScnMgr.popView("ProductsView",{productList=lists,tabidx=1})
            end)

        end)

    -- gifts
    core.displayEX.newButton(self.ctr_.btn_gifts_labby)
        :onButtonClicked(function(event)

            -- local params = {
            --     message = "Play the casino game, go go!!!!",
            --     title   = "Invite friend & reward lots of coins",
            -- }

            -- core.FBPlatform:appRequest(params, function( ret, msg )
            --     -- body
            --     local invite = json.decode(msg)
            --     table.dump(invite, "invite")

            --     if invite.error_message then
            --     else
                    
            --     end

            -- end
            -- )
           -- scn.ScnMgr.addView("BigWinView",{winCoin = 100000})
            scn.ScnMgr.popView("gift.GiftsView",{tabidx=1,pid = app:getUserModel():getPid(),islabby=true})
        end)

    -- specialAD
    core.displayEX.newButton(self.ctr_.btn_specialAD) 
        :onButtonClicked(function(event)
            AdMgr.showAdListView(7)
        end)

    -- social
    core.displayEX.newButton(self.ctr_.btn_social) 
        :onButtonClicked(function(event)
            scn.ScnMgr.popView("social.SocialView",{tabidx=1})
        end)
end

function GameController:onTapFriendCell(self, event)
    
    if event.cell.pid == -1 then return end

    local function onComplete(infos)
        scn.ScnMgr.popView("social.FriendInforView",{info=infos})
    end

    net.UserCS:getPlayerInfo(event.cell.pid, onComplete)
end


return GameController
