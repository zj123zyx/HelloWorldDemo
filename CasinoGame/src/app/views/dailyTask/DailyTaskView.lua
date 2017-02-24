
local TaskCell = require("app.views.dailyTask.TaskCell")

local View = class("DailyTaskView",function()
    return core.displayEX.newSwallowEnabledNode()
end)


function View:ctor(val)
    self.viewNode  = CCBReaderLoad("lobby/task/daily_task.ccbi", self)
    self:addChild(self.viewNode)

    self.mloaded = false
    self.showItemNum = 0
    self:LoadTask()
    self:registerUIEvent()

    self.cell = val.cell

    self.cell.animationManager:runAnimationsForSequenceNamed("normal_anim")
    --self.cell:stopAllActions()
    app:getUserModel():setProperty(scn.models.UserModel.hastask, 0)
end

function View:LoadTask()
    if not self.mloaded then
        net.DailyTaskCS:getDailyTaskList(function(tasklist)
            self.mloaded = true
            app:getUserModel():setProperties({hastask=-1})
            app:getUserModel():serializeModel()
            self:addTaskList(tasklist)
        end)
    end
end

function View:addTaskList(tasklist)
    local box = self.content_rect:getBoundingBox()
    self.tasksListView = cc.ui.UIListView.new {
        --bgColor = cc.c4b(255, 0, 0, 120),
        bg = nil,
        bgScale9 = false,
        viewRect = box,
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = nil}
        :onTouch(handler(self, self.onTasklistListener))
        :addTo(self.panel_node)

-- add items
    local listnum = #tasklist
    local isComplated = true
    if listnum > 0 then
        table.sort(tasklist,function(a,b) return a.state > b.state end)
        for i=1, listnum do
            local task = tasklist[i]
            if task.state ~= 2 then
                local item = self.tasksListView:newItem()
                local cell = TaskCell.new(task)
                local itemsize = cell:getContentSize()
                cell:setPositionX(box.width/2)
                item:addContent(cell)
                item:setItemSize(itemsize.width, itemsize.height)
                self.tasksListView:addItem(item)
                self.showItemNum = self.showItemNum + 1
                isComplated = false
            end
        end
    end
    if isComplated then
        self.all_completed:setVisible(true)
    else
        self.tasksListView:reload()
        self.all_completed:setVisible(false)
    end
end

function View:onTasklistListener(event)
    if "clicked" == event.name and event.item then
        local cell = event.item:getContent()
        if cell then
            local on_clicked,ctl,image = cell:onClicked(event)
            if on_clicked then
                net.DailyTaskCS:getTaskReward(cell.task.taskId, function(msg)
                    -- body
                    if msg.result == 1 then
                        self.btn_close:setButtonEnabled(false)
                        local function callback()
                            self.btn_close:setButtonEnabled(true)
                            local totalCoins = app:getUserModel():getCoins() + msg.rewardCoins
                            local totalGems = app:getUserModel():getGems() + msg.rewardGems
                            app:getUserModel():setCoins(totalCoins)
                            app:getUserModel():setGems(totalGems)
                            EventMgr:dispatchEvent({name  = EventMgr.UPDATE_LOBBYUI_EVENT})
                            self.tasksListView:removeItem(event.item,true)
                            self.showItemNum = self.showItemNum - 1
                            if self.showItemNum <= 0 then
                                self.all_completed:setVisible(true)
                            end
                        end
                        AnimationUtil.CollectRewards("#"..image,10,ctl, app.coinSprite,callback)
                    end

                end)
            end
        end
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    else
        print("event name:" .. event.name)
    end
end


function View:registerUIEvent()
    core.displayEX.extendButton(self.btn_close)
    self.btn_close.clickedCall = function()
        scn.ScnMgr.removeView(self)
    end
end

function View:onExit()
    self = {}
end


return View