local WinChip = class("WinChip", function()
    return display.newNode()
end)

function WinChip:ctor(value)
    local arr = {}
    local x,y = 0,0
    local items = DictUtil.getChipsByValue(value)
    for k, v in pairs(items) do
        local item = DictUtil.getChipItem(k)
        for i = 1, v do
            local sp = display.newSprite("#"..item.picture)
            table.insert(arr,sp)
            local len = #arr
            if len > 15 then len = 15 end

            sp:setPosition(x+len*2 ,y+len*2)
            self:addChild(sp)
        end
    end
    self.value = value
    self:setNodeEventEnabled(true)
end

function WinChip:showText()
    local label = display.newTTFLabel({
        text =  self.value,
        font = "Helvetica-Bold",
        color = cc.c3b(255, 168, 0),
        size = 22,
        align = cc.TEXT_ALIGNMENT_CENTER
    })
    label:setPositionY(-30)
    label:enableOutline(cc.c4b(0, 0, 0, 200), 2)

    self:addChild(label)
    self.text = label
end

function WinChip:onExit()
    self:removeAllNodeEventListeners()
    self = {}
end

return WinChip

