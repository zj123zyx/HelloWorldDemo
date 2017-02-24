local DragonGameInfoView = class("DragonGameInfoView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function DragonGameInfoView:ctor()
    self.viewNode  = CCBuilderReaderLoad("lobby/challengegame/challenge_info.ccbi", self)
    self:addChild(self.viewNode)
       
    if self.title then  self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3) end

    self:registerUIEvent()
end

function DragonGameInfoView:registerUIEvent()
    core.displayEX.extendButton(self.exitBtn)
    self.exitBtn.clickedCall = function()
        scn.ScnMgr.removeView(self)
    end
end


return DragonGameInfoView
