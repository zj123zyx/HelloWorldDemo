local BTV = class("CommonTip", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function BTV:ctor(args)
    self.viewNode  = CCBReaderLoad("view/CommonTip.ccbi",self)
    self:addChild(self.viewNode)
    self:setNodeEventEnabled(true)
    if args.title then
        self.lbl_title:enableOutline(cc.c4b(64, 64, 64, 255), 3);
        self.lbl_title:setString(args.title)
        self.lbl_title:setVisible(true)
    else
        self.lbl_title:setVisible(false)
    end

    if args.content then
        self.lbl_content:setString(args.content)
    end
    if args.ok_callback then
        self.ok_callback = args.ok_callback
    end
    if args.cancle_callback then
        self.cancle_callback = args.cancle_callback
    end
end

function BTV:onEnter()
    core.displayEX.extendButton(self.btn_ok)
    self.btn_ok.clickedCall = function()
        if self.ok_callback then
            self.ok_callback()
        end
        scn.ScnMgr.removeView(self)
    end
    core.displayEX.extendButton(self.btn_cancel)
    self.btn_cancel.clickedCall = function()
        if self.cancle_callback then
            self.cancle_callback()
        end
        scn.ScnMgr.removeView(self)
    end
end

function BTV:onExit()
    self:removeAllNodeEventListeners()
end

return BTV
