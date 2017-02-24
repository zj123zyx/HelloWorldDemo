-- 大厅的主体内容视口类

local LobbyCell = require("app.scenes.lobby.views.LobbyCell")
local ADBarViewCell = require("app.views.adViews.ADBarViewCell")
local margin = 30

local LobbyView = class("LobbyView", function()
    return display.newNode()
end)

function LobbyView:ctor(args)

    print("jjftest: LobbyView:ctor")
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    -- self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

    self.rect = args.rect
    --local cls = user.class

    -- 通过代理注册事件的好处：可以方便的在视图删除时，清理所以通过该代理注册的事件，
    -- 同时不影响目标对象上注册的其他事件
    --
    -- EventProxy.new() 第一个参数是要注册事件的对象，第二个参数是绑定的视图
    -- 如果指定了第二个参数，那么在视图删除时，会自动清理注册的事件
    --cc.EventProxy.new(user, self)
    --    :addEventListener(cls.GEM_CHANGED_EVENT, handler(self, self.updateLabel_))

    self.viewCenter  = CCBuilderReaderLoad("lobby/lobby.ccbi", self)
    self:addChild(self.viewCenter)
    
    self:setNodeEventEnabled(true)

    -- -- Members
    -- self.hasUpdate = false

    -- self.hasaddAD = false
    -- self.ADPageWidth = 40 + display.width/4 + (display.height-640) * 0.10
    -- --self.ADPageWidth = 270 + (display.height-640) * 0.10

    -- self.curLayoutIdx = nil
    -- self.oldLayoutIdx = nil

    self:registerUIEvent()

    self:Layout()
end

function LobbyView:registerUIEvent()

    core.displayEX.newButton(self.guestLogin) 
        :onButtonClicked( function(event)
            print("guestLogin showFishView")
            self:dispatchEvent({name = "showFishView"})
        end)

end

-- function LobbyView:setHomeBtnVisible(isShow)
--     if self.gamectr_ then
--         self.gamectr_.btn_lobby:setVisible(isShow)
--     else
--         print("-----------------------GameController:setHomeBtnVisible(isShow) nil")
--     end
-- end

function LobbyView:onEnter()

    -- if app.layoutId then
    --     self:addGameList(tostring(app.layoutId))
    --     self.curLayoutIdx = app.layoutId
    --     self.oldLayoutIdx = "1"
    -- else
    --     self:addGameList("1")
    -- end

    EventMgr:addEventListener(EventMgr.UPDATE_PLAYERS_EVENT, handler(self, self.updatePlayers))
    EventMgr:addEventListener(EventMgr.UPDATE_LOBBYUI_EVENT, handler(self, self.updateUIState))

end

function LobbyView:onExit()
    --core.SocketNet:unregistEvent(GC_GET_FRIEND_LIST)
    --core.SocketNet:unregistEvent(GC_GET_ONLINE_PLAYERS)
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_PLAYERS_EVENT)
    EventMgr:removeEventListenersByEvent(EventMgr.UPDATE_LOBBYUI_EVENT)

    if self.schEntry then
        self.scheduler.unscheduleGlobal(self.schEntry)
        self.schEntry = nil
    end
    self.hasaddAD = false
    core.SocketNet:unregistEvent(GC_GET_AD_LIST)
end

function LobbyView:updateUIState(event)

    for i,v in ipairs(self.gamesList.items_) do

        if v.cells then
            local cellnum = #v.cells
            
            for count = 1, cellnum do
                local cell = v.cells[count]
                local down = app:getUserModel():getUnitDownLoad(cell.unit.zipname)
                if down ~= nil and tonumber(down.needdown)==1 and down.hasdown==1 then
                    if cell.downloadSign then
                        cell.downloadSign:setVisible(false)
                    end
                end
            end
        end

    end
    
end

