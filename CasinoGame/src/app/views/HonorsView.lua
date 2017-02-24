local HonorCell = require("app.views.HonorCell")

local tabBase = require("app.views.TabBase")

local HonorsView = class("HonorsView", tabBase)

function HonorsView:ctor(val)
    self.viewNode  = CCBReaderLoad("lobby/honor/honors.ccbi", self)
    self:addChild(self.viewNode)

    self.honors = val

    self:registerUIEvent()

    self:addAllHonorList(self.honors)
    app:getUserModel():setProperty(scn.models.UserModel.hashonor, 0)

    EventMgr:dispatchEvent({name = EventMgr.UPDATE_LOBBYUI_EVENT})
    
    
end

function HonorsView:registerUIEvent()
    core.displayEX.extendButton(self.btn_close)
    self.btn_close.clickedCall = function()
        scn.ScnMgr.removeView(self)
    end
end

function HonorsView:addAllHonorList(honorlist)

    local box = self.contentRect:getBoundingBox()
    
    self.honorsList = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = box,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onHonorlistListener))
        :addTo(self.tabPanel)

-- add items

    local listnum = #honorlist

    local honorsAll = {}
    honorsAll["COMMON"] = {}
    honorsAll["SLOTS"] = {}
    honorsAll["VIDEO_POKER"] = {}
    honorsAll["TEXAS_HOLDEM"] = {}
    honorsAll["BLACK_JACK"] = {}

    for i=1,#honorlist do
        local categoryHonor = honorsAll[honorlist[i].category]
        if categoryHonor then
            categoryHonor[#categoryHonor + 1] = honorlist[i]
        end
    end

    local addSubHonor = function(key, subhonorsList)
        -- body
        local item = self.honorsList:newItem()
        local cell = CCBReaderLoad("lobby/honor/honor_cell_sp.ccbi", self)

        self.hTitle:setSpriteFrame(gameTitleTxt[key])

        local itemsize = cell:getContentSize()
        cell:setPositionX(box.width/2)

        item:addContent(cell)
        item:setItemSize(itemsize.width, itemsize.height)
        self.honorsList:addItem(item)

        local num = #subhonorsList

        for i=1, num do

            local honor = subhonorsList[i]
            
            local item = self.honorsList:newItem()
            local cell = HonorCell.new(honor, self.isme)
            local itemsize = cell:getContentSize()
            cell:setPositionX(box.width/2)
            item:addContent(cell)
            item:setItemSize(itemsize.width, itemsize.height)
            self.honorsList:addItem(item)

        end
    end

    addSubHonor("SUMMARY", honorsAll["COMMON"])
    addSubHonor("SLOTS", honorsAll["SLOTS"])
    addSubHonor("VIDEO_POKER", honorsAll["VIDEO_POKER"])
    addSubHonor("TEXAS_HOLDEM", honorsAll["TEXAS_HOLDEM"])
    addSubHonor("BLACK_JACK", honorsAll["BLACK_JACK"])

    self.honorsList:reload()
end


function HonorsView:onHonorlistListener(event)

    local listView = event.listView

    if "clicked" == event.name then

        local cell = event.item:getContent()
        if cell then cell:onClicked(event) end

    elseif "moved" == event.name then
        --self.bListViewMove = true
    elseif "ended" == event.name then
        --self.bListViewMove = false
    else
        print("event name:" .. event.name)
    end

end


function HonorsView:onExit()
end

return HonorsView
