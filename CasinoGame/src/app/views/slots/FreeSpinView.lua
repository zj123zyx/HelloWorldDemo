
-----------------------------------------------------------
-- FreeSpinView 
-----------------------------------------------------------
local FreeSpinView = class("FreeSpinView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

-----------------------------------------------------------
-- Construct 
-- args.machineId
-----------------------------------------------------------
function FreeSpinView:ctor(model) 
    
    local freespin_ccbi = DICT_MAC_RES[tostring(model:getMachineId())].freespin_ccbi

    self.ccbNode = CCBuilderReaderLoad(freespin_ccbi.freespin_start, self)
    self:addChild(self.ccbNode)
    self:setNodeEventEnabled(true)

	self:setCount(model:getFrSpinCount())

    self:init()

end

-----------------------------------------------------------
-- init 
-----------------------------------------------------------
function FreeSpinView:init()

    self:performWithDelay(function()
		scn.ScnMgr.removeView(self)
    end,3.2)

end


-----------------------------------------------------------
-- init
-----------------------------------------------------------
function FreeSpinView:setCount(cnt)
    if self.freespinNum then self.freespinNum:setString(tostring(cnt)) end
end


-----------------------------------------------------------
-- onExit 
-----------------------------------------------------------
function FreeSpinView:onExit()
    self:removeAllNodeEventListeners()
end

return FreeSpinView
