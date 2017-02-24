
require "app.interface.pb.Game_pb"
require "app.interface.pb.CasinoMessageType"

local GameCS = {}

-- 加入游戏
function GameCS:joinGame(gid, callfunction)

    local function callBack(rdata)
        local msg = Game_pb.GCJoinGame()
        msg:ParseFromString(rdata)
        app.JackpotCoins = msg.jackPot
        callfunction(msg.playerList, msg.siteId, msg.roomId, msg.rankingList)
    end

    local pid = app:getUserModel():getPid()
    local req = Game_pb.CGJoinGame()
    req.pid = pid
    req.gameId = gid

    core.SocketNet:sendCommonProtoMessage(CG_JOIN_GAME, GC_JOIN_GAME, pid, req, callBack, true)
end

function  GameCS:rejoinGame(callfunction)
    local function callBack(data)
        local msg = Game_pb.GCJoinGame()
        msg:ParseFromString(data)
        app.JackpotCoins=msg.jackPot
        callfunction(msg.playerList, msg.siteId, msg.roomId, msg.rankingList)
    end

    local req = Game_pb.CGReJoinGame() 
    req.pid  = app:getUserModel():getPid()
    req.gameId = app:getPlayerStatus().gameId
    req.roomId = app:getPlayerStatus().roomId
    req.siteId = app:getPlayerStatus().siteId
    core.SocketNet:sendCommonProtoMessage(CG_RE_JOIN_GAME,GC_JOIN_GAME, req.pid ,req, callBack, true)
end


function GameCS:joinPlayerGame(inviteInfo, callfunction) --加入游戏

    local function callBack(rdata)
        
        local msg = Game_pb.GCJoinGame()
        msg:ParseFromString(rdata)
        app.JackpotCoins=msg.jackPot
        callfunction(msg.playerList, msg.siteId, msg.roomId, msg.rankingList)
    end

    local pid = app:getUserModel():getPid()

    local req= Game_pb.CGJoinPlayerGame()

    req.pid  = pid
    req.gameId = inviteInfo.gameId
    req.targetPid = inviteInfo.senderPid
    req.roomId = inviteInfo.roomId
    req.siteId = inviteInfo.siteId
    core.SocketNet:sendCommonProtoMessage(CG_JOIN_PLAYER_GAME,GC_JOIN_GAME, pid,req, callBack,true)

end


function GameCS:leaveGame()--离开游戏

    print("leave game:")
    app:setPlayerStatus(false)

    local pid = app:getUserModel():getPid()

    local req= Game_pb.CGLeaveGame()

    req.pid  = pid

    core.SocketNet:sendCommonProtoMessage(CG_LEAVE_GAME,GC_LEAVE_GAME, pid,req, nil, false)

end

function GameCS:inviteFriend(invitval, callfunction) --邀请好友 

    local pid = app:getUserModel():getPid()

    local req = Game_pb.CGInviteFriend()

    req.pid  = pid
    req.invitePid   = invitval.pid
    req.gameId      = invitval.gameId
    req.roomId      = invitval.roomId
    req.siteId      = invitval.siteId
    
    core.SocketNet:sendCommonProtoMessage(CG_INVITE_FRIEND,CG_INVITE_FRIEND, pid,req,nil ,false)

end

function GameCS:getGameStat(ppid,callfunction)
    
    local function callBack(rdata)

        local msg = Game_pb.GCGetGameStat()
        msg:ParseFromString(rdata)

        print(tostring(msg))

        callfunction(msg.gameStat)

    end

    local pid = app:getUserModel():getPid()

    local req= Game_pb.CGGetGameStat()

    req.pid  = ppid

    core.SocketNet:sendCommonProtoMessage(CG_GET_GAME_STAT,GC_GET_GAME_STAT, pid,req, callBack, true)

end

return GameCS
