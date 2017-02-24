
require "app.interface.pb.Friend_pb"
require "app.interface.pb.CasinoMessageType"

local FriendsCS = {}

function FriendsCS:getFriendsList(callfunction)

    local function callBack(rdata)

        local msg = Friend_pb.GCGetFriendList()
        msg:ParseFromString(rdata)

        callfunction(msg.friendList)

    end

    local pid = app:getUserModel():getPid()

    local req= Friend_pb.CGGetFriendList()

    req.pid  = pid
    req.index   = 1

    core.SocketNet:sendCommonProtoMessage(CG_GET_FRIEND_LIST,GC_GET_FRIEND_LIST, pid,req, callBack, true)

end

function FriendsCS:getAllFriends(giftType, callfunction)
   
    local function callBack(rdata)

        local msg = Friend_pb.GCGetAllFriends()
        msg:ParseFromString(rdata)

        callfunction(msg.friendList)

    end

    local pid = app:getUserModel():getPid()

    local req= Friend_pb.CGGetAllFriends()

    req.pid  = pid
    req.giftType = giftType

    core.SocketNet:sendCommonProtoMessage(CG_GET_ALL_FRIENDS,GC_GET_ALL_FRIENDS, pid,req, callBack, true)

end

function FriendsCS:getFriendInfo(fid, callfunction)

    local function callBack(rdata)

        local msg = Friend_pb.GCFriendInfo()
        msg:ParseFromString(rdata)

        callfunction(msg)

    end

    local pid = app:getUserModel():getPid()

    local req= Friend_pb.CGFriendInfo()

    req.pid     = fid

    core.SocketNet:sendCommonProtoMessage(CG_FRIEND_INFO,GC_FRIEND_INFO, pid,req, callBack, true)

end

function FriendsCS:getOnlinePlayers(callfunction)

    local function callBack(rdata)

        local msg = Friend_pb.GCGetOnlinePlayers()
        msg:ParseFromString(rdata)

        callfunction(msg.friendList)

    end

    local pid = app:getUserModel():getPid()

    local req= Friend_pb.CGGetOnlinePlayers()

    req.pid  = pid
    req.currentState = 0

    core.SocketNet:sendCommonProtoMessage(CG_GET_ONLINE_PLAYERS,GC_GET_ONLINE_PLAYERS, pid,req, callBack, true)

end

function FriendsCS:addFriend(targetPid)

    local pid = app:getUserModel():getPid()

    local req= Friend_pb.CGAddFriend()

    req.pid  = pid
    req.targetPid = targetPid

    core.SocketNet:sendCommonProtoMessage(CG_ADD_FRIEND,CG_ADD_FRIEND, pid,req, nil, false)

end

function FriendsCS:addFacebookFriends(fbids, callfunction)

    local function callBack(rdata)

        local msg = Friend_pb.GCAddFacebookFriends()
        msg:ParseFromString(rdata)

        callfunction(msg)

    end

    local pid = app:getUserModel():getPid()

    local req= Friend_pb.CGAddFacebookFriends()

    req.pid  = pid
    req.facebookIds  = fbids

    core.SocketNet:sendCommonProtoMessage(CG_ADD_FACEBOOK_FRIENDS,GC_ADD_FACEBOOK_FRIENDS, pid,req, callBack, true)

end

return FriendsCS
