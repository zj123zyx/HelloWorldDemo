local BjHandSet = class("BjHandSet")

function BjHandSet:ctor(handId,bet)
    self.handId=handId
    self.bet=bet
    self.jbet=0 --J区bet值
    self.insuranceBet=0 --保险金额
    self.dbTable={}
end

function BjHandSet:toDbTable()
    self.dbTable.handId=self.handId
    self.dbTable.bet = self.bet
    self.dbTable.jbet = self.jbet
    self.dbTable.insuranceBet=self.insuranceBet
    return self.dbTable
end

function BjHandSet:fromDbTable(dbt)
    self.handId=dbt.handId
    self.bet=dbt.bet 
    self.jbet=dbt.jbet 
    self.insuranceBet=dbt.insuranceBet 
    return self
end

return BjHandSet