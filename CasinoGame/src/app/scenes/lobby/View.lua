--声明 View 类

local View = class("View", function()
    return display.newNode()
end)

function View:ctor()
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    local  node  = CCBReaderLoad("view.ccbi", self)
    self:addChild(node)

    self:setTouchSwallowEnabled(false) -- 是否吞噬事件，默认值为 true
    self:setTouchEnabled(true)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        print("---d-d-d-d-d-")
        return self:onTouch(event.name, event.x, event.y)
    end)

    if true then return end

    -- button2 响应触摸后，不会吞噬掉触摸事件
    self.button2 = createTouchableSprite({
            image = "PinkButton.png",
            size = cc.size(400, 160),
            label = "TOUCH ME !"})
        :pos(300, 200)
        :addTo(self)
    cc.ui.UILabel.new({text = "SWALLOW = NO\n事件会传递到下层对象", size = 24})
        :align(display.CENTER, 200, 90)
        :addTo(self.button2)
    drawBoundingBox(self, self.button2, cc.c4f(0, 0, 1.0, 1.0))

    self.button2:setTouchEnabled(true)
    self.button2:setTouchSwallowEnabled(true) -- 当不吞噬事件时，触摸事件会从上层对象往下层对象传递，称为“穿透”
    self.button2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local label = string.format("button2: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        self.button2.label:setString(label)
        return true
    end)

end

function View:onTouch(event, x, y)
    print(event, x, y)
end

function View:onEnter()
    self:setTouchEnabled(true)
    print("View:onEnter")

    display.removeUnusedSpriteFrames()

end

function View:onExit()
    self:removeAllEventListeners()
    print("View:onExit")

    display.removeUnusedSpriteFrames()

end

return View