local LP = class("LoadingPage", function()
    return display.newScene("LoadingPage")
end)

function LP:ctor(name,value)
    local  node  = CCBuilderReaderLoad(RES_CCBI.loadingPage,self)
   self:addChild(node)

    local delaycall = function()
        scn.ScnMgr.showPools[#scn.ScnMgr.showPools + 1] = {name=name, type="scene", value= value}
    end
    self:performWithDelay(delaycall, 0.6)

    self:setNodeEventEnabled(true)

    --self:Layout()

 --[[   local s = cc.Director:getInstance():getWinSize()
    local layer = display.newColorLayer(cc.c4b(0, 200,0, 100))
    layer:setContentSize(s)
    self:addChild(layer)]]

end

function LP:onEnter()
end

function LP:onExit()
    self = {}
end

return LP

