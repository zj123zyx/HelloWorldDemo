local ccnet = require("framework.cc.net.init")

require "app.interface.pb.Chat_pb"
require "app.interface.pb.Game_pb"
require "app.interface.pb.CasinoMessageType"


local PM = require("app.core.network.PacketModule")

local SocketNetModule = class("SocketNetModule")

function SocketNetModule:ctor()
    --self:init()
end

--初始化方法，程序启动时初始化一次
function SocketNetModule:init()

    local time = ccnet.SocketTCP.getTime()
   print("socket time:" .. time)

    local socket = ccnet.SocketTCP.new()
    socket:setName("SocketTcp")
    socket:setTickTime(0.1)
    socket:setReconnTime(6)
    socket:setConnFailTime(4)

    socket:addEventListener(ccnet.SocketTCP.EVENT_DATA, handler(self, self.tcpData))
    socket:addEventListener(ccnet.SocketTCP.EVENT_CLOSE, handler(self, self.tcpClose))
    socket:addEventListener(ccnet.SocketTCP.EVENT_CLOSED, handler(self, self.tcpClosed))
    socket:addEventListener(ccnet.SocketTCP.EVENT_CONNECTED, handler(self, self.tcpConnected))
    socket:addEventListener(ccnet.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.tcpConnectedFail))

    self.socket_ = socket
    
    self:ConnectServer()

    self.requests = {}

    --self.events={}

    --self.waitingCnt = 0

    --self.requestting = false

    --self.curRequestting = nil

    self.netErrorViewOpen = false

    self.netReceiveData = nil

end

function SocketNetModule:ConnectServer()
    
    core.Waiting.show()

    local socket_addr = cc.UserDefault:getInstance():getStringForKey("socket_addr")
    local socket_port = cc.UserDefault:getInstance():getStringForKey("socket_port")
    print("socket_addr:", socket_addr, "socket_port:", socket_port)
    self.socket_:connect(socket_addr, socket_port, false) --122.0.71.122   8081
    --self.socket_:connect("192.168.3.117", "8081", false)
    --self.socket_:connect("192.168.1.175", "8083", false)
    print("socket_addr", socket_addr, socket_port)
end

function SocketNetModule:enterGame()

end

function SocketNetModule:isConnected()
    return self.socket_.isConnected
end

function SocketNetModule:isNeedWaiting()
    for k,v in pairs(self.requests) do
        if k ~= nil and v ~= nil then
            if v.needwait == true and v.count > 0 then
                return true
            end
        end
    end
    return false
end


function SocketNetModule:resetRequests()
    for k,v in pairs(self.requests) do
        if k ~= nil and v ~= nil then
            if v.global == false then
                v.count = 0
            end
        end
    end

    self.requestting = false
    app.logining = false
    core.Waiting.forceHide()
end

function SocketNetModule:removeReq(itype,rtype)

    for k,v in pairs(self.requests) do
        if k ~= nil and v ~= nil and k == itype then

            if v.global == true then
                if v.count > 0 then v.count = v.count - 1 end
            else
                if v.rType == rtype and v.count > 0 then

                    if v.needwait==true then
                        core.Waiting.hide()
                    end

                    v.count = v.count - 1
                    print("收到数据", rtype, v.needwait, v.count)

                    return
                end
            end

        end
    end
end

function SocketNetModule:handleRequestType(rtype)

    for k,v in pairs(self.requests) do

        if k ~= nil and v ~= nil then
            
            if v.rType == rtype and v.count > 0 then

                if v.global == false then
                    self.requestting = false
                    self:removeReq(k, rtype)
                end

                return v.callback

            end
        end
    end

    return nil

end

function SocketNetModule:tcpData(event)

    if self.netReceiveData then
        event.data = self.netReceiveData..event.data
    end

    local itype, body, datanext = PM.getPacketBody(event.data)

    local reNum = 0

    while itype and body do

        reNum = reNum + 1

        local callbackFun = self:handleRequestType(itype)

        if nil ~= callbackFun then
            callbackFun(body)
        else
            print("not found callbackFun by type:"..itype)
        end

        itype, body, datanext = PM.getPacketBody(datanext)

    end

    self.netReceiveData = datanext

end

function SocketNetModule:ReConnectInit()
    self:resetRequests()
end

function SocketNetModule:tcpClose()
    -- if self.requestHandle  then
    --     scheduler.unscheduleGlobal(self.requestHandle)
    --     self.requestHandle = nil
    -- end
    local playerGameing = app:getPlayerStatus().gaming
    print("SocketTCP close:playerGameing:",playerGameing)
    self:resetRequests()
    core.Waiting.forceHide()
    app.logined = false
    net.GameCS:leaveGame()

    EventMgr:dispatchEvent({name = EventMgr.OFFLINE_STOP_SUTOSPIN})

    if self.netErrorViewOpen == false then

        if playerGameing == true  then --游戏中途断开
            scn.ScnMgr.addView("RejoinGameView",{
                    callback1 = function()
                        EventMgr:addEventListener(EventMgr.SOCKET_CONNECT_EVENT, function()
                            net.UserCS:EnterGame(function()
                                self.netErrorViewOpen = false
                                app.logined = true

                                scn.ScnMgr.replaceScene("lobby.LobbyScene", {2}, true)
                                EventMgr:removeEventListenersByTag("EnterGame")
                            end)
                        end,"EnterGame")
                        core.SocketNet:ConnectServer()
                    end,
                    callback2 = function()
                        EventMgr:addEventListener(EventMgr.SOCKET_CONNECT_EVENT, function()
                            net.UserCS:EnterGame(function()
                                self.netErrorViewOpen = false
                                app.logined = true
                                EventMgr:removeEventListenersByTag("EnterGame")
                                app:rejoinGame()
                            end)
                        end,"EnterGame")
                        core.SocketNet:ConnectServer()
                        
                    end
                })
            
        else
            local netview=scn.ScnMgr.addView("NetErrorView",
                {
                    callback = function()
                        self.netErrorViewOpen = false
                        
                        -- app.logined = true

                        EventMgr:addEventListener(EventMgr.SOCKET_CONNECT_EVENT, function()
                            net.UserCS:EnterGame(function()
                                EventMgr:removeEventListenersByTag("EnterGame")
                            end)
                        end,"EnterGame")

                        core.SocketNet:ConnectServer()
                    end
                })
        end

        self.netErrorViewOpen = true
    end
    
