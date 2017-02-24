View = require("app.scenes.lobby.View")

local TDScene = class("TDScene", function()
    return display.newScene("TDScene")
end)

function TDScene:ctor()

    local  node  = CCBReaderLoad("test/lobby3D.ccbi", self)
    self:addChild(node)


    local function onHairBtn()
    	local labelTTF = self["mCCControlEventLabel"]
    	if nil == labelTTF then
       		return
    	end
        labelTTF:setString("Hair") 


        self._useHairId = self._useHairId + 1
        if self._useHairId > 1 then
            self._useHairId = 0
        end

        if self._useHairId >= 0 and self._sprite ~= nil then
            for i=1,2 do
                local subMesh = self._sprite:getMeshByName(self._girlHair[i])
                if nil ~= subMesh then
                    if (i - 1) == self._useHairId then
                        subMesh:setVisible(true)
                    else
                        subMesh:setVisible(false)
                    end
                end
            end
        end
	end

    self.HairBtn:registerControlEventHandler(onHairBtn, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

	local function onGlassesBtn()
    	local labelTTF = self["mCCControlEventLabel"]
    	if nil == labelTTF then
       		return
    	end
        labelTTF:setString("Glasses") 

       	local subMesh = self._sprite:getMeshByName("Girl_Glasses01")
        if nil ~= subMesh then
            if subMesh:isVisible() then
                subMesh:setVisible(false)
            else
                subMesh:setVisible(true)
            end
        end
	end
    self.GlassesBtn:registerControlEventHandler(onGlassesBtn, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)


	local function onCoatBtn()
    	local labelTTF = self["mCCControlEventLabel"]
    	if nil == labelTTF then
       		return
    	end
        labelTTF:setString("Coat") 

       	self._useUpBodyId = self._useUpBodyId + 1
        if self._useUpBodyId > 1 then
            self._useUpBodyId = 0
        end
        if self._useUpBodyId >= 0  and nil ~= self._sprite then
            for i=1,2 do
                local subMesh = self._sprite:getMeshByName(self._girlUpperBody[i])
                if nil ~=subMesh then
                    if (i - 1) == self._useUpBodyId then
                        subMesh:setVisible(true)
                    else
                        subMesh:setVisible(false)
                    end
                end
            end
        end
       	
	end
    self.CoatBtn:registerControlEventHandler(onCoatBtn, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)


    local function onPantsBtn()
    	local labelTTF = self["mCCControlEventLabel"]
    	if nil == labelTTF then
       		return
    	end
        labelTTF:setString("Pants") 

       	self._usePantsId = self._usePantsId + 1
        if self._usePantsId > 1 then
            self._usePantsId = 0
        end

        if self._usePantsId >= 0  and nil ~= self._sprite then
            for i=1,2 do
                local subMesh = self._sprite:getMeshByName(self._girlPants[i])
                if nil ~= subMesh then
                    if (i - 1) == self._usePantsId then
                        subMesh:setVisible(true)
                    else
                        subMesh:setVisible(false)
                    end
                end
            end
        end
	end
    self.PantsBtn:registerControlEventHandler(onPantsBtn, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

	local function onShoesBtn()
    	local labelTTF = self["mCCControlEventLabel"]
    	if nil == labelTTF then
       		return
    	end
        labelTTF:setString("Shoes") 

       	self._useShoesId = self._useShoesId + 1
        if self._useShoesId > 1 then
            self._useShoesId = 0
        end

        if self._useShoesId >= 0  and nil ~= self._sprite then
            for i=1,2 do
                local subMesh = self._sprite:getMeshByName(self._girlShoes[i])
                if nil ~= subMesh then
                    if (i - 1) == self._useShoesId then
                        subMesh:setVisible(true)
                    else
                        subMesh:setVisible(false)
                    end
                end
            end
        end
	end
    self.ShoesBtn:registerControlEventHandler(onShoesBtn, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

    self.ccbNode = nil

    local function onCCBTestBtn()

        if true then
            scn.ScnMgr.replaceScene("lobby.LobbyScene")

            --app:enterScene("LobbyScene")
            --display.removeUnusedSpriteFrames()
            return
        end

        if self.ccbNode == nil then
            self.ccbNode  = View.new()

            self:addChild(self.ccbNode)
        else
            self.ccbNode:removeFromParent()
            self.ccbNode = nil
            --display.removeUnusedSpriteFrames()
        end
        
    end
    self.ccbTestBtn:registerControlEventHandler(onCCBTestBtn, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

    self._girlPants = {"Girl_LowerBody01", "Girl_LowerBody02"}
    self._girlUpperBody = {"Girl_UpperBody01", "Girl_UpperBody02"}
    self._girlShoes  = {"Girl_Shoes01", "Girl_Shoes02"}
    self._girlHair  = {"Girl_Hair01", "Girl_Hair02"}
    self._usePantsId = 0
    self._useUpBodyId = 0
    self._useShoesId   =0
    self._useHairId = 0

    local fileName = "Sprite3DTest/ReskinGirl.c3b"
    local sprite = cc.Sprite3D:create(fileName)
    sprite:setScale(8)
    sprite:setRotation3D({x = 0, y =0 ,z = 0})
    local girlPants = sprite:getMeshByName(self._girlPants[2])
    if nil ~= girlPants then
        girlPants:setVisible(false)
    end

    local girlShoes = sprite:getMeshByName(self._girlShoes[2])
    if nil ~= girlShoes then
        girlShoes:setVisible(false)
    end

    local girlHair = sprite:getMeshByName(self._girlHair[2])
    if nil ~= girlHair then
        girlHair:setVisible(false)
    end

    local girlUpBody = sprite:getMeshByName( self._girlUpperBody[2])
    if nil ~=girlUpBody then
        girlUpBody:setVisible(false)
    end

    self:addChild(sprite)
    sprite:setPosition( display.cx, 150 )
    local animation = cc.Animation3D:create(fileName)
    if nil ~= animation then
        local animate = cc.Animate3D:create(animation)
        sprite:runAction(cc.RepeatForever:create(animate))
    end
    
    self._sprite = sprite


    self:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
    self:setTouchEnabled(true)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        print("TDScene on touch ")
        return true
    end)


    --add logo
    --local logo = cc.EffectSprite:create("logo.png")
    --self._logoSize = logo:getContentSize()
    --logo:setPosition(self.size.width*0.53,self.size.height*0.55)
    --logo:setScale(0.1)
    --self._logo = logo
    --self:addChild(logo)

    -- effectNormalMap
    --local effectNormalMapped = cc.EffectNormalMapped:create("logo_normal.png");
    --effectNormalMapped:setPointLight(self._pointLight)
    --effectNormalMapped:setKBump(50)
   -- self._logo:setEffect(effectNormalMapped)

    self._directionalLight = cc.DirectionLight:create(cc.vec3(1.0, 1.0, 1.0), cc.c3b(200, 200, 200))
    self._directionalLight:setEnabled(true)
    self:addChild(self._directionalLight)
    self._directionalLight:setCameraMask(2)


    self._ambientLight = cc.AmbientLight:create(cc.c3b(200, 200, 200))
    self._ambientLight:setEnabled(true)
    self:addChild(self._ambientLight)
    self._ambientLight:setCameraMask(2)
    
    self:createLayer()
end


--crate a main layer
function TDScene:createLayer()
    local mainLayer = cc.Layer:create()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_AUTO)
    self.size = cc.Director:getInstance():getVisibleSize()

    --add logo
   -- self:addLogo(mainLayer)
    
    --add pointlight
   -- self:addPointLight(mainLayer)
    
    --self:addChild(mainLayer)
end


function TDScene:addLogo(layer)
    --add logo
    local logo = cc.EffectSprite:create("logo.png")
    self._logoSize = logo:getContentSize()
    logo:setPosition(self.size.width*0.53,self.size.height*0.55)
    logo:setScale(0.1)
    self._logo = logo
    layer:addChild(logo,4)
    
    local action = cc.EaseElasticOut:create(cc.ScaleTo:create(2,1.1))
    
    logo:runAction(action)
    
    --logo shake
    local time = 0
    --logo animation
    local function logoShake()
        --rand_n = range * math.sin(math.rad(time*speed+offset))
        local rand_x = 0.1*math.sin(math.rad(time*0.5+4356))
        local rand_y = 0.1*math.sin(math.rad(time*0.37+5436)) 
        local rand_z = 0.1*math.sin(math.rad(time*0.2+54325))
        logo:setRotation3D({x=math.deg(rand_x),y=math.deg(rand_y),z=math.deg(rand_z)})
        time = time+1
    end
    self.logoSchedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(logoShake,0,false)
end

function TDScene:getLightSprite()
    self._lightSprite = cc.Sprite:create("light.png")
    self._lightSprite:setBlendFunc(gl.ONE,gl.ONE_MINUS_SRC_ALPHA)
    self._lightSprite:setScale(1.2)
    
    self._lightSprite:setPosition3D(cc.vec3(self.size.width*0.5,self.size.height*0.5,0))

end

--add pointlight
function TDScene:addPointLight(layer)

    --add pointlight
    self._pointLight = cc.PointLight:create(cc.vec3(0,0,-100),cc.c3b(255,255,255),10000)
    self._pointLight:setCameraMask(1)
    self._pointLight:setEnabled(true)

    --add lightsprite
    self:getLightSprite()
    self._lightSprite:addChild(self._pointLight)
    self:addChild(self._lightSprite,10)
    self._lightSprite:setPositionZ(100)

    -- effectNormalMap
    local effectNormalMapped = cc.EffectNormalMapped:create("logo_normal.png");
    effectNormalMapped:setPointLight(self._pointLight)
    effectNormalMapped:setKBump(50)
    self._logo:setEffect(effectNormalMapped)
    
    --action
    local function getBezierAction()
        local bezierConfig1 = {
            cc.p(self.size.width*0.9,self.size.height*0.4),
            cc.p(self.size.width*0.9,self.size.height*0.8),
            cc.p(self.size.width*0.5,self.size.height*0.8)
        }
        local bezierConfig2 = {
            cc.p(self.size.width*0.1,self.size.height*0.8),
            cc.p(self.size.width*0.1,self.size.height*0.4),
            cc.p(self.size.width*0.5,self.size.height*0.4)
        }
        local bezier1 = cc.BezierTo:create(5,bezierConfig1)
        local bezier2 = cc.BezierTo:create(5,bezierConfig2)
        local bezier = cc.Sequence:create(bezier1,bezier2)

        return bezier
    end
    self._lightSprite:runAction(cc.RepeatForever:create(getBezierAction()))
    
    --touch eventlistener
    local function onTouchBegin(touch,event)
        self._lightSprite:stopAllActions()
        
        local location = touch:getLocation()
        self._prePosition = location

        local function movePoint(dt)
            local lightSpritePos = getPosTable(self._lightSprite)
            local point = cc.pLerp(lightSpritePos,self._prePosition,dt*2)
            self._lightSprite:setPosition(point)
            local z = math.sin(math.rad(math.random(0,2*math.pi)))*100+100
            --self._lightSprite:setPositionZ(z)
        end
        self._scheduleMove = cc.Director:getInstance():getScheduler():scheduleScriptFunc(movePoint,0,false)
        
        return true
    end
    local function onTouchMoved(touch,event)
        --again set prePosition
        local location = touch:getLocation()
        self._prePosition = location
        
        self._angle =cc.pToAngleSelf(cc.pSub(location,getPosTable(self._lightSprite)))
    end
    local function onTouchEnded(touch,event)
        --unschedule and stop action
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduleMove)
        self._lightSprite:stopAllActions()
        --self._lightSprite:setPositionZ(100)
        self._lightSprite:runAction(cc.RepeatForever:create(getBezierAction()))      
    end
    
    --add event listener
    local touchEventListener = cc.EventListenerTouchOneByOne:create()
    touchEventListener:registerScriptHandler(onTouchBegin,cc.Handler.EVENT_TOUCH_BEGAN)
    touchEventListener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    touchEventListener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(touchEventListener,layer)
end

function TDScene:onEnter()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function TDScene:onExit()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

return TDScene
