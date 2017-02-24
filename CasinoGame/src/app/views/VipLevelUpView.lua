
local LUV = class("VipLevelUpView",function()
    return display.newNode()
end)

function LUV:ctor(args)
  --  self:addChild(cc.LayerColor:create(cc.c4b(0, 0, 0, 200)))
    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)

    local viewNode = CCBReaderLoad("view/VipLevelUpView.ccbi",self)
    self:addChild(viewNode)

    local model = app:getUserModel()
    self.vipLevel = model:getVipLevel()

    self:initUI()
    self:registerUIEvent()
end

function LUV:registerUIEvent()
    core.displayEX.newButton(self.btn_ok)
    self.btn_ok.clickedCall = function()
        scn.ScnMgr.removeView(self)
    end

    core.displayEX.newButton(self.btn_share)
    :onButtonClicked(function(event)
        core.FBPlatform.shareFacebookImpl(function()
            -- body
            scn.ScnMgr.removeView(self)
        end)
    end)
end

function LUV:initUI()
    local item = DICT_VIP[tostring(self.vipLevel)]
    if item ~= nil and cc.SpriteFrameCache:getInstance():getSpriteFrame(item.picture) then
        self.vip_name1:setSpriteFrame(item.picture)
        self.vip_name2:setSpriteFrame(item.picture)
    end
end


function LUV:onEnter()

end

function LUV:onExit()
    self:removeAllNodeEventListeners()
end

return LUV