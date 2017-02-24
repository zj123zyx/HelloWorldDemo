
require "app.interface.pb.Task_pb"
require "app.interface.pb.CasinoMessageType"

local DailyTaskCS = {}

function DailyTaskCS:getDailyTaskList(callfunction)

    local function callBack(rdata)
        local msg = Task_pb.GCGetDailyTaskList()
        msg:ParseFromString(rdata)

        --print(tostring(msg),"----=====rdata======")
        --table.dump(msg)
        if callfunction then callfunction(msg.taskList) end
    end
    local pid = app:getUserModel():getPid()
    local req= Task_pb.CGGetDailyTaskList()
    req.pid = pid
    core.SocketNet:sendCommonProtoMessage(CG_GET_DAILY_TASK_LIST,GC_GET_DAILY_TASK_LIST,pid,req, callBack, true)
end

function DailyTaskCS:getTaskReward(taskID,callfunction)

    local function callBack(rdata)

        local msg = Task_pb.GCReceiveTaskReward()
        msg:ParseFromString(rdata)

        if callfunction then callfunction(msg) end

    end

    local pid = app:getUserModel():getPid()

    local req= Task_pb.CGReceiveTaskReward()

    req.pid=pid

    if taskID then req.taskId = taskID end

    core.SocketNet:sendCommonProtoMessage(CG_RECEIVE_TASK_REWARD,GC_RECEIVE_TASK_REWARD,pid,req, callBack, true)
end


return DailyTaskCS