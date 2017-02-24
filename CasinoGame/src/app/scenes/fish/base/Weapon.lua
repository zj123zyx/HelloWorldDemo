local Weapon = class("Weapon",function()
    return display.newNode()
end)

function Weapon:ctor(sourceID)
    
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

    self:setNodeEventEnabled(true)
    self:load()
end

function Weapon:load()

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

function Weapon:init( startPt, endPt )

    local poits = {}
    poits[#poits + 1] = startPt
    poits[#poits + 1] = endPt

    local lenght = ToolUtils.dist2(startPt, endPt)

    self.route = GEM.Line.new()
    self.route:init(poits, lenght, 2, 0)

    self.route:setSpeed(self.speed)

    self.moveObj.node:setRotation(90-self.route.rotation)
end

function Weapon:start()

    local totalGems = app:getUserModel():getGems()
    if totalGems >= self.bet then
        app:getUserModel():setGems(totalGems - self.bet)

        EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})

        self.startMove = true
        self.startTime = socket.gettime()
        self.moveObj.animationMgr:runAnimationsForSequenceNamed('move')

        audio.playSound("fish/audio/shoot.mp3")

    else
        app:getUserModel():setGems(100000)
        scn.ScnMgr.popView("ShortGemsView",{})
    end
end

function Weapon:explore()
    --audio.playSound("fish/audio/explore.mp3")
    self.moveObj.animationMgr:runAnimationsForSequenceNamed('idle')
    self.exploreObj.animationMgr:runAnimationsForSequenceNamed('explore')  
    self:performWithDelay(function() self:removeFromParent(false) end, 1.0)
end

function Weapon:playEffectAfterShoot(fishes)

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
    
    -- local dieCnt = #fishes
    -- for i = 1, dieCnt do

    --     -- 鱼消失动画
    --     local fish = fishes[i]
    --     fish:die(0)

    --     -- 金币处理
    --     local coins = (tonumber(fish.value) + bet) * self.baseBet
    --     if coins > 0 then

    --         -- 金币数据增加
    --         app:getUserModel():setCoins(app:getUserModel():getCoins() + coins)
            
    --         -- 金币动画效果
    --         local fishPos = self:getParent():convertToWorldSpace(cc.p(fish:getPosition()))
    --         local coinImage = CCBuilderReaderLoad("fish/effect/coins_numadd.ccbi", self)
    --         coinImage:setPosition(fishPos)
    --         coinImage:performWithDelay(function() coinImage:removeFromParent(true) end, 1.0)
    --         SceneManager.effectNode:addChild(coinImage)
            
    --         -- 金币动态大小和数值
    --         local scale = coins / 1000.0 + 0.8
    --         self.coinsPanel:setScale(scale > 2.8 and 2.8 or scale)
    --         self.numOfCoins:setString(coins)
    --     end
    -- end

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

function Weapon:update(time)
    
    if  self.startMove then

        if self.route.rate == 1 then
            
            scheduler.unscheduleGlobal(self.scheduleObj)
            self.route.rate = 0
            self:explore()

            local collision, shootedFishs = SceneManager.checkCollision(self.globalPos, self)
            if collision == true then
                self:playEffectAfterShoot(shootedFishs)
            end

            print("self:Position:",self:getPositionX(),",",self:getPositionY())

            return
        end

        self.globalPos = self.route:update( socket.gettime()- self.startTime);
        self:setPositionX(self.globalPos.x)
        self:setPositionY(self.globalPos.y)
        self:setVisible(true)
    end

    return nil
end

function Weapon:onEnter()
    self.scheduleObj = scheduler.scheduleGlobal(function(dt)
        self:update(dt)
    end, 0)
end

function Weapon:onExit()
    self.inuse = false
    scheduler.unscheduleGlobal(self.scheduleObj)
end

return Weapon
