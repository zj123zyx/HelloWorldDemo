
require("config")
require("cocos.init")
require("framework.init")
require("app.init")
JackPotNotice = require("app.views.JackPotNotice")
require("app.data.txspoker.TxsTestCase")
Notification = require "app.core.Notification"

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    core.SocketNet:init()
    -- self:initAdmob()
    self:init()

    self:registGlobalEvents()
    --[[
    if device.platform == "android" then
        local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
        notificationCenter:registerScriptObserver(nil, handler(self, self.onAndroidQuitGame), "APP_ANDROID_QUIT_EVENT")
    end
    ]]


    -- local levelFileStr = cc.HelperFunc:getFileData("res/test.json")
    -- local levelFileData = json.decode(levelFileStr)

    -- print("----1",levelFileStr)
    -- print("----2",levelFileData,levelFileData.FishScene.id)

    -- local num = table.nums(levelFileData,levelFileData.FishScene.ScenePath)

    -- table.dump(levelFileData,levelFileData.FishScene.ScenePath,"DICT_MATCH5")

    -- print(num, levelFileData,levelFileData.FishScene.ScenePath)

    -- for i=1, 2 do
    --     local path = levelFileData,levelFileData.FishScene.ScenePath[i]
    --     print(path,path.name,#path.fishData)
    -- end

end

function MyApp:initAdmob()
    self.admob = plugin.PluginManager:getInstance():loadPlugin("AdsAdmob")
    self.admob:configDeveloperInfo({AdmobID = "ca-app-pub-4690219173167338/7698409400"})
    self.admob:setDebugMode(true)
    self.admob:setCallback(function(code, info)
        print("AdsAdmob", code, info)
    end)
    self.admob:getCallback()(777, "getCallback test")
    self.showingAds = false
end

function MyApp:showAds()
    app.admob:showAds({AdmobType = "1", AdmobSizeEnum = "1"}, 1)
    self.showingAds = true
end

function MyApp:hideAds()
    self.showingAds = false
    app.admob:hideAds({AdmobType = "1"})
end

function MyApp:init() --初始化
    self.test = "MyApp:init-test"
    self.logined = false
    self.slotAutoSpin = true --为false时一定时间内没触摸屏幕就自动断开网络 TouchLayer:onEnter()
    -- game status
    self.playerStatus_ = {gaming=false, gameId=0, siteId=0,roomId=0}
	-- body
	self.objects_ = {}
    -- data
    core.Sqlite.init()
    if not self:isObjectExists("UserModel") then
        -- user 对象只有一个，不需要每次进入场景都创建
        local usermodel = scn.models.UserModel.new({
            id = "UserModel",
            udid = AppLuaApi:getInstance():UDID()
        })
        self:setObject("UserModel", usermodel)
    end
    if not self:isObjectExists("ReportModel") then
        -- user 对象只有一个，不需要每次进入场景都创建
        local reportmodel = data.ReportModel.new({
            id = "ReportModel"
        })
        self:setObject("ReportModel", reportmodel)
    end
    -------jackPot---待用数据
    self.JackpotCoins = 0
    self.jackpotLabel = nil
    self.changJackpot = nil
    self.showWinTable = {}

end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:preStart()
    scn.ScnMgr.replaceScene("lobby.LoginScene")
    -- SlotsMgr.enterMachineById(6)
end

function MyApp:preStart()

    local onTick = function(dt)
        scn.ScnMgr.show()
    end
    self.schedulerEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onTick, 0, false)

    Notification.registNotification()

    -- location notice
    -- AppNotification:sharedAppNotification():cancelAllLocalNotifications();
    -- AppNotification:sharedAppNotification():RegisterLocalNotification("3:16:06","slot location notification");
end

function MyApp:setPlayerStatus(gaming, gameid, roomid, siteid)--设置游戏内属性
    self.playerStatus_.gaming = gaming

    if gameid ~=nil then
        self.playerStatus_.gameId = gameid
    end
    if roomid ~=nil then
        self.playerStatus_.roomId = roomid
    end
    if siteid ~= nil then
        self.playerStatus_.siteId = siteid
    end

    -- print("setPlayerStatus  " ..  roomid )
end

function MyApp:getPlayerStatus()
    return self.playerStatus_
end

function MyApp:setObject(id, object)
    assert(self.objects_[id] == nil, string.format("MyApp:setObject() - id \"%s\" already exists", id))
    self.objects_[id] = object
end

function MyApp:getObject(id)
    assert(self.objects_[id] ~= nil, string.format("MyApp:getObject() - id \"%s\" not exists", id))
    return self.objects_[id]
end

function MyApp:getUserModel()
    return self:getObject('UserModel')
end

function MyApp:isObjectExists(id)
    return self.objects_[id] ~= nil
end

function MyApp:serializeModels()
    for key, model in pairs(self.objects_) do
        if model.loadModel ~= nil and type(model.loadModel) == "function" then
            model:loadModel()
        end
    end
end


function MyApp:popDailyLogin()

    if self.logined == true then
        return 
    end

    self.logined = true

    local callback = function()
        AdMgr.showPopViews()
    end

    -- body
    if self.dailyLoginData and self.dailyLoginData.loginRewardState == 1 then
        scn.ScnMgr.popView("DailyLoginRewardView",{dailyLoginData = self.dailyLoginData,showPopViews = callback})
    else
        callback()
    end

    net.NotifyCS:getNotifyList()--获得通知

end

function MyApp:getFreeBouns(serverBack)
    self.freeBouns = 1
    local onComplete = function(msg)
        self.freeBonusData = msg
        Notification.registType2(dict_notification["2"])
        serverBack()
    end

    net.TimingRewardCS:getTimingRewardState(onComplete)
end

function MyApp:updateDailyReward(serverBack)

    local function onCallBack(msg)
        self.dailyLoginData = msg
        serverBack()
    end

    net.DailyLoginCS:getLoginRewardState(onCallBack)
end

function MyApp:requestAfterEnterGame(callback)

    local serverBack = function()
        -- body
        self:updateDailyReward(function()

            pcall(callback)

            core.Waiting.logining = false
            core.Waiting.hide()

        end)

    end

    self:getFreeBouns(serverBack)
end

function MyApp:getPlayerInfo() --获得玩家信息
    -- body
    local function onComplete(lists)
        EventMgr:dispatchEvent({
            name  = EventMgr.UPDATE_PLAYERS_EVENT,
            list = lists
        })  

    end

    net.FriendsCS:getOnlinePlayers(onComplete)
end

function MyApp:getFriendInfo() --获得朋友信息
    -- body
    local function onComplete(lists)
        EventMgr:dispatchEvent({
            name  = EventMgr.UPDATE_FRIENDS_EVENT,
            list = lists
        })

    end

    net.FriendsCS:getFriendsList(onComplete)
end

function MyApp:registGlobalEvents()
    core.SocketNet:registEvent(GC_MSG_NOTIFY, function(body)--推送信息
        -- body
        local msg = Notify_pb.GCMsgNotify()
        msg:ParseFromString(body)
        
        print("message notify :",msg.msgType)
        EventMgr:dispatchEvent({
            name  = EventMgr.SERVER_NOTICE_EVENT,
            hasnews = msg.msgType
        })
    end)
    core.SocketNet:registEvent(GC_NOTIFY, function(body)
        -- body
        local msg = Game_pb.GCNotify()
        msg:ParseFromString(body)

        print("player notify")
        
        EventMgr:dispatchEvent({
            name  = EventMgr.UPDATE_PSTATES_EVENT,
            playerList = msg.playerList
        })

        -- display.getRunningScene():performWithDelay(function()
        --     EventMgr:dispatchEvent({
        --         name  = EventMgr.UPDATE_PSTATES_EVENT,
        --         playerList = msg.playerList
        --     })
        -- end,1)
    end)

    core.SocketNet:registEvent(GC_INVITE_FRIEND, function(body)--好友邀请
        -- body
        local msg = Game_pb.GCInviteFriend()
        msg:ParseFromString(body)

        --print(tostring(msg))

        local function onComplete(infos)                
            scn.ScnMgr.popView("JoinGameNotifyView",{joininfo = msg, senderinfo=infos})
        end
        net.UserCS:getPlayerInfo(msg.senderPid, onComplete)    

    end)
    core.SocketNet:registEvent(GC_GET_JACK_POT, function(body)--JackPot
        local msg = JackPot_pb.GCGetJackPot()
        msg:ParseFromString(body)
        self.JackpotCoins = msg.jackPot
        EventMgr:dispatchEvent({
            name = EventMgr.UPDATE_JACKPOT,
            list = msg.jackPot
        })
    end)

    core.SocketNet:registEvent(GC_BROADCAST_JACK_POT,function(body)
        local msg = JackPot_pb.GCBroadcastJackPot()
        msg:ParseFromString(body)
        print("======msg.rewardCoins=======" ..msg.baseJackpot)
        if tonumber(msg.gameId) == tonumber( self.playerStatus_.gameId ) then --判断是否是当前gameId
            self.changJackpot(msg.baseJackpot)
        end
        if tonumber(msg.pid) ~= tonumber(app:getObject("UserModel"):getPid()) then
            JackPotNotice.create(msg)
        end
    end)

end


function MyApp:joinPlayerGame(info)
    local gid = info.gameId
    local unit = DICT_UNIT[tostring(gid)]
    local celltype = unit.type
    local callback = function()
        local onComplete = function(lists, siteId, rId, rankingList)

            app:setPlayerStatus(true,gid,rId,siteId)
            app.layoutId = tostring(unit.p_unit_id + 1)
           
            local args = {players=lists,rList=rankingList,info={unitdata=unit,mysite=siteId, roomId =rId, gameId=tonumber(gid)}}
            if celltype == "Slots" then
                args.animation = true -- controll the menus animation
                SlotsMgr.joinSlotMachine(unit.dict_id,args)
            elseif celltype == "BlackJack" then
                scn.ScnMgr.replaceScene("blackjack.BJController",{args})
            elseif celltype == "VideoPoker" then
                scn.ScnMgr.replaceScene("videopoker.PokerController",{args})
            elseif celltype == "Texas" then
                scn.ScnMgr.replaceScene("texas.TexasController",{args})
            end
        end

        net.GameCS:joinPlayerGame(info, onComplete)
    end
    if app:JudgeMoney(unit) == false then
        return
    end
    if app:needDown({unit = unit},callback) == false then
        callback()
    end
end


function MyApp:rejoinGame() --重新进入游戏
    local gid = self.playerStatus_.gameId 
    local unit = DICT_UNIT[tostring(gid)]
    local celltype = unit.type
    local callback = function()
        local onComplete = function(lists, siteId, rId, rankingList)
            app:setPlayerStatus(true,gid,rId,siteId)

            local args = {players=lists,rList=rankingList,info={unitdata=unit,mysite=siteId, roomId =rId, gameId=tonumber(gid)}}
            if celltype == "Slots" then
                args.animation = true -- controll the menus animation
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
                args.players = nil
                if unit.unit_id == "1001" then
                    scn.ScnMgr.replaceScene("challenge.ChallageScene",{args})
                elseif unit.unit_id == "1002" then
                    scn.ScnMgr.replaceScene("challenge.WheelBonusController",{{state=0},args})
                end
            end
        end
    
        net.GameCS:rejoinGame(onComplete)--调用接口 
    end
    if app:JudgeMoney(unit) == false then
        return
    end
    if app:needDown({unit = unit},callback) == false then
        callback()
    end
end

function MyApp:watchVedioAd()
    -- body

    ApplovinAdMgr:getInstance():setLuaListener(function(event)
        -- body
        print("-------applovin",event.adEventName)
        
        --core.Waiting.hide()

        if event.adEventName == "event_didLoadAd" then

            ApplovinAdMgr:getInstance():showRewardedVideoAd()

        elseif event.adEventName == "event_VideoStarted" then
        elseif event.adEventName == "event_VideoEnded" then
        elseif event.adEventName == "event_AdDisplayed" then
        elseif event.adEventName == "event_AdDismissed" then
        elseif event.adEventName == "event_AdClicked" then
        else
        end

    end);

    --core.Waiting.show()
    ApplovinAdMgr:getInstance():preloadRewardedVideo()


end


function MyApp:onEnterBackground()
    display.pause()
    core.FBPlatform.onEnterBackground()
end

function MyApp:onEnterForeground()
    display.resume()

    core.FBPlatform.onEnterForeground()
    --self:requestAfterEnterGame()

end

function MyApp:needDown(tapcell,callback)

    if true then return false end
    
    local unit = tapcell.unit
    local dic = DICT_UNIT[unit.p_unit_id]
    local downloadFiles = {}

    local p_zipname=""
    local pngname = ""

    if dic then

        p_zipname = dic.zipname
        pngname = dic.zipname

        local down1 = app:getUserModel():getUnitDownLoad(p_zipname)

        if down1 ~= nil and tonumber(down1.needdown)==1 and down1.hasdown==0 then
            local files = cc.UserDefault:getInstance():getStringForKey(p_zipname)
            if files ~= nil then
                local filearray = string.split(files, ",")
                local num = math.floor(#filearray / 2)
                for i=1, num do
                    local df = {}
                    df.name     =filearray[2*(i-1) + 1]
                    df.md5      =filearray[2*(i-1) + 2]
                    df.zipname = p_zipname
                    table.insert(downloadFiles, df)
                end
            end
        end
    end

    local zipname = unit.zipname

    if p_zipname ~= zipname then

        pngname = unit.zipname

        local down2 = app:getUserModel():getUnitDownLoad(zipname)

        if down2 ~= nil and tonumber(down2.needdown)==1 and down2.hasdown==0 then
            local files = cc.UserDefault:getInstance():getStringForKey(zipname)
            if files ~= nil then
                local filearray = string.split(files, ",")
                local num = math.floor(#filearray / 2)
                for i=1, num do
                    local df = {}
                    df.name     =filearray[2*(i-1) + 1]
                    df.md5      =filearray[2*(i-1) + 2]
                    df.zipname = zipname

                    table.insert(downloadFiles, df)
                end
            end
        end

    end

    if #downloadFiles > 0 then
        scn.ScnMgr.addView("LoadingView",{downloads=downloadFiles,callback=callback, downloadName=pngname})
        return true
    else
        print("there is no files")
    end
    return false
end

function MyApp:JudgeMoney(unit) 
    local gameType = unit.type
    if gameType == "Challenge" and app:getUserModel():getGems()> unit.config.cost_gems then
        return true
    elseif gameType ~= "Challenge" and app:getUserModel():getCoins() > unit.config.min_bet then
        return true
    else
        if gameType == "Challenge" then
            scn.ScnMgr.popView("ShortGemsView",{})
        elseif gameType ~= "Challenge" then 
            scn.ScnMgr.popView("ShortCoinsView",{})
        end
        return false
    end
end


return MyApp
