
local LobbyController = class("LobbyController", scn.cotors.GameCotor)

function LobbyController:ctor(layoutIndex)

    LobbyController.super.ctor(self)
    --AdMgr.getNoticeBarInfo()
    local ViewClass = require("app.scenes.lobby.views.LobbyView")
    self.views_ = ViewClass.new({rect=self.ctr_.gameRect}):addTo(self)

    self.views_.gamectr_ = self.ctr_

    self.views_:addEventListener("onTapLobbyCell", handler(self, self.onTapLobbyCell), self)
    self.views_:addEventListener("showFishView", handler(self, self.showFishView), self)
    -- 注册帧事件
    --self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    --self:scheduleUpdate()

    -- 在视图清理后，检查模型上注册的事件，看看是否存在内存泄露
    self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "exit" then
            self.user_:getComponent("components.behavior.EventProtocol"):dumpAllEventListeners()
            self.views_:removeEventListenersByTag(self)
        end
    end)

end

function LobbyController:onBackLobby()
    if self.views_.oldLayoutIdx ~= nil then
        self.views_:addGameList(self.views_.oldLayoutIdx)
        self.views_.oldLayoutIdx = nil
    end
end

function LobbyController:exit()
    self.user_:getComponent("components.behavior.EventProtocol"):dumpAllEventListeners()
    self.views_:removeEventListenersByTag(self)
end

function LobbyController:showFishView(self, event)
    print("showFishView")
    scn.ScnMgr.replaceScene("fish.FishScene")
end

function LobbyController:onTapLobbyCell(self, event)

    if event.cell.unit.type ~= "Layout" then

        app.layoutId = self.views_.curLayoutIdx
    
        if event.cell.isLock == true then
           return
        end
    else
        app.layoutId = nil
    end

    local callback = function()
        self:onHandleTapCell(event.cell)
    end

    if app:needDown(event.cell,callback) == true then
       return
    end
        
    self:onHandleTapCell(event.cell)
end

-- 点击进入游戏菜单项
function LobbyController:onHandleTapCell(tapcell)

    -- jjftest
    app:getUserModel():setCoins(2000000)
    app:getUserModel():setGems(100000)

    local celltype = tapcell.unit.type
    print("casinotest 菜单项类型 = ", celltype)
    
    if celltype == "Layout" then
        self.views_:addGameList(tapcell.unit.dict_id)
    elseif celltype == "Store" then
        net.PurchaseCS:GetProductList(function(lists)
            scn.ScnMgr.popView("ProductsView",{productList=lists,tabidx=2})
        end)
    elseif celltype == "TimingReward" then

    elseif celltype == "AD" then
        AdMgr.showAdListView(tapcell.unit.config.special_ad_id)
    elseif celltype == "Facebook" then
       --print("Facebook")
    elseif celltype == "Task" then
        scn.ScnMgr.addView("dailyTask.DailyTaskView",{cell=tapcell})
    elseif celltype == "COMINGSOON" then
        print("COMINGSOON")
    else
        local gid = tonumber(tapcell.unitidx)
        local unit = tapcell.unit
        if app:JudgeMoney(unit) == false then
            return
        end

        -- 默认的游戏信息
        local args = { players = lists, info = { unitdata = unit, mysite = siteId, roomId = rId, gameId = gid } }
        
        if celltype == "TexasOnline" then
            local args = nil;
            local function callback(rdata)

                -- 进游戏的消息只接收一次
                core.SocketNet:unregistEvent(GC_TEXAS_ONLINE_TABLE_INIT_INFO)

                -- 进入游戏场景
                local msg = TexasGame_pb.GCTexasOnlineTableInitInfo()
                msg:ParseFromString(rdata)
                scn.ScnMgr.replaceScene("texasonline.TexasOnlineScene", {args, msg})
            end
            core.SocketNet:registEvent(GC_TEXAS_ONLINE_TABLE_INIT_INFO, callback);

            local callback = function(lists, siteId, rId, rankingList)

                -- 服务器返回给客户端的游戏信息
                args = 
                {
                    players = lists, 
                    rList = rankingList, 
                    info = 
                    { 
                        unitdata = unit, 
                        mysite = siteId, 
                        roomId = rId,
                        gameId = gid
                    }
                }
                app:setPlayerStatus(true, gid, rId, siteId)
            end
            net.GameCS:joinGame(gid, callback)
        else

            local onComplete = function(lists, siteId, rId, rankingList)
                local args = {players=lists,rList=rankingList,info={unitdata=unit,mysite=siteId, roomId =rId, gameId=gid}}
                app:setPlayerStatus(true,gid,rId,siteId)

                if celltype == "Slots" then
                    args.animation=true-- controll the menus animation
                    SlotsMgr.joinSlotMachine(unit.dict_id,args)
                elseif celltype == "BlackJack" then
                    scn.ScnMgr.replaceScene("blackjack.BJController",{args})
                elseif celltype == "VideoPoker" then
                    scn.ScnMgr.replaceScene("videopoker.PokerController",{args})
                elseif celltype == "Texas" then
                    scn.ScnMgr.replaceScene("texas.TexasController",{args})
                elseif celltype == "Fish" then
                    scn.ScnMgr.replaceScene("fish.FishScene",{args})
                elseif celltype == "Challenge" then

                end
            end

            net.GameCS:joinGame(gid, onComplete)
        end
    end
end

return LobbyController
