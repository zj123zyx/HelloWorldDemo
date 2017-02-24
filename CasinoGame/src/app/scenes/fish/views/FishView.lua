
local FishView = class("FishView",  controllBase)

function FishView:ctor(args)

    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    --local cls = user.class

    -- 通过代理注册事件的好处：可以方便的在视图删除时，清理所以通过该代理注册的事件，
    -- 同时不影响目标对象上注册的其他事件
    --
    -- EventProxy.new() 第一个参数是要注册事件的对象，第二个参数是绑定的视图
    -- 如果指定了第二个参数，那么在视图删除时，会自动清理注册的事件
    --cc.EventProxy.new(user, self)
    --    :addEventListener(cls.GEM_CHANGED_EVENT, handler(self, self.updateLabel_))

    self.ctr = args

    local node = CCBReaderLoad("fish/fish_deepsea.ccbi", self)
    self:addChild(node,-100)

    self.fishNode = display.newNode()
    self:addChild(self.fishNode,-50)

    SceneManager.effectNode = display.newNode()
    self:addChild(SceneManager.effectNode,-20)

    local node = CCBReaderLoad("fish/fish_ctlbtn.ccbi", self)
    self:addChild(node)

    app.jackpotLabel = self.jackpot
    app.jackpotLabel:setTag(app:getPlayerStatus().gameId)

    self:initWeapon()

    self:layoutCtr(true)
end

function FishView:initWeapon()
    local weaponLevel = app:getObject("FishModel"):getWeaponLevel()
    local b_dict = DICT_WEAPON[tostring(weaponLevel)]

    self.betLabel:setString(b_dict.bet)

    local node = CCBReaderLoad("fish/effect/fish_weapons.ccbi", self)
    self.weaponAminatinMgr=self.rootNode.animationManager

    self.weaponNode:addChild(node)

    local weaponImage = "fish_weapon_"..tostring(weaponLevel)..".png"
    self.weaponSprite:setSpriteFrame(weaponImage)



    local size = self.weaponSprite:getContentSize()
    self.fire_sprite:setPositionX(size.width*0.5)
    self.fire_sprite:setPositionY(size.height*0.95)
    
    self.weaponAminatinMgr:runAnimationsForSequenceNamed('enter')
end

function FishView:getWeaponPos()
    local angle = self.weaponSprite:getRotation()

    local size = self.weaponSprite:getContentSize()
    local pos = self.weaponSprite:getParent():convertToWorldSpace(cc.p(self.weaponSprite:getPosition()))

    pos.x = pos.x + size.height*math.sin(math.rad(angle))*0.65
    pos.y = pos.y + size.height*math.cos(math.rad(angle))*0.65

    return pos
end

-- 切换武器
function FishView:changeWeapon(weaponLevel)
    
    -- 变更当前炮弹的价格
    local b_dict = DICT_WEAPON[tostring(weaponLevel)]
    self.betLabel:setString(b_dict.bet)

    -- 切换武器动作
    self.weaponAminatinMgr:runAnimationsForSequenceNamed('enter')
    self.weaponSprite:setSpriteFrame("fish_weapon_"..tostring(weaponLevel)..".png")
    self.weaponSprite:setRotation(0)

    -- 校正武器火光的位置
    local size = self.weaponSprite:getContentSize()
    self.fire_sprite:setPosition(size.width * 0.5, size.height * 0.95)

    -- 粒子特效
    self.weaponSprite:getParent():removeChildByName("emitter")
    local emitter = cc.ParticleSystemQuad:create("fish/particle/fish_weapon_changed.plist")
    if emitter ~= nil then
        emitter:setName("emitter")
        emitter:setAutoRemoveOnFinish(true)
        emitter:setPosition(1.0, 1.0)
        self.weaponSprite:getParent():addChild(emitter, 100)
    end

    local ret = tonumber(b_dict.switch_cd) / 1000
    return ret >= 0 and ret or 0
end

function FishView:changeDirection(destPos,callFunction)

    local startPos = self.weaponSprite:getParent():convertToWorldSpace(cc.p(self.weaponSprite:getPosition()))
    local angle = ToolUtils.getRotation(startPos.x,startPos.y,destPos.x,destPos.y)

    angle=90-angle
    local time = math.abs(angle) / 360

    self.weaponSprite:runAction(cc.Sequence:create(
        cc.RotateTo:create(time, angle),
        cc.CallFunc:create(function()
            callFunction()
            self.weaponAminatinMgr:runAnimationsForSequenceNamed('fire')
        end)
    ))
end

function FishView:onTouch(p)
    -- print("FishView:onTouch")
    if self.menus_node:isVisible() == false then 
        -- print("FishView: self.ctr:onTouch_ ")
        self.ctr:onTouch_({name="began",x=p.x,y=p.y})
    end

    self.super.onTouch(self, p)
end

function FishView:onEnter()
    self.super.onEnter(self)
end

function FishView:onExit()
    self.super.onExit(self)
end

return FishView
