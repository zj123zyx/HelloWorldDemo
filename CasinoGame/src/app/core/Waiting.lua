local Waiting = {}

Waiting.hasshow = false
Waiting.count = 0
Waiting.indicator = nil

function Waiting.show()

    Waiting.count = Waiting.count + 1
    
    print("Waiting.count show", Waiting.count)

    if Waiting.hasshow == true then return end
    if Waiting.count > 0 then Waiting.hasshow = true end

    if device.platform == "ios" then
        device.showActivityIndicator()
    elseif device.platform == "android" then
        AppLuaApi:showIndicator()
    end

    Waiting.indicator = scn.ScnMgr.addView("CoverView")
    
    if Waiting.indicator then
        Waiting.indicator:setLocalZOrder(80000)
    end
end

function Waiting.hide()

    Waiting.count = Waiting.count - 1
    
    print("Waiting.count hide", Waiting.count)

    if Waiting.count < 0 then Waiting.count = 0 end
    if Waiting.hasshow == false then return end
    if Waiting.count > 0 then return end

    Waiting.hasshow = false

    if device.platform == "ios" then
        device.hideActivityIndicator()
    elseif device.platform == "android" then
        AppLuaApi:hideIndicator()
    end

    if Waiting.indicator then
        scn.ScnMgr.removeView(Waiting.indicator)
        Waiting.indicator = nil
    end
end

function Waiting.forceHide()

    Waiting.count = 0
    Waiting.hasshow = false 

    if device.platform == "ios" then
        device.hideActivityIndicator()
    elseif device.platform == "android" then
        AppLuaApi:hideIndicator()
    end

    if Waiting.indicator then
        scn.ScnMgr.removeView(Waiting.indicator)
        Waiting.indicator = nil
    end
end

return Waiting
