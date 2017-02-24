local Cell = class("CollectGiftCell", function()
    return display.newNode()
end)

function Cell:ctor(args)
    self.data = args
    self.viewNode  = CCBReaderLoad("lobby/present/collect_gift_cell.ccbi", self)
    self:addChild(self.viewNode)
    local size = self.viewNode:getContentSize()
    self:setContentSize(size)
    self.descText:setString(args.content)
    self.valueText:setString(args.title)
    if cc.SpriteFrameCache:getInstance():getSpriteFrame(args.giftPicture) then
        self.giftSprite:setSpriteFrame(display.newSpriteFrame(args.giftPicture))
    end
    local headview = headViewClass.new({player={
        pid = args.fromPid,
        name=args.fromName,
        pictureId=args.pictureId,
    }, scale=0.5})
    headview:replaceHead(self.head)
    headview:showUserName()
    headview:registClickHead(false)

end

function Cell:checkClick(p)
    local tSize = self.collectBtn:getContentSize()
    local tPos = self.collectBtn:getParent():convertToWorldSpace(cc.p(self.collectBtn:getPosition()))
    local rect = cc.rect(tPos.x - tSize.width / 2, tPos.y - tSize.height / 2, tSize.width, tSize.height)
    local isClick  = cc.rectContainsPoint(rect, p)
    return isClick
end

return Cell