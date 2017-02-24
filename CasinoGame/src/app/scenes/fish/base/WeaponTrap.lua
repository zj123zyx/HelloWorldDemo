local WeaponTrap = class("WeaponTrap",function()
    return display.newNode()
end)

function WeaponTrap:ctor(sourceID)
    
    local b_dict = DICT_WEAPON[tostring(sourceID)]
    self.sourceID = sourceID
    self.baseBet = 20
    self.speed = b_dict.speed
    self.distance = b_dict.distance
    self.bet = tonumber(b_dict.bet) 
    self.range = b_dict.range
    self.upper_limit = tonumber(b_dict.upper_limit)
    self.cooling_cd = b_dict.cooling_cd
    self.switch_cd = b_dict.switch_cd
    self.moveResPath= "fish/effect/weapon_"..b_dict.ccb..".ccbi"
    self.exploreResPath="fish/effect/weapon_"..b_dict.ccb.."_explore.ccbi"
    self.startMove = false
    self.rotation = 0
    self.fishCnt = 0
    -- self.coughtFishes={}

    self:setNodeEventEnabled(true)
    self:load()
end

function WeaponTrap:load()
    print("WeaponTrap:load self.moveResPath:",self.moveResPath,"self.exploreResPath:",self.exploreResPath)
    -- 炮弹
    self.moveObj = {}
    self.moveObj.node  = CCBuilderReaderLoad(self.moveResPath, self)
    self.moveObj.node:setScale(0.6+0.4*tonumber(self.sourceID)/8)
    self.moveObj.animationMgr = self.rootNode.animationManager
    self:addChild(self.moveObj.node)

    -- 爆炸
    self.exploreObj = {}
    self.exploreObj.node  = CCBuilderReaderLoad(self.exploreResPath, self)
    self.exploreObj.node:setScale(0.6+0.4*tonumber(self.sourceID)/8)
    self.exploreObj.animationMgr = self.rootNode.animationManager
    self:addChild(self.exploreObj.node)

    -- 由于Pos是在update中动态设置的，故初始化时使其暂时不可见 jjf
    self:setVisible(false)
end

function WeaponTrap:init( startPt, endPt )
    self.endPoint = {
        x=endPt.x,
        y=endPt.y
    }
    -- self.endPtX=endPt.x
    -- self.endPtY=endPt.y
    self:setPositionX(endPt.x)
    self:setPositionY(endPt.y)
    print("self:Position:",self:getPositionX(),",",self:getPositionY())
    print("self.endPoint.x:",self.endPoint.x,",self.endPoint.y:",self.endPoint.y)

end

function WeaponTrap:start()
    self:setVisible(true)
    self.exploreObj.animationMgr:runAnimationsForSequenceNamed('explore') --lv1
    self.startMove = true
end

function WeaponTrap:explore()
    print("WeaponTrap:explore()")
    --audio.playSound("fish/audio/explore.mp3")
    self.moveObj.animationMgr:runAnimationsForSequenceNamed('idle')
    self.exploreObj.animationMgr:runAnimationsForSequenceNamed('explore')  
    -- self:performWithDelay(function() self:removeFromParent(false) end, 1.0)
end

function WeaponTrap:playEffectAfterShoot(fishes)

    local comboId = self.fishCnt - 2
    if comboId > 6 then comboId = 6 end

    local bet = 0
    local comboDict = nil
    local totalCoins = 0

    -- 获取连击加成值
    if comboId > 0 then
        comboDict = DICT_COMBO[tostring(comboId)]
        bet = tonumber(comboDict.reward_bet)
    end

    -- 鱼死亡
    local dieCnt = #fishes
    for i = 1, dieCnt do
        local fish = fishes[i]
        fish:die(i * 0.1)
        totalCoins = totalCoins + (tonumber(fish.value) + bet) * self.baseBet
    end

    -- 金币处理
    local pos = self:getParent():convertToWorldSpace(cc.p(self:getPosition()))
    if totalCoins > 0 then

        -- 金币数据增加
        app:getUserModel():setCoins(app:getUserModel():getCoins() + totalCoins)
        
        -- 金币动画效果
        local coinImage = CCBuilderReaderLoad("fish/effect/coins_numadd.ccbi", self)
        coinImage:setPosition(pos)
        coinImage:performWithDelay(function() coinImage:removeFromParent(true) end, 1.0)
        SceneManager.effectNode:addChild(coinImage)
        
        -- 金币动态大小和数值
        local scale = totalCoins / 1000.0 + 0.8
        self.coinsPanel:setScale(scale > 3.0 and 3.0 or scale)
        self.numOfCoins:setString(totalCoins)
    end

    -- 连击处理
    if comboDict then

        -- 连击文字加到提示层
        SceneManager.effectNode:performWithDelay(function()

            -- 连击动画效果
            local comboImage = CCBuilderReaderLoad("fish/effect/effect_combos.ccbi", self)
            comboImage:setPosition(pos)
            comboImage:performWithDelay(function() comboImage:removeFromParent(true) end, 1.4)
            SceneManager.effectNode:addChild(comboImage)

            -- 替换连击提示数字的图片
            self.comboSprite:setSpriteFrame("fish_combo_"..comboDict.ccb..".png")
        end, 1.1)
    end

    -- 增长经验
    app:getUserModel():setExp(self.bet + app:getUserModel():getExp())
end

function WeaponTrap:update(time)
    
    -- local Cnt = #self.coughtFishes
    -- for i = 1, Cnt do
    --     local fish = self.coughtFishes[i]
    --     -- fish:cought(i * 0.1)
    --     if fish.actionType == MOVE_TYPE.COUGHT then
    --         if fish.coughtTime > 0 then
    --             fish.coughtTime = fish.coughtTime - time
    --         else
    --             if tonumber(FishController.curFishValue-FishController.targetValue)>0 then
    --                 FishController.curFishValue=FishController.curFishValue-fish.value
    --                 fish:escape()
    --             end
    --         end
    --     end
    -- end

    if  self.startMove then
        local collision, shootedFishs = SceneManager.checkCollision(self.endPoint, self)
        if collision == true then
            -- scheduler.unscheduleGlobal(self.scheduleObj)
            self:explore()
            -- self:playEffectAfterShoot(shootedFishs)
            self:fishCought(shootedFishs)
        end
    end
end

function WeaponTrap:fishCought(fishes)
    -- 鱼捕获
    local Cnt = #fishes
    for i = 1, Cnt do
        local fish = fishes[i]
        if FishController.targetValue==0 or tonumber(fish.value)<=tonumber(FishController.targetValue-FishController.curFishValue) then
            fish:cought(i * 0.1)
            table.insert(FishController.coughtFishes, fish)
            FishController.curFishValue=FishController.curFishValue+fish.value
        end
    end
    print("FishController====>targetValue:",FishController.targetValue,",curFishValue:",FishController.curFishValue)
end

function WeaponTrap:onEnter()
    self.scheduleObj = scheduler.scheduleGlobal(function(dt)
        self:update(dt)
    end, 0.5)
end

function WeaponTrap:onExit()
    self.inuse = false
    scheduler.unscheduleGlobal(self.scheduleObj)
end

return WeaponTrap
