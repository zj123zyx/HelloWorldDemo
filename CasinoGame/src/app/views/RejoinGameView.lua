local RejoinGameView = class("RejoinGameView", function()
	return core.displayEX.newSwallowEnabledNode();
end)



function RejoinGameView:ctor(args)
	self.viewNode = CCBuilderReaderLoad("view/RejoinGameView.ccbi",self)
	self:addChild(self.viewNode)

	--self.title:enableOutline(cc.c4b(64, 64, 64, 255), 3);

	--self.lbl_content:enableOutline(cc.c4b(64,64,64,255),2)
	self.args = args
	self:registerEvent()
end

function RejoinGameView:registerEvent()
	core.displayEX.newButton(self.btn_gomain)
		:onButtonClicked(function(event)
			print(" go main")

			self.args.callback1()
		end)
	core.displayEX.newButton(self.btn_rejoin)
		:onButtonClicked(function(event)

			print(" re join")
			self.args.callback2()
		end)
end

return RejoinGameView 
