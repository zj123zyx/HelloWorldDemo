
local TxsCard=require("app.data.txspoker.beans.TxsCard")
local TxsGameSet=require("app.data.txspoker.beans.TxsGameSet")
local TxsRound=require("app.data.txspoker.beans.TxsRound")
local TxsApi = require("app.data.txspoker.TxsApi")
local TxsCalculation = require("app.data.txspoker.calculation.TxsCalculation")

function testTxsDeal()

    print("TxsTestCase testTxsDeal()")

    local aar={}
    for i=1,5 do
        local card=TxsCard.new(i)
        table.insert(aar,card)
    end
    

    
    --从大到小排序
        local function comps(a,b)
            return tonumber(a.cardNumber) <= tonumber(b.cardNumber)
        end
        --table.sort(aar,comps)
        quick_sort_DESC(aar,comps)
        for i=1,#aar do
            print("aar[i].cardId",aar[i].cardId,aar[i].cardNumber)
        end

    
    local txsGameSet=TxsGameSet.new(400)
    txsGameSet.anteBet=5
    txsGameSet.aaBet=10
    local txsRound=TxsApi.deal(txsGameSet)
    print(table.serialize(txsRound:toDbTable()))
    print("===========call==================")
    txsRound=TxsApi.call(txsGameSet)
    print(table.serialize(txsRound:toDbTable()))
end

function testpickMaxCardArray()
    local userCardArray={}
    table.insert(userCardArray,TxsCard.new(8))
    table.insert(userCardArray,TxsCard.new(42))
    local commonCardArray={}
    table.insert(commonCardArray,TxsCard.new(43))
    table.insert(commonCardArray,TxsCard.new(15))
    table.insert(commonCardArray,TxsCard.new(35))
    table.insert(commonCardArray,TxsCard.new(31))
    table.insert(commonCardArray,TxsCard.new(34))
    
    TxsCalculation.pickMaxCardArray(userCardArray,commonCardArray)
end

function testTxsPoker()
    local txsGameSet=TxsGameSet.new(401)
    txsGameSet.anteBet=5
    local txsRound=TxsApi.texasDeal(txsGameSet)
    print(table.serialize(txsRound:toDbTable()))
    print("===========texasCall==================")
    txsRound=TxsApi.texasCall(txsGameSet)
    print(table.serialize(txsRound:toDbTable()))
    print("===========texasBetUp1==================")
    txsRound=TxsApi.texasBetUp(txsGameSet)
    print(table.serialize(txsRound:toDbTable()))
    print("===========texasBetUp2==================")
    txsRound=TxsApi.texasBetUp(txsGameSet)
    print(table.serialize(txsRound:toDbTable()))
end

