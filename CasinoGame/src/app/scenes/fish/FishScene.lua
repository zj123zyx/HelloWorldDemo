local fishctr = import("app.scenes.fish.controllers.FishController")

-----------------------------------------------------------
-- FishScene 
-----------------------------------------------------------
local FishScene = class("FishScene", function()
    return display.newScene("FishScene")
end)


-----------------------------------------------------------
-- @Construct:
-- initData
-----------------------------------------------------------
function FishScene:ctor( homeinfo )

	if not app:isObjectExists("FishModel") then
        local ModelClass = require("app.scenes.fish.models.FishModel")
        local model = ModelClass.new({id = "FishModel"})
        app:setObject("FishModel", model)
    end

    self.ctr_ = fishctr.new(homeinfo)
    self:addChild(self.ctr_)

    self.sceneTotaltime = 0
end


-----------------------------------------------------------
-- update 
-----------------------------------------------------------
function FishScene:update( dt )
   
    SceneManager.scnTotalTime = SceneManager.scnTotalTime + dt

    self.ctr_:update( dt )

end
-----------------------------------------------------------
-- onEnter
-----------------------------------------------------------
function FishScene:onEnter()

    print("FishScene:onEnter")
	
    audio.playMusic("fish/audio/bg_01.mp3")
    
    SceneManager.scnTotalTime=0
    
    self.scheduleObj = scheduler.scheduleGlobal(function(dt)
        self:update(dt)
    end, 0)
end

-----------------------------------------------------------
-- onExit
-----------------------------------------------------------
function FishScene:onExit()

    print("FishScene:onExit")
    scheduler.unscheduleGlobal(self.scheduleObj)

	audio.stopMusic()
	FishManager.release()
end

return FishScene
