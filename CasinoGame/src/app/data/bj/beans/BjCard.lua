local BjCard = class("BjCard")


function BjCard:ctor(cardId)
    self.cardId = tostring(cardId)
    local dicCard = BJ.DICT_BJ_CARD[self.cardId]
    if dicCard ~= nil then
        self.cardNumber = dicCard.card_number
        self.cardNumber1 = tonumber(dicCard.card_number1)
        self.cardNumber2 = tonumber(dicCard.card_number2)
        self.cardColor = dicCard.card_color
        self.resName = dicCard.res_name
    else
        self.cardNumber =""
        self.cardNumber1 = 0
        self.cardNumber2 = 0
        self.cardColor = BJ.CARD_COLOR.default
        self.cardType = BJ.CARD_TYPE.NORMAL
        self.resName = "poker_back.png"
    end
    self.dbTable={}
end

function BjCard:toDbTable()
    self.dbTable.cardId = self.cardId
    self.dbTable.cardNumber = self.cardNumber
    self.dbTable.cardNumber1 = self.cardNumber1
    self.dbTable.cardNumber2 = self.cardNumber2
    self.dbTable.cardColor = self.cardColor
    self.dbTable.resName = self.resName
    return self.dbTable
end

function BjCard:fromDbTable(dbt)
    self.cardId=dbt.cardId 
    self.cardNumber=dbt.cardNumber
    self.cardNumber1=dbt.cardNumber1
    self.cardNumber2=dbt.cardNumber2
    self.cardColor=dbt.cardColor
    self.resName=dbt.resName
    return self
end

function BjCard:toString()
    local str=string.format("[cardId=%s,cardNumber1=%s,cardColor=%s]",tostring(self.cardId),tostring(self.cardNumber1),tostring(self.cardColor))
    return str
end

return BjCard