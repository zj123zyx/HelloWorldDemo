
-----------------------------------------------------------
-- FishModel 
-----------------------------------------------------------
local FishModel = class("FishModel", data.serializeModel)

FishModel.schema                        = clone(cc.mvc.ModelBase.schema)

FishModel.name           				= "name"
FishModel.weaponLevel           		= "weaponLevel"

FishModel.schema[FishModel.name ]      			= {"string", ""}
FishModel.schema[FishModel.weaponLevel]      	= {"number", 1}


-----------------------------------------------------------
-- Construct:
-----------------------------------------------------------
function FishModel:ctor( properties )
	FishModel.super.ctor(self, properties)
	if self.loadModel ~= nil then
        self:loadModel()
    end
end

function FishModel:getWeaponLevel()
    return self.weaponLevel_
end

function FishModel:setWeaponLevel(val)
    self.weaponLevel_=val
    self:serializeModel()
end

return FishModel
