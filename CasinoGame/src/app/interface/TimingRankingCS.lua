
require "app.interface.pb.TimingRanking_pb"
require "app.interface.pb.CasinoMessageType"

local TimingRankingCS = {}

function TimingRankingCS:getRankingListInRoom(gId,rId, callfunction)

    local function callBack(rdata)

        local msg = TimingRanking_pb.GCGetRankingListInRoom()
        msg:ParseFromString(rdata)

        print("msg.rankingList",#msg.rankingList,msg.remainedTimeLimit)

        callfunction(msg.rankingList, msg.remainedTimeLimit)
    end

    local pid = app:getUserModel():getPid()

    local req= TimingRanking_pb.CGGetRankingListInRoom()

    req.gameId = gId
    req.roomId = rId

    print("RankingListInGame",gId, rId)

    core.SocketNet:sendCommonProtoMessage(CG_GET_RANKING_LIST_IN_ROOM,GC_GET_RANKING_LIST_IN_ROOM, pid,req,callBack, true)
end

function TimingRankingCS:getRankingListInGame(gId,rkType, callfunction)

    local function callBack(rdata)

        local msg = TimingRanking_pb.GCGetRankingListInGame()
        msg:ParseFromString(rdata)

        print("msg.rankingList",#msg.rankingList,msg.remainedTimeLimit)

        callfunction(msg.rankingList, msg.remainedTimeLimit)
    end

    local pid = app:getUserModel():getPid()

    local req= TimingRanking_pb.CGGetRankingListInGame()

    req.gameId = gId
    req.rankingType = rkType

    print("RankingListInGame",gId, rkType)

    core.SocketNet:sendCommonProtoMessage(CG_GET_RANKING_LIST_IN_GAME,GC_GET_RANKING_LIST_IN_GAME, pid,req,callBack, true)
end

function TimingRankingCS:getSelfRankings(gId, rid, callfunction)

    local function callBack(rdata)

        local msg = TimingRanking_pb.GCGetSelfRankings()
        msg:ParseFromString(rdata)

        callfunction(msg.selfRankings, msg.rewardMapping)
        
    end

    local pid = app:getUserModel():getPid()

    local req= TimingRanking_pb.CGGetSelfRankings()

    req.gameId = gId
    req.roomId = rid

    core.SocketNet:sendCommonProtoMessage(CG_GET_SELF_RANKINGS,GC_GET_SELF_RANKINGS, pid,req,callBack, true)
end

function TimingRankingCS:getRankingRemainedTime(gId, rid, callfunction)

    local function callBack(rdata)

        local msg = TimingRanking_pb.GCGetRankingRemainedTime()
        msg:ParseFromString(rdata)

        callfunction(msg.remainedTimeList)
        
    end

    local pid = app:getUserModel():getPid()

    local req= TimingRanking_pb.CGGetRankingRemainedTime()

    req.gameId = gId
    req.roomId = rid

    core.SocketNet:sendCommonProtoMessage(CG_GET_RANKING_REMAINED_TIME,GC_GET_RANKING_REMAINED_TIME, pid,req,callBack, false)
end

return TimingRankingCS
