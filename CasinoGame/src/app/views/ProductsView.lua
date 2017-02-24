local ProductCoinsCell = require("app.views.ProductCoinsCell")
local ProductGemsCell = require("app.views.ProductGemsCell")

local ProductsView = class("ProductsView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

local PDV = ProductsView
local Purchase = core.Purchase

function PDV:ctor(args)
    --self:addChild(display.newColorLayer(cc.c4b(0, 0, 0, 128)))

    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.cashin, self)
    self:addChild(self.viewNode)
    self.cells = {}
    self.storeHandles = {}
    self.tabidx = args.tabidx
    self.pdidx = 3

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,  function(event) 
        return self:onTouch(event)  
    end)

    self:addNodeEventListener(cc.NODE_EVENT, function(event)
        
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        elseif event.name == "cleanup" then
            self:removeAllEventListeners()
        end
    end)


    self.productList = args.productList

    self.onShowProdId = args.onShowProdId

    if self.onShowProdId then
        self:initShowIndex()
    end
       
    local vipinfo = DICT_VIP[tostring(app:getUserModel():getVipLevel())]
    
    local strName = "Bronze"
    local vipBenifit = "10"
    if vipinfo ~= nil then
        strName = vipinfo.alias
        vipBenifit = vipinfo.extra_coins_percent
    end
    vipBenifit = vipBenifit.."%"

    self.vipName:setString(strName)
    self.vipGain:setString(vipBenifit)
    
    self:registerUIEvent()

    self:initStore()
end


function PDV:initShowIndex()
    
    local productType
    for i=1, #self.productList do
        if self.productList[i].prodId == self.onShowProdId then
            productType = self.productList[i].productType
            break
        end
    end

    if productType == 'C' then
        self.tabidx = 1
    elseif productType == 'G' then
        self.tabidx = 2
    end

    local pdidx = 0
    for i=1, #self.productList do
        if self.productList[i].productType == productType then
            pdidx = pdidx + 1
        end
        if self.productList[i].prodId == self.onShowProdId then
            self.pdidx = pdidx
            break
        end
    end

end

function PDV:initStore()
    --如果是ios
    if device.platform == "ios" then
        if not Purchase.store:canMakePurchases() then
            --device.showAlert("IAP Error", "canMakePurchases() == false", {"Please check project config"})
            return
        end
    end

    self.busy = false

    --如果是ios
    if device.platform == "ios" then
        self.storeHandles[Purchase.store.LOAD_PRODUCTS_FINISHED]     = Purchase.store:addEventListener(Purchase.store.LOAD_PRODUCTS_FINISHED,   handler(self, self.onLoadProductsFinished))
        self.storeHandles[Purchase.store.TRANSACTION_PURCHASED]      = Purchase:addEventListener(Purchase.store.TRANSACTION_PURCHASED,          handler(self, self.onTransactionPurchased))
        self.storeHandles[Purchase.store.TRANSACTION_CANCEL]         = Purchase:addEventListener(Purchase.store.TRANSACTION_CANCEL,             handler(self, self.onTransactionFailed))
        self.storeHandles[Purchase.store.TRANSACTION_FAILED]         = Purchase:addEventListener(Purchase.store.TRANSACTION_FAILED,             handler(self, self.onTransactionFailed))
        self.storeHandles[Purchase.store.TRANSACTION_TIMEOUT]        = Purchase:addEventListener(Purchase.store.TRANSACTION_TIMEOUT,            handler(self, self.onTransactionFailed))
        self.storeHandles[Purchase.store.TRANSACTION_UNKNOWN_ERROR]  = Purchase:addEventListener(Purchase.store.TRANSACTION_UNKNOWN_ERROR,      handler(self, self.onTransactionFailed))
    end
    
    --device.showActivityIndicator()
    self.gems_products = {}
    self.coins_products = {}
    --self.boosts_products = {}

    self.selectedProduct = nil
    self.hasselectedTab = nil
    self.tabBtns = {}
    self.coinsPanel.btn=self.coinsTabBtn
    self.gemsPanel.btn=self.gemsTabBtn
    self.coinsPanel.buybtn=self.coinsBuyBtn
    self.gemsPanel.buybtn=self.gemsBuyBtn
    self.coinsPanel.selShow=self.selCoinTab
    self.gemsPanel.selShow=self.selGemTab
    --self.boostsPanel.btn=self.boostsTabBtn
    --self.boostsPanel.buybtn=self.boostsBuyBtn

    self.tabBtns[#self.tabBtns + 1] = self.coinsPanel
    self.tabBtns[#self.tabBtns + 1] = self.gemsPanel
    --self.tabBtns[#self.tabBtns + 1] = self.boostsPanel

    self:initCoinsPanel()
    self:initGemsPanel()
    --self:initBoostsPanel()

    if self.tabidx == 1 then
        self.activeTab=self.coinsPanel
    elseif self.tabidx == 2 then
        self.activeTab=self.gemsPanel
    elseif self.tabidx == 3 then
        --self.activeTab=self.boostsPanel
    end

    self:tabBtn(self.activeTab)
    self:initSelectCell(self.pdidx)

end

function PDV:tabBtn(btnObj)
    
    for i=1,#self.tabBtns do
        local tabBtn = self.tabBtns[i]
        if tabBtn == btnObj then
            tabBtn:setVisible(true)
            tabBtn.buybtn:setVisible(true)
            tabBtn.buybtn:setButtonEnabled(true)
            tabBtn.selShow:setVisible(true)
            tabBtn.btn:setVisible(false)

        else
            if tabBtn.btn == nil then print(i) end
            tabBtn:setVisible(false)
            tabBtn.buybtn:setVisible(false)
            tabBtn.buybtn:setButtonEnabled(false)
            tabBtn.selShow:setVisible(false)
            tabBtn.btn:setVisible(true)
        end
    end
    
    if self.hasselectedTab ~= btnObj then
        self.hasselectedTab = btnObj
        self:initSelectCell(self.pdidx)
    end

end

function PDV:registerUIEvent()

    core.displayEX.newButton(self.exitBtn) 
        :onButtonClicked(function(event)
            -- body
            scn.ScnMgr.removeView(self)
        end)

    core.displayEX.newButton(self.gemsTabBtn) 
        :onButtonClicked(function(event)
            -- body
            self:onGemsTab()
            self:tabBtn(self.activeTab)
        end)

    core.displayEX.newButton(self.coinsTabBtn) 
        :onButtonClicked(function(event)
            -- body
            self:onCoinsTab()
            self:tabBtn(self.activeTab)

        end)

    core.displayEX.newButton(self.coinsBuyBtn) 
        :onButtonClicked(function(event)
            -- body
            if self.busy == true then return end
            self:onBuy()
        end)

    core.displayEX.newButton(self.gemsBuyBtn) 
        :onButtonClicked(function(event)
            -- body
            if self.busy == true then return end
            self:onBuy()
        end)

    EventMgr:addEventListener(EventMgr.UPDATE_PRODUCT_LIST,handler(self,self.updateProductList))
end

function PDV:onTouch(event)

    if event.name == "began" then
        self:onTouchCells(event, event.x, event.y)

    elseif event.name == "moved" then

    elseif event.name == "ended" then

    else -- cancelled

    end

    return true
end

function PDV:selectedCell(btnObj, selected)

    local cells = nil
    if self.activeTab == self.gemsPanel then
        cells = self.gems_products
    elseif self.activeTab == self.coinsPanel then
        cells = self.coins_products
    elseif self.activeTab == self.boostsPanel then
        --cells = self.boosts_products
    end

    for i=1,#cells do
        local cell = cells[i]
        if cell == btnObj then
            cell:onSelected(selected)
        else
            cell:onSelected(false)
        end
    end

end

function PDV:initBoostsPanel()
    
    local coinsSize = self.boostsCellsNode:getContentSize()
        
    local startX = 0;
    local startY = coinsSize.height;
    local index = 1

    for key, boost in pairs(DICT_PROPS) do
        if boost.item_id == tostring(ITEM_TYPE.BOOSTER_MULITIPLE2) then

            local cell = ProductBoostsCell.new(boost)
            self.boosts_products[#self.boosts_products + 1] = cell
            local size = cell:getContentSize()
        
            cell:setPosition(startX + size.width * (index-0.92)+index*5, startY - size.height * 1.4 )
            self.boostsCellsNode:addChild(cell)
            index = index + 1
        end
    end
    
    index=1

    for key, boost in pairs(DICT_PROPS) do
        if boost.item_id == tostring(ITEM_TYPE.BOOSTER_MULITIPLE5) then
        
            local cell = ProductBoostsCell.new(boost)
            self.boosts_products[#self.boosts_products + 1] = cell
            local size = cell:getContentSize()

            cell:setPosition(startX + size.width * (index-0.92)+index*5, startY - size.height * 3.2 )
            self.boostsCellsNode:addChild(cell)
            index = index + 1
        end
    end

end

function PDV:initCoinsPanel()
    local products = nil
    --ios和 android模式取不同的产品列表
    if device.platform == "android" then
        products=string.split(DICT_PRODUCT_AUTH[ANDROID_APP_ID].product_ids, ",")
    elseif device.platform == "ios" then
        products=string.split(DICT_PRODUCT_AUTH[IOS_APP_ID].product_ids, ",")
    end

    local coinsSize = self.coinsCellsNode:getContentSize()
        
    local startX = coinsSize.width/2;
    local startY = coinsSize.height;
    local index = 1
    
    -- print("coins count:", #products)
    -- for i=1,#products do
    -- local dicIAP=DICT_PRODUCT[tostring(products[#products - i + 1])]

    self.coinsCellsNode:removeAllChildren()
    for i=1,#self.productList do

        local dicIAP=self.productList[i]

        if dicIAP.productType == "C" then

            local cell = ProductCoinsCell.new(dicIAP)

            self.coins_products[#self.coins_products + 1] = cell
            local size = cell:getContentSize()

            cell:setPosition(startX - size.width / 2, startY - 1.05*size.height * (index) )
            self.coinsCellsNode:addChild(cell)
                        
            index = index + 1

        end
    end

end

function PDV:initGemsPanel()
    local products = nil
    --ios和 android模式取不同的产品列表
    if device.platform == "android" then
        products=string.split(DICT_PRODUCT_AUTH[ANDROID_APP_ID].product_ids, ",")
    elseif device.platform == "ios" then
        products=string.split(DICT_PRODUCT_AUTH[IOS_APP_ID].product_ids, ",")
    end

    local gemsSize = self.gemsCellsNode:getContentSize()
    local startX = gemsSize.width/2;
    local startY = gemsSize.height;
    
    local index = 1

    -- for i=1,#products do
    --     local dicIAP=DICT_IAP_PRODUCT[tostring(products[#products - i + 1])]
    for i=1,#self.productList do

        local dicIAP=self.productList[i]
        if dicIAP.productType == "G" then

            local cell = ProductGemsCell.new(dicIAP)
            self.gems_products[#self.gems_products + 1] = cell
            local size = cell:getContentSize()

            cell:setPosition(startX - size.width / 2, startY - 1.05*size.height * (index) )
            self.gemsCellsNode:addChild(cell)
            
            index = index + 1
        end
    end

end

function PDV:showPanel()
    --transition.moveTo(self.rootNode, {time = 0.5, x = self.endX, easing = "BACKOUT"})
end

function PDV:onTouchCells(event, x, y)
    local pos = cc.p(x, y)

    local cells = nil

    if self.activeTab == self.gemsPanel then
        cells = self.gems_products
    elseif self.activeTab == self.coinsPanel then
        cells = self.coins_products
    elseif self.activeTab == self.boostsPanel then
        --cells = self.boosts_products
    end

    if cells == nil then return end

    for i=1,#cells do
        local cell = cells[i]
        local boundingBox = cell:getCascadeBoundingBox();

        if boundingBox:containsPoint(pos) then
            print(i, event.name, event.x, event.y)
            self:selectedCell(cell, true)
            self.selectedProduct = cell
            return true
        end
    end

end

function PDV:initSelectCell(idx)

    local cells = nil
    if self.activeTab == self.gemsPanel then
        cells = self.gems_products
    elseif self.activeTab == self.coinsPanel then
        cells = self.coins_products
    elseif self.activeTab == self.boostsPanel then
        --cells = self.boosts_products
    end

    if cells == nil then return end

    for i=1,#cells do
        local cell = cells[i]

        if i == idx then
            self:selectedCell(cell, true)
            self.selectedProduct = cell
            return true
        end
    end

end

function PDV:onRemove()
    scn.ScnMgr.removeView(self)
end

function PDV:onGemsTab()
    self.activeTab = self.gemsPanel
end

function PDV:onCoinsTab()
    self.activeTab = self.coinsPanel
end

function PDV:onBoostsTab()
    --self.activeTab = self.boostsPanel
end

function PDV:onBuy()


    if self.selectedProduct ~= nil then

        self.busy = true
        core.Waiting.show()
        
        if self.activeTab == self.boostsPanel then
            local needgem = tonumber(self.selectedProduct.product.cost_gems)
            local gem = tonumber(app:getUserModel():getGems())
            
            if gem >= needgem then
                scn.ScnMgr.addView(
                    "CommonView",{title="Exchange Succeed", content="Good luck and have fun.",
                    delayPopCall=function()
                        
                        --User.setProperty(User.KEY_TOTALGEMS,gem-needgem)
                        
                        local key   = self.selectedProduct.product.item_id
                        local count = self.selectedProduct.product.count
                        print(key, count)
                        --User.Items.addItem(key, count, true)
                        --User.save()
                    end}
                )

            else
                scn.ScnMgr.addView(
                    "CommonView",{title="Not Enough Gems", content="Please Buy More Gems.",
                    delayPopCall=function()
                        self.activeTab = self.gemsPanel
                        self:tabBtn(self.gemsPanel)
                        self:initSelectCell(self.pdidx)
                    end}
                )

            end
        else

            print("-------pid:",self.selectedProduct.prodInfo.prodId)
            --如果是ios
            if device.platform == "ios" then
                Purchase.store:loadProducts(self.selectedProduct.prodInfo.iapProductId)
            elseif device.platform == "android" then
                local args = {}
                args.productId = self.selectedProduct.prodInfo.prodId
                args.adId = self.selectedProduct.prodInfo.adId
                args.view = self
                args.iapId = self.selectedProduct.prodInfo.finalIapId
                args.payPrice = self.selectedProduct.prodInfo.payPrice
                args.removeViewCall=nil
                args.iapProductId = self.selectedProduct.prodInfo.iapProductId
                Purchase:purchaseProductWithID(args)
            end
        end
    end

end

function PDV:onEnter()
end

function PDV:onExit()    
    --如果是ios
    if device.platform == "ios" then
        Purchase.store:removeEventListener(self.storeHandles[Purchase.store.LOAD_PRODUCTS_FINISHED])
        Purchase:removeEventListener(self.storeHandles[Purchase.store.TRANSACTION_PURCHASED])
        Purchase:removeEventListener(self.storeHandles[Purchase.store.TRANSACTION_CANCEL])
        Purchase:removeEventListener(self.storeHandles[Purchase.store.TRANSACTION_FAILED])
        Purchase:removeEventListener(self.storeHandles[Purchase.store.TRANSACTION_TIMEOUT])
        Purchase:removeEventListener(self.storeHandles[Purchase.store.TRANSACTION_UNKNOWN_ERROR])
    end
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_PRODUCT_LIST)
end

function PDV:onLoadProductsFinished(event)

    if event.productIdentifier ~= nil then

        print("onLoadProductsFinished")
        --device.showAlert("IAP OK", "Load products success \n Test Account: \n name:slots_wonder@test.com \n password:Slots260d", "OK")    
        
        self:onPurchase(event.productIdentifier)

    else
        --device.showAlert("IAP ERROR", "Load Products Error", "OK")
        --Waiting.hide()
        self:onRemove()
    end

end

function PDV:onPurchase(productId)
    if self.busy then return end

    Purchase.store:purchaseProduct(productId)
end

function PDV:onTransactionPurchased(event)
    
    local args = {}

    args.receipt = event.receipt
    args.productId = self.selectedProduct.prodInfo.prodId
    args.adId = self.selectedProduct.prodInfo.adId
    args.view = self
    args.iapId = self.selectedProduct.prodInfo.finalIapId
    args.payPrice = self.selectedProduct.prodInfo.payPrice

    --PurchaseReport:reportPurchase(args) --transaction, tonumber(promotionId), self)
    -- PurchaseReport:reportPurchase(transaction,0, self)
    --print("onTransactionPurchased4")

    net.PurchaseCS:IosPurchase(args,function()
        -- body
        self.busy = false
        core.Waiting.hide()
    end) 
end

function PDV:onTransactionFailed(event)
    self.busy = false
    core.Waiting.hide()

    print("failed :", event.name)
end


function PDV:updateProductList()
    if tonumber(self.selectedProduct.prodInfo.purchaseLimit) ~= 1 then
        return
    end
    net.PurchaseCS:GetProductList(function(lists)
        self.productList = lists
        self:initStore()
    end)
end

return ProductsView
