local SettingView = class("SettingView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

local CHECKBOX_BUTTON_IMAGES = {
    off = "#shezhi_off_01.png",
    off_pressed = "#shezhi_off_01.png",
    off_disabled = "#shezhi_off_01.png",
    on = "#shezhi_on_01.png",
    on_pressed = "#shezhi_on_01.png",
    on_disabled = "#shezhi_on_01.png",
}

function SettingView:ctor()
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.setting, self)
    self:addChild(self.viewNode)

    --if self.title then self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3) end

    self:initUI()

    self:registerEvent()

end

function SettingView:registerEvent()

    --self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self, self.onTouch_))

	-- on close
    core.displayEX.newButton(self.btn_close) 
        :onButtonClicked(function(event)
            scn.ScnMgr.removeView(self)
        end)

	-- on pan
    core.displayEX.newButton(self.btn_go) 
        :onButtonClicked(function(event)
			device.openURL("https://www.facebook.com/pages/Royal-Casino/811294582240964?ref=hl")
        end)

    core.displayEX.newButton(self.fbBtn) 
        :onButtonClicked(function(event)
            --scn.ScnMgr.addView("FBConnectView")
            core.FBPlatform.onLoginImpl(function()
                -- body
                net.UserCS:EnterGame(function()
                    EventMgr:dispatchEvent({name=EventMgr.UPDATE_LOBBYUI_EVENT})
                    --self:initUI()

                    self:postFBPhoto()

                    app.logining = false
                end)
                
            end)

        end)

    core.displayEX.newButton(self.loginoutBtn) 
        :onButtonClicked(function(event)

            local model = app:getObject("UserModel")
            local cls = model.class
            
            local properties = model:getProperties({cls.pid, cls.name, cls.facebook,cls.extinfo})
            properties[cls.facebook] = {}
            properties[cls.pictureId] = 1
            properties[cls.facebookId] = ""

            -- modify picture id server
            local ei = {}
            ei[cls.ei.signature] = properties[cls.extinfo][cls.ei.signature]
            ei[cls.pictureId] = 1
            net.UserCS:modifyPlayerInfo(properties[cls.pid], properties[cls.name], ei)

            model:setProperties(properties)
            model:serializeModel()
            
            app.logined = false

            core.FBPlatform.logout()
            scn.ScnMgr.replaceScene("lobby.LoginScene")
            scn.ScnMgr.removeView(self)
        end)

end

function SettingView:postFBPhoto()
    if core.FBPlatform.getIsLogin() == true then

        local model = app:getUserModel()
        local cls = model.class
        local properties = model:getProperties({
                cls.name, 
                cls.level, 
                cls.vipLevel,
                cls.pictureId,
                cls.facebookId,
                cls.hasgift,
                cls.facebook})

        local fb = properties[cls.facebook]


        self.headView = headViewClass.new({player=properties, scale=0.8})
        self.headView:replaceHead(self.headImage)
        self.headView:showUserLevel()

        self.name:setString(fb[cls.fb.name])
        self.name:setVisible(true)
        self.loginoutBtn:setVisible(true)
        self.tips:setVisible(false)
        self.fbBtn:setVisible(false)

    else
        self.tips:setVisible(true)
        self.fbBtn:setVisible(true)
        self.name:setVisible(false)
        self.loginoutBtn:setVisible(false)
    end
end

function SettingView:initUI()

    self:postFBPhoto()

    self.musicCheckBox = cc.ui.UICheckBoxButton.new(CHECKBOX_BUTTON_IMAGES)
        :onButtonStateChanged(function(event)

            local checkbox = event.target

            if checkbox:isButtonSelected() then
                self:selectMusic(true)
            else
                self:selectMusic(false)
            end

        end)
        :align(display.CENTER, self.mark_music:getPosition())
        :addTo(self.mark_music:getParent())

    self.mark_music:setVisible(false)

    self.soundCheckBox = cc.ui.UICheckBoxButton.new(CHECKBOX_BUTTON_IMAGES)
        :onButtonStateChanged(function(event)

            local checkbox = event.target

            if checkbox:isButtonSelected() then
                self:selectSound(true)
            else
                self:selectSound(false)
            end

        end)
        :align(display.CENTER, self.mark_sound:getPosition())
        :addTo(self.mark_sound:getParent())
        
    self.mark_sound:setVisible(false)


    local model = app:getUserModel()
    local cls = model.class
    local properties = model:getProperties({cls.pid, cls.musicSign, cls.soundSign})

    if properties[cls.soundSign] == 1 then
        audio.setSoundsVolume(1)
        self.soundCheckBox:setButtonSelected(true)
    else
        audio.setSoundsVolume(0)
        self.soundCheckBox:setButtonSelected(false)
    end

    if properties[cls.musicSign] == 1 then
        audio.setMusicVolume(0.4)
        self.musicCheckBox:setButtonSelected(true)
    else
        audio.setMusicVolume(0)
        self.musicCheckBox:setButtonSelected(false)
    end
end

function SettingView:onTouch_(event)

    if event.name == "ended" then

    	if self.mark_music:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) then
            self:selectMusic()
    	elseif self.mark_sound:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) then
    		self:selectSound()
    	end

    end

    return true
end

function SettingView:selectNotice()
	
	local model = app:getUserModel()
    local cls = model.class
    local properties = model:getProperties({cls.noticeSign})

    if properties[cls.noticeSign] == 1 then
    	self.mark_notification:setVisible(false)
    	properties[cls.noticeSign] = 0
    else
    	properties[cls.noticeSign] = 1
    	self.mark_notification:setVisible(true)
    end

    model:setProperties(properties)
    model:serializeModel()
end

function SettingView:selectMusic(val)

    local model = app:getUserModel()
    local cls = model.class
    local properties = model:getProperties({cls.musicSign})

    if val == false then
        properties[cls.musicSign] = 0
        audio.setMusicVolume(0)
    else
        properties[cls.musicSign] = 1
        audio.setMusicVolume(0.4)
    end

    model:setProperties(properties)

    model:serializeModel()
end

function SettingView:selectSound(val)

	local model = app:getUserModel()
    local cls = model.class
    local properties = model:getProperties({cls.soundSign})

    if val == false then
    	properties[cls.soundSign] = 0
        audio.setSoundsVolume(0)
    else
    	properties[cls.soundSign] = 1
        audio.setSoundsVolume(1)
    end

    model:setProperties(properties)

    model:serializeModel()
end

return SettingView
