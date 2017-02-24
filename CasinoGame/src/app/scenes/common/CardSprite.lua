local Card = class("CardSprite", function()
    return display.newNode()
end)

local function scaleFun(target, scaleX,scaleY, time, onComplete)
    transition.scaleTo(target, {scaleX=scaleX,scaleY= scaleY,time= time,onComplete = onComplete})
end

function Card:ctor(front,back)
    local resName = "#"..front

    --TODO
    if cc.SpriteFrameCache:getInstance():getSpriteFrame(resName) == nil then
        display.addSpriteFrames("poker/poker_card_big.plist","poker/poker_card_big.pvr.ccz")
    end

    local sp = display.newSprite(resName)
    self:addChild(sp)
    self.front = sp
    -- sp:setCameraMask(cc.CameraFlag.USER1)
    -- sp:setZOrder(-100)

    if back ~= nil then
        self.onback = true
        resName = "#"..back
        sp = display.newSprite(resName)
        self:addChild(sp)
        self.back = sp
        -- sp:setCameraMask(cc.CameraFlag.USER1)
        -- sp:setZOrder(-100)
    end

    self:setNodeEventEnabled(true)
end

function Card:addBack(backRes)
    
    if self.back then return end

    self.onback = false
    resName = "#"..backRes
    sp = display.newSprite(resName)
    self:addChild(sp)
    self.tempback = sp

    -- sp:setCameraMask(cc.CameraFlag.USER1)
    -- sp:setZOrder(-100)
    
end

function Card:moveFromTo(toPos, callback)

    local spBack = nil
    
    if self.back == nil then
        spBack = display.newSprite("#bj_back.png")
        self:addChild(spBack)
    end


    local move = cc.MoveTo:create(0.2,cc.p(toPos.x,toPos.y))
    local rote = cc.RotateTo:create(0.2, 0)

    local span = cc.Spawn:create(
            move,
            rote
        )

    if spBack then
        
        --self.front:setScaleX(0)

        local sequence = cc.Sequence:create(
            
            span,

            cc.CallFunc:create(function()
                ToolUtils.flipPoker(self.front, self.tempback, 0.2,function()

                        spBack:removeFromParent(true)
                        if callback then callback() end

                    end)

                -- scaleFun( spBack, 0,1, 0.2, function()

                --     scaleFun( self.front, 1,1, 0.2,function()

                --         spBack:removeFromParent(true)
                --         if callback then callback() end

                --     end)
                -- end)


            end)
        )

        spBack:runAction(sequence)

    else

        local sequence = cc.Sequence:create(
            
            span,
            cc.CallFunc:create(function()

                if callback then callback() end

            end)
        )

        self.back:runAction(sequence)

    end

end

function Card:flip1()
    
    if self.back then return end
    
    audio.playSound(RES_AUDIO.poker_card_flip)

    ToolUtils.flipPoker(self.front, self.tempback, 0.15)


    -- print("------flip1")
    -- self.front:setScaleX(0)
    -- scaleFun(self.tempback, 0,1, 0.15, function()
    --     scaleFun( self.front, 1,1, 0.15,function()
    --         self.tempback:setVisible(false)
    --     end)
    -- end)
end

function Card:flip(callback)

    ToolUtils.flipPoker(self.front, self.back, 0.10,  callback)


    -- self.front:setScaleX(0)
    -- print("------flip1")

    -- scaleFun(self.back, 0,1, 0.15, function()
    --     scaleFun( self.front, 1,1, 0.15,function()
    --         self.back:setVisible(false)
    --         if callback ~= nil then
    --             callback()
    --         end

    --     end)
    -- end)
end


function Card:onExit()
    self.front = nil
    self.back = nil
    self:removeAllNodeEventListeners()
end

return Card
