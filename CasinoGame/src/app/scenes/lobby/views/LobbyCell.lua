local LobbyCell = {}

function LobbyCell.extendFreeBonus(target, mgr)

    local function formatTimer(isecs)

        isecs = math.ceil(isecs)

        local function formatSTR(num)
            if num < 10 then
                num = '0'..num
            end
            return num
        end

        local hor = math.modf(isecs/(60 * 60))
        local min = math.modf((isecs - hor * 60 * 60)/60)
        local sec = isecs - hor * 60 * 60 - min * 60

        hor = formatSTR(hor)
        min = formatSTR(min)
        sec = formatSTR(sec)

        local timeStr = hor..':'..min..':'..sec

        return timeStr
    end

    target.scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    target.timeleftLabel = mgr.timeleft
    target.collect = mgr.collect
    target.luckywheel = mgr.luckywheel
    target.progressNode = mgr.progressNode
    target.rewardCnt = mgr.rewardCnt
    --target.time_frame = mgr.time_frame

    target:setNodeEventEnabled(true)


    function target:initReward(args)

        if args then
            target.index = args.index
            target.state = args.state
            target.timeLeft = args.timeLeft
            target.totalTime = args.totalTime
        end

        print("initReward--------",target.index, target.state, target.timeLeft, target.totalTime)

        if target.state == 1 then
            if target.index == 4 then
                target.luckywheel:setVisible(true)
                target.collect:setVisible(false)
                target.progressNode:setVisible(false)
            else
                target.luckywheel:setVisible(false)
                target.collect:setVisible(true)
                target.progressNode:setVisible(true)
            end

            target.rewardCnt:setString(tostring(target.rewardCoins))
        else
            target.collect:setVisible(false)
            target.luckywheel:setVisible(false)
            target.progressNode:setVisible(true)

            target:startTimer()
        end

        for i=1,5 do
            target["plan"..tostring(i)] = mgr["plan"..tostring(i)]
            if i > target.index then
                target["plan"..tostring(i)]:setVisible(false) 
            else
                target["plan"..tostring(i)]:setVisible(true) 
            end
        end

        if target.state == 1 then
            target["plan"..tostring(target.index+1)]:setVisible(true) 
        end
        
        --target:setProgress()
    end


    function target:initProgress()

        local expX,expY = target.time_frame:getPosition()
        local parent = target.time_frame:getParent()
        
        target.time_frame:removeFromParent(false)

        target.timeProgress = display.newProgressTimer(target.time_frame, display.PROGRESS_TIMER_BAR)
            :pos(expX, expY)
            :addTo(parent)

        target.timeProgress:setMidpoint(cc.p(0, 0))
        target.timeProgress:setBarChangeRate(cc.p(1, 0))
        
    end

    function target:setProgress()
        local percent = 100 * ( target.totalTime - self.timeLeft ) / target.totalTime
        target.timeProgress:setPercentage(percent)
    end

    function target:endTimer()
        if target.schEntry  then 
            target.scheduler.unscheduleGlobal(target.schEntry) 
            target.schEntry = nil
        end
    end
    
    function target:startTimer()

        local tick = function(dt)
            --print(dt)
            self.timeLeft = self.timeLeft - dt

            self.timeleftLabel:setString(formatTimer(self.timeLeft))

            if self.timeLeft < 0 then 
                self:endTimer()
                self.state = 1
                self:initReward()
            end

        end

        self.schEntry = self.scheduler.scheduleGlobal(tick , 0)
    end

    function target:onExit()
        self:endTimer()
    end

    target.rewardCoins = app.freeBonusData.rewardCoins
    target:initReward(app.freeBonusData)

    target.timeleftLabel:enableOutline(cc.c4b(32, 32, 32, 255), 2);

    target.timeleftLabel:setString(formatTimer(target.timeLeft))

end

-------------------------------------------
-- extendAdCell
-------------------------------------------
function LobbyCell.extendAdCell(adCell, container, spAdId)

    local schEntry, secTimer, counter = nil, 0, 1000
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

    adCell:setNodeEventEnabled(true)

    local function formatTimer(dtime)

        local hor, min, sec, timeStr
        dtime = math.ceil(dtime)

        local function formatTime(num)
            if num < 10 then
                num = '0'..num
            end
            return num
        end

        hor = math.modf(dtime/(60 * 60))
        min = math.modf((dtime - hor * 60 * 60)/60)
        sec = dtime - hor * 60 * 60 - min * 60

        hor = formatTime(hor)
        min = formatTime(min)
        sec = formatTime(sec)

        timeStr = hor..':'..min..':'..sec

        return timeStr
    end

    local function tick(dt)

        secTimer = secTimer + dt
        if secTimer >= 1 and counter >= 1 and container then
                
            secTimer = 0
            counter = counter - 1
            container.ad_timer:setString(formatTimer(counter))

        elseif counter <= 0 or not container then

            scheduler.unscheduleGlobal(schEntry) 
            schEntry = nil

        end

    end

    function adCell:onEnter()
       local function callback(leftTime)
            if not self then return end
            counter = leftTime
            schEntry = scheduler.scheduleGlobal(tick , 0)
        end
        AdMgr.updataSpAdTimer(spAdId, callback)
    end

    function adCell:onExit()
        if schEntry then
            scheduler.unscheduleGlobal(schEntry) 
            schEntry = nil
        end
    end

end

-------------------------------------------
-- 加载老虎机列表项
-------------------------------------------
function LobbyCell.extendSlotsCell(cell, container, machineId)

    print("machineId", machineId)
    local minBet = DICT_MACHINE[tostring(machineId)].bet_list[1]
    minBet = minBet * #DICT_MACHINE[tostring(machineId)].used_lines
    container.minbet:setString(minBet)

end

return LobbyCell
