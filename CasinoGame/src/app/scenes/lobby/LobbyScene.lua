local lobbyctr = import("app.scenes.lobby.controllers.LobbyController")

-- 游戏大厅场景类
local LobbyScene = class("LobbyScene", function()
    return display.newScene("LobbyScene")
end)

function LobbyScene:ctor(layoutId)

    local model = app:getUserModel()
    local cls = model.class
    local properties = model:getProperties({cls.pid, cls.musicSign, cls.soundSign})
    
    if properties[cls.soundSign] == 1 then
        audio.setSoundsVolume(1)
    else
        audio.setSoundsVolume(0)
    end

    if properties[cls.musicSign] == 1 then
        audio.setMusicVolume(0.4)
    else
        audio.setMusicVolume(0)
    end
    
    self.ctr_ = lobbyctr.new(layoutId)

    self:addChild(self.ctr_)
    
    self:setNodeEventEnabled(true)
end

function LobbyScene:onEnter()

    -- 弹出每日签到及推荐商品页 jjftest
	-- app:popDailyLogin()
end

function LobbyScene:onExit()
end

return LobbyScene
