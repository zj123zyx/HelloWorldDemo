
-----------------------------------------------------------
-- BonusDialogView 
-----------------------------------------------------------
local BonusDialogView = class("BonusDialogView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

-----------------------------------------------------------
-- Construct 
-- args.onComplete
-----------------------------------------------------------
function BonusDialogView:ctor(args) 

    local bonus_ccbi = DICT_MAC_RES[tostring(args.model:getMachineId())].bonus_ccbi

    self.onComplete = args.onComplete
    self.ccbNode = CCBuilderReaderLoad(bonus_ccbi.bonus_start, self)
    self:addChild(self.ccbNode)
    self:setNodeEventEnabled(true)

    self:init()

end

-----------------------------------------------------------
-- init 
-----------------------------------------------------------
function BonusDialogView:init()

    local okBtn = self.okBtn
    self.okBtn = core.displayEX.newButton(okBtn)
        :onButtonClicked(function() 
            self.onComplete()
            scn.ScnMgr.removeView(self)
        end)

end

-----------------------------------------------------------
-- onExit 
-----------------------------------------------------------
function BonusDialogView:onExit()
    self:removeAllNodeEventListeners()
end

return BonusDialogView
