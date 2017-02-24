
local ScnAnimView = class("ScnAnimView", function()
    return display.newNode()
end)

function ScnAnimView:ctor(args)

    self.controlBar = args.ctr
    self.machineScn = args.machineScn
    self.machineNodes = args.machineNode

    self.machineScnParent = self.machineScn:getParent()

    self.viewNode  = CCBuilderReaderLoad(args.animccbi, self)
    
    self:addChild(self.viewNode)

    self.machineScn:removeFromParent(false)

    self.machPosX, self.machPosY = self.machineScn:getPosition()

    print("ScnAnimView", self.machPosX, self.machPosY)

    local rect = self.machineScn:getCascadeBoundingBox()
    print("getCascadeBoundingBox1", rect.x, rect.y, rect.width, rect.height)

    local size = self.machineScn:getContentSize()
    self.machineScn:setPosition(-size.width/2, -size.height/2)
    

    --self.machineNode:removeAllChildren()
    
    self.machineNode:addChild(self.machineScn)


    -- controlbar

    self.controlBar:removeFromParent(false)
    self.controlNode:addChild(self.controlBar)

    self.machineScnParent:addChild(self)
    if self.game_name then
        self.game_name:setString(args.game_name)
    end

    local rect = self.machineScn:getCascadeBoundingBox()
    print("getCascadeBoundingBox2", rect.x, rect.y, rect.width, rect.height)

    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)

end

function ScnAnimView:controllBarEnter()

    if self.controlBar ~= nil then

        local posX, posY = self.controlBar.bottom_bar:getPosition()

        self.controlBar.bottom_bar:setPositionY(posY-150)

        transition.moveTo(self.controlBar.bottom_bar, {x=posX, y=posY, time=0.5, delay = 1.0,
            onComplete=function()
            end})

    end

    if self.controlBar.top ~= nil then

        local posX, posY = self.controlBar.top:getPosition()

        self.controlBar.top:setPositionY(posY+150)

        transition.moveTo(self.controlBar.top, {x=posX, y=posY, time=0.5, delay = 1.0,
            onComplete=function()
            end})

    end


    self.controlBar:headNodeAction()

end

function ScnAnimView:playOnEnter()
    local scale = self.machineNodes:getScale()
    self.machineNodes:setScale(0.40*scale)
    transition.scaleTo(self.machineNodes, {time = 1.5, scale = scale})

    self.viewNode.animationManager:runAnimationsForSequenceNamed("enter")
end

function ScnAnimView:playOnExit()
    self.viewNode.animationManager:runAnimationsForSequenceNamed("exit")
end

function ScnAnimView:onEnterComplete()
    print("onEnterComplete")
    --self:reAttachTo()
end

function ScnAnimView:onExitComplete()
    print("onEnterComplete")
    --self:reAttachTo()
end

function ScnAnimView:reAttachTo()
    -- body
    self.machineScn:removeFromParent(false)
    self.machineScn:setPosition(self.machPosX, self.machPosY)
    self.machineScnParent:addChild(self.machineScn)
    self:removeFromParent(false)

end

function ScnAnimView:onEnter()
end

function ScnAnimView:onExit()
    print("ScnAnimView:onExit()")
end

return ScnAnimView