local MsgCell = require("app.views.MessageCell")

local MessageView = class("MessageView", function()
return core.displayEX.newSwallowEnabledNode()
end)

function MessageView:ctor(msgsList)
    self.viewNode  = CCBuilderReaderLoad(RES_CCBI.message, self)
    self:addChild(self.viewNode)

    self.msgsList = msgsList
    self:registerEvent()
    self:initUI()
    app:getUserModel():setProperty(scn.models.UserModel.hasnews, 0)
end

function MessageView:registerEvent()
    -- on close
    core.displayEX.newButton(self.btn_close) 
        :onButtonClicked(function(event)
            scn.ScnMgr.removeView(self)
        end)
end

function MessageView:initUI()
    self:addMsgList()
end

function MessageView:addMsgList()
    app:getUserModel():setProperties({hasnews=-1})
    app:getUserModel():serializeModel()
    EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})--取消红点

    local num = #self.msgsList
    
    print("cells num:", num)

    if num < 1 then 
        return
    end

    self.nomessageHint:setVisible(false)

    local box = self.msgRect:getBoundingBox()
    
    self.msgsListNode = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = box,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onMsglistListener))
        :addTo(self.msgRect:getParent())

-- add items

    self.cells = {}
    
    for i=1, num do
        local item = self.msgsListNode:newItem()
        local msg=self.msgsList[i]
        local msgcell = MsgCell.new({msg=msg,parent=self,closeBtn=self.btn_close})
        
        msgcell.item = item
        msgcell.msgsListNode = self.msgsListNode

        local itemsize = msgcell.viewNode:getContentSize()
        item:setPositionX(box.width/2)

        item:addContent(msgcell)
        item:setItemSize(itemsize.width, itemsize.height)

        self.msgsListNode:addItem(item)


        self.cells[#self.cells] = msgcell
    end

    self.msgsListNode:setDelegate(handler(self, self.msgListDelegate))
    self.msgsListNode:reload()

end

function MessageView:onMsglistListener(event)

    local listView = event.listView


    if "clicked" == event.name then
        --print("event name:" .. event.name)
        --print("item idx :", event.itemPos, event.x, event.y, event.point.x, event.point.y)
        local cell = event.item:getContent()
        print("message:",event.name, cell,event.itemPos)
        if cell then cell:onTouched(event) end

    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        --print("event name:" .. event.name)
    end

end

function MessageView:msgListDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
    elseif cc.ui.UIListView.CELL_TAG == tag then
    else
    end
end


return MessageView