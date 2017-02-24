
require "app.interface.pb.UserAuth_pb"
require "app.interface.pb.CasinoMessageType"

local UserAuthCS = {}

function UserAuthCS:updateDataFromServer(args, model, cls)

    local properties = {}

    properties[cls.pid]                 = args.playerInfo.pid
    properties[cls.serialNo]            = args.playerInfo.serialNo + 1
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
function UserAuthCS:quickLogin(callfunction)

    print("--quickLogin---111")
    
    core.Waiting.show()

    local model = app:getObject("UserModel")
    local cls = model.class
    local properties = model:getProperties({cls.pid, cls.udid, cls.serialNo, cls.name, cls.level, cls.exp, cls.vipLevel, cls.vipPoint, cls.coins, cls.gems, cls.money, cls.liked, cls.pictureId, cls.extinfo, cls.gameState, cls.itemState})

    local function callBack(responseCode,rdata)
        core.Waiting.hide()

        if tonumber(responseCode) ~= 200 then
            device.showAlert("Server Connect", "Server Connect error, please check your net!!!", "OK",
            function()
                CCDirector:sharedDirector():endToLua()
                os.exit()
            end)
            return
        end

        local body=core.NetPacket.subPacketBody(rdata)
        local msg = UserAuth_pb.GCQuickLogin()
        msg:ParseFromString(body)

        --print("msg.result", msg.result, msg.playerInfo.pid)

        print(tostring(msg))

        if msg.result == 1 then
        
            if msg.pid ~= properties[cls.pid] then               -- new user
                print("quickLogin==========msg.pid=",msg.pid," cls.pid=",properties[cls.pid])
                model:setProperties({pid=msg.pid})
            end
            
            if callfunction~= nil then callfunction() end

        elseif msg.result == 2 then
            --if callfunction~= nil then callfunction() end

        elseif msg.result == 3 then

            --model:setProperties({serialNo=msg.playerInfo.serialNo})

            --self:updateDataFromServer(msg, model, cls)

            if callfunction~= nil then callfunction() end

        end

    end

    local req= UserAuth_pb.CGQuickLogin()


    local udid = properties[cls.udid]

    if string.len(udid) == 0 then
        udid = device.getOpenUDID()
    end

    print("user udid:", udid)

    req.udid= udid --properties[cls.udid]--device.getOpenUDID()
    req.deviceType=device.model
    req.osVersion = AppLuaApi:getInstance():SystemVersion()--"1.0"
    req.clientType = 1
    req.gameVersion = AppLuaApi:getInstance():AppVersion()--"1.0"


    model:stepSerialNO()

    core.HttpNet.sendCommonProtoMessage(CG_QUICK_LOGIN,1,req, callBack)

end

function UserAuthCS:thirdLogin(id, fbname,callfunction)
    core.Waiting.show()

    local model = app:getObject("UserModel")
    local cls = model.class
    local properties = model:getProperties({cls.pid, cls.serialNo, cls.name, cls.level, cls.exp, cls.vipLevel, cls.vipPoint, cls.coins, cls.gems, cls.money, cls.liked, cls.pictureId, cls.extinfo, cls.gameState, cls.itemState})

    local function callBack(responseCode,rdata)
        core.Waiting.hide()

        if tonumber(responseCode) ~= 200 then

            device.showAlert("Server Connect", "Server Connect error, please check your net!!!", "OK",
                function()
                    CCDirector:sharedDirector():endToLua()
                    os.exit()
                end)
            return
        end

        local body=core.NetPacket.subPacketBody(rdata)
        local msg = UserAuth_pb.GCThirdConnect()
        msg:ParseFromString(body)

        print("------------msg--",tostring(msg))

        if msg.result == 1 then
        
            if msg.pid ~= properties[cls.pid] then               -- new user
                print("thirdLogin==========msg.pid=",msg.pid," cls.pid=",properties[cls.pid])
                model:setProperties({pid=msg.pid})
            end

            if callfunction~= nil then callfunction() end

        elseif msg.result == 2 then
            if callfunction~= nil then callfunction() end

        elseif msg.result == 3 then
                        
            -- model:setProperties({serialNo=msg.playerInfo.serialNo})
            -- self:updateDataFromServer(msg, model, cls)

            -- User:dispatchEvent( { name=User.EVENT_FBLOGINEVENT,
            --     [User.KEY_TOTALCOINS] = User.getProperty(User.KEY_TOTALCOINS),
            --     [User.KEY_TOTALGEMS] =  User.getProperty(User.KEY_TOTALGEMS),
            --     [User.KEY_LEVEL] =  User.getProperty(User.KEY_LEVEL),
            --     [User.KEY_EXP] = User.getProperty(User.KEY_EXP)} )
            
            -- User:dispatchEvent( { name=User.EVENT_STARSCHANGE, [User.KEY_STARS] = User.getProperty(User.KEY_STARS)} )
            
            -- User.Report.initGameState()

            if callfunction~= nil then callfunction() end

        end

    end

    local req= UserAuth_pb.CGThirdConnect()
    req.thirdId = id
    req.channelCode = 1
    req.deviceType=device.model
    req.osVersion = AppLuaApi:getInstance():SystemVersion()--"1.0"
    req.clientType = 1
    req.gameVersion = AppLuaApi:getInstance():AppVersion()--"1.0"

    req.thirdName=fbname

    req.pid=properties[cls.pid]

    -- req.playerInfo.pid          = properties[cls.pid]
    -- req.playerInfo.serialNo     = properties[cls.serialNo]
    -- req.playerInfo.name         = properties[cls.name]
    -- req.playerInfo.level        = properties[cls.level]
    -- req.playerInfo.exp          = properties[cls.exp]
    -- req.playerInfo.vipLevel     = properties[cls.vipLevel]
    -- req.playerInfo.vipPoint     = properties[cls.vipPoint]
    -- req.playerInfo.coins        = properties[cls.coins]
    -- req.playerInfo.gems         = properties[cls.gems]
    -- req.playerInfo.money        = properties[cls.money]
    -- req.playerInfo.liked        = properties[cls.liked]
    -- req.playerInfo.pictureId    = properties[cls.pictureId]
    
    model:stepSerialNO()
    print("thirdLogin==========pid=",id," cls.pid=",properties[cls.pid])

    core.HttpNet.sendCommonProtoMessage(CG_THIRD_CONNECT,1,req, callBack)

end

return UserAuthCS
