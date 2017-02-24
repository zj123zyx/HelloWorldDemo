local JackPotNotice = {}

function JackPotNotice.create(msg)
    local scene = cc.Director:getInstance():getRunningScene()
    local ccbNode = CCBuilderReaderLoad("view/JackPotNotice.ccbi", JackPotNotice)
	scene:addChild(ccbNode)
	ccbNode:setPosition(cc.p(display.cx,display.height))

    local baseInfo = {}
    local name = DICT_UNIT[tostring(msg.gameId)].desc
    JackPotNotice.jackpotTip:setString("has won a " .. name .." Jackpot:")

    JackPotNotice.getJackpot:setString(msg.rewardCoins)
    baseInfo.pid = msg.pid
    baseInfo.name = msg.name
    baseInfo.pictureId = msg.pictureId
    baseInfo.level = msg.level
    baseInfo.vipLevel = msg.vipLevel

    local headView = headViewClass.new({player=baseInfo, scale=0.24})
    headView:replaceHead(JackPotNotice.head)
    headView:showUserName()

    scene:runAction(cc.Sequence:create(cc.DelayTime:create(6),cc.CallFunc:create(function()
        ccbNode:removeFromParent()
    end)))

end



return JackPotNotice