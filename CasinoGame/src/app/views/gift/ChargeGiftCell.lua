local Cell = class("ChargeGiftCell", function()
    return display.newNode()
end)

function Cell:ctor(args)
    self.viewNode  = CCBReaderLoad("lobby/present/charge_gift_cell.ccbi", self)
    self:addChild(self.viewNode)
    self.gift = args
    self.coinNode:setVisible(false)
    self.gemNode:setVisible(false)
    if args.type == "1" then
        self.gemNode:setVisible(false)
        self.coinNode:setVisible(false)
        self.freecharge:setVisible(true)
        self.img_vip:setVisible(false)
    elseif args.type == "2" then
        self.freecharge:setVisible(false)
        if args.currency == "1000" then
            self.gemNode:setVisible(false)
            self.coinNode:setVisible(true)
            self.coinValue:setString(args.price)
        else
            self.gemNode:setVisible(true)
            self.coinNode:setVisible(false)
            self.gemValue:setString(args.price)
        end

        local playerVipLevel = app:getUserModel():getVipLevel()

        if false then -- cost gem not viplevel
       -- if tonumber(args.vipLevel) > 0 and playerVipLevel < tonumber(args.vipLevel) then
            local  vipSpriteFrame = "head_"..DICT_VIP[args.vipLevel].alias..".png"
            self.img_vip:setSpriteFrame(vipSpriteFrame)--礼物
        else
            self.img_vip:setVisible(false)
        end

    end

    self.name:enableOutline(cc.c4b(64, 64, 64, 128), 2);
    self.lifeLable:enableOutline(cc.c4b(64, 64, 64, 128), 2);
    self.gemValue:enableOutline(cc.c4b(64, 64, 64, 128), 2);
    self.coinValue:enableOutline(cc.c4b(64, 64, 64, 128), 2);
    self.content:enableOutline(cc.c4b(64, 64, 64, 128), 2);

    if self.name then
        self.name:setString(args.name)
    end

    if self.content then
        self.content:setString(args.desc)
    end

    if self.lifeLable then
        if args.life_time[1] == 1 then
            self.lifeLable:setString(args.life_time[2].." day")
        elseif args.life_time[1] == 2 then
            self.lifeLable:setString(args.life_time[2].." hour")
        elseif args.life_time[1] == 3 then
            self.lifeLable:setString(args.life_time[2].." min")
        end
    end
    self.giftSprite:setSpriteFrame(args.picture)

end

return Cell
