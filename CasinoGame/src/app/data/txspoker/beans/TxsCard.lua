local TxsCard = class("TxsCard")


function TxsCard:ctor(cardId)
    self.cardId = tostring(cardId)
    local dicCard = TXS.DICT_TXS_CARD[self.cardId]
    if dicCard ~= nil then
        self.cardNumber = dicCard.card_number
        self.cardColor = dicCard.card_color
        self.cardType = dicCard.card_type
        self.resName = dicCard.res_name
    else
        self.cardNumber = "0"
        self.cardColor = TXS.CARD_COLOR.default
        self.cardType = TXS.CARD_TYPE.NORMAL
        self.resName = "poker_back.png"
    end
    self.isShow=1 --是否显示 0 否 1 是 
    self.winSign=0  --是否获胜牌 0 否 1 是
    self.dbTable={}
end

function TxsCard:toDbTable()
    self.dbTable.cardId = self.cardId
    self.dbTable.cardNumber = self.cardNumber
    self.dbTable.cardColor = self.cardColor
    self.dbTable.cardType = self.cardType
    self.dbTable.isShow = self.isShow
    self.dbTable.winSign = self.winSign
    self.dbTable.resName = self.resName
    return self.dbTable
end

function TxsCard:fromDbTable(dbt)
    if dbt==nil or table.isEmpty(dbt)==true then
        return self
    end

    self.cardId=dbt.cardId 
    self.cardNumber=dbt.cardNumber
    self.cardColor=dbt.cardColor 
    self.cardType=dbt.cardType
    self.isShow=dbt.isShow
    self.winSign=dbt.winSign
    self.resName=dbt.resName
    return self
end

return TxsCard