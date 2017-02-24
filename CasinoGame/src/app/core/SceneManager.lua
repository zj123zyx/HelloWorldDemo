touchLayer = require("app.scenes.TouchLayer")

local sm = class("SceneManager")

sm.showPools = {}
sm.showingView = nil
sm.viewNode = nil
sm.greyLayer = nil

--------------------------------------
-- replaceScene
--------------------------------------
function sm.replaceScene(sceneName, args, showloading)
    --sm.showPools[#sm.showPools + 1] = {name=sceneName, type="scene", value= args }

    if showloading ~= nil and showloading == true then
        sm.showPools[#sm.showPools + 1] = {name="lobby.LoadingPage", type="scene",value= {sceneName,args}}
    else
        sm.showPools[#sm.showPools + 1] = {name=sceneName, type="scene", value= args }
    end
end

--------------------------------------
-- addView
--------------------------------------

function sm.addTopView( className, oldview, ... )
    
    local view = nil

    if sm.viewNode ~= nil then

        view = app:createSView(className, ... )
        view.pop = false
        view.top = true
        sm.viewNode:addChild( view )

        if oldview then view.showingAddView = oldview end

        if view.showingAddView then

            local posX, posY = view:getPosition()
            view:setPositionX(posX + display.width)

            transition.moveBy(view, {x = -display.width, time = 0.35})
            transition.moveBy(view.showingAddView, {x = -display.width, time = 0.35})
        end

    end
    return view
end
--------------------------------------
-- addView
--------------------------------------
function sm.removeTopView( topview )

    if topview.showingAddView then

        local showingAddView = topview.showingAddView

        transition.moveBy(topview, {x = display.width, time = 0.35, onComplete = function()
                topview:removeSelf()
            end})
        transition.moveBy(showingAddView, {x = display.width, time = 0.35})
    else
        topview:removeSelf()
    end

end

--------------------------------------
-- addView
--------------------------------------
function sm.addView( className, ... )
    local view = nil
    if sm.viewNode ~= nil then
        view = app:createSView(className, ... )
        view.pop = false
        sm.viewNode:addChild( view )
    end
    return view
end

--------------------------------------
-- addView
--------------------------------------
function sm.removeView( view )
    
    if view.top and view.top == true then
        sm.removeTopView( view )
        return
    end

    if view.pop == nil then
        sm.shownext(view.nextshow)
    end
    view:removeSelf()
end

--------------------------------------
-- PopView
--------------------------------------
function sm.popView( className, args )
    
    if sm.showingView ~= nil then
        local nextview = sm.showingView.nextshow
        local newshow = {name=className, type="view", value= args }
        newshow.nextshow = nextview

        local tempview = newshow
        local tempshows = {}
        
        while tempview ~= nil do
            tempshows[#tempshows + 1] = tempview
            tempview = tempview.nextshow
        end

        local sortFunc = function(a, b)
            return tonumber(sm.getPriority(a)) > tonumber(sm.getPriority(b))
        end

        table.sort(tempshows, sortFunc)
        
        for i=2,#tempshows do
            local show = tempshows[i-1]
            local nextshow = tempshows[i]
            nextshow.nextshow = nil
            show.nextshow = nextshow
        end
        
        local showingnext = tempshows[1]

        sm.showingView.obj.nextshow = showingnext
        sm.showingView.nextshow = showingnext

    else
        sm.showPools[#sm.showPools + 1] = {name=className, type="view", value= args }
    end
end

function sm.shownext(nextshow)
    
    sm.showingView = nil

    if nextshow ~= nil then
        if nextshow.type == "view" then
            print("View: ",nextshow.name)
            local view = app:createSView(nextshow.name, nextshow.value )
            view.nextshow = nextshow.nextshow

            if nextshow.value ~= nil and nextshow.value.event ~= nil then
                local event = nextshow.value.event
                view:addEventListener(event.name,    event.func,    event.target)
            end

            -- local scn = display.getRunningScene()
            if sm.viewNode ~= nil then
                sm.viewNode:addChild(view)
                nextshow.obj = view
                sm.showingView = nextshow
            end

        elseif nextshow.type == "scene" then
            print("Scene: ",nextshow.name)
            sm.preEnter()

            local scn = app:enterScene(nextshow.name, nextshow.value)
            sm.viewNode = touchLayer.new()
            scn:addChild(sm.viewNode, 10000)

            sm.postEnter()
        end
    end
end

function sm.preEnter()

    if sm.viewNode ~= nil then
        sm.viewNode:removeFromParent(true)
        sm.viewNode = nil
        sm.greyLayer = nil
    end
    
    display.removeUnusedSpriteFrames()
    collectgarbage("collect")
end

function sm.postEnter()
    if core.Waiting.hasshow == true then
        if device.platform == "ios" then
            core.Waiting.indicator = sm.addView('CoverView')
            core.Waiting.indicator:setLocalZOrder(80000)
        end
    end
end

function sm.show()

    if sm.viewNode ~= nil then
        if table.getn(sm.viewNode:getChildren()) > 0 and sm.greyLayer == nil then
            sm.greyLayer = display.newColorLayer(cc.c4b(0, 0, 0, 165))
            sm.viewNode:addChild(sm.greyLayer,-10)

            if app.showingAds == true then
                app:hideAds()
                app.showingAds = true
            end

        elseif table.getn(sm.viewNode:getChildren()) == 1 and sm.greyLayer ~= nil then

            sm.greyLayer:removeFromParent(true)
            sm.greyLayer = nil

            if app.showingAds == true then
                app:showAds()
            end

        end
    end

    if #sm.showPools < 1 then return end

    local sortFunc = function(a, b)
        return tonumber(sm.getPriority(a)) > tonumber(sm.getPriority(b))
    end

    table.sort(sm.showPools, sortFunc)

    for i=2,#sm.showPools do
        local show = sm.showPools[i-1]
        local nextshow = sm.showPools[i]
        show.nextshow = nextshow
    end
    
    local showview = sm.showPools[1]
    sm.showPools = nil 
    sm.showPools = {}

    sm.shownext(showview)

end

function sm.getPriority(show)
    
    local priority = 0

    if show.type == "scene" then
        priority = -100
    else
        priority = 0
    end
    
    return priority

end

return sm
