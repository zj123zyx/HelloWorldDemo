--
-- Author: lizhanping
-- Date: 2016-10-10 15:45:04
--
require "app.interface.pb.TexasGame_pb"
require "app.interface.pb.CasinoMessageType"

local TexasGame = {}

-- 进入房间
function TexasGame:EnterTexasOnlineRoom(roomType,playerCarryCoins,callfunction)
	local function callBack(rdata)
        local msg = TexasGame_pb.GCTexasOnlineTableInitInfo()
        msg:ParseFromString(rdata)
        print("msg.tableInitInfo::::",msg)
        callfunction(msg)
        print("TexasGame:EnterTexasOnlineRoom==>进入房间")
    end

    local pid = app:getUserModel():getPid()
    local req= Game_pb.CGJoinGame()

    req.pid  = pid
    req.gameId = roomType
    print("pid",pid,roomType)
    core.SocketNet:sendCommonProtoMessage(CG_JOIN_GAME,GC_TEXAS_ONLINE_TABLE_INIT_INFO, pid,req, callBack, true)
end

-- 玩家操作
-- handleType Fold 1   check 2   bet 3   call 4   raise 5   callany 6   timeout 7
function TexasGame:TexasOnlinePlayerHandle(chairId, handleType, betNum, callfunction)

	local function callBack(rdata)
        local msg = TexasGame_pb.GCTexasOnlinePlayerHandle()
        msg:ParseFromString(rdata)

        if callfunction then
        	callfunction(msg.result)
        end
    end

    local pid = app:getUserModel():getPid()
    local req = TexasGame_pb.CGTexasOnlinePlayerHandle()
    req.pid = pid
    req.siteId = chairId
    req.handleType = handleType
    req.bet = (betNum and betNum >= 0) and betNum or 0

    core.SocketNet:sendCommonProtoMessage(CG_TEXAS_ONLINE_PLAYER_HANDLE, GC_TEXAS_ONLINE_PLAYER_HANDLE, pid, req, callBack, false)
end

return TexasGame