-----------------------------------------------------------
-- FishController 
-----------------------------------------------------------
local FishController = class("FishController", function()
        return display.newNode()
end)

FishController.curFishValue=0
FishController.targetValue=0
FishController.coughtFishes={}
FishController.weaponTraps={}

function FishController:ctor( homeinfo )

    local ViewClass = require("app.scenes.fish.views.FishView")
    self.fishView =  ViewClass.new(self)
    self.fishView:init(homeinfo)
    self.fishView:addTo(self)

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    -- self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
    --         return self:onTouch_(event)
    --     end)

    -- FishController.curFishValue=0
    -- FishController.targetValue=50

    -- 初始化鱼群控制参数(测试性能) jjf
    self.minCnt = 20
    self.maxCnt = 30
    self.fishTime = 0

    -- self.throwingBomb = false

    self.switchWeapon = false
    self.switchWeaponTime = 0
    self.switchWeaponCD = 0
    self.weaponsCache={}

    self.pathConfigId = DICT_FISH_SCENE["1"].path_Id

    PathPool.loadPath()

    self:registerUIEvent()
    self:initFishControllerData()
end

function FishController:initFishControllerData()
    FishController.curFishValue=0
    FishController.targetValue=0
    FishController.coughtFishes={}
    FishController.weaponTraps={}
end

function FishController:onEnter()
    self.scheduleObj = scheduler.scheduleGlobal(function(dt)
        self:updateTrapFishes(dt)
    end, 1)
end

function FishController:onExit() 
    scheduler.unscheduleGlobal(self.scheduleObj)
end

function FishController:updateTrapFishes(dt)
    local Cnt = #FishController.coughtFishes
    for i = 1, Cnt do
        local fish = FishController.coughtFishes[i]
        if fish~=nil and fish.actionType == MOVE_TYPE.COUGHT then
            if fish.coughtTime > 0 then
                fish.coughtTime = fish.coughtTime - dt
            else
                if FishController.targetValue==0 or tonumber(FishController.curFishValue-FishController.targetValue)>0 then
                    FishController.curFishValue=FishController.curFishValue-fish.value
                    fish:escape()
                    table.remove(FishController.coughtFishes, i)
                    Cnt = #FishController.coughtFishes
                    ------------test
                    if FishController.targetValue==0 then
                        FishController.targetValue=30
                    end
                    ------------test
                end
            end
        end
    end

    if FishController.targetValue>0 then
        if FishController.curFishValue<FishController.targetValue then
            local trapCnt = #FishController.weaponTraps
            for i = 1, trapCnt do
                local weaponTrap = FishController.weaponTraps[i]
                SceneManager.createFishClusterByTrap(weaponTrap, self.fishView.fishNode)
            end
        end
        if FishController.curFishValue==FishController.targetValue then
            print("===FishController.curFishValue=FishController.targetValue===")
            scheduler.unscheduleGlobal(self.scheduleObj)

            self:performWithDelay(function()
                local contentStr = "Are you sure you want to leave the room ?"
                
                scn.ScnMgr.addView("CommonTip",{ok_callback = function()
                    scn.ScnMgr.replaceScene("lobby.LoginScene")
                end,
                title="LEAVE ROOM",
                content=contentStr})

            end, ESCAPE_TIME)
            
        end
    end

    print("FishController.targetValue:",FishController.targetValue,"FishController.curFishValue:",FishController.curFishValue)
end

function FishController:update(dt)

    -- 控制换武器CD jjf
    if self.switchWeapon == true then
        self.switchWeaponTime = self.switchWeaponTime  + dt
        if self.switchWeaponTime > self.switchWeaponCD then
            self.switchWeapon = false
            self.switchWeaponTime = 0
        end
    end

    -- 控制鱼群的最小数量 jjf
    while self.fishView.fishNode:getChildrenCount() < self.minCnt do
        local pathId = SceneManager.buildPath(self.pathConfigId)
        local clusterId = SceneManager.buildClusterByPathId(pathId)
        SceneManager.createFishCluster(pathId, clusterId, self.fishView.fishNode)
    end

    -- 控制鱼群的最大数量 jjf
    self.fishTime = self.fishTime + dt
    if  self.fishTime > 1.0 then
        self.fishTime = 0

        if self.fishView.fishNode:getChildrenCount() < self.maxCnt and math.newrandom() > 0.5 then
            local pathId = SceneManager.buildPath(self.pathConfigId)
            local clusterId = SceneManager.buildClusterByPathId(pathId)
            SceneManager.createFishCluster(pathId, clusterId, self.fishView.fishNode)
        end
    end
end

