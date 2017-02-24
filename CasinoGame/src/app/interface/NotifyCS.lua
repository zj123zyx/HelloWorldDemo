require "app.interface.pb.Notify_pb"
require "app.interface.pb.CasinoMessageType"

local NotifyCS = {}

function NotifyCS:getNotifyList()
	local function callBack(data)
		local msg = Notify_pb.GCMsgNotifyList()
		msg:ParseFromString(data)

		local model = app:getUserModel()
		for k,v in ipairs(msg.msgTypeList) do
			print(v)
		 	if v ~= -1 then
			 	EventMgr:dispatchEvent({
		            name  = EventMgr.SERVER_NOTICE_EVENT,
		            hasnews = v
		        })
		 	end
		end    		
	end
	local pid = app:getUserModel():getPid()
	local req = Notify_pb.CGMsgNotifyList()
	req.pid = pid
    core.SocketNet:sendCommonProtoMessage(CG_MSG_NOTIFY_LIST,GC_MSG_NOTIFY_LIST,pid,req, callBack, true)
	
end

function NotifyCS:sendMessageToPlayer(sendmsg)

	local pid = app:getUserModel():getPid()
	local req = Notify_pb.CGSendMsg()
	req.fromPid = pid
	req.toPid = sendmsg.toPid
	req.title = sendmsg.title
	req.shortContent = sendmsg.shortContent
	req.content = sendmsg.content

    core.SocketNet:sendCommonProtoMessage(CG_SEND_MSG,CG_SEND_MSG,pid,req, nil, false)
	
end

return NotifyCS