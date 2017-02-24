
--[[--
“User” Class
]]

local UserModel = class("UserModel", data.serializeModel)

UserModel.EXP_CHANGED_EVENT         = "EXP_CHANGED_EVENT"
UserModel.GEM_CHANGED_EVENT         = "GEM_CHANGED_EVENT"
UserModel.COIN_CHANGED_EVENT        = "COIN_CHANGED_EVENT"
UserModel.LEVEL_UP_EVENT            = "LEVEL_UP_EVENT"

-- player info
UserModel.pid                       = "pid"
UserModel.udid                      = "udid"
UserModel.lastPid                   = "lastPid"
UserModel.serialNo       			= "serialNo"
UserModel.name       				= "name"
UserModel.level       				= "level"
UserModel.exp       				= "exp"
UserModel.vipLevel       			= "vipLevel"
UserModel.vipPoint       			= "vipPoint"
UserModel.coins       				= "coins"
UserModel.gems       				= "gems"
UserModel.money       				= "money"
UserModel.liked       				= "liked"
UserModel.pictureId                 = "pictureId"
UserModel.facebookId                = "facebookId"
UserModel.successiveLoginDays       = "successiveLoginDays"
UserModel.loginDays                 = "loginDays"
UserModel.doublePoker               = "doublePoker"
UserModel.noticeSign                = "noticeSign"
UserModel.musicSign                 = "musicSign"
UserModel.soundSign                 = "soundSign"
UserModel.hasnews                   = "hasnews"

UserModel.hasgift                   = "hasgift"
UserModel.hastask                   = "hastask"
UserModel.hashonor                  = "hashonor"

UserModel.lastgetbonustime       	= "lastgetbonustime"
UserModel.lastgetbonusflag       	= "lastgetbonusflag"

UserModel.rateSign                  = "rateSign"
-- hour bonus
UserModel.wheelcount                = "wheelcount"

-- player item state
UserModel.items                 = "items"
UserModel.it = {
    itemId                      = "itemId",
    count                       = "count",
}

-- player ext info
UserModel.extinfo               = "extinfo"
UserModel.ei = {
    signature                   = "signature",
    gender                      = "gender",
    age                         = "age",
    country                     = "country",
    rateSign                    = "rateSign",
}

-- player game state
UserModel.gameState      	    = "gameState"
UserModel.gs= {
	gameId       				= "gameId",
	gameCnt       				= "gameCnt",
	winCnt       				= "winCnt",
	totalBet       				= "totalBet",
	totalWin       				= "totalWin",
	maxWin       				= "maxWin",
	bestSuit       				= "bestSuit",
}

-- player item state
UserModel.itemState           	= "itemState"
UserModel.is = {
 	itemId       				= "itemId",
 	currCount       			= "currCount",
 	buyCnt       				= "buyCnt",
 	usedCnt       				= "usedCnt",
}

-- facebook
UserModel.guest                 = "guest"
UserModel.gs   = {
    udid                        = "udid",
}

-- facebook
UserModel.facebook              = "facebook"
UserModel.fb = {
    fbid                        = "fbid",
    name                        = "name",
    token                       = "token",
    gender                      = "gender",
    location                    = "location",
    tokenExpireDate             = "tokenExpireDate",
}

-- facebook
UserModel.userdownload          = "userdownload"
UserModel.userdown = {
    md5val                      = "md5val",
    needdown                    = "needdown",
    hasdown                     = "hasdown",
}

UserModel.notifybar             = "notifybar"

UserModel.inviteFrends          = "inviteFrends"

-- player info
UserModel.schema                                     = clone(cc.mvc.ModelBase.schema)
UserModel.schema[UserModel.pid]          	         = {"number", 0}
UserModel.schema[UserModel.udid]                     = {"string", ""}
UserModel.schema[UserModel.lastPid]                  = {"number", 0}
UserModel.schema[UserModel.serialNo]                 = {"number", 0}
UserModel.schema[UserModel.name]         	         = {"string", ""}
UserModel.schema[UserModel.level]         	         = {"number", 1}
UserModel.schema[UserModel.exp]         	         = {"number", 0}
UserModel.schema[UserModel.vipLevel]                 = {"number", 0}
UserModel.schema[UserModel.vipPoint]                 = {"number", 0}
UserModel.schema[UserModel.coins]         	         = {"number", 0}
UserModel.schema[UserModel.gems]                     = {"number", 100}
UserModel.schema[UserModel.money]                    = {"number", 100}
UserModel.schema[UserModel.liked]         	         = {"number", 0}
UserModel.schema[UserModel.pictureId]                = {"number", 1}
UserModel.schema[UserModel.facebookId]               = {"string", ""}
UserModel.schema[UserModel.successiveLoginDays]      = {"number", 0}
UserModel.schema[UserModel.loginDays]                = {"number", 0}
UserModel.schema[UserModel.noticeSign]               = {"number", 1}
UserModel.schema[UserModel.musicSign]                = {"number", 1}
UserModel.schema[UserModel.soundSign]                = {"number", 1}
UserModel.schema[UserModel.hasnews]                  = {"number", 0}
UserModel.schema[UserModel.hasgift]                  = {"number", 0}
UserModel.schema[UserModel.hastask]                  = {"number", 0}
UserModel.schema[UserModel.hashonor]                 = {"number", 0}
UserModel.schema[UserModel.wheelcount]               = {"number", 0 }

UserModel.schema[UserModel.lastgetbonustime]         = {"number", 0}
UserModel.schema[UserModel.lastgetbonusflag]         = {"number", 0 }

UserModel.schema[UserModel.rateSign]                 = {"number", 0 }

-- table
UserModel.schema[UserModel.extinfo]                  = {"table", {}}
UserModel.schema[UserModel.gameState]                = {"table", {}}
UserModel.schema[UserModel.itemState]                = {"table", {}}
UserModel.schema[UserModel.doublePoker]              = {"table", {}}
UserModel.schema[UserModel.facebook]                 = {"table", {}}
UserModel.schema[UserModel.userdownload]             = {"table", {}}
UserModel.schema[UserModel.notifybar]                = {"table", {}}
UserModel.schema[UserModel.inviteFrends]             = {"table", {}}

function UserModel:ctor(properties)
    UserModel.super.ctor(self, properties)

    if self.loadModel ~= nil then
        
        self:loadModel()

        local isw = false

        for k,v in pairs(DICT_UNIT) do
            
            local zipname = v.zipname

            if tonumber(v.need_download) == 1 then

                if self.userdownload_[zipname] == nil then
                    
                    local downname = {}

                    downname[UserModel.userdown.md5val] = ""
                    downname[UserModel.userdown.hasdown] = 0
                    downname[UserModel.userdown.needdown] = tonumber(v.need_download)

                    self.userdownload_[zipname] = downname

                    print("zipname", zipname, downname[UserModel.userdown.needdown], downname[UserModel.userdown.hasdown])

                    isw = true
                else

                    local down = cc.UserDefault:getInstance():getStringForKey(zipname)
                    local md5str = string.split(down, ",")

                    if self.userdownload_[zipname][UserModel.userdown.needdown] == 1
                       and self.userdownload_[zipname][UserModel.userdown.md5val] ~= md5str[2] then
                        self.userdownload_[zipname][UserModel.userdown.hasdown] = 0
                        isw = true
                        print("zipname", zipname, md5str, self.userdownload_[zipname][UserModel.userdown.needdown], self.userdownload_[zipname][UserModel.userdown.hasdown])
                    end

                end

            end
        end

        if isw then self:serializeModel() end

    end

    EventMgr:addEventListener(EventMgr.SPIN_SLOTSGAME_EVENT, handler(self, self.onSpinSlotsGame), self)
end

function UserModel:setGems(gems)
    self.gems_ = gems
    self:serializeModel()
end

function UserModel:getPid()
    return self.pid_
end

function UserModel:getLastPid()
    return self.lastPid_
end

function UserModel:getGems()
    return self.gems_
end

function UserModel:getCoins()
    return self.coins_
end

function UserModel:setCoins(val)
    self.coins_ = val
    self:serializeModel()
end

function UserModel:setName(val)
    self.name_ = val
    self:serializeModel()
end

function UserModel:getName()
    return self.name_
end

function UserModel:getLastgetbonusflag()
    return self.lastgetbonusflag_
end

function UserModel:getLastgetbonustime()
    return self.lastgetbonustime_
end

function UserModel:getLevel()
    return self.level_
end

function UserModel:getVipLevel()
    return self.vipLevel_
end

function UserModel:getExp()
    return self.exp_
end

function UserModel:getCurrentLvExp()
    return self.exp_ -  getLevelExpByLevel(self.level_)
end

function UserModel:getVipPoint()
    return self.vipPoint_
end

function UserModel:getCurrentVipLvExp()
    return self.vipPoint_ - getVipPointsByLevel(self.vipLevel_)
end

function UserModel:getFriendVipLvExp(vippoint,viplevel)
    return vippoint - getVipPointsByLevel(viplevel)
end

function UserModel:setExp(val)

    local currLevel = self.level_
    local nextLevel = getLevelByExp(val)

    local lvUp = false
    if tonumber(nextLevel) > tonumber(currLevel) then
        lvUp = true
        self:setProperty(self.class.level, nextLevel)
    end

    self.exp_ = val
    self:serializeModel()

    return lvUp
end

function UserModel:setVipPoint(val)
    local currLevel = self.vipLevel_
    local nextLevel = getVipLevelByVipPoint(val)

    local vlvUp = false
    if tonumber(nextLevel) > tonumber(currLevel) then
        vlvUp = true
        self:setProperty(self.class.vipLevel, nextLevel)
    end

    self.vipPoint_ = val
    self:serializeModel()
    if vlvUp then
        app:getObject("ReportModel"):sendReportBaseInfo()
    end
    return vlvUp
end

function UserModel:setPictureId(val)
    if val > 0 and val < 13 then
        self.pictureId_ = val
        self:serializeModel()
    else
        print("setPictureId() error !")
    end
end

function UserModel:getPictureId()
    return self.pictureId_
end

function UserModel:getDoublePoker()
    return self.doublePoker_
end

function UserModel:setDoublePoker(val)
    self.doublePoker_ = val
    self:serializeModel()
end

function UserModel:getSerialNo()
    return self.serialNo_
end

function UserModel:stepSerialNO()
    self.serialNo_ = self.serialNo_ + 1
    return self.serialNo_
end

function UserModel:buy(items)
    if items.type == 1 then
        self:increaseGems(items.count)
    end
end

function UserModel:onSpinSlotsGame(event)
    print("onSpinSlotsGame")
end


function UserModel:getUnitDownLoad(zipname)
    return self.userdownload_[zipname]
end

function UserModel:setUnitDownLoad(zipname, key, val)
    print(zipname, key)
    self.userdownload_[zipname][key] = val
    self:serializeModel()
end


function UserModel:InviteFrendsMgr(pid)
    if self.inviteFrends_[pid] then --pid存在
        return 1
    else
        self.inviteFrends_[pid] = 1
        return 0
    end
end

function UserModel:InviteFrends()
    return self.inviteFrends_
end

return UserModel