end

function SocketNetModule:tcpClosed()
    print("SocketTCP closed")
end

function SocketNetModule:tcpConnected()
    print("SocketTCP connect success")
    core.Waiting.hide()
    
    EventMgr:dispatchEvent({ name  = EventMgr.SOCKET_CONNECT_EVENT  })

    -- local requestTime = 0

    -- local requestTick = function(dt)

    --     requestTime = requestTime + dt

    --     if self.requestting == true or self.socket_.isConnected == false then

    --         -- if self:isNeedWaiting() == true then
    --         --     core.Waiting.show()
    --         -- end

    --         local status = network.getInternetConnectionStatus()

    --         if status == kCCNetworkStatusNotReachable then
    --             self.socket_:close()
    --             return
    --         elseif status == kCCNetworkStatusReachableViaWiFi then
    --         elseif status == kCCNetworkStatusReachableViaWWAN then
    --         end

    --         if self.socket_.isConnected == false then
    --             self.socket_:close()
    --             return
    --         end

    --         if requestTime > 30 then
    --             self.requestting = false

    --             --self.socket_:close()
    --             if self.curRequestting then
    --                 print("self.curRequestting",self.curRequestting.rType,self.curRequestting.count)
    --             end
    --         end

    --         return
    --     end

    --     requestTime = 0

    --     if true then return end

    --     for k,v in pairs(self.requests) do

    --         if k ~= nil and v ~= nil and v.global == false and v.count > 0 then

    --             if v.callback ~= nil and self.requestting == false then

    --                 local bodyData = v.protoObj:SerializeToString()

    --                 self.requestting = true
    --                 self.curRequestting = v

    --                 self:sendCommonMessage(k,v.passportId,bodyData)
    --                 break
    --             else
    --                 local bodyData = v.protoObj:SerializeToString()
    --                 self:sendCommonMessage(k,v.passportId,bodyData)
    --                 self.requests[k] = nil
    --             end
    --         else
    --             --print("request waiting:",k, v.global,v.count)
    --         end
    --     end
    -- end

    -- if self.requestHandle  then
    --     scheduler.unscheduleGlobal(self.requestHandle)
    --     self.requestHandle = nil
    -- end

    -- self.requestHandle = scheduler.scheduleGlobal(requestTick, 0.1)

end

function SocketNetModule:tcpConnectedFail()
    print("SocketTCP connect fail")
    --core.Waiting.hide()
    core.Waiting.forceHide()
end

--停止发送和接收数据
function SocketNetModule:stop()
    print("SocketNetModule:stop()")
    self.socket_:close()
end

function SocketNetModule:registEvent(iType, callback)

    if self.requests[tostring(iType)] == nil then
        self.requests[tostring(iType)] = {}
    end

    self.requests[tostring(iType)].count=1
    self.requests[tostring(iType)].global=true
    self.requests[tostring(iType)].callback=callback
    self.requests[tostring(iType)].needwait=false
    self.requests[tostring(iType)].rType=iType

end

function SocketNetModule:unregistEvent(iType)
    self:removeReq(iType)
end

-- add request to queue
function SocketNetModule:sendCommonProtoMessage(iType,rType,passportId,protoObj, callback, needwait,forceMove)

    print("发送数据  ", iType, rType)

    if self:isConnected() then

        if callback then

            if self.requests[tostring(iType)] == nil then
                self.requests[tostring(iType)] = {}
                self.requests[tostring(iType)].global=false
                self.requests[tostring(iType)].count=0
            end

            --self.requests[tostring(iType)].protoObj=protoObj
            self.requests[tostring(iType)].rType=rType
            --self.requests[tostring(iType)].passportId=passportId
            self.requests[tostring(iType)].callback=callback
            self.requests[tostring(iType)].needwait=needwait
            self.requests[tostring(iType)].global=false
            
            local count = self:requestBackHandleCount(iType)

            if self.requests[tostring(iType)].count ~= count then

                self.requests[tostring(iType)].count = count

                if needwait == true then
                    core.Waiting.show()
                end
            end

        end

        local bodyData = protoObj:SerializeToString()
        self:sendCommonMessage(iType,passportId,bodyData)
        
    end

end

function SocketNetModule:requestBackHandleCount(iType)

    local requetObj = {}

    for k,v in pairs(self.requests) do
        if k ~= nil and v ~= nil then
            if v.rType and tonumber(iType) == tonumber(k) then
                requetObj[v.rType] = iType
            elseif v.rType == nil and tonumber(iType) == tonumber(k) then
                requetObj["nil"] = iType
            end
        end
    end
    
    return table.nums(requetObj)
end


function SocketNetModule:sendCommonMessage(iType,passportId,iBody)
    local packet=core.NetPacket.buildPacket(iType,passportId,iBody)
    self.socket_:send(packet)
end
 
return SocketNetModule