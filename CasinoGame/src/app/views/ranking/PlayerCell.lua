local Cell = class("PlayerCell", function()
    return display.newNode()
end)

function Cell:ctor(args, panelContain)
    self.panelContain = panelContain
    self.data = args

    self.viewNode  = CCBReaderLoad("lobby/ranking/player_cell.ccbi", self)
    self:addChild(self.viewNode)
    local size = self.viewNode:getContentSize()
    self:setContentSize(size)

    --self.nameText:setString(args.name)

    self.rankNum:setString(tostring(args.rankNum))
    self.betNum:setString(tostring(args.totalBet))

    
    if args.rewardCnt == 0 then 
        self.rewardNode:setVisible(false) 
        self.rankNumBg:setVisible(false) 
    else
        self.rankNumBg:setVisible(true) 

        self.rewardCnt:setString(tostring(args.rewardCnt))

        if tonumber(args.rewardId) == ITEM_TYPE.NORMAL_MULITIPLE then --奖励金币
            image = "gold.png"
        else
            image = "gems.png"
        end

        self.gemIcon:setSpriteFrame(image)
        self.rankNum:setColor(cc.c4b(128,64,0,255))

    end

    self.headview = headViewClass.new({player=args})
    self.headview:replaceHead(self.head)
    self.headview:showUserName()

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

function Cell:onExit()
    self = {}
end

return Cell
