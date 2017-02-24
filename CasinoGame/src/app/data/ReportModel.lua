require "app.interface.pb.DataReport_pb"
require "app.interface.pb.CasinoMessageType"

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local m = class("ReportModel", require("app.data.SerializeModel"))

m.curGameReport           = "curGameReport"
m.waitGameReport          = "waitGameReport"


m.List = {
    doubleGameList                  = "doubleGameList",
    levelUpList                     = "levelUpList",
    gameDataList                    = "gameDataList"
}

m.GameDataKey = {
    pid                              = "pid",
    timestamp                        = "timestamp",
    gameType                         = "gameType",
    gameId                           = "gameId",
    gameCnt                          = "gameCnt",
    winCnt                           = "winCnt",
    costCoins                        = "costCoins",
    winCoins                         = "winCoins",
    handsPlayed                      = "handsPlayed",
    handsWin                         = "handsWin",
    handsPushed                      = "handsPushed",
    handsLost                        = "handsLost",
    blackJack                        = "blackJack",
    royalFlush                       = "royalFlush",
    straightFlush                    = "straightFlush",
    fourOfAKind                      = "fourOfAKind",
    fiveOfAKind                      = "fiveOfAKind",
    costGems                         = "costGems",
    rewardGems                       = "rewardGems",
    pokerSuit                        = "pokerSuit",
    account                          = "account",
    bigWin                           = "bigWin",
    mageWin                          = "mageWin",
}

m.LevelUpKey = {
    timestamp                        = "timestamp",
    preLevel                         = "preLevel",
    rewardCoins                      = "rewardCoins",
    vipPoint                         = "vipPoint",
    account                          = "account",
}

m.DoubleGameKey = {
    timestamp                        = "timestamp",
    initCoins                        = "initCoins",
    flopCnt                          = "flopCnt",
    rewardCoins                      = "rewardCoins",
    account                          = "account",
}

m.schema                            = clone(cc.mvc.ModelBase.schema)

m.schema[m.curGameReport]            = {"table", {}}
m.schema[m.waitGameReport]           = {"table", {}}


local reportTopNum = 1

function m:ctor(properties)
    m.super.ctor(self, properties)
    if self.loadModel ~= nil then
        self:loadModel()
    end
    self.reporting = false

    -- self.requestTime = 0

    -- local requestTick = function(dt)

    --     if self.reporting == true then 
    --         self.requestTime = self.requestTime + dt

    --         print("CG_GAME_REPORT time:", self.requestTime)
            
    --         if self.requestTime > 30 then
    --             core.SocketNet:unregistEvent(CG_GAME_REPORT)
    --             self.reporting = false
    --         end

    --     else
    --         self.requestTime = 0
    --     end
    -- end

    -- self.requestHandle = scheduler.scheduleGlobal(requestTick, 1)

end

function m:test()
end

function m:checkSendReportGameData()
    local num = 0
    for _,v in pairs(self.curGameReport_) do
        num = num + table.nums(v)
    end
    if num >= reportTopNum then
        table.insert(self.waitGameReport_, clone(self.curGameReport_))
        self.curGameReport_ = {}
        self:serializeModel()
    end

    -- print("checkSendReportGameData====num=",num,self.reporting)
    if table.nums(self.waitGameReport_) > 0 and self.reporting == false then
        self:sendReportGameData()
    end
end

