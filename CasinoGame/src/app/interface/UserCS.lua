
require "app.interface.pb.User_pb"
require "app.interface.pb.CasinoMessageType"

local UserCS = {}

function UserCS:updateDataFromServer(args, model, cls)

    local properties = {}

    properties[cls.pid]                 = args.playerInfo.pid
    properties[cls.serialNo]            = args.playerInfo.serialNo --+ 1
    properties[cls.name]                = args.playerInfo.name
    properties[cls.exp]                 = args.playerInfo.exp
    properties[cls.level]               = args.playerInfo.level
    properties[cls.coins]               = args.playerInfo.coins
    properties[cls.gems]                = args.playerInfo.gems
    properties[cls.money]               = args.playerInfo.money
    properties[cls.vipLevel]            = args.playerInfo.vipLevel
    properties[cls.vipPoint]            = args.playerInfo.vipPoint
    properties[cls.liked]               = args.playerInfo.liked
    properties[cls.pictureId]           = args.playerInfo.pictureId
    properties[cls.loginDays]           = args.playerInfo.loginDays
    properties[cls.successiveLoginDays] = args.playerInfo.successiveLoginDays

    model:setProperties(properties)

    model:serializeModel()

end

--http调用登录接口
function UserCS:EnterGame(callfunction)
    print("--EnterGame---222")

    local model = app:getObject("UserModel")
    local cls = model.class
    local properties = model:getProperties({cls.pid, cls.lastPid, cls.serialNo, cls.name, cls.level, cls.exp, cls.vipLevel, cls.vipPoint, cls.coins, cls.gems, cls.money, cls.liked, cls.pictureId, cls.extinfo, cls.gameState, cls.itemState})


    local checkFbStatus = function( )
        -- check if not facebook then fb data is set nil and update server data

        if core.FBPlatform.getIsLogin() == false then

            local modifyProperties = model:getProperties({cls.pid, cls.name, cls.facebook,cls.extinfo})
            local fb = modifyProperties[cls.facebook]

            if fb[cls.fb.fbid] ~= nil then

                print("----checkFbStatus---")
                local ei = {}
                ei[cls.ei.signature] = modifyProperties[cls.extinfo][cls.ei.signature]
                ei[cls.pictureId] = 1

                modifyProperties[cls.facebook] = {}
                modifyProperties[cls.pictureId] = 1
                modifyProperties[cls.facebookId] = ""

                net.UserCS:modifyPlayerInfo(modifyProperties[cls.pid], modifyProperties[cls.name], ei)

                model:setProperties(modifyProperties)

                model:serializeModel()

            end


        end
    end


    local function callBack(rdata)

        local msg = User_pb.GCEnterGame()
        msg:ParseFromString(rdata)

        print("ProtoMessage:",tostring(msg))

        if msg.result == 1 then

            local updateFromServer = false

            if tonumber(properties[cls.serialNo]) < msg.playerInfo.serialNo  then --or properties[cls.serialNo] < msg.playerInfo.serialNo then
                model:setProperties({serialNo=tonumber(msg.playerInfo.serialNo)})
                updateFromServer = true
            end

            if properties[cls.pid] ~= properties[cls.lastPid] then
                model:setProperties({lastPid=properties[cls.pid]})
                updateFromServer = true
            end

            if updateFromServer == true then                 
                self:updateDataFromServer(msg, model, cls)
            end

            checkFbStatus()

            if callfunction~= nil then callfunction() end

        elseif msg.result == 2 then
            if callfunction~= nil then callfunction() end
        end

    end

    local req= User_pb.CGEnterGame()

    req.pid=properties[cls.pid]

    core.SocketNet:sendCommonProtoMessage(CG_ENTER_GAME,GC_ENTER_GAME,properties[cls.pid],req,callBack, true)

end

function UserCS:getPlayerInfo(pid, callfunction)
    local function callBack(rdata)
        local msg = User_pb.GCPlayerInfo()
        msg:ParseFromString(rdata)
        --print(tostring(msg))
        callfunction(msg)
    end

    local req= User_pb.CGPlayerInfo()

    req.pid = pid

    core.SocketNet:sendCommonProtoMessage(CG_PLAYER_INFO,GC_PLAYER_INFO, app:getUserModel():getPid(),req, callBack, true)

