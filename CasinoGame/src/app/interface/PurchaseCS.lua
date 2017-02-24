
require "app.interface.pb.Purchase_pb"
require "app.interface.pb.CasinoMessageType"

local PurchaseCS = {}

function PurchaseCS:GetProductList(callfunction)


    local function callBack(rdata)

        local msg = Purchase_pb.GCGetProductList()
        msg:ParseFromString(rdata)

        callfunction(msg.productList)


    end

    local pid = app:getUserModel():getPid()

    local req= Purchase_pb.CGGetProductList()

    req.pid = pid

    if device.platform == "android" then
        req.appId = ANDROID_APP_ID
    elseif device.platform == "ios" then
        req.appId = IOS_APP_ID
    end

    core.SocketNet:sendCommonProtoMessage(CG_GET_PRODUCT_LIST,GC_GET_PRODUCT_LIST,pid,req,callBack,true)
end

function PurchaseCS:IosPurchase(args,onCallBack)

    local model = app:getUserModel()
    local pid = model:getPid()

    local adId  = args.adId
    local view  = args.view
    local iapId = args.iapId
    local receipt = args.receipt
    local productId = args.productId
    local argCallBack = args.callBack
    local payPrice  = args.payPrice

    local function callBack(rdata)

        local msg = Purchase_pb.GCIosPurchase()
        msg:ParseFromString(rdata)

        if msg.result == 1000 then --IOS充值校验成功

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
            
            --向appsflyer汇报
            --local ifly=IntergrateAppsFlyer:instance()
            --local iprice= payPrice
            --ifly:appsFlyerTrackEvent("purchase",iprice)

            
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

            if onCallBack then onCallBack() end

        elseif msg.result == 1002 then  -- IOS校验失败
        elseif msg.result == 1003 then
        elseif msg.result == 1004 then

        end


    end

    local req= Purchase_pb.CGIosPurchase()

    req.pid = pid
    req.appId = IOS_APP_ID
    req.receipt = receipt
    req.prodId = productId
    req.iapId = iapId
    req.adId = adId
    req.deviceType   = device.model
    req.clientType   = 1

    core.SocketNet:sendCommonProtoMessage(CG_IOS_PURCHASE,GC_IOS_PURCHASE,pid,req,callBack, true)
end

function PurchaseCS:getOrderPayload(playCallBackFun)

    local function callBack(rdata)

        local msg = Purchase_pb.GCGetOrderPayload()
        msg:ParseFromString(rdata)

        print("server back", tostring(msg))
        
        playCallBackFun(msg.payload)
    end

    local model = app:getUserModel()
    local pid = model:getPid()

    local req = Purchase_pb.CGGetOrderPayload()
    req.pid = pid
    core.SocketNet:sendCommonProtoMessage(CG_GET_ORDER_PAYLOAD, GC_GET_ORDER_PAYLOAD, pid, req, callBack, true)

end

function PurchaseCS:googlePlayPurchase(args)

    local model = app:getUserModel()
    local pid = model:getPid()

    local receipt= args.receipt
    local signature= args.signature
    local adId = args.adId
    local prodId = args.productId
    local iapId = args.iapId
    local playCallBackFun=args.playCallBackFun

    local function callBack(rdata)
        
        local msg = Purchase_pb.GCGooglePlayPurchase()
        msg:ParseFromString(rdata)

        print("google Play Purchase server back")
        
        playCallBackFun(msg)
    end

    print("pid:",pid)
    print("appId:",ANDROID_APP_ID)
    print("receipt:",receipt)
    print("signature:",signature)
    print("adId:", adId)

    local req = Purchase_pb.CGGooglePlayPurchase()
    req.pid = pid
    req.appId=ANDROID_APP_ID
    req.receipt= receipt
    req.signature= signature
    req.adId = adId
    req.prodId = prodId
    req.iapId = iapId
    req.deviceType   = device.model
    req.clientType   = 2
    req.gameVersion  = AppLuaApi:getInstance():AppVersion()

    core.SocketNet:sendCommonProtoMessage(CG_GOOGLE_PLAY_PURCHASE, GC_GOOGLE_PLAY_PURCHASE,  pid, req, callBack, true)

end

return PurchaseCS