function m:forceSendReportGameData()
    local list = self.curGameReport_[m.List.gameDataList]
    if list ~= nil then
        if table.nums(list) >= 1 then
            table.insert(self.waitGameReport_, clone(self.curGameReport_))
            self.curGameReport_ = {}
            self:serializeModel()
        end
        print("------m:forceSendReportGameData()-----num=",#list)
    end
    if (not self.reporting) and table.nums(self.waitGameReport_) > 0 then
        self:sendReportGameData()
    end
end

function m:handleMsg(msg) --推送的信息

    print("report notifyList:",#msg.notifyList)

    if msg.notifyList ~= nil and #msg.notifyList > 0 then

        EventMgr:dispatchEvent({
            name  = EventMgr.SERVER_NOTICE_EVENT,
            notifyList = msg.notifyList
        })

    end

end

function m:sendReportGameData()

    self.reporting = true
    --self.requestTime = 0

    local function callBack(rdata)

        local msg = DataReport_pb.GCGameReport()
        msg:ParseFromString(rdata)

        if msg.result then

            print("report callBack", table.nums(self.waitGameReport_))

            -- self:handleMsg(msg)

            table.remove(self.waitGameReport_, 1)
            self:serializeModel()

            if table.nums(self.waitGameReport_) > 0 then

                scheduler.performWithDelayGlobal(function()
                    self:sendReportGameData()
                end,1)

            else
                self.reporting = false
            end
        end
    end

    local gamedata = self.waitGameReport_[1]

    if gamedata == nil then 
        print("ReportGameData error: gamedata is null")
        return 
    end

    local curPid = app:getUserModel():getPid()
    local req = DataReport_pb.CGGameReport()
    req.pid = curPid
    req.serialNo = app:getUserModel():stepSerialNO()--playerInfo.serialNo
    self:getAccountInfo(req.account)

    local gameDataList = gamedata[m.List.gameDataList]
    if not gameDataList then gameDataList = {} end
    for _, val in pairs(gameDataList) do
        local info  = req.gameDataList:add()
        for k,v in pairs(val) do
            if type(v) == "table" then
                for key,var in pairs(v) do
                    info[k][key] = var
                end
            else
                info[k] = v
            end
        end
    end

    local lvUPlist = gamedata[m.List.levelUpList]
    if not lvUPlist then lvUPlist = {} end
    for _, val in pairs(lvUPlist) do
        local info = req.levelUpList:add()
        for k,v in pairs(val) do
            if type(v) == "table" then
                for key,var in pairs(v) do
                    info[k][key] = var
                end
            else
                info[k] = v
            end
        end
    end

    local doubleGameList = gamedata[m.List.doubleGameList]
    if not doubleGameList then doubleGameList = {} end
    for _, val in pairs(doubleGameList) do
        local info = req.doubleGameList:add()
        for k,v in pairs(val) do
            if type(v) == "table" then
                for key,var in pairs(v) do
                    info[k][key] = var
                end
            else
                info[k] = v
            end
        end
    end
    -- print("sendReportGameData()---getCurrentPid :", curPid,"  req.serialNo:", req.serialNo)
    core.SocketNet:sendCommonProtoMessage(CG_GAME_REPORT, GC_GAME_REPORT, curPid, req, callBack, false)
end

function m:addReportGameData(gameDataInfo)
    local info = {}
    info[m.GameDataKey.pid] = app:getUserModel():getPid()
    info[m.GameDataKey.timestamp] = os.time()
    info[m.GameDataKey.gameType] = gameDataInfo.gameType
    info[m.GameDataKey.gameId] = gameDataInfo.gameId
    info[m.GameDataKey.gameCnt]  = 1
    info[m.GameDataKey.winCnt]   = gameDataInfo.winCnt
    info[m.GameDataKey.costCoins] = gameDataInfo.costCoins
    info[m.GameDataKey.winCoins] = gameDataInfo.winCoins

    if gameDataInfo.bigWin then
        info[m.GameDataKey.bigWin] = gameDataInfo.bigWin
    end
    if gameDataInfo.mageWin then
        info[m.GameDataKey.mageWin] = gameDataInfo.mageWin
    end

    if gameDataInfo.costGems then
        info[m.GameDataKey.costGems] = gameDataInfo.costGems
    end
    if gameDataInfo.rewardGems then
        info[m.GameDataKey.rewardGems] = gameDataInfo.rewardGems
    end

    if gameDataInfo.handsPlayed then
        info[m.GameDataKey.handsPlayed] = gameDataInfo.handsPlayed
    end
    if gameDataInfo.handsWin then
        info[m.GameDataKey.handsWin] = gameDataInfo.handsWin
    end
    if gameDataInfo.handsPushed then
        info[m.GameDataKey.handsPushed] = gameDataInfo.handsPushed
    end
    if gameDataInfo.handsLost then
        info[m.GameDataKey.handsLost] = gameDataInfo.handsLost
    end

    if gameDataInfo.blackJack then
        info[m.GameDataKey.blackJack] = gameDataInfo.blackJack
    end
    
    if gameDataInfo.royalFlush then
        info[m.GameDataKey.royalFlush] = gameDataInfo.royalFlush
    end
    if gameDataInfo.straightFlush then
        info[m.GameDataKey.straightFlush] = gameDataInfo.straightFlush
    end
    if gameDataInfo.fourOfAKind then
        info[m.GameDataKey.fourOfAKind] = gameDataInfo.fourOfAKind
    end

    if gameDataInfo.fiveOfAKind then
        info[m.GameDataKey.fiveOfAKind] = gameDataInfo.fiveOfAKind
    end

    if gameDataInfo.pokerSuit then
        info[m.GameDataKey.pokerSuit] = gameDataInfo.pokerSuit
    end

    info[m.GameDataKey.account] = self:getAccountInfo()

    if self.curGameReport_[m.List.gameDataList] == nil then
        self.curGameReport_[m.List.gameDataList] = {}
    end
    local list = self.curGameReport_[m.List.gameDataList]
    list[#list+1] = info

    --table.dump(info,"-----addReportGameData------")
    -- print("-----addReportGameData------num＝",#list)

    self:checkSendReportGameData()
end

function m:addReportLevelUp(preLevel, rewardCoins, vipPoint)
    print("m:addReportLevelUp preLevel:", preLevel, "rewardCoins:", rewardCoins, "vipPoint:", vipPoint)

    local lvupInfo = {}
    lvupInfo[m.LevelUpKey.timestamp] = os.time()
    lvupInfo[m.LevelUpKey.preLevel] = preLevel
    lvupInfo[m.LevelUpKey.rewardCoins] = rewardCoins
    lvupInfo[m.LevelUpKey.vipPoint] = vipPoint
    lvupInfo[m.LevelUpKey.account] = self:getAccountInfo()

    if self.curGameReport_[m.List.levelUpList] == nil then
        self.curGameReport_[m.List.levelUpList] = {}
    end
    local curLevelUpList = self.curGameReport_[m.List.levelUpList]
    curLevelUpList[#curLevelUpList+1] = lvupInfo

    print("addReportLevelUp=====num=", #curLevelUpList)
    self:checkSendReportGameData()
end

function m:addReportDoubleGame(initCoins, flopCnt, rewardCoins)
    local info = {}
    info[m.DoubleGameKey.timestamp] = os.time()
    info[m.DoubleGameKey.initCoins] = initCoins
    info[m.DoubleGameKey.flopCnt] = flopCnt
    info[m.DoubleGameKey.rewardCoins] = rewardCoins
    info[m.DoubleGameKey.account] = self:getAccountInfo()

    if self.curGameReport_[m.List.doubleGameList] == nil then
        self.curGameReport_[m.List.doubleGameList] = {}
    end
    local list = self.curGameReport_[m.List.doubleGameList]
    list[#list+1] = info
    print("m:addReportDoubleGame initCoins:", initCoins, "flopCnt:", flopCnt, "rewardCoins:", rewardCoins," num=",#list)
    self:checkSendReportGameData()
end

function m:getPlayerInfo()
    local model = app:getUserModel()
    local cls = model.class
    return app:getUserModel():getProperties({cls.pid, cls.serialNo, cls.level, cls.exp, cls.vipLevel, cls.vipPoint, cls.coins, cls.gems,cls.money})
end

function m:getAccountInfo(target)
    local temp = {}
    local playerInfo = self:getPlayerInfo()
    temp.pid = app:getUserModel():getPid()
    temp.gems = playerInfo.gems
    temp.coins = playerInfo.coins
    temp.vipPoint = playerInfo.vipPoint
    temp.vipLevel = playerInfo.vipLevel
    temp.exp = playerInfo.exp
    temp.level = playerInfo.level
    temp.money = playerInfo.money
    if target then
        for k,v in pairs(temp) do
            target[k] = v
        end
    end
    return temp
end

function m:sendReportBaseInfo()
    local function callBack(rdata)
        local msg = DataReport_pb.GCGameReport()
        msg:ParseFromString(rdata)
        if msg.result then
            print("sendReportBaseInfo callBack:", msg.result,msg.serialNo)
        end
    end

    local curPid = app:getUserModel():getPid()
    local req = DataReport_pb.CGGameReport()
    req.pid = curPid
    req.serialNo = app:getUserModel():stepSerialNO()
    self:getAccountInfo(req.account)
    print("getCurrentPid :", curPid,"  base--req.serialNo:", req.serialNo)
    core.SocketNet:sendCommonProtoMessage(CG_GAME_REPORT, GC_GAME_REPORT, curPid, req, callBack, false)
end
return m
