
local PaytableView = class("PaytableView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

local PaytableView = PaytableView


function PaytableView:ctor(args)

    local ccbifile = args.ccbi
    --self:addChild(display.newColorLayer(cc.c4b(0, 0, 0, 128)))

    if self.title then  self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3) end
    
    self.viewNode  = CCBuilderReaderLoad(ccbifile, self)
    self:addChild(self.viewNode)

    self.pageNum = 0

    for i=1,10 do

        if self["page"..tostring(i)] == nil then
            break
        else
            self.pageNum = self.pageNum + 1
        end

    end

    if args.scroll and args.scroll == true then
        self:initScrollHelp()
    else
        self:initPageHelp()
    end
    
    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)
end

function PaytableView:initScrollHelp()
    -- body

    local bound = self.content_rect:getBoundingBox()

    self.helpLayer:removeFromParent(false)

    --,scrollbarImgV="#paytable_scroll_line.png"
    
    self.helpScrollView = cc.ui.UIScrollView.new({viewRect = bound})
        :addScrollNode(self.helpLayer)
        :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
        :onScroll(handler(self, self.scrollListener))
        :addTo(self.content_rect:getParent())


    if self.btn_close ~= nil then
        local btn_close = self.btn_close
        self.btn_close = core.displayEX.newButton(btn_close)
        :onButtonClicked(function()
            self:onRemove()
        end)
    end
end

function PaytableView:initPageHelp()
    if self.nextBtn ~= nil then
        local nextBtn = self.nextBtn
        self.nextBtn = core.displayEX.newButton(nextBtn)
        :onButtonClicked(function()
            self:onNextPage()
        end)
    end

    if self.prevBtn ~= nil then
        local prevBtn = self.prevBtn
        self.prevBtn = core.displayEX.newButton(prevBtn)
        :onButtonClicked(function()
            self:onPrePage()
        end)
    end

    if self.exitBtn ~= nil then
        local exitBtn = self.exitBtn
        self.exitBtn = core.displayEX.newButton(exitBtn)
        :onButtonClicked(function()
            self:onRemove()
        end)
    end
    if self.pageNum > 0 then
        self.tabidx = 1
        self:onShowPage(self.tabidx)
    end

    if self.pageNum == 1 then
        self.prevBtn:setVisible(false)
        self.nextBtn:setVisible(false)
        self.prevBtn:setButtonEnabled(false)
        self.nextBtn:setButtonEnabled(false)
    end
end

function PaytableView:scrollListener(event)
    --print("PaytableView - scrollListener:" .. event.name)
end


function PaytableView:onShowPage(idx)
    for i=1,self.pageNum do
        if idx == i then
            self["page"..tostring(i)]:setVisible(true)
        else
            self["page"..tostring(i)]:setVisible(false)
        end
    end
    self.prevBtn:setButtonEnabled(true)
    self.nextBtn:setButtonEnabled(true)
end

function PaytableView:onRemove()
    self:removeFromParent(true)
end

function PaytableView:onNextPage()
    self.tabidx = self.tabidx + 1
    if self.tabidx > self.pageNum then
        self.tabidx = 1
    end
    self:onShowPage(self.tabidx)
end

function PaytableView:onPrePage()
    self.tabidx = self.tabidx - 1
    if self.tabidx < 1 then
        self.tabidx = self.pageNum
    end
    self:onShowPage(self.tabidx)
end

function PaytableView:onEnter()
    --AnimationUtil.EnterScale(self.viewNode, 0.3)
end

function PaytableView:onExit()
    self:removeAllNodeEventListeners()
end

return PaytableView