function FishController:registerUIEvent()

    -- 切换武器(+) jjf
    core.displayEX.newButton(self.fishView.addBetBtn):onButtonClicked(function() 

        -- 判断换武器状态标识
        if self.switchWeapon == true then return end

        local level = app:getObject("FishModel"):getWeaponLevel() + 1
        if level <= 8 then

            -- 判断当前的金额是否足够发射炮弹
            if app:getUserModel():getGems() < tonumber(DICT_WEAPON[tostring(level)].bet) then
                scn.ScnMgr.popView("ShortCoinsView", {})
            else
                app:getObject("FishModel"):setWeaponLevel(level)
                self.switchWeaponCD = self.fishView:changeWeapon(level)
                self.switchWeapon = true
            end
        end
    end)

    -- 切换武器(-) jjf
    core.displayEX.newButton(self.fishView.subBetBtn):onButtonClicked(function() 

        -- 判断换武器状态标识
        if self.switchWeapon == true then return end

        local level = app:getObject("FishModel"):getWeaponLevel() - 1
        if level >= 1 then
            app:getObject("FishModel"):setWeaponLevel(level)
            self.switchWeaponCD = self.fishView:changeWeapon(level)
            self.switchWeapon = true
        end
    end)

    core.displayEX.newButton(self.fishView.paytableBtn):onButtonClicked(function()
        local ccbi = "fish/fishing_hawaii/paytable_hawaii.ccbi"
        scn.ScnMgr.addView("PaytableView",{ccbi = ccbi, scroll=true})
    end)

    -- core.displayEX.newButton(self.fishView.item1Btn)
    --     :onButtonClicked(function()
    --         scn.ScnMgr.addView("CommonTip",{ok_callback = function()

    --                 local totalGems = app:getUserModel():getGems()
    --                 if totalGems >= 5 then
    --                     app:getUserModel():setGems(totalGems-5)
    --                     self.throwingBomb = true
    --                 else
    --                     scn.ScnMgr.popView("ShortGemsView",{})
    --                 end

    --             end,
    --             title="Throwing Bomb",
    --             content="Cost 5 Gems, you will fishing biger fishes,Are you sure you want to throwing Bomb ?"})

    --     end)

    core.displayEX.newButton(self.fishView.item1Btn)
        :onButtonClicked(function()
            local contentStr = "Are you sure you want to leave the room ?"    
            scn.ScnMgr.addView("CommonTip",{ok_callback = function()
                scn.ScnMgr.replaceScene("lobby.LoginScene")
            end,
            title="LEAVE ROOM",
            content=contentStr})
        end)

    -- self.fishView.item1Btn:setButtonEnabled(false)
    -- self.fishView.item2Btn:setButtonEnabled(false)
end

function FishController:onTouch_(event)

    if event.name == "began" then
        self.time = 0

        if event.x < 80 then return true end
        if event.y < 100 then return true end

        if event.x > display.width - 80 then return true end
        if event.y > display.height - 80 then return true end

        -- if self.throwingBomb == true then

        --     local destPos = {x=event.x, y=event.y}

        --     local bombEffect  = CCBReaderLoad("fish/effect/bomb_explore.ccbi", self)

        --     bombEffect:setPosition(destPos)

        --     self.fishView.effectNode:addChild(bombEffect)

        --     self:performWithDelay(function()
        --         bombEffect:removeFromParent(false)
        --     end,1.0)

        --     self.throwingBomb = false

        --     return true
        -- end


        local weaponLevel = app:getObject("FishModel"):getWeaponLevel()
        local b_dict = DICT_WEAPON[tostring(weaponLevel)]

        if app:getUserModel():getCoins() < tonumber(b_dict.bet) then
            scn.ScnMgr.popView("ShortCoinsView",{})
        else
            local destPos = {x=event.x, y=event.y}
            self.fishView:changeDirection(destPos,function()

                local weaponPos = self.fishView:getWeaponPos()
                local startPos = {x=weaponPos.x, y=weaponPos.y}

                -- local weapon=Weapon.new(weaponLevel)
                -- weapon:init(startPos, destPos)
                -- weapon:start()
                -- self.fishView.fishNode:addChild(weapon)

                local weaponTrap=WeaponTrap.new(weaponLevel)
                weaponTrap:init(startPos, destPos)
                weaponTrap:start()
                self.fishView.fishNode:addChild(weaponTrap)

                table.insert(FishController.weaponTraps, weaponTrap)
                -- SceneManager.createFishClusterByTrap(weaponTrap, self.fishView.fishNode)
            end)
        end


    elseif event.name == "ended" then
        
    end

    return true
end

function FishController:getUnusedWeapon(level)

    local weapons = self.weaponsCache[level]

    if weapons then

        for i=1,#weapons do
            local weapon = weapons[i]

            if weapon.inuse == false then
                weapon.inuse = true
                return weapon
            end

        end    
    else
        weapons = {}
        self.weaponsCache[level] = weapons
    end
    
    local weapon=Weapon.new(level)
    weapon.inuse = true

    table.insert(weapons, weapon)

    return weapon
end

function FishController:lockUI()
    --self.controlbarView.addGemsBtn:setButtonEnabled(false)
    --self.controlbarView.addCoinsBtn:setButtonEnabled(false)
    --self.controlbarView.subBetBtn:setButtonEnabled(false)
    --self.controlbarView.addBetBtn:setButtonEnabled(false)
    --self.controlbarView:lockBTN()
end

function FishController:unLockUI()
    --self.controlbarView.addGemsBtn:setButtonEnabled(true)
    --self.controlbarView.addCoinsBtn:setButtonEnabled(true)
    --self.controlbarView.subBetBtn:setButtonEnabled(true)
    --self.controlbarView.addBetBtn:setButtonEnabled(true)
    --self.controlbarView:unlockBTN()
end

return FishController
