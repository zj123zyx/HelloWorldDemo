
local LoadingView = class("LoadingView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function LoadingView:ctor(args)

    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.loadingview, self)

    self:addChild(self.viewNode)

    self.downloads = args.downloads
    self.callback = args.callback

    self.downloadName = "dating_"..args.downloadName..".png"

    if cc.SpriteFrameCache:getInstance():getSpriteFrame(self.downloadName) then
        self.slots_icon:setSpriteFrame(display.newSpriteFrame(self.downloadName))
    end

    local x,y = self.progressSprite:getPosition()
    local parent = self.progressSprite:getParent()
    self.progressSprite:removeFromParent(false)
    self.loadingProgress = cc.ProgressTimer:create(self.progressSprite)
    self.loadingProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.loadingProgress:setMidpoint(cc.p(0, 1))
    self.loadingProgress:setBarChangeRate(cc.p(1, 0))
    self.loadingProgress:setPosition(cc.p(x, y))

    parent:addChild(self.loadingProgress)

    self:startUpdate()

end

function LoadingView:startUpdate()

    local versionurl = cc.UserDefault:getInstance():getStringForKey("version_url")

    self.baseurl = cc.UserDefault:getInstance():getStringForKey("base_url")

    self.assetsManager = cc.AssetsManager:new("","",device.writablePath)
    self.assetsManager:setConnectionTimeout(3)
    self.assetsManager:setVersionFileUrl(versionurl);

    local model = app:getUserModel()
    local cls = model.class


    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            self.progressLabel:setString("no new version")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            self.progressLabel:setString("network error")

        end
        scn.ScnMgr.popView("CommonView",{
                    title="Error down!!", 
                    content="error when download package!!!"
                })
        self:exit()
    end

    local function onProgress( percent )
        local progress = string.format("downloading... %d%%",percent)
        --if percent > 0 then
            self.progressLabel:setString(progress)
            self.loadingProgress:setPercentage(percent)
            self.progressNode:setVisible(true)
        --end
    end

    local function onSuccess()

        local down = self.downloads[self.downloadIndex]
            
        local machineinfo = cc.UserDefault:getInstance():getStringForKey(self.zipname)
        local md5str = string.split(machineinfo, ",")

        model:setUnitDownLoad(self.zipname, cls.userdown.md5val,  md5str[2])
        model:setUnitDownLoad(self.zipname, cls.userdown.hasdown, 1)
        model:serializeModel()

        if #self.downloads > self.downloadIndex then

            self.downloadIndex = self.downloadIndex + 1
            self.assetsManager:deleteVersion();
            cc.UserDefault:getInstance():flush();
            
            local down = self.downloads[self.downloadIndex]
            self.zipname = down.zipname
            local downurl = self.baseurl..self.zipname.."/"..down.name;
            print(downurl)

            self.assetsManager:setPackageUrl(downurl);
            self.assetsManager:update()
        else

            self.progressLabel:setString("downloading ok")

            EventMgr:dispatchEvent({  name  = EventMgr.UPDATE_LOBBYUI_EVENT })

            self:exit()
        end
    end

    self.assetsManager:retain()
    self.assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
    self.assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
    self.assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )

    self.downloadIndex = 1

    local down = self.downloads[self.downloadIndex]
    self.zipname = down.zipname
    local downurl = self.baseurl..self.zipname.."/"..down.name;
    
    print(downurl)

    self.assetsManager:deleteVersion();

    self.assetsManager:setPackageUrl(downurl);

    self.assetsManager:update()
end

function LoadingView:exit()
    if self.callback ~= nil then
        self.callback()
    end
    scn.ScnMgr.removeView(self)
end

return LoadingView
