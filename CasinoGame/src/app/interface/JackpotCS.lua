require "app.interface.pb.JackPot_pb"
require "app.interface.pb.CasinoMessageType"

local JackpotCS = {}

function JackpotCS:rewardJackpot(rewardCoins,callfunction)
    local function callback(data)
        local msg = JackPot_pb.GCRewardJackPot()
       	msg:ParseFromString(data)
       	callfunction(msg.rewardCoins)
    end

    local req = JackPot_pb.CGRewardJackPot()
    req.pid = app:getUserModel():getPid()
    req.gameId = app:getPlayerStatus().gameId 
    req.rewardCoins = rewardCoins
    core.SocketNet:sendCommonProtoMessage(CG_REWARD_JACK_POT,GC_REWARD_JACK_POT, req.pid ,req, callback, true)
end

return JackpotCS