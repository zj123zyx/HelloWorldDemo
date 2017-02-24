
local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

function LoginScene:ctor()

    local  node  = CCBReaderLoad("Login.ccbi", self)
    self:addChild(node)

    self:registerUIEvent()

    --self:addChild(display.newColorLayer(cc.c4b(0, 128, 0, 255)))

    -- local font = display.newTTFLabel({
    --             text = "me ttf AAA BBB 你好",
    --             font = "Arial",
    --             color = cc.c3b(255, 127, 0),
    --             size = 64,
    --             align = cc.TEXT_ALIGNMENT_CENTER
    --         })

    -- font:enableOutline(cc.c4b(64, 100, 64, 255), 6);

    -- font:setPosition(display.cx, display.cy)
    -- self:addChild(font)


    -- local font1 = display.newTTFLabel({
    --             text = "me ttf AAA BBB 你好",
    --             font = "Marker Felt",
    --             color = cc.c3b(255, 127, 0),
    --             size = 64,
    --             align = cc.TEXT_ALIGNMENT_CENTER
    --         })

    -- font1:enableOutline(cc.c4b(200, 100, 64, 255), 6);

    -- font1:setPosition(display.cx, display.cy-100)
    -- self:addChild(font1)


    -- local font2 = display.newTTFLabel({
    --             text = "me ttf AAA BBB 你好",
    --             font = "Marker Felt",
    --             color = cc.c3b(255, 127, 0),
    --             size = 64,
    --             align = cc.TEXT_ALIGNMENT_CENTER
    --         })

    -- font2:enableShadow(cc.c4b(255, 50, 32, 255), cc.size(4,-4))

    -- font2:setPosition(display.cx, display.cy+100)
    -- self:addChild(font2)

    -- local lf = self.fbLogin:getTitleLabelForState(cc.CONTROL_STATE_NORMAL)
    
    -- lf:enableShadow(cc.c4b(53, 119, 0, 255), cc.size(2,-2))

    -- local lg = self.guestLogin:getTitleLabelForState(cc.CONTROL_STATE_NORMAL)
    
    -- lg:enableOutline(cc.c4b(53, 119, 0, 255), 2)

    self:Layout()


    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local customListenerBg = cc.EventListenerCustom:create(AppBase.APP_ENTER_BACKGROUND_EVENT,
                                handler(self, self.onEnterBackground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    local customListenerFg = cc.EventListenerCustom:create(AppBase.APP_ENTER_FOREGROUND_EVENT,
                                handler(self, self.onEnterForeground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)

end

function LoginScene:onEnterBackground()
    print("=====进入后台====")
end
function LoginScene:onEnterForeground()
    print("=====回到游戏====")
end

function LoginScene:registerUIEvent()

    core.displayEX.newButton(self.fbLogin) 
        :onButtonClicked( function(event)
            print("fbLogin")
            local test = app.test
            print("test=?")
            if test~=nil then
                print(test)
            else
                print("test=nil")
            end
            scn.ScnMgr.replaceScene("fish.FishScene")
            
            -- self:performWithDelay(function() self:hideBtn() end,1.0)

            -- core.FBPlatform.onLoginImpl(function()
            --     -- body
            --     core.Waiting.show()-- 登陆游戏时始终显示waiting 等待直到广告弹出
            --     self:performWithDelay(function() self:showBtn() end,3.0)

            --     self:logined()
            -- end)

        end)

    core.displayEX.newButton(self.guestLogin) 
        :onButtonClicked( function(event)
            -- if false then
            --     self:editBox()
            --     --local ReelAnalysis = require("app.data.slots.ReelAnalysis")
            --     --ReelAnalysis.analysis("7",20000)
            --     --local ReelGenerater = require("app.data.slots.ReelGenerater")
            --     --ReelGenerater.analysisForReels(5, "2", 10000)
            --     return
            -- end

            core.Waiting.show()-- 登陆游戏时始终显示waiting 等待直到广告弹出

            local function logined()
                self:logined()
            end
            
            net.UserAuthCS:quickLogin(logined)

        end)

end

function LoginScene:editBox()
    self:addChild(display.newColorLayer(cc.c4b(0, 128, 0, 255)))

    -- body
    local editBoxSize = cc.size(300, 60)
    local EditName = nil
    local EditPassword = nil
    local EditEmail = nil
    
    local function editBoxTextEventHandle(strEventName,pSender)
        local edit = pSender
        local strFmt 
        if strEventName == "began" then
            print(strEventName)
        elseif strEventName == "ended" then
            print(strEventName)
        elseif strEventName == "return" then
            if edit == EditName then
                print("Name EditBox return !")
            elseif edit == EditPassword then
                print("Password EditBox return !")
            elseif edit == EditEmail then
                print("Email EditBox return !")
            end
            print(strEventName)
        elseif strEventName == "changed" then
            strFmt = string.format("editBox TextChanged, text: %s ", edit:getText())
            print(strFmt)
        end
    end
    -- top
    EditName = cc.EditBox:create(editBoxSize, "dating_shuzhi_kuang.png")
    EditName:setPosition(cc.p(display.cx, display.cy))


    if device.platform == "ios" then
        EditName:setFontName("Paint Boy")
    elseif device.platform == "android" then
        EditName:setFontName("Paint Boy.ttf")
    end

    EditName:setFontSize(25)
    EditName:setFontColor(cc.c3b(255,0,0))
    EditName:setPlaceHolder("Name:")
    EditName:setPlaceholderFontColor(cc.c3b(255,255,255))
    EditName:setMaxLength(8)
    EditName:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    --Handler
    EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    self:addChild(EditName)
   
end

function LoginScene:logined()
    -- body
    if core.SocketNet:isConnected() then
        net.UserCS:EnterGame(function()
            -- body
            self:onLobbyScene()
        end)
    else
        EventMgr:addEventListener(EventMgr.SOCKET_CONNECT_EVENT, handler(self, self.connected))
        core.SocketNet:ConnectServer()
    end
    
end

function LoginScene:connected(event)
    core.Waiting.hide()

    net.UserCS:EnterGame(function()
        -- body
        EventMgr:removeEventListenersByEvent(EventMgr.SOCKET_CONNECT_EVENT)
        self:onLobbyScene()
    end)
end

function LoginScene:onLobbyScene()

    app:requestAfterEnterGame(function()
        -- body
        scn.ScnMgr.replaceScene("lobby.LobbyScene")

    end)

end

function LoginScene:hideBtn()
    self.fbLogin:setVisible(false)
    self.fbLogin:setButtonEnabled(false) 

    self.guestLogin:setVisible(false)
    self.guestLogin:setButtonEnabled(false) 
end

function LoginScene:showBtn()
    self.fbLogin:setVisible(true)
    self.fbLogin:setButtonEnabled(true) 

    self.guestLogin:setVisible(true)
    self.guestLogin:setButtonEnabled(true) 
end

function LoginScene:onEnter()
    print("LoginScene:onEnter")
    local model = app:getObject("UserModel")
    local cls = model.class
    local properties = model:getProperties({cls.facebook})

    local fb = properties[cls.facebook]

    if fb[cls.fb.fbid] ~= nil then
        
        self.connectTip:setVisible(false)

        self:hideBtn()
        self:performWithDelay(function() self:showBtn() end,3.0)


        core.FBPlatform.onLoginImpl(function()
            -- body
            core.Waiting.show()-- 登陆游戏时始终显示waiting 等待直到广告弹出
            self:logined()
        end)
        
    end
end

function LoginScene:onExit()
end

return LoginScene