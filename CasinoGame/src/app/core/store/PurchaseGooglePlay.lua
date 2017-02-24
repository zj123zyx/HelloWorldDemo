
local PurchaseGooglePlay = class("PurchaseGooglePlay")
local GooglePlayAppKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtssi4DXDWYuMLvMtG2uSfxGHccWqooqcxRT8f69XwN2JAAQgX2PmNrsoELKerjXG9B8BhxFzqqBO9Xv9dEWdxH8dfgPiA/EZv6LPbIsAoYc/tMCeE3//oiJjKTYqMtCclQh2bMqr2E6QBa1ven9Wx7OpsW2pIoMXT3q3MqeeKYYV6exxW5P8zrh/OKapVmNondd1sB3YSkN+sV1/kdtezMuEC4H7NQDr7VfdSAXEjKosRwEJ8CFAlO4vD2ZKh1lm4Seu9ywyqGPPetKQg4ms+THBmYFGJRivTTssGehnNql6IXINM/KfDMToEvfi267MhEVq+62AkAe3b8wo8x9zrwIDAQAB"

-----------------------------------------------------------
-- Construct
-----------------------------------------------------------
function PurchaseGooglePlay:ctor()
    
    self.iap = plugin.PluginManager:getInstance():loadPlugin("IAPGooglePlay")
    self:init()

end

-----------------------------------------------------------
-- 
-----------------------------------------------------------
function PurchaseGooglePlay:init()

    local pPlayStoreInfo = {}
    pPlayStoreInfo["GooglePlayAppKey"] = GooglePlayAppKey
    self.iap:configDeveloperInfo(pPlayStoreInfo)
    self.iap:setDebugMode(true)

end

-----------------------------------------------------------
-- 
-----------------------------------------------------------
function PurchaseGooglePlay:purchaseProductWithID(args)

    local function getOrderPayloadCallBack(payload)

        local onGooglePlayCallback = function(ret, msg)

            if ret == 0 then -- success

                local msgJson = json.decode(msg)
                args.receipt = msgJson.receipt
                args.signature = msgJson.signature
                args.playCallBackFun = function(vagrs) 
                    self:onOurPurchaseServerCallback(vagrs, args.removeViewCall) 
                end

                net.PurchaseCS:googlePlayPurchase(args)

            else
                scn.ScnMgr.addView("CommonView", {title="Google Play Error", content=msg})
                core.Waiting.hide()
                EventMgr:dispatchEvent({name = EventMgr.PURCHASE_PBFAILED_EVENT})
            end

        end

        print("net.PurchaseCS:getOrderPayload", payload,args.iapProductId)
        self.iap:payForProduct({
            productId = args.iapProductId,
            payload = payload
            }, onGooglePlayCallback)
    end
    
    net.PurchaseCS:getOrderPayload(getOrderPayloadCallBack)

end

-----------------------------------------------------------
-- 
-----------------------------------------------------------
function PurchaseGooglePlay:onOurPurchaseServerCallback(msg, onCallBack)

    if msg.result == 1000 then
        
        local model = app:getUserModel()

        local itemsBuy = msg.purchaseItems
        local num = #itemsBuy
        local vipCount = 0

        for i = 1, num do

            local itemBuy=itemsBuy[i]
            vipCount = itemBuy.vipCount

            if itemBuy.itemId == ITEM_TYPE.NORMAL_MULITIPLE then

                local coins = model:getCoins()
                if not vipCount then
                    vipCount = 0
                end
                model:setCoins(coins + itemBuy.count + vipCount)
                EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})

            elseif itemBuy.itemId == ITEM_TYPE.GEMS_MULITIPLE then

                local gems =  model:getGems()
                model:setGems(gems + itemBuy.count)
                EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})
                
            end
        end
        
        -- --向appsflyer汇报
        -- --local productId = args.productId
        -- local ifly=IntergrateAppsFlyer:instance()
        -- local iprice= payPrice--getProductAmount(productId)
        -- ifly:appsFlyerTrackEvent("purchase",iprice)

        local vp = model:getVipPoint()
        local vipup = model:setVipPoint(vp + msg.vipPoint)

        scn.ScnMgr.addView("CommonView", {title="Congratulations!", content="Purchase Successful!", delayPopCall=function()

                local delayVipCall = function()
                    if vipup == true then
                        scn.ScnMgr.addView("VipLevelUpView")
                        EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})
                    end
                    if argCallBack ~= nil then argCallBack() end
                end
                if vipCount ~= nil and vipCount > 0 then
                    scn.ScnMgr.addView("ExtraCoinView",{coins=vipCount, callback=delayVipCall})
                else
                    delayVipCall()
                end
        end} )

        model:serializeModel()

        core.Waiting.hide()

        if onCallBack then onCallBack() end

    elseif msg.result == 1002 then 
    elseif msg.result == 1003 then
    elseif msg.result == 1004 then
    end
end

return PurchaseGooglePlay
