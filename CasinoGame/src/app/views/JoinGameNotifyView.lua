local JoinGameNotifyView = class("JoinGameNotifyView", function()
    return core.displayEX.newSwallowEnabledNode()
end)

function JoinGameNotifyView:ctor(msg)
    self.viewNode  = CCBuilderReaderLoad("view/jointhegameview.ccbi", self)
    self:addChild(self.viewNode)

    --self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

    self.msg = msg.joininfo
    self.senderinfo = msg.senderinfo


    if self.headView == nil then
        self.headView = headViewClass.new({player=self.senderinfo, scale=0.8})
        self.headView:replaceHead(self.player_icon)
        self.headView:showGameName()
        self.headView:registClickHead()
    end
        
    self:registerUIEvent()

end

function JoinGameNotifyView:registerUIEvent()

    local pbtn = core.displayEX.newButton(self.btn_join) 
        :onButtonClicked( function(event)
            app:joinPlayerGame(self.msg)
        end)

    local pbtn = core.displayEX.newButton(self.btn_notnow) 
        :onButtonClicked( function(event)

            scn.ScnMgr.removeView(self)

        end)
end


return JoinGameNotifyView
