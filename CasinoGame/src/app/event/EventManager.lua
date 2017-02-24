local EventManager = class("EventManager")

EventManager.SPIN_SLOTSGAME_EVENT         = "SPIN_SLOTSGAME_EVENT"
EventManager.SERVER_NOTICE_EVENT          = "SERVER_NOTICE_EVENT"
EventManager.SOCKET_CONNECT_EVENT         = "SOCKET_CONNECT_EVENT"
EventManager.UPDATE_PLAYERS_EVENT         = "UPDATE_PLAYERS_EVENT"
EventManager.UPDATE_FRIENDS_EVENT         = "UPDATE_FRIENDS_EVENT"
EventManager.UPDATE_PSTATES_EVENT         = "UPDATE_PSTATES_EVENT"
EventManager.UPDATE_LOBBYUI_EVENT         = "UPDATE_LOBBYUI_EVENT"
EventManager.SEND_MESSAGE_EVENT			  = "SEND_MESSAGE_EVENT"
EventManager.STOP_LINEEFF_EVENT			  = "STOP_LINEEFF_EVENT"
EventManager.OFFLINE_STOP_SUTOSPIN        = "OFFLINE_STOP_SUTOSPIN"
EventManager.UPDATE_PRODUCT_LIST          = "UPDATE_PRODUCT_LIST"
EventManager.UPDATE_JACKPOT               = "UPDATE_JACKPOT"
function EventManager.instance()
    return EventManager.new()
end

function EventManager:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function EventManager:exit()
    self:getComponent("components.behavior.EventProtocol"):dumpAllEventListeners()
end

return EventManager