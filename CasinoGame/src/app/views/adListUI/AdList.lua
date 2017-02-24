
local AdListCell = import(".AdListCell")
local PageControl = import("app.views.adListUI.AdPageControl")


local AdList = class("AdList", PageControl)

AdList.INDICATOR_MARGIN = 46 + 10

function AdList:ctor(rect, adList)

    self:initBgccb()
    AdList.super.ctor(self, rect, PageControl.DIRECTION_HORIZONTAL)

    
    local numPages = 0
    -- print("#adList:", #adList)

    local adInfo
    for i=1, #adList do
        adInfo = adList[i]
        if adInfo.templateId ~= -1 then

            local cell = AdListCell.new(cc.size(display.width, display.height), adInfo)
            cell:addEventListener("onTapLevelIcon", function(event) return self:onTapLevelIcon(event) end)
            self:addCell(cell)
            numPages = numPages + 1

            -- print("cell function:", cell.checkButton)

        end

    end

--
    -- add indicators
    local x = (self:getClippingRect().width - AdList.INDICATOR_MARGIN * (numPages - 1)) / 2
    local y = self:getClippingRect().y + display.height/10 --0 --100

    self.indicator_ = display.newSprite("#btn_pageindacator_sel.png")
    self.indicator_:setPosition(x, y)
    self.indicator_.firstX_ = x

    for pageIndex = 1, numPages do
        local icon = display.newSprite("#btn_pageindacator_bg.png")
        icon:setPosition(x, y)
        self:addChild(icon)
        x = x + AdList.INDICATOR_MARGIN
    end

    self:addChild(self.indicator_)
--]]

end

function AdList:initBgccb()

    local ccb = 'lobby/ad/adListView.ccbi'
    local node = display.newNode()
    local bg = CCBuilderReaderLoad(ccb, self)

    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)
    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- print("bg touch")
        return true
    end)

    core.displayEX.newButton(self.closeAllBtn)
        :onButtonClicked(function() 
            self:removeSelf(true)
        end)

    self.bg = node
    node:addChild(bg)
    self:addChild(node)
    
end

function AdList:scrollToCell(index, animated, time)

    AdList.super.scrollToCell(self, index, animated, time)

    transition.stopTarget(self.indicator_)
    local x = self.indicator_.firstX_ + (self:getCurrentIndex() - 1) * AdList.INDICATOR_MARGIN
    if animated then
        time = time or self.defaultAnimateTime
        transition.moveTo(self.indicator_, {x = x, time = time / 2})
    else
        self.indicator_:setPositionX(x)
    end

end

function AdList:onExit()

    AdList.super.onExit(self)
    self.bg:removeAllNodeEventListeners()
    -- self.bgccb:unregisterScriptTouchHandler()

    -- print("adList:onExit")

end

function AdList:onTapLevelIcon(event)
    self:dispatchEvent(event)
end


return AdList
