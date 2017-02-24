scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
data = require("app.data.init")
scn = require("app.scenes.lobby.init") 
EventMgr = require("app.event.EventManager").instance()
core = require("app.core.init") 
net = require("app.interface.init") --网络

-- SlotsMgr = require("app.scenes.slots.SlotsManager")
-- SymbolMgr = require("app.scenes.slots.SymbolManager")

-- AdMgr = require("app.scenes.Advertisement.AdvertisementManager")

controllBase = require("app.scenes.common.ControllBarBase")
headViewClass = require("app.scenes.common.HeadView")
AppBase = require("framework.cc.mvc.AppBase")
ToolUtils = require("app.core.ToolUtils")

require("app.res")
require("app.scenes.fish.init") --网络
