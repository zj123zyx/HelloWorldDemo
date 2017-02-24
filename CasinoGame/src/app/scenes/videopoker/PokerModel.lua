require("app.data.poker.DictPokerConstants")

local PokerModel = class("PokerModel", data.serializeModel)

PokerModel.SPIN_GAME_EVENT         = "SPIN_GAME_EVENT"
PokerModel.DRAW_CARD_EVENT         = "DRAW_CARD_EVENT" --发牌事件

PokerModel.wincoinskey              = "wincoins"
PokerModel.betkey                   = "bet"
PokerModel.pokerresultkey           = "pokerresult"
PokerModel.bestpokerkey           = "bestpokerkey"

PokerModel.schema                                   = clone(cc.mvc.ModelBase.schema)
PokerModel.schema[PokerModel.wincoinskey]           = {"number", 0}
PokerModel.schema[PokerModel.betkey]                = {"number", 0}
PokerModel.schema[PokerModel.pokerresultkey]        = {"table", {}}
PokerModel.schema[PokerModel.bestpokerkey]        = {"table", {}}


function PokerModel:ctor(properties)
    PokerModel.super.ctor(self, properties)

    if self.loadModel ~= nil then
        self:loadModel()
    end
end

function PokerModel:getWinCoins()
    return self.wincoins_
end

function PokerModel:onWin(items)
    if items.type == 1 then
        self.wincoins_ = items.count
    end
end

function PokerModel:setBet(val)
    self.bet_ = val
end

function PokerModel:getBet()
    return self.bet_
end

function PokerModel:getPokerResult()
    return self.pokerresult_
end

function PokerModel:getPokerSuit()

    -- print("--getPokerSuit--")
    local pokersuit = {}
    for k,v in pairs(self.bestpokerkey_) do
        -- print(k,v,v.resName)
        pokersuit[v.resName] = v.resName
    end
    -- print("--getPokerSuit--")

    return pokersuit
end

function PokerModel:updatePokerResult(pr)
    --print("PokerModel:updatePokerResult",pr)
    self.pokerresult_=pr
    self:serializeModel()
end

function PokerModel:getBestPoker()
    return self.bestpokerkey_
end

function PokerModel:updateBestPoker(pr)
    self.bestpokerkey_=pr
    self:serializeModel()
end

return PokerModel
