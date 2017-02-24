local ADBarViewCell = class("ADBarViewCell", function()
    return display.newNode() --ViewExtend.extend(CCLayer:create())
end)

local Purchase = core.Purchase
local Store = Purchase.store
local Waiting = core.Waiting

------------------------------------------------
--
-- adInfo: 
-- adInfo.adId
-- adInfo.iapId
-- adInfo.prodId
-- adInfo.templateId
-- adInfo.startTm
-- adInfo.endTm
-- adInfo.timeLeft
--
------------------------------------------------
function ADBarViewCell:ctor(adInfo)

    -- ViewExtend.extend(self)

    self.schEntryArray = {}
    self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

    self.adInfo = {}

    self.adInfo.adId            = adInfo.adId
    self.adInfo.endTm           = adInfo.endTm
    self.adInfo.startTm         = adInfo.startTm
    self.adInfo.prodId          = adInfo.prodId
    self.adInfo.iapId           = adInfo.iapId
    self.adInfo.price           = adInfo.price
    self.adInfo.newPrice        = adInfo.newPrice
    self.adInfo.timeLeft        = adInfo.timeLeft
    self.adInfo.totalGamePoint  = adInfo.totalGamePoint
    self.adInfo.purchaseLimit   = adInfo.purchaseLimit
    self.adInfo.iapProductId    = adInfo.iapProductId
    self.adInfo.template        = adInfo.template
    self.adInfo.payPrice        = adInfo.price
    self.adInfo.discount        = adInfo.discount

    local fileFam = '.ccbi'
    local prePath = 'lobby/cell/'
    local ccbName = self.adInfo.template.ccbName

    local fullPath = cc.FileUtils:getInstance():fullPathForFilename(prePath..ccbName..fileFam)
    local ccbExist = cc.FileUtils:getInstance():isFileExist(fullPath)

    print("fullPath:", fullPath)
    print("ccbExist:", ccbExist)

    if not ccbExist then
        ccbName = self.adInfo.template.defaultCcb
    end

    print("ADBarViewCell--prePath..ccbName:", prePath..ccbName..fileFam)

    self.viewNode = CCBuilderReaderLoad(prePath..ccbName..fileFam, self)
    local size = self.viewNode:getContentSize()
    self.viewNode:setPositionX(size.width/2)
    self.viewNode:setPositionY(size.height/2)

    self:addChild(self.viewNode)
    self:setContentSize(size)

    self:setNodeEventEnabled(true)

    self:init()

end

function ADBarViewCell:chectButtonTouch(pos)
    
end

---------------------------------
-- init 
---------------------------------
function ADBarViewCell:init()
    if self.adInfo.template.uiType == "ad" then
        -- init coin
        self:initCoin()
        -- init discount
        self:initDiscount()
        -- initLeftTimer
        self:initLeftTime()

        -- init showBuyBtn
        self:initBuyBtn()
    elseif self.adInfo.template.uiType == "game" then
        local unit = DICT_UNIT[tostring(self.adInfo.template.targetId)]
        if unit then
            if type(unit.config) == "table" and unit.config.min_bet then
                if self.bet then
                    self.bet:setString(unit.config.min_bet)
                end
            end
        end
    end
end

---------------------------------
-- initDiscount 
---------------------------------
function ADBarViewCell:initDiscount()
    if not self.adInfo.discount or not self.percentage then
        return
    end
    self.percentage:setString(self.adInfo.discount)
end

---------------------------------
-- initCoin 
---------------------------------
function ADBarViewCell:initCoin()
    if self.adInfo.iapId == -1 or self.adInfo.productId == -1 then
        return
    end

    self.adInfo.payPrice = self.adInfo.newPrice

    self.priceOriginalLabel:setString('$'..self.adInfo.price)
    self.priceDiscountLabel:setString('$'..self.adInfo.newPrice)
    self.coinsNumberLabel:setString(self.adInfo.totalGamePoint)

end


---------------------------------
-- initLeftTimer 
---------------------------------
function ADBarViewCell:initLeftTime()
    if self.adInfo.template.showLeftTime == true then
        self.leftTimeLabel:setVisible(true)
        self.leftTimeLabel:setString(' ')
        --self.leftTimeLabel:enableOutline(cc.c4b(0, 0, 0, 200), 2)

        local validTime = self.adInfo.timeLeft

        local secTimer = 0
        local function tick( dt )
            secTimer = secTimer + dt

            if secTimer >= 1 and validTime >= 1 then

                secTimer = 0
                validTime = validTime - 1
                -- print("validTime:", validTime)
                self.leftTimeLabel:setString(AdMgr.formatValidTimeToStr(validTime))

            elseif validTime <= 0 then

                self.isOnTimer = false
                self.scheduler.unscheduleGlobal(self.schEntryArray['LeftTime'])
                self.schEntryArray['LeftTime'] = nil
                self:removeFromParent()
            end
        end
        if validTime > 0 then
            self.schEntryArray['LeftTime'] = self.scheduler.scheduleGlobal(tick , 0)
        end
    else
        --if self.leftTimeLayer then  self.leftTimeLayer:setVisible(false) end
    end
end

---------------------------------
-- initBuyBtn
---------------------------------
function ADBarViewCell:initBuyBtn()
    self:initStoreEvn()
    local onbuy = function()
        -- print("self.adInfo.iapProductId:", self.adInfo, self.adInfo.iapProductId)
        if self.busy == true then return end

        self.busy = false
        core.Waiting.hide()

        if device.platform == "ios" then
            self.storeHandles = {}
            self.storeHandles[Store.LOAD_PRODUCTS_FINISHED]     = Purchase.store:addEventListener(Store.LOAD_PRODUCTS_FINISHED,     self.onLoadProductsFinished,    self)
            self.storeHandles[Store.TRANSACTION_PURCHASED]      = Purchase:addEventListener(Store.TRANSACTION_PURCHASED,            self.onTransactionPurchased,    self)
            self.storeHandles[Store.TRANSACTION_CANCEL]         = Purchase:addEventListener(Store.TRANSACTION_CANCEL,               self.onTransactionFailed,       self)
            self.storeHandles[Store.TRANSACTION_FAILED]         = Purchase:addEventListener(Store.TRANSACTION_FAILED,               self.onTransactionFailed,       self)
            self.storeHandles[Store.TRANSACTION_TIMEOUT]        = Purchase:addEventListener(Store.TRANSACTION_TIMEOUT,              self.onTransactionFailed,       self)
            self.storeHandles[Store.TRANSACTION_UNKNOWN_ERROR]  = Purchase:addEventListener(Store.TRANSACTION_UNKNOWN_ERROR,        self.onTransactionFailed,       self)
        end
        if device.platform == "ios" then
            local store_products = {}
            store_products[#store_products + 1]=self.adInfo.iapProductId
            Purchase.store:loadProducts(store_products)
        elseif device.platform == "android" then
            local args = {}
            args.productId = self.adInfo.prodId
            args.adId = self.adInfo.adId
            args.view = self
            args.iapId = self.adInfo.iapId
            args.payPrice = self.adInfo.payPrice
            args.removeViewCall=function()
                User.setProperty(User.KEY_NPSPURCHASED,true, true)
                AdMgr.closeAdListView()
            end
            args.iapProductId = self.adInfo.iapProductId
            Purchase:purchaseProductWithID(args)
        end
    end

end

---------------------------------
-- initStoreEvn
---------------------------------
function ADBarViewCell:initStoreEvn()
    if device.platform == "ios" then
        if not Purchase.store:canMakePurchases() then
            device.showAlert("IAP Error", "appStore cennect faild", {"Please try agin!"})
            return
        end
    end
    self.busy = false
end

---------------------------------
-- onLoadProductsFinished
---------------------------------
function ADBarViewCell:onLoadProductsFinished(event)


    if event.productIdentifier ~= nil then

        self:onPurchase(event.productIdentifier)

    else
        device.showAlert("IAP ERROR", "Load Products Error", "OK")
        Waiting.hide()
        -- self:removeView()
    end

end

---------------------------------
-- onPurchaseClicked
---------------------------------
function ADBarViewCell:onPurchase(productId)
    Purchase.store:purchaseProduct(productId)
end

---------------------------------
-- onTransactionPurchased
---------------------------------
function ADBarViewCell:onTransactionPurchased(event)
    if self.adInfo == nil then return end

    local args = {}

    args.receipt = event.receipt
    args.productId = self.adInfo.prodId
    args.adId = self.adInfo.adId
    args.view = self
    args.iapId = self.adInfo.iapId
    args.payPrice = self.adInfo.payPrice


    args.callBack = function()  AdMgr.closeAdListView() end


    --PurchaseReport:reportPurchase(args)

    -- if self.adInfo.showRule.showPurchaseLimit == true then

    --     self.adInfo.purchaseLimit = self.adInfo.purchaseLimit - 1
    --     self.purchaseLimitLabel:setVisible(true)
    --     self.purchaseLimitLabel:setString(self.adInfo.purchaseLimit)

    -- end

    net.PurchaseCS:IosPurchase(args,function( )
        -- body
        self.busy = false
        core.Waiting.hide()
    end)
    self:removeStoreEvn()

end

---------------------------------
-- onTransactionFailed
---------------------------------
function ADBarViewCell:onTransactionFailed(event)

    self:removeStoreEvn()

    self.busy = false
    core.Waiting.hide()

end

---------------------------------
-- removeStoreEvn
---------------------------------
function ADBarViewCell:removeStoreEvn()
    if device.platform == "ios" and self.storeHandles then
        Purchase.store:removeEventListener(self.storeHandles[Store.LOAD_PRODUCTS_FINISHED])
        Purchase:removeEventListener(self.storeHandles[Store.TRANSACTION_PURCHASED])
        Purchase:removeEventListener(self.storeHandles[Store.TRANSACTION_CANCEL])
        Purchase:removeEventListener(self.storeHandles[Store.TRANSACTION_FAILED])
        Purchase:removeEventListener(self.storeHandles[Store.TRANSACTION_TIMEOUT])
        Purchase:removeEventListener(self.storeHandles[Store.TRANSACTION_UNKNOWN_ERROR])
    end
end

---------------------------------
-- onEnter
---------------------------------
function ADBarViewCell:onEnter()
end

---------------------------------
-- onExit
---------------------------------
function ADBarViewCell:onExit()

    for k,v in pairs(self.schEntryArray) do
        if v ~= nil then
            self.scheduler.unscheduleGlobal(v)
        end
    end

    self:removeStoreEvn()
    self:removeAllNodeEventListeners()
    print("---====ADBarViewCell:onExit()--------------")
end

return ADBarViewCell