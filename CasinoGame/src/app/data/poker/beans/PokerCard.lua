local PokerCard = class("PokerCard")


function PokerCard:ctor(cardId)
    self.showIdx = 1 
    self.cardId = tostring(cardId)
    local dicCard = DICT_POKER_CARD[self.cardId]
    if dicCard ~= nil then
        self.cardNumber = dicCard.card_number
        self.cardColor = dicCard.card_color
        self.cardType = dicCard.card_type
        self.resName = dicCard.res_name
    else
        self.cardNumber = "1"
        self.cardColor = VP.CARD_COLOR.default
        self.cardType = VP.CARD_TYPE.NORMAL
        self.resName = "poker_back.png"
    end
    self.holdSign=0  --0 否 1 是
    self.dbTable={}
end

function PokerCard:setShowIdx(showIdx)
    self.showIdx = showIdx
end

function PokerCard:getShowIdx()
    return self.showIdx
end

function PokerCard:setCardId(cardId)
    self.cardId = cardId
end

function PokerCard:getCardId()
    return self.cardId
end

function PokerCard:setCardColor(cardColor)
    self.cardColor = cardColor
end

function PokerCard:getCardColor()
    return self.cardColor
end

function PokerCard:setCardType(cardType)
    self.cardType = cardType
end

function PokerCard:getCardType()
    return self.cardType
end

function PokerCard:setHoldSign(holdSign)
    self.holdSign = holdSign
end

function PokerCard:getHoldSign()
    return self.holdSign
end

function PokerCard:setCardNumber(cardNumber)
    self.cardNumber = cardNumber
end

function PokerCard:getCardNumber()
    return self.cardNumber
end

function PokerCard:toDbTable()
    self.dbTable.showIdx=self.showIdx
    self.dbTable.cardId = self.cardId
    self.dbTable.cardNumber = self.cardNumber
    self.dbTable.cardColor = self.cardColor
    self.dbTable.cardType = self.cardType
    self.dbTable.holdSign = self.holdSign
    self.dbTable.resName = self.resName

    return self.dbTable
end

function PokerCard:fromDbTable(dbt)
    self.showIdx=dbt.showIdx
    self.cardId=dbt.cardId 
    self.cardNumber=dbt.cardNumber
    self.cardColor=dbt.cardColor 
    self.cardType=dbt.cardType
    self.holdSign=dbt.holdSign
    self.resName = dbt.resName
    return self
end

function PokerCard:clone()
    local card=PokerCard.new(self.cardId)
    card.showIdx=self.showIdx
    card.cardId = self.cardId
    card.cardNumber = self.cardNumber
    card.cardColor = self.cardColor
    card.cardType = self.cardType
    card.holdSign = self.holdSign
    return card
end

function PokerCard:toString()
    local str=string.format("[showIdx=%s,cardId=%s,cardNumber=%s,cardColor=%s,holdSign=%s]",tostring(self.showIdx),tostring(self.cardId),tostring(self.cardNumber),tostring(self.cardColor),tostring(self.holdSign))
    return str
end

return PokerCard