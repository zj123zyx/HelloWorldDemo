local Cell = class("PlayerGiftCell", function()
    return display.newNode()
end)

function Cell:ctor(args)
    self.data = args
    self.viewNode  = CCBReaderLoad("lobby/social/player_gift_cell.ccbi", self)
    self:addChild(self.viewNode)
    local size = self.viewNode:getContentSize()
    self:setContentSize(size)
    self.giftSprite:setSpriteFrame(args.giftPicture)
    self.headview = headViewClass.new({player={
        pid = args.fromPid,
        name = args.fromName,
        pictureId = args.pictureId,
        facebookId = args.facebookId,
        vipLevel = args.fromVipLevel,
    }})

    self.headview:replaceHead(self.head)
    self.headview:showUserName()

    self.collectBtn:setOpacity(0)
    self.send_btn:setOpacity(0)
    
    self.valueText:setString("Gift")
    self.descText:setString("One gift for you")
    if args.state == 0 then
        self.giftSprite:setOpacity(0)
        self.send_btn:setOpacity(255)
    else
        self.descText:setString(args.content)
        self.valueText:setString(args.title)
    end
    self.count = 0
end 

function Cell:checkClickHead(p,isme,oldView)
    local tSize = self.headview.head:getContentSize()
    local tPos = self.headview.head:getParent():convertToWorldSpace(cc.p(self.headview.head:getPosition()))
    local rect = cc.rect(tPos.x - tSize.width / 2, tPos.y - tSize.height / 2, tSize.width, tSize.height)
    local isClick  = cc.rectContainsPoint(rect, p)
    
    if isClick == true then
        self.headview:onClicked(isme, oldView)
    end

    return isClick
end


function Cell:checkGiftCollected()
    if self.data.state ~=0 or self.count ~=0 then
        return false
    end
    self.count = self.count + 1
    return true
end

function Cell:showEffect()
    self.send_btn:setVisible(false)
    self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        self.goldEffect = CCBReaderLoad(GIFTS_EFFECT[tonumber(self.data.giftId)], self)
        self.goldEffect:setScale(0.5)
        self.goldEffect:setPosition(cc.p(self.giftSprite:getPosition()))
        self:addChild(self.goldEffect,10)
        self.goldEffect:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(function()
            local image,coinsprite = nil,nil
            if tonumber(self.data.giftId) == 1 then
                image = "gold.png"
                coinsprite = app.coinSprite
                AnimationUtil.CollectRewards("#"..image,10,self.giftSprite,coinsprite,function()
                    if self.descText then
                       self.descText:setString(self.data.content) 
                    end
                    if self.valueText then
                        self.valueText:setString(self.data.title)
                    end
                end)
            elseif tonumber(self.data.giftId) == 2 then
                image = "gems.png"
                coinsprite = app.gemSprite
                AnimationUtil.CollectRewards("#"..image,5,self.giftSprite,coinsprite,function()
                    if self.descText then
                       self.descText:setString(self.data.content) 
                    end
                    if self.valueText then
                        self.valueText:setString(self.data.title)
                    end
                end)
            end
        end)))
    end)))
end


return Cell
