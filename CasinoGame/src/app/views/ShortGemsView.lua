local SCV = class("ShortGemsView", function()
    return display.newNode()
end)

function SCV:ctor(args)
    self.viewNode  = CCBReaderLoad("view/shortofgems.ccbi",self)

    --self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

    self:addChild(self.viewNode)
    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)

    if args.callback then
        self.callback = args.callback
    end
end

function SCV:onBuy()
    net.PurchaseCS:GetProductList(function(lists)
        scn.ScnMgr.removeView(self)
        scn.ScnMgr.addView("ProductsView",{productList=lists,tabidx=2})
    end)
end

function SCV:onLater()
    if self.callback then
        self.callback()
    end
    scn.ScnMgr.removeView(self)
end


function SCV:onEnter()
    core.displayEX.extendButton(self.btn_buy)
    self.btn_buy.clickedCall = function()
        self:onBuy()
    end

    core.displayEX.extendButton(self.btn_later)
    self.btn_later.clickedCall = function()
        self:onLater()
    end
end

function SCV:onExit()
    self:removeAllNodeEventListeners()
end

return SCV