end


function UserCS:updateData(args)

    local model = app:getUserModel()
    local cls = model.class

    local properties = {}

    properties[cls.exp]                 = args.exp
    properties[cls.level]               = args.level
    properties[cls.coins]               = args.coins
    properties[cls.gems]                = args.gems

    model:setProperties(properties)

    EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
    --model:serializeModel()

end

--[[
    local data={}
    data.gameType = unit.category
    data.gameId = unit.unit_id
    data.winCnt = --1 win  0 lose
    data.costCoins = -- 消耗金币数
    data.winCoins = -- 赚取金币数

    net.UserCS:dataReport(data)
]]

function UserCS:dataReport(data)
    app:getObject("ReportModel"):addReportGameData(data)
    -- do return end
    
    -- local function callBack(rdata)

    --     local msg = User_pb.GCDataReport()
    --     msg:ParseFromString(rdata)

    --     print("UserCS:dataReport",print(tostring(msg)))

    --     self:updateData(msg)
    -- end

    -- local pid = app:getUserModel():getPid()
    -- local serialNo = app:getUserModel():getSerialNo()

    -- local req= User_pb.CGDataReport()

    -- req.pid = pid
    -- req.serialNo = serialNo

    -- req.gameCnt     = 1

    -- req.gameType    = data.gameType
    -- req.gameId      = data.gameId
    -- req.winCnt      = data.winCnt
    -- req.costCoins   = data.costCoins
    -- req.winCoins    = data.winCoins

    -- if data.handsPlayed     then req.handsPlayed    = data.handsPlayed      end
    -- if data.handsWin        then req.handsWin       = data.handsWin         end
    -- if data.handsPushed     then req.handsPushed    = data.handsPushed      end
    -- if data.handsLost       then req.handsLost      = data.handsLost        end
    -- if data.blackJack       then req.blackJack      = data.blackJack        end
    -- if data.royalFlush      then req.royalFlush     = data.royalFlush       end
    -- if data.straightFlush   then req.straightFlush  = data.straightFlush    end
    -- if data.fourOfAKind     then req.fourOfAKind    = data.fourOfAKind      end
    -- if data.pokerSuit       then req.pokerSuit      = data.pokerSuit        end

    -- core.SocketNet:sendCommonProtoMessage(CG_DATA_REPORT,GC_DATA_REPORT,pid,req, callBack, false)

end

function UserCS:modifyPlayerInfo(pid,name,exinfo,callfunction)
    local req = User_pb.CGModifyPlayerInfo()
    req.pid = tonumber(pid)
    req.name = name

    if exinfo.gender ~= nil  then
        req.extendInfo.gender = exinfo.gender
    end

    if exinfo.country ~= nil then
        req.extendInfo.country = exinfo.country
    end

    if exinfo.age ~= nil then
        req.extendInfo.age = exinfo.age
    end

    if exinfo.signature ~= nil then
        req.extendInfo.signature = exinfo.signature
    end

    if exinfo.pictureId ~= nil then
        req.pictureId = exinfo.pictureId
    end

    local function callBack(rdata)
        local msg = User_pb.GCModifyPlayerInfo()
        msg:ParseFromString(rdata)

        print("-------modifyPlayerInfo2")

        if callfunction then
            callfunction(msg)
        end
    end

    core.SocketNet:sendCommonProtoMessage(CG_MODIFY_PLAYER_INFO,GC_MODIFY_PLAYER_INFO,pid,req, callBack, false)
end

function UserCS:like(topid, callfunction)
    
    local function callBack(rdata)
        local msg = User_pb.GCLike()
        msg:ParseFromString(rdata)

        callfunction(msg)

    end

    local pid = app:getUserModel():getPid()

    local req= User_pb.CGLike()

    req.pid = pid
    req.likedPid = topid

    core.SocketNet:sendCommonProtoMessage(CG_LIKE,GC_LIKE, pid,req, callBack, true)

end

function UserCS:RateUsBack()
    local pid = app:getUserModel():getPid()
    local req= User_pb.CGRateUs()
    req.pid = pid

    core.SocketNet:sendCommonProtoMessage(CG_RATE_US,GC_RATE_US, pid,req, print, false)
end

return UserCS