function LobbyView:updatePlayers(event)

    self.players = event.list

    local getInfo =function(pid)
        -- body
        for i=1,#self.players do
            local info = self.players[i]
            if pid == info.pid then
                return info
            end
        end
    end

    if self.hasUpdate == false then

        -- local idx = 1

        -- for i=1,#self.gamesList.items_ do
        --     local  item = self.gamesList.items_[i]
        --     if item.isgame == false then
        --         local cellnum = #item.cells
        --         for count = 1, cellnum do
        --             local cell = item.cells[count]
        --             local info = self.players[idx]
        --             if info then
        --                 cell.pid = info.pid
        --                 cell.name:setString(info.name)
        --                 cell.head:setSpriteFrame(HEAD_IMAGE[info.pictureId])
        --             end
        --             idx = idx + 1
        --         end
        --     end
        -- end


        --self:addPlayers()

        self.hasUpdate = true
    else

        for i=1,#self.gamesList.items_ do
            local  item = self.gamesList.items_[i]
            if item.isgame == false then

                local cellnum = #item.cells
                
                for count = 1, cellnum do
                    local cell = item.cells[count]
                    local info = getInfo(cell.pid)
                    if info then
                        cell.name:setString(info.name)
                        if cc.SpriteFrameCache:getInstance():getSpriteFrame(HEAD_IMAGE[info.pictureId]) then
                            cell.head:setSpriteFrame(display.newSpriteFrame(HEAD_IMAGE[info.pictureId]))
                        end
                    end
                end

            end
           
        end
    end
    
end

-- -- 加载一个列表项，如大厅列表，二级游戏列表
-- function LobbyView:loadCell(unit)

--     -- 加载图片资源
--     local fccbi=SUBPATH.GAMECELL..unit.ccb..FILE_SUFFIX.CCBI
--     local owner = {}
--     local cell = CCBuilderReaderLoad(fccbi, owner)

--     if unit.type == "TimingReward" then
--         --LobbyCell.extendFreeBonus(cell, owner)

--     elseif unit.type == "AD" then
--         local spId = unit.config.special_ad_id
--         --LobbyCell.extendAdCell(cell, owner, spId)

--     -- 加载老虎机的二级游戏列表项
--     elseif unit.type == "Slots" then
--         LobbyCell.extendSlotsCell(cell, owner, unit.dict_id)

--     elseif unit.type == "Task" then
--         if app:getUserModel():getProperty(scn.models.UserModel.hastask) == 6 
--             and cell.animationManager:getRunningSequenceName() ~= "light_anim" then
--             cell.animationManager:runAnimationsForSequenceNamed("light_anim")
--         end

--     else
--         if owner.minbet ~= nil then
--             owner.minbet:setString(unit.config.min_bet)
--             owner.minbet:enableOutline(cc.c4b(0, 0, 0, 255), 2)
--         elseif owner.gems_num ~= nil then
--             owner.gems_num:setString(unit.config.cost_gems)
--             owner.gems_num:enableOutline(cc.c4b(0, 0, 0, 255), 2)
--         end
--     end

--     if unit.type ~= "Layout" and unit.type ~= "Task" then

--         local level = app:getUserModel():getLevel()

--         local isLock = false
--         local iconlevel=( self.iconCnt - 1 ) * 5
--         if iconlevel > level then
--             --isLock = true
--         end

--         isLock = false

--         cell.isLock = isLock

--         if isLock == true then
--             if owner.unlock then owner.unlock:setVisible(true) end
--             if owner.unlockLevel then owner.unlockLevel:setString("Level "..tostring(iconlevel)) end
--         else
--             if owner.unlock then owner.unlock:setVisible(false) end

--             local down = app:getUserModel():getUnitDownLoad(unit.zipname)

--             down = nil

--             if down ~= nil and tonumber(down.needdown)==1 and down.hasdown==0 then
--                 if owner.downloadSign then owner.downloadSign:setVisible(true) end
--             else
--                 if owner.downloadSign then owner.downloadSign:setVisible(false) end
--             end
--         end

--     end

--     cell.downloadSign = owner.downloadSign

--     return cell
-- end

-- function LobbyView:addItem_1_1(colcells)

--     local item = self.gamesList:newItem()

--     local content = display.newNode()
--     local itemsize = {width=0,height=0}
--     item.cells = {}


--     local numCells = #colcells
--     local mrow = self.rect.height /(2*numCells)

--     for cellidx = 1, numCells do

--         local unitidx = colcells[cellidx]


--         local unit = DICT_UNIT[tostring(unitidx)]

--         if unit ~= nil then
           
--             local cell = self:loadCell(unit)

--             local size = cell:getContentSize()

--             itemsize.width = size.width
--             itemsize.height = size.height + itemsize.height

--             local scale = 2*mrow / ( size.height + 6 ) 

--             if scale < 1 then
--                 cell:setScale(scale)
--             end

--             local posY = 0

--             if numCells == 1 then
                
--                 posY = 0

--                 local cellwidth = display.width / 4
--                 itemsize.width = cellwidth

--                 local scale = 2*mrow / ( size.height + 80) 

--                 if (cellwidth - size.width) < 40 then

--                     local scaleW = (cellwidth - 40)/ cellwidth 

--                     if scaleW < scale then
--                         scale = scaleW
--                     end
--                 end

--                 if scale < 1 then
--                     cell:setScale(scale)
--                 end

--             elseif numCells == 2 then

--                 local subPixel = (display.height-640)*0.1

--                 if cellidx == 1 then
--                     posY = mrow - subPixel
--                 else
--                     posY = subPixel - mrow
--                 end
                
--                 itemsize.width = itemsize.width * scale + 15

--             elseif numCells == 3 then

--                 if cellidx == 1 then
--                     posY = -2*mrow
--                 elseif cellidx == 2 then
--                     posY = 0
--                 else
--                     posY = 2*mrow
--                 end

--             end

--             cell:setPositionY(posY)
--             content:addChild(cell)

--             cell.isgame = true
--             cell.idx = cellidx
--             cell.unit = clone(unit)
--             cell.unitidx=unitidx
--             item.cells[#item.cells + 1] = cell

--             self.iconCnt = self.iconCnt + 1

--         end
--     end

--     return content, item, itemsize
-- end

-- function LobbyView:addItem_1_2(colcells)

--     self.AdHeight = (display.height-(display.height - 640) - 200)

--     local item = self.gamesList:newItem()

--     local content = display.newNode()
--     local itemsize = {width=0,height=0}
--     item.cells = {}

--     local numCells = 2
--     local delat = 0.5
--     local designHeight = 416
--     local iphoneHeight = 640

--     --local mrow = (designHeight + delat * (display.height-iphoneHeight))/ (numCells*2)
--     local mrow = self.AdHeight / (numCells*2)

--     local cellIdx = {}
--     cellIdx[1] = colcells[1]
--     cellIdx[2] = colcells[2][1]
--     cellIdx[3] = colcells[2][2]

--     for cellidx = 1, 3 do

--         local unitidx = cellIdx[cellidx]

--         local unit = DICT_UNIT[tostring(unitidx)]

--         if unit ~= nil then

--             local cell = self:loadCell(unit)

--             if cellidx == 1 then
--                 itemsize.width = 1.35 * display.width/4  
--                 itemsize.height = mrow*2 + itemsize.height
--             elseif cellidx == 2 then
--                 itemsize.height = mrow*2 + itemsize.height
--             end

--             local posY = 0
--             local posX = 0

--             if cellidx == 1 then
--                 posY = mrow
--             else
--                 posY = -mrow
                
--                 if cellidx == 2 then
--                     posX = -itemsize.width/4
--                 elseif cellidx == 3 then
--                     posX = itemsize.width/4
--                 end
--             end
                
--             cell:setPositionX(posX)
--             cell:setPositionY(posY)
--             content:addChild(cell)

--             cell.isgame = true
--             cell.idx = cellidx
--             cell.unit = clone(unit)
--             cell.unitidx=unitidx
--             item.cells[#item.cells + 1] = cell

--         end
--     end

--     --self.AdHeight = (designHeight + 0.5 * (display.height-iphoneHeight) * 0.5 ) - 6
--     --self.AdHeight = (display.height-160) * 0.85

--     return content, item, itemsize
-- end

-- function LobbyView:addGameList(layoutIdx)

--     self.oldLayoutIdx = self.curLayoutIdx
--     self.curLayoutIdx = layoutIdx

--     if self.gamesList then 
        
--         self.gamesList:onCleanup() 
--         self.gamesList:removeAllItems()
        
--         if self.hasaddAD == true then

--             if self.schEntry then
--                 self.scheduler.unscheduleGlobal(self.schEntry)
--                 self.schEntry = nil
--             end
--             self.pv:removeAllItems() 
--             self.adRoot:removeFromParent(true)

--         end

--     else
--         self.gamesList = cc.ui.UIListView.new {
--             -- bgColor = cc.c4b(200, 200, 200, 120),
--             bg = nil,
--             bgScale9 = false,
--             viewRect = self.rect,
--             direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
--             scrollbarImgV = nil}
--             :onTouch(handler(self, self.onGamelistListener))
--             :addTo(self.gamelistNode)
--     end

--     if tonumber(layoutIdx) == 1 then
--         self:setHomeBtnVisible(false)
--         self.hasaddAD = true

--     else
--         self:setHomeBtnVisible(true)
--         self.hasaddAD = false
--     end

--     -- add items
--     local lobbyLayout = DICT_LAYOUT[tostring(layoutIdx)]
--     if lobbyLayout == nil then
--         print("layout idx is null", layoutIdx)
--     end
--     local cells = lobbyLayout.contain_unit
--     local cols = #cells

--     local startIdx = 0

--     if self.hasaddAD == true then
--         startIdx = 0
--     else
--         startIdx = 1
--     end

--     local getLayoutType = function(elements)
--         -- body

--         local layout_type = "LAYOUT"
--         for idx = 1, #elements do

--             local element = elements[idx]

--             if type(element) == "table" then
--                 layout_type = layout_type.."_"..tostring(#element)
--             else
--                 layout_type = layout_type.."_1"
--             end
--         end

--         return layout_type

--     end

--     self.iconCnt = 1

--     for i=startIdx, cols do

--         local item
--         local content
--         local itemsize 

--         if i > 0 then

--             local colcells = cells[i]

--             local layType = getLayoutType(colcells)

--             print("-----", layType)

--             if layType == "LAYOUT_1_2" then
--                content, item, itemsize = self:addItem_1_2(colcells)
--             elseif layType == "LAYOUT_1_1" then
--                 content, item, itemsize = self:addItem_1_1(colcells)
--             elseif layType == "LAYOUT_1" then
--                 content, item, itemsize = self:addItem_1_1(colcells)
--             end

--             item.isgame = true

--         else
--             item = self.gamesList:newItem()
--             content = display.newNode()
--             itemsize = {}
            
--             itemsize.width =1.15 * display.width/4  
--             itemsize.height = self.rect.height
--         end

--         item:addContent(content)
--         item:setPositionY(self.rect.height/2)
--         item:setItemSize(itemsize.width, self.rect.height)

--         self.gamesList:addItem(item)
--     end

--     self.gamesList:setDelegate(handler(self, self.gameListDelegate))
--     self.gamesList:reload()
    
--     local idx = 1

--     for i,v in ipairs(self.gamesList.items_) do

--         if idx < 5 then
            
--             local posX, posY = v:getPosition()
--             v:setPositionX(posX+display.width-200)
--             transition.moveTo(v, {x=posX, y=posY, time=0.1+0.1*idx, delay = 0.1,easing="SINEOUT",
--                 onComplete=function()
--                 end}
--             )

--         end

--         idx = idx + 1
--     end
--     --self:addPlayers()
    
--     self:add_AD(layoutIdx)
-- end

-- function LobbyView:touchADListener(event)
--     local listView = event.listView

--     if "pageChange" ==  event.name then        
--         local x = self.indicator_.firstX_ + (self.pv:getCurPageIdx() - 1) * margin
--         transition.moveTo(self.indicator_, {x = x, time=0.1})
--         self.pv.bDrag_ = false
--     elseif "clicked" == event.name then
--         self:gotoGamelistListener(event.item.data)
--     --        print("select ad idx:", event.item.adidx)
--     --        dump(event.item.data)
--     elseif "moved" == event.name then
--         self.bListViewMove = true
--     elseif "ended" == event.name then
--         self.bListViewMove = false
--         --self.pv.bDrag_ = false
--         print("event name:---123456789")
--     elseif "began" == event.name then
--         self.bListViewMove = true
--     else
--         print("event name:" .. event.name)
--     end
-- end


-- function LobbyView:addPlayers()
   
-- -- add items

--     local friendcolnum = math.floor(self.rect.width/150)

--     local friends = 0
--     if self.players ~= nil then
--         friends = math.ceil(#(self.players)/friendcolnum)
--     end

--     local fidx = 1

--     for i=1, friends do
--         local item = self.gamesList:newItem()

--         local content = display.newNode()
--         local itemsize = {width=0,height=0}
--         item.cells = {}

--         --print("-----add player")

--         if true then
--             item.isgame = false

--             local numCells = friendcolnum
--             local mcol = self.rect.width/(numCells)

--             for cellidx = 1, numCells do
                
--                 local player = self.players[fidx]

--                 if player then

--                     local cell  = CCBuilderReaderLoad("view/share_head.ccbi", self)
--                     local size = cell:getContentSize()
--                     cell.name = self.name
--                     cell.head = self.head
--                     cell.game_icon = self.game_icon
--                     cell.pid = -1

                    
--                     cell.pid = player.pid
--                     cell.name:setString(player.name)
--                     if cc.SpriteFrameCache:getInstance():getSpriteFrame(HEAD_IMAGE[player.pictureId]) then
--                         cell.head:setSpriteFrame(display.newSpriteFrame(HEAD_IMAGE[player.pictureId]))
--                     end

--                     --cell.game_icon:setSpriteFrame(ICON_IMAGE[tonumber(player.currentState)])
--                     local image_icon = ICON_IMAGE[player.currentState + 1]
--                     if cc.SpriteFrameCache:getInstance():getSpriteFrame(image_icon) then
--                         cell.game_icon:setSpriteFrame(display.newSpriteFrame(image_icon))
--                     end

--                     fidx = fidx + 1

--                     local scale = mcol / ( size.width + 10 ) 
--                     if scale < 1 then
--                         cell:setScale(scale)
--                     end

--                     itemsize.width = itemsize.width + size.width
--                     itemsize.height = size.height + 2

--                     local posX = cellidx*mcol - (self.rect.width + size.width )/2

--                     cell:setPositionX(posX)
--                     content:addChild(cell)
--                     cell.isgame = false
--                     item.cells[cellidx] = cell

--                 end
                
--             end

--         end

--         item:addContent(content)
--         item:setPositionX(self.rect.width/2)
--         item:setItemSize(self.rect.width, itemsize.height)

--         self.gamesList:addItem(item)
--     end

--     self.gamesList:setDelegate(handler(self, self.gameListDelegate))
--     self.gamesList:reload()

-- end

-- function LobbyView:onGamelistListener(event)
--     local listView = event.listView
--     if "clicked" == event.name then
--         local p = cc.p(event.x, event.y)

--         if event.item.cells == nil then return end

--         local cellnum = #event.item.cells
        
--         for count = 1, cellnum do
--             local cell = event.item.cells[count]
--             local boundingBox = cell:getCascadeBoundingBox()
--             if cc.rectContainsPoint(boundingBox, p) then
--                 print("cell:", cell.unit.type, cell.unit.zipname)
--                 self:dispatchEvent({name = "onTapLobbyCell", cell=cell})
--                 return
--             else
--                 --print("no contain :", count, boundingBox.x, boundingBox.y, boundingBox.width, boundingBox.height)
--             end
--         end

--     elseif "moved" == event.name then
--         self.bListViewMove = true
--     elseif "ended" == event.name then
--         self.bListViewMove = false
--     else
--         print("event name:" .. event.name)
--     end
-- end

-- function LobbyView:gameListDelegate(listView, tag, idx)
-- end


-- function LobbyView:gotoGamelistListener(item)


--     local showWaiting = function( )
--         -- body
--         if device.platform == "ios" then
--             core.Waiting.show()
--         else
--             self.indicator = scn.ScnMgr.addView("CoverView")
--         end
--     end

--     local hideWaiting = function( )
--         -- body
--         if device.platform == "ios" then
--         else
--             scn.ScnMgr.removeView(self.indicator)
--         end
--     end

--     if item.uiType == "game" then
--         local gid = tonumber(item.targetId)
--         local unit = DICT_UNIT[tostring(gid)]
--         if gid and unit then
--             local cell = {}
--             cell.unit = clone(unit)
--             cell.unitidx = gid
--             self:dispatchEvent({name = "onTapLobbyCell", cell=cell})
--             return
--         end
--     elseif item.uiType == "ad" then
--         AdMgr.showAdListView(tonumber(item.targetId))
--     elseif item.uiType == "vip" then
--         app:watchVedioAd()
--         --scn.ScnMgr.popView("VipView")
--     elseif item.uiType == "applovin" then

--         app:watchVedioAd()

--     elseif item.uiType == "cashin" then
--         net.PurchaseCS:GetProductList(function(lists)
--             scn.ScnMgr.popView("ProductsView",{productList=lists,tabidx=1})
--         end)
--     end
-- end

-- function LobbyView:add_AD(layoutIdx)

--     if self.hasaddAD == false then return end

--     AdMgr.getAdBarFromServer(handler(self, self.handleAD))

--     self.adRoot = display.newNode()
--     self:addChild(self.adRoot,1)


--     self.adNode = cc.ClippingNode:create()
--     self.adRoot:addChild(self.adNode)

--     local pageHeight = self.AdHeight
--     local distY = (self.rect.height - pageHeight) / 2

--     --local pageHeight = self.rect.height - distY * 2


--     --local distY = 10 + (display.height-640) * 0.20
--     local distX = (self.ADPageWidth - 220) / 2

--     local pageWidth = self.ADPageWidth - distX * 2

--     local pagePosX = self.rect.x + distX
--     local pagePosY = self.rect.y + distY

--     cc.ui.UIImage.new(IMAGE_PNG.dating_guanggao_pai, {scale9 = true})
--     :setLayoutSize(pageWidth, pageHeight)
--     :align(display.CENTER, pagePosX + pageWidth/2, pagePosY+pageHeight/2)
--     :addTo(self.adNode)

--     self.pv = cc.ui.UIPageView.new {
--         viewRect = cc.rect(pagePosX, pagePosY, pageWidth, pageHeight),
--         column = 1, row = 1,bCirc=true}
--     :onTouch(handler(self, self.touchADListener))
--     :addTo(self.adNode)

--     local stencil=display.newSprite(IMAGE_PNG.dating_guanggao_pai)
--     local size = stencil:getContentSize()
--     stencil:setScaleX(pageWidth/size.width)
--     stencil:setScaleY((pageHeight-1)/size.height)
--     stencil:setPosition(pagePosX + pageWidth/2, pagePosY+pageHeight/2)

--     self.adNode:setStencil(stencil)
--     self.adNode:setInverted(false)
--     self.adNode:setAlphaThreshold(0)

--     local topUI = cc.ui.UIImage.new(IMAGE_PNG.dating_guanggao_yabian, {scale9 = true})
--     topUI:setLayoutSize(pageWidth, pageHeight)
--     topUI:align(display.CENTER, pagePosX + pageWidth/2, pagePosY + pageHeight/2)

--     self.adRoot:addChild(topUI)

--     local posX1, posY1 = self.adRoot:getPosition()
--     self.adRoot:setPositionX(posX1-300)

--     transition.moveTo(self.adRoot, {x=posX1, y=posY1, time=0.3, delay = 0.1,easing="SINEOUT"})

-- end


-- function LobbyView:handleAD(adInfo)
-- --    if layoutIdx == "1" then
-- --        self.hasaddAD = true
-- --    else
-- --        self.hasaddAD = false
-- --    end

--     if self.hasaddAD == false then return end

--     local pageHeight = self.AdHeight
--     local distY = (self.rect.height - pageHeight) / 2


--     --local distY = 10 + (display.height-640) * 0.15
--     local distX = (self.ADPageWidth - 220) / 2

--     --local pageHeight = self.rect.height - distY * 2
--     local pageWidth = self.ADPageWidth - distX * 2

--     local pagePosX = self.rect.x + distX
--     local pagePosY = self.rect.y + distY

--     -- add items
--     local numPages = #adInfo
--     self.pv:removeAllItems()
--     for i=1, numPages do
--         local item = self.pv:newItem()

--         local content = ADBarViewCell.new(adInfo[i])
--         local cellsize = content:getContentSize()
--         --content:setScaleY(1.02*pageHeight/cellsize.height)
--         content:setScale(pageWidth/cellsize.width)

--         content:setPositionY(cellsize.height * (pageHeight/cellsize.height - 1) * 0.5)

--         item:addChild(content)
--         item.adidx = i
--         item.data = adInfo[i].template
--         self.pv:addItem(item)
--     end

--     -- add indicators
--     local x = pagePosX + (pageWidth - margin * (numPages - 1)) / 2
--     local y = pagePosY + 20

--     self.indicator_ = display.newSprite(IMAGE_PNG.pageindacator_sel)
--     self.indicator_:setPosition(x, y)
--     self.indicator_.firstX_ = x

--     for pageIndex = 1, numPages do
--         local icon = display.newSprite(IMAGE_PNG.pageindacator_bg)
--         icon:setPosition(x, y)
--         self.adNode:addChild(icon)
--         x = x + margin
--     end
--     self.adNode:addChild(self.indicator_)

--     self.pv:reload()
--     local function tick(event)
--         if not self.pv.bDrag_ then
--             local index =  self.pv:getCurPageIdx() + 1
--             if index > self.pv:getPageCount() then
--                 index = 1
--             end
--             self.pv:gotoPage(index, true, false)
--         end
--     end
--     if not self.schEntry then
--         self.schEntry = self.scheduler.scheduleGlobal(tick,6)
--     end
-- end


return LobbyView
