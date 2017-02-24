local TaskCell = class("TaskCell", function()
    return display.newNode()
end)

function TaskCell:ctor(task)
    self.viewNode  = CCBReaderLoad("lobby/task/task_cell.ccbi", self)
    self:addChild(self.viewNode)

    local size = self.viewNode:getContentSize()
    self:setContentSize(size)
    self.task = task
    self:initUI()
end

function TaskCell:initUI()
    --    required int32 taskId = 1;
    --    required string content = 2;
    --    required int32 target = 3;			//目标值
    --    required int32 currentValue = 4; 	//当前值
    --    required int32 state = 5;			//状态 0未完成 1已完成 2已领取
    --    required int32 rewardType = 6;		//奖励类型  1000金币 1003宝石
    --    required int32 rewardCnt = 7;		//奖励数量
    --    optional string picture = 8;

    local lf = self.btn_collect:getTitleLabelForState(cc.CONTROL_STATE_NORMAL)
    
    --lf:enableShadow(cc.c4b(53, 119, 0, 255), cc.size(2,-2))
    lf:enableOutline(cc.c4b(32, 32, 32, 128), 2);


    --self.state_name:enableShadow(cc.c4b(53, 119, 0, 255), cc.size(2,-2))
    --self.task_name:enableOutline(cc.c4b(32, 32, 32, 128), 2);

    --self.task_pic:setSpriteFrame(self.task.picture)
    local expX,expY = self.progress_sprite:getPosition()
    local parent = self.progress_sprite:getParent()
    self.progress_sprite:removeFromParent(false)
    self.expProgress = display.newProgressTimer(self.progress_sprite, display.PROGRESS_TIMER_BAR)
    :pos(expX, expY)
    :addTo(parent)

    self.expProgress:setMidpoint(cc.p(0, 0))
    self.expProgress:setBarChangeRate(cc.p(1, 0))
    self.expProgress:setPercentage(100*(self.task.currentValue) / self.task.target)

    local str_name,str_content = self.task.content,""
    local index, indexEnd= string.find(self.task.content," in")
    if index then
        str_name = string.sub(self.task.content,1,index)
        str_content = string.sub(self.task.content,index+1,-1)
    end

    self.task_name:setString(str_name)
    self.task_content:setString(str_content)
    self.progress_text:setString(tostring(self.task.currentValue).."/"..tostring(self.task.target))
    self.reward_count:setString(tostring(self.task.rewardCnt))


    if self.task.state == 0 then
        self.btn_collect:setVisible(false)
    elseif self.task.state == 1 then
        self.btn_collect:setVisible(true)
    elseif self.task.state == 2 then
        self.btn_collect:setVisible(false)
    end

    if self.task.rewardType == ITEM_TYPE.NORMAL_MULITIPLE then
        self.rewardIcon:setSpriteFrame("gold.png")
        self.rewardImage = "gold.png"
    elseif self.task.rewardType == ITEM_TYPE.GEMS_MULITIPLE then
        self.rewardIcon:setSpriteFrame("gems.png")
        self.rewardImage = "gems.png"
    end
end

function TaskCell:onClicked(event)
    return (self.btn_collect:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) and self.btn_collect:isVisible()),self.rewardIcon,self.rewardImage
end

return TaskCell