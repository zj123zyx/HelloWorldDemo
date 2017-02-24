-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('DataReport_pb')


local PLAYERACCOUNT = protobuf.Descriptor();
local PLAYERACCOUNT_PID_FIELD = protobuf.FieldDescriptor();
local PLAYERACCOUNT_COINS_FIELD = protobuf.FieldDescriptor();
local PLAYERACCOUNT_GEMS_FIELD = protobuf.FieldDescriptor();
local PLAYERACCOUNT_MONEY_FIELD = protobuf.FieldDescriptor();
local PLAYERACCOUNT_LEVEL_FIELD = protobuf.FieldDescriptor();
local PLAYERACCOUNT_EXP_FIELD = protobuf.FieldDescriptor();
local PLAYERACCOUNT_VIPLEVEL_FIELD = protobuf.FieldDescriptor();
local PLAYERACCOUNT_VIPPOINT_FIELD = protobuf.FieldDescriptor();
local GAMEDATA = protobuf.Descriptor();
local GAMEDATA_PID_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_TIMESTAMP_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_GAMETYPE_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_GAMEID_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_GAMECNT_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_WINCNT_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_COSTCOINS_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_WINCOINS_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_HANDSPLAYED_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_HANDSWIN_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_HANDSPUSHED_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_HANDSLOST_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_BIGWIN_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_MAGEWIN_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_BLACKJACK_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_ROYALFLUSH_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_STRAIGHTFLUSH_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_FOUROFAKIND_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_FIVEOFAKIND_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_COSTGEMS_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_REWARDGEMS_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_POKERSUIT_FIELD = protobuf.FieldDescriptor();
local GAMEDATA_ACCOUNT_FIELD = protobuf.FieldDescriptor();
local DOUBLEGAME = protobuf.Descriptor();
local DOUBLEGAME_TIMESTAMP_FIELD = protobuf.FieldDescriptor();
local DOUBLEGAME_INITCOINS_FIELD = protobuf.FieldDescriptor();
local DOUBLEGAME_FLOPCNT_FIELD = protobuf.FieldDescriptor();
local DOUBLEGAME_REWARDCOINS_FIELD = protobuf.FieldDescriptor();
local DOUBLEGAME_ACCOUNT_FIELD = protobuf.FieldDescriptor();
local LEVELUP = protobuf.Descriptor();
local LEVELUP_TIMESTAMP_FIELD = protobuf.FieldDescriptor();
local LEVELUP_PRELEVEL_FIELD = protobuf.FieldDescriptor();
local LEVELUP_REWARDCOINS_FIELD = protobuf.FieldDescriptor();
local LEVELUP_VIPPOINT_FIELD = protobuf.FieldDescriptor();
local LEVELUP_ACCOUNT_FIELD = protobuf.FieldDescriptor();
local CGGAMEREPORT = protobuf.Descriptor();
local CGGAMEREPORT_PID_FIELD = protobuf.FieldDescriptor();
local CGGAMEREPORT_SERIALNO_FIELD = protobuf.FieldDescriptor();
local CGGAMEREPORT_GAMEDATALIST_FIELD = protobuf.FieldDescriptor();
local CGGAMEREPORT_DOUBLEGAMELIST_FIELD = protobuf.FieldDescriptor();
local CGGAMEREPORT_LEVELUPLIST_FIELD = protobuf.FieldDescriptor();
local CGGAMEREPORT_ACCOUNT_FIELD = protobuf.FieldDescriptor();
local GCGAMEREPORT = protobuf.Descriptor();
local GCGAMEREPORT_RESULT_FIELD = protobuf.FieldDescriptor();
local GCGAMEREPORT_SERIALNO_FIELD = protobuf.FieldDescriptor();
local GCGAMEREPORT_NOTIFYLIST_FIELD = protobuf.FieldDescriptor();
local NOTIFYTYPE = protobuf.Descriptor();
local NOTIFYTYPE_TYPE_FIELD = protobuf.FieldDescriptor();

PLAYERACCOUNT_PID_FIELD.name = "pid"
PLAYERACCOUNT_PID_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.pid"
PLAYERACCOUNT_PID_FIELD.number = 1
PLAYERACCOUNT_PID_FIELD.index = 0
PLAYERACCOUNT_PID_FIELD.label = 2
PLAYERACCOUNT_PID_FIELD.has_default_value = false
PLAYERACCOUNT_PID_FIELD.default_value = 0
PLAYERACCOUNT_PID_FIELD.type = 3
PLAYERACCOUNT_PID_FIELD.cpp_type = 2

PLAYERACCOUNT_COINS_FIELD.name = "coins"
PLAYERACCOUNT_COINS_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.coins"
PLAYERACCOUNT_COINS_FIELD.number = 2
PLAYERACCOUNT_COINS_FIELD.index = 1
PLAYERACCOUNT_COINS_FIELD.label = 2
PLAYERACCOUNT_COINS_FIELD.has_default_value = false
PLAYERACCOUNT_COINS_FIELD.default_value = 0
PLAYERACCOUNT_COINS_FIELD.type = 3
PLAYERACCOUNT_COINS_FIELD.cpp_type = 2

PLAYERACCOUNT_GEMS_FIELD.name = "gems"
PLAYERACCOUNT_GEMS_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.gems"
PLAYERACCOUNT_GEMS_FIELD.number = 3
PLAYERACCOUNT_GEMS_FIELD.index = 2
PLAYERACCOUNT_GEMS_FIELD.label = 2
PLAYERACCOUNT_GEMS_FIELD.has_default_value = false
PLAYERACCOUNT_GEMS_FIELD.default_value = 0
PLAYERACCOUNT_GEMS_FIELD.type = 3
PLAYERACCOUNT_GEMS_FIELD.cpp_type = 2

PLAYERACCOUNT_MONEY_FIELD.name = "money"
PLAYERACCOUNT_MONEY_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.money"
PLAYERACCOUNT_MONEY_FIELD.number = 4
PLAYERACCOUNT_MONEY_FIELD.index = 3
PLAYERACCOUNT_MONEY_FIELD.label = 1
PLAYERACCOUNT_MONEY_FIELD.has_default_value = false
PLAYERACCOUNT_MONEY_FIELD.default_value = 0
PLAYERACCOUNT_MONEY_FIELD.type = 3
PLAYERACCOUNT_MONEY_FIELD.cpp_type = 2

PLAYERACCOUNT_LEVEL_FIELD.name = "level"
PLAYERACCOUNT_LEVEL_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.level"
PLAYERACCOUNT_LEVEL_FIELD.number = 5
PLAYERACCOUNT_LEVEL_FIELD.index = 4
PLAYERACCOUNT_LEVEL_FIELD.label = 2
PLAYERACCOUNT_LEVEL_FIELD.has_default_value = false
PLAYERACCOUNT_LEVEL_FIELD.default_value = 0
PLAYERACCOUNT_LEVEL_FIELD.type = 5
PLAYERACCOUNT_LEVEL_FIELD.cpp_type = 1

PLAYERACCOUNT_EXP_FIELD.name = "exp"
PLAYERACCOUNT_EXP_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.exp"
PLAYERACCOUNT_EXP_FIELD.number = 6
PLAYERACCOUNT_EXP_FIELD.index = 5
PLAYERACCOUNT_EXP_FIELD.label = 2
PLAYERACCOUNT_EXP_FIELD.has_default_value = false
PLAYERACCOUNT_EXP_FIELD.default_value = 0
PLAYERACCOUNT_EXP_FIELD.type = 3
PLAYERACCOUNT_EXP_FIELD.cpp_type = 2

PLAYERACCOUNT_VIPLEVEL_FIELD.name = "vipLevel"
PLAYERACCOUNT_VIPLEVEL_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.vipLevel"
PLAYERACCOUNT_VIPLEVEL_FIELD.number = 7
PLAYERACCOUNT_VIPLEVEL_FIELD.index = 6
PLAYERACCOUNT_VIPLEVEL_FIELD.label = 1
PLAYERACCOUNT_VIPLEVEL_FIELD.has_default_value = false
PLAYERACCOUNT_VIPLEVEL_FIELD.default_value = 0
PLAYERACCOUNT_VIPLEVEL_FIELD.type = 5
PLAYERACCOUNT_VIPLEVEL_FIELD.cpp_type = 1

PLAYERACCOUNT_VIPPOINT_FIELD.name = "vipPoint"
PLAYERACCOUNT_VIPPOINT_FIELD.full_name = ".com.zy.game.casino.message.PlayerAccount.vipPoint"
PLAYERACCOUNT_VIPPOINT_FIELD.number = 8
PLAYERACCOUNT_VIPPOINT_FIELD.index = 7
PLAYERACCOUNT_VIPPOINT_FIELD.label = 1
PLAYERACCOUNT_VIPPOINT_FIELD.has_default_value = false
PLAYERACCOUNT_VIPPOINT_FIELD.default_value = 0
PLAYERACCOUNT_VIPPOINT_FIELD.type = 3
PLAYERACCOUNT_VIPPOINT_FIELD.cpp_type = 2

PLAYERACCOUNT.name = "PlayerAccount"
PLAYERACCOUNT.full_name = ".com.zy.game.casino.message.PlayerAccount"
PLAYERACCOUNT.nested_types = {}
PLAYERACCOUNT.enum_types = {}
PLAYERACCOUNT.fields = {PLAYERACCOUNT_PID_FIELD, PLAYERACCOUNT_COINS_FIELD, PLAYERACCOUNT_GEMS_FIELD, PLAYERACCOUNT_MONEY_FIELD, PLAYERACCOUNT_LEVEL_FIELD, PLAYERACCOUNT_EXP_FIELD, PLAYERACCOUNT_VIPLEVEL_FIELD, PLAYERACCOUNT_VIPPOINT_FIELD}
PLAYERACCOUNT.is_extendable = false
PLAYERACCOUNT.extensions = {}
GAMEDATA_PID_FIELD.name = "pid"
GAMEDATA_PID_FIELD.full_name = ".com.zy.game.casino.message.GameData.pid"
GAMEDATA_PID_FIELD.number = 1
GAMEDATA_PID_FIELD.index = 0
GAMEDATA_PID_FIELD.label = 2
GAMEDATA_PID_FIELD.has_default_value = false
GAMEDATA_PID_FIELD.default_value = 0
GAMEDATA_PID_FIELD.type = 3
GAMEDATA_PID_FIELD.cpp_type = 2

GAMEDATA_TIMESTAMP_FIELD.name = "timestamp"
GAMEDATA_TIMESTAMP_FIELD.full_name = ".com.zy.game.casino.message.GameData.timestamp"
GAMEDATA_TIMESTAMP_FIELD.number = 2
GAMEDATA_TIMESTAMP_FIELD.index = 1
GAMEDATA_TIMESTAMP_FIELD.label = 2
GAMEDATA_TIMESTAMP_FIELD.has_default_value = false
GAMEDATA_TIMESTAMP_FIELD.default_value = 0
GAMEDATA_TIMESTAMP_FIELD.type = 3
GAMEDATA_TIMESTAMP_FIELD.cpp_type = 2

GAMEDATA_GAMETYPE_FIELD.name = "gameType"
GAMEDATA_GAMETYPE_FIELD.full_name = ".com.zy.game.casino.message.GameData.gameType"
GAMEDATA_GAMETYPE_FIELD.number = 3
GAMEDATA_GAMETYPE_FIELD.index = 2
GAMEDATA_GAMETYPE_FIELD.label = 2
GAMEDATA_GAMETYPE_FIELD.has_default_value = false
GAMEDATA_GAMETYPE_FIELD.default_value = 0
GAMEDATA_GAMETYPE_FIELD.type = 5
GAMEDATA_GAMETYPE_FIELD.cpp_type = 1

GAMEDATA_GAMEID_FIELD.name = "gameId"
GAMEDATA_GAMEID_FIELD.full_name = ".com.zy.game.casino.message.GameData.gameId"
GAMEDATA_GAMEID_FIELD.number = 4
GAMEDATA_GAMEID_FIELD.index = 3
GAMEDATA_GAMEID_FIELD.label = 2
GAMEDATA_GAMEID_FIELD.has_default_value = false
GAMEDATA_GAMEID_FIELD.default_value = 0
GAMEDATA_GAMEID_FIELD.type = 5
GAMEDATA_GAMEID_FIELD.cpp_type = 1

GAMEDATA_GAMECNT_FIELD.name = "gameCnt"
GAMEDATA_GAMECNT_FIELD.full_name = ".com.zy.game.casino.message.GameData.gameCnt"
GAMEDATA_GAMECNT_FIELD.number = 5
GAMEDATA_GAMECNT_FIELD.index = 4
GAMEDATA_GAMECNT_FIELD.label = 2
GAMEDATA_GAMECNT_FIELD.has_default_value = false
GAMEDATA_GAMECNT_FIELD.default_value = 0
GAMEDATA_GAMECNT_FIELD.type = 3
GAMEDATA_GAMECNT_FIELD.cpp_type = 2

GAMEDATA_WINCNT_FIELD.name = "winCnt"
GAMEDATA_WINCNT_FIELD.full_name = ".com.zy.game.casino.message.GameData.winCnt"
GAMEDATA_WINCNT_FIELD.number = 6
GAMEDATA_WINCNT_FIELD.index = 5
GAMEDATA_WINCNT_FIELD.label = 2
GAMEDATA_WINCNT_FIELD.has_default_value = false
GAMEDATA_WINCNT_FIELD.default_value = 0
GAMEDATA_WINCNT_FIELD.type = 3
GAMEDATA_WINCNT_FIELD.cpp_type = 2

GAMEDATA_COSTCOINS_FIELD.name = "costCoins"
GAMEDATA_COSTCOINS_FIELD.full_name = ".com.zy.game.casino.message.GameData.costCoins"
GAMEDATA_COSTCOINS_FIELD.number = 7
GAMEDATA_COSTCOINS_FIELD.index = 6
GAMEDATA_COSTCOINS_FIELD.label = 2
GAMEDATA_COSTCOINS_FIELD.has_default_value = false
GAMEDATA_COSTCOINS_FIELD.default_value = 0
GAMEDATA_COSTCOINS_FIELD.type = 3
GAMEDATA_COSTCOINS_FIELD.cpp_type = 2

GAMEDATA_WINCOINS_FIELD.name = "winCoins"
GAMEDATA_WINCOINS_FIELD.full_name = ".com.zy.game.casino.message.GameData.winCoins"
GAMEDATA_WINCOINS_FIELD.number = 8
GAMEDATA_WINCOINS_FIELD.index = 7
GAMEDATA_WINCOINS_FIELD.label = 2
GAMEDATA_WINCOINS_FIELD.has_default_value = false
GAMEDATA_WINCOINS_FIELD.default_value = 0
GAMEDATA_WINCOINS_FIELD.type = 3
GAMEDATA_WINCOINS_FIELD.cpp_type = 2

GAMEDATA_HANDSPLAYED_FIELD.name = "handsPlayed"
GAMEDATA_HANDSPLAYED_FIELD.full_name = ".com.zy.game.casino.message.GameData.handsPlayed"
GAMEDATA_HANDSPLAYED_FIELD.number = 9
GAMEDATA_HANDSPLAYED_FIELD.index = 8
GAMEDATA_HANDSPLAYED_FIELD.label = 1
GAMEDATA_HANDSPLAYED_FIELD.has_default_value = false
GAMEDATA_HANDSPLAYED_FIELD.default_value = 0
GAMEDATA_HANDSPLAYED_FIELD.type = 3
GAMEDATA_HANDSPLAYED_FIELD.cpp_type = 2

GAMEDATA_HANDSWIN_FIELD.name = "handsWin"
GAMEDATA_HANDSWIN_FIELD.full_name = ".com.zy.game.casino.message.GameData.handsWin"
GAMEDATA_HANDSWIN_FIELD.number = 10
GAMEDATA_HANDSWIN_FIELD.index = 9
GAMEDATA_HANDSWIN_FIELD.label = 1
GAMEDATA_HANDSWIN_FIELD.has_default_value = false
GAMEDATA_HANDSWIN_FIELD.default_value = 0
GAMEDATA_HANDSWIN_FIELD.type = 3
GAMEDATA_HANDSWIN_FIELD.cpp_type = 2

GAMEDATA_HANDSPUSHED_FIELD.name = "handsPushed"
GAMEDATA_HANDSPUSHED_FIELD.full_name = ".com.zy.game.casino.message.GameData.handsPushed"
GAMEDATA_HANDSPUSHED_FIELD.number = 11
GAMEDATA_HANDSPUSHED_FIELD.index = 10
GAMEDATA_HANDSPUSHED_FIELD.label = 1
GAMEDATA_HANDSPUSHED_FIELD.has_default_value = false
GAMEDATA_HANDSPUSHED_FIELD.default_value = 0
GAMEDATA_HANDSPUSHED_FIELD.type = 3
GAMEDATA_HANDSPUSHED_FIELD.cpp_type = 2

GAMEDATA_HANDSLOST_FIELD.name = "handsLost"
GAMEDATA_HANDSLOST_FIELD.full_name = ".com.zy.game.casino.message.GameData.handsLost"
GAMEDATA_HANDSLOST_FIELD.number = 12
GAMEDATA_HANDSLOST_FIELD.index = 11
GAMEDATA_HANDSLOST_FIELD.label = 1
GAMEDATA_HANDSLOST_FIELD.has_default_value = false
GAMEDATA_HANDSLOST_FIELD.default_value = 0
GAMEDATA_HANDSLOST_FIELD.type = 3
GAMEDATA_HANDSLOST_FIELD.cpp_type = 2

GAMEDATA_BIGWIN_FIELD.name = "bigWin"
GAMEDATA_BIGWIN_FIELD.full_name = ".com.zy.game.casino.message.GameData.bigWin"
GAMEDATA_BIGWIN_FIELD.number = 13
GAMEDATA_BIGWIN_FIELD.index = 12
GAMEDATA_BIGWIN_FIELD.label = 1
GAMEDATA_BIGWIN_FIELD.has_default_value = false
GAMEDATA_BIGWIN_FIELD.default_value = 0
GAMEDATA_BIGWIN_FIELD.type = 3
GAMEDATA_BIGWIN_FIELD.cpp_type = 2

GAMEDATA_MAGEWIN_FIELD.name = "mageWin"
GAMEDATA_MAGEWIN_FIELD.full_name = ".com.zy.game.casino.message.GameData.mageWin"
GAMEDATA_MAGEWIN_FIELD.number = 14
GAMEDATA_MAGEWIN_FIELD.index = 13
GAMEDATA_MAGEWIN_FIELD.label = 1
GAMEDATA_MAGEWIN_FIELD.has_default_value = false
GAMEDATA_MAGEWIN_FIELD.default_value = 0
GAMEDATA_MAGEWIN_FIELD.type = 3
GAMEDATA_MAGEWIN_FIELD.cpp_type = 2

GAMEDATA_BLACKJACK_FIELD.name = "blackJack"
GAMEDATA_BLACKJACK_FIELD.full_name = ".com.zy.game.casino.message.GameData.blackJack"
GAMEDATA_BLACKJACK_FIELD.number = 15
GAMEDATA_BLACKJACK_FIELD.index = 14
GAMEDATA_BLACKJACK_FIELD.label = 1
GAMEDATA_BLACKJACK_FIELD.has_default_value = false
GAMEDATA_BLACKJACK_FIELD.default_value = 0
GAMEDATA_BLACKJACK_FIELD.type = 3
GAMEDATA_BLACKJACK_FIELD.cpp_type = 2

GAMEDATA_ROYALFLUSH_FIELD.name = "royalFlush"
GAMEDATA_ROYALFLUSH_FIELD.full_name = ".com.zy.game.casino.message.GameData.royalFlush"
GAMEDATA_ROYALFLUSH_FIELD.number = 16
GAMEDATA_ROYALFLUSH_FIELD.index = 15
GAMEDATA_ROYALFLUSH_FIELD.label = 1
GAMEDATA_ROYALFLUSH_FIELD.has_default_value = false
GAMEDATA_ROYALFLUSH_FIELD.default_value = 0
GAMEDATA_ROYALFLUSH_FIELD.type = 3
GAMEDATA_ROYALFLUSH_FIELD.cpp_type = 2

GAMEDATA_STRAIGHTFLUSH_FIELD.name = "straightFlush"
GAMEDATA_STRAIGHTFLUSH_FIELD.full_name = ".com.zy.game.casino.message.GameData.straightFlush"
GAMEDATA_STRAIGHTFLUSH_FIELD.number = 17
GAMEDATA_STRAIGHTFLUSH_FIELD.index = 16
GAMEDATA_STRAIGHTFLUSH_FIELD.label = 1
GAMEDATA_STRAIGHTFLUSH_FIELD.has_default_value = false
GAMEDATA_STRAIGHTFLUSH_FIELD.default_value = 0
GAMEDATA_STRAIGHTFLUSH_FIELD.type = 3
GAMEDATA_STRAIGHTFLUSH_FIELD.cpp_type = 2

GAMEDATA_FOUROFAKIND_FIELD.name = "fourOfAKind"
GAMEDATA_FOUROFAKIND_FIELD.full_name = ".com.zy.game.casino.message.GameData.fourOfAKind"
GAMEDATA_FOUROFAKIND_FIELD.number = 18
GAMEDATA_FOUROFAKIND_FIELD.index = 17
GAMEDATA_FOUROFAKIND_FIELD.label = 1
GAMEDATA_FOUROFAKIND_FIELD.has_default_value = false
GAMEDATA_FOUROFAKIND_FIELD.default_value = 0
GAMEDATA_FOUROFAKIND_FIELD.type = 3
GAMEDATA_FOUROFAKIND_FIELD.cpp_type = 2

GAMEDATA_FIVEOFAKIND_FIELD.name = "fiveOfAKind"
GAMEDATA_FIVEOFAKIND_FIELD.full_name = ".com.zy.game.casino.message.GameData.fiveOfAKind"
GAMEDATA_FIVEOFAKIND_FIELD.number = 19
GAMEDATA_FIVEOFAKIND_FIELD.index = 18
GAMEDATA_FIVEOFAKIND_FIELD.label = 1
GAMEDATA_FIVEOFAKIND_FIELD.has_default_value = false
GAMEDATA_FIVEOFAKIND_FIELD.default_value = 0
GAMEDATA_FIVEOFAKIND_FIELD.type = 3
GAMEDATA_FIVEOFAKIND_FIELD.cpp_type = 2

GAMEDATA_COSTGEMS_FIELD.name = "costGems"
GAMEDATA_COSTGEMS_FIELD.full_name = ".com.zy.game.casino.message.GameData.costGems"
GAMEDATA_COSTGEMS_FIELD.number = 20
GAMEDATA_COSTGEMS_FIELD.index = 19
GAMEDATA_COSTGEMS_FIELD.label = 1
GAMEDATA_COSTGEMS_FIELD.has_default_value = false
GAMEDATA_COSTGEMS_FIELD.default_value = 0
GAMEDATA_COSTGEMS_FIELD.type = 3
GAMEDATA_COSTGEMS_FIELD.cpp_type = 2

GAMEDATA_REWARDGEMS_FIELD.name = "rewardGems"
GAMEDATA_REWARDGEMS_FIELD.full_name = ".com.zy.game.casino.message.GameData.rewardGems"
GAMEDATA_REWARDGEMS_FIELD.number = 21
GAMEDATA_REWARDGEMS_FIELD.index = 20
GAMEDATA_REWARDGEMS_FIELD.label = 1
GAMEDATA_REWARDGEMS_FIELD.has_default_value = false
GAMEDATA_REWARDGEMS_FIELD.default_value = 0
GAMEDATA_REWARDGEMS_FIELD.type = 3
GAMEDATA_REWARDGEMS_FIELD.cpp_type = 2

GAMEDATA_POKERSUIT_FIELD.name = "pokerSuit"
GAMEDATA_POKERSUIT_FIELD.full_name = ".com.zy.game.casino.message.GameData.pokerSuit"
GAMEDATA_POKERSUIT_FIELD.number = 22
GAMEDATA_POKERSUIT_FIELD.index = 21
GAMEDATA_POKERSUIT_FIELD.label = 1
GAMEDATA_POKERSUIT_FIELD.has_default_value = false
GAMEDATA_POKERSUIT_FIELD.default_value = ""
GAMEDATA_POKERSUIT_FIELD.type = 9
GAMEDATA_POKERSUIT_FIELD.cpp_type = 9

GAMEDATA_ACCOUNT_FIELD.name = "account"
GAMEDATA_ACCOUNT_FIELD.full_name = ".com.zy.game.casino.message.GameData.account"
GAMEDATA_ACCOUNT_FIELD.number = 23
GAMEDATA_ACCOUNT_FIELD.index = 22
GAMEDATA_ACCOUNT_FIELD.label = 2
GAMEDATA_ACCOUNT_FIELD.has_default_value = false
GAMEDATA_ACCOUNT_FIELD.default_value = nil
GAMEDATA_ACCOUNT_FIELD.message_type = PLAYERACCOUNT
GAMEDATA_ACCOUNT_FIELD.type = 11
GAMEDATA_ACCOUNT_FIELD.cpp_type = 10

GAMEDATA.name = "GameData"
GAMEDATA.full_name = ".com.zy.game.casino.message.GameData"
GAMEDATA.nested_types = {}
GAMEDATA.enum_types = {}
GAMEDATA.fields = {GAMEDATA_PID_FIELD, GAMEDATA_TIMESTAMP_FIELD, GAMEDATA_GAMETYPE_FIELD, GAMEDATA_GAMEID_FIELD, GAMEDATA_GAMECNT_FIELD, GAMEDATA_WINCNT_FIELD, GAMEDATA_COSTCOINS_FIELD, GAMEDATA_WINCOINS_FIELD, GAMEDATA_HANDSPLAYED_FIELD, GAMEDATA_HANDSWIN_FIELD, GAMEDATA_HANDSPUSHED_FIELD, GAMEDATA_HANDSLOST_FIELD, GAMEDATA_BIGWIN_FIELD, GAMEDATA_MAGEWIN_FIELD, GAMEDATA_BLACKJACK_FIELD, GAMEDATA_ROYALFLUSH_FIELD, GAMEDATA_STRAIGHTFLUSH_FIELD, GAMEDATA_FOUROFAKIND_FIELD, GAMEDATA_FIVEOFAKIND_FIELD, GAMEDATA_COSTGEMS_FIELD, GAMEDATA_REWARDGEMS_FIELD, GAMEDATA_POKERSUIT_FIELD, GAMEDATA_ACCOUNT_FIELD}
GAMEDATA.is_extendable = false
GAMEDATA.extensions = {}
DOUBLEGAME_TIMESTAMP_FIELD.name = "timestamp"
DOUBLEGAME_TIMESTAMP_FIELD.full_name = ".com.zy.game.casino.message.DoubleGame.timestamp"
DOUBLEGAME_TIMESTAMP_FIELD.number = 1
DOUBLEGAME_TIMESTAMP_FIELD.index = 0
DOUBLEGAME_TIMESTAMP_FIELD.label = 2
DOUBLEGAME_TIMESTAMP_FIELD.has_default_value = false
DOUBLEGAME_TIMESTAMP_FIELD.default_value = 0
DOUBLEGAME_TIMESTAMP_FIELD.type = 3
DOUBLEGAME_TIMESTAMP_FIELD.cpp_type = 2

DOUBLEGAME_INITCOINS_FIELD.name = "initCoins"
DOUBLEGAME_INITCOINS_FIELD.full_name = ".com.zy.game.casino.message.DoubleGame.initCoins"
DOUBLEGAME_INITCOINS_FIELD.number = 2
DOUBLEGAME_INITCOINS_FIELD.index = 1
DOUBLEGAME_INITCOINS_FIELD.label = 2
DOUBLEGAME_INITCOINS_FIELD.has_default_value = false
DOUBLEGAME_INITCOINS_FIELD.default_value = 0
DOUBLEGAME_INITCOINS_FIELD.type = 3
DOUBLEGAME_INITCOINS_FIELD.cpp_type = 2

DOUBLEGAME_FLOPCNT_FIELD.name = "flopCnt"
DOUBLEGAME_FLOPCNT_FIELD.full_name = ".com.zy.game.casino.message.DoubleGame.flopCnt"
DOUBLEGAME_FLOPCNT_FIELD.number = 3
DOUBLEGAME_FLOPCNT_FIELD.index = 2
DOUBLEGAME_FLOPCNT_FIELD.label = 2
DOUBLEGAME_FLOPCNT_FIELD.has_default_value = false
DOUBLEGAME_FLOPCNT_FIELD.default_value = 0
DOUBLEGAME_FLOPCNT_FIELD.type = 5
DOUBLEGAME_FLOPCNT_FIELD.cpp_type = 1

DOUBLEGAME_REWARDCOINS_FIELD.name = "rewardCoins"
DOUBLEGAME_REWARDCOINS_FIELD.full_name = ".com.zy.game.casino.message.DoubleGame.rewardCoins"
DOUBLEGAME_REWARDCOINS_FIELD.number = 4
DOUBLEGAME_REWARDCOINS_FIELD.index = 3
DOUBLEGAME_REWARDCOINS_FIELD.label = 2
DOUBLEGAME_REWARDCOINS_FIELD.has_default_value = false
DOUBLEGAME_REWARDCOINS_FIELD.default_value = 0
DOUBLEGAME_REWARDCOINS_FIELD.type = 3
DOUBLEGAME_REWARDCOINS_FIELD.cpp_type = 2

DOUBLEGAME_ACCOUNT_FIELD.name = "account"
DOUBLEGAME_ACCOUNT_FIELD.full_name = ".com.zy.game.casino.message.DoubleGame.account"
DOUBLEGAME_ACCOUNT_FIELD.number = 5
DOUBLEGAME_ACCOUNT_FIELD.index = 4
DOUBLEGAME_ACCOUNT_FIELD.label = 2
DOUBLEGAME_ACCOUNT_FIELD.has_default_value = false
DOUBLEGAME_ACCOUNT_FIELD.default_value = nil
DOUBLEGAME_ACCOUNT_FIELD.message_type = PLAYERACCOUNT
DOUBLEGAME_ACCOUNT_FIELD.type = 11
DOUBLEGAME_ACCOUNT_FIELD.cpp_type = 10

DOUBLEGAME.name = "DoubleGame"
DOUBLEGAME.full_name = ".com.zy.game.casino.message.DoubleGame"
DOUBLEGAME.nested_types = {}
DOUBLEGAME.enum_types = {}
DOUBLEGAME.fields = {DOUBLEGAME_TIMESTAMP_FIELD, DOUBLEGAME_INITCOINS_FIELD, DOUBLEGAME_FLOPCNT_FIELD, DOUBLEGAME_REWARDCOINS_FIELD, DOUBLEGAME_ACCOUNT_FIELD}
DOUBLEGAME.is_extendable = false
DOUBLEGAME.extensions = {}
LEVELUP_TIMESTAMP_FIELD.name = "timestamp"
LEVELUP_TIMESTAMP_FIELD.full_name = ".com.zy.game.casino.message.LevelUp.timestamp"
LEVELUP_TIMESTAMP_FIELD.number = 1
LEVELUP_TIMESTAMP_FIELD.index = 0
LEVELUP_TIMESTAMP_FIELD.label = 2
LEVELUP_TIMESTAMP_FIELD.has_default_value = false
LEVELUP_TIMESTAMP_FIELD.default_value = 0
LEVELUP_TIMESTAMP_FIELD.type = 3
LEVELUP_TIMESTAMP_FIELD.cpp_type = 2

LEVELUP_PRELEVEL_FIELD.name = "preLevel"
LEVELUP_PRELEVEL_FIELD.full_name = ".com.zy.game.casino.message.LevelUp.preLevel"
LEVELUP_PRELEVEL_FIELD.number = 2
LEVELUP_PRELEVEL_FIELD.index = 1
LEVELUP_PRELEVEL_FIELD.label = 2
LEVELUP_PRELEVEL_FIELD.has_default_value = false
LEVELUP_PRELEVEL_FIELD.default_value = 0
LEVELUP_PRELEVEL_FIELD.type = 5
LEVELUP_PRELEVEL_FIELD.cpp_type = 1

LEVELUP_REWARDCOINS_FIELD.name = "rewardCoins"
LEVELUP_REWARDCOINS_FIELD.full_name = ".com.zy.game.casino.message.LevelUp.rewardCoins"
LEVELUP_REWARDCOINS_FIELD.number = 3
LEVELUP_REWARDCOINS_FIELD.index = 2
LEVELUP_REWARDCOINS_FIELD.label = 1
LEVELUP_REWARDCOINS_FIELD.has_default_value = false
LEVELUP_REWARDCOINS_FIELD.default_value = 0
LEVELUP_REWARDCOINS_FIELD.type = 5
LEVELUP_REWARDCOINS_FIELD.cpp_type = 1

LEVELUP_VIPPOINT_FIELD.name = "vipPoint"
LEVELUP_VIPPOINT_FIELD.full_name = ".com.zy.game.casino.message.LevelUp.vipPoint"
LEVELUP_VIPPOINT_FIELD.number = 4
LEVELUP_VIPPOINT_FIELD.index = 3
LEVELUP_VIPPOINT_FIELD.label = 1
LEVELUP_VIPPOINT_FIELD.has_default_value = false
LEVELUP_VIPPOINT_FIELD.default_value = 0
LEVELUP_VIPPOINT_FIELD.type = 5
LEVELUP_VIPPOINT_FIELD.cpp_type = 1

LEVELUP_ACCOUNT_FIELD.name = "account"
LEVELUP_ACCOUNT_FIELD.full_name = ".com.zy.game.casino.message.LevelUp.account"
LEVELUP_ACCOUNT_FIELD.number = 5
LEVELUP_ACCOUNT_FIELD.index = 4
LEVELUP_ACCOUNT_FIELD.label = 2
LEVELUP_ACCOUNT_FIELD.has_default_value = false
LEVELUP_ACCOUNT_FIELD.default_value = nil
LEVELUP_ACCOUNT_FIELD.message_type = PLAYERACCOUNT
LEVELUP_ACCOUNT_FIELD.type = 11
LEVELUP_ACCOUNT_FIELD.cpp_type = 10

LEVELUP.name = "LevelUp"
LEVELUP.full_name = ".com.zy.game.casino.message.LevelUp"
LEVELUP.nested_types = {}
LEVELUP.enum_types = {}
LEVELUP.fields = {LEVELUP_TIMESTAMP_FIELD, LEVELUP_PRELEVEL_FIELD, LEVELUP_REWARDCOINS_FIELD, LEVELUP_VIPPOINT_FIELD, LEVELUP_ACCOUNT_FIELD}
LEVELUP.is_extendable = false
LEVELUP.extensions = {}
CGGAMEREPORT_PID_FIELD.name = "pid"
CGGAMEREPORT_PID_FIELD.full_name = ".com.zy.game.casino.message.CGGameReport.pid"
CGGAMEREPORT_PID_FIELD.number = 1
CGGAMEREPORT_PID_FIELD.index = 0
CGGAMEREPORT_PID_FIELD.label = 2
CGGAMEREPORT_PID_FIELD.has_default_value = false
CGGAMEREPORT_PID_FIELD.default_value = 0
CGGAMEREPORT_PID_FIELD.type = 3
CGGAMEREPORT_PID_FIELD.cpp_type = 2

CGGAMEREPORT_SERIALNO_FIELD.name = "serialNo"
CGGAMEREPORT_SERIALNO_FIELD.full_name = ".com.zy.game.casino.message.CGGameReport.serialNo"
CGGAMEREPORT_SERIALNO_FIELD.number = 2
CGGAMEREPORT_SERIALNO_FIELD.index = 1
CGGAMEREPORT_SERIALNO_FIELD.label = 2
CGGAMEREPORT_SERIALNO_FIELD.has_default_value = false
CGGAMEREPORT_SERIALNO_FIELD.default_value = 0
CGGAMEREPORT_SERIALNO_FIELD.type = 3
CGGAMEREPORT_SERIALNO_FIELD.cpp_type = 2

CGGAMEREPORT_GAMEDATALIST_FIELD.name = "gameDataList"
CGGAMEREPORT_GAMEDATALIST_FIELD.full_name = ".com.zy.game.casino.message.CGGameReport.gameDataList"
CGGAMEREPORT_GAMEDATALIST_FIELD.number = 3
CGGAMEREPORT_GAMEDATALIST_FIELD.index = 2
CGGAMEREPORT_GAMEDATALIST_FIELD.label = 3
CGGAMEREPORT_GAMEDATALIST_FIELD.has_default_value = false
CGGAMEREPORT_GAMEDATALIST_FIELD.default_value = {}
CGGAMEREPORT_GAMEDATALIST_FIELD.message_type = GAMEDATA
CGGAMEREPORT_GAMEDATALIST_FIELD.type = 11
CGGAMEREPORT_GAMEDATALIST_FIELD.cpp_type = 10

CGGAMEREPORT_DOUBLEGAMELIST_FIELD.name = "doubleGameList"
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.full_name = ".com.zy.game.casino.message.CGGameReport.doubleGameList"
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.number = 4
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.index = 3
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.label = 3
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.has_default_value = false
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.default_value = {}
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.message_type = DOUBLEGAME
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.type = 11
CGGAMEREPORT_DOUBLEGAMELIST_FIELD.cpp_type = 10

CGGAMEREPORT_LEVELUPLIST_FIELD.name = "levelUpList"
CGGAMEREPORT_LEVELUPLIST_FIELD.full_name = ".com.zy.game.casino.message.CGGameReport.levelUpList"
CGGAMEREPORT_LEVELUPLIST_FIELD.number = 5
CGGAMEREPORT_LEVELUPLIST_FIELD.index = 4
CGGAMEREPORT_LEVELUPLIST_FIELD.label = 3
CGGAMEREPORT_LEVELUPLIST_FIELD.has_default_value = false
CGGAMEREPORT_LEVELUPLIST_FIELD.default_value = {}
CGGAMEREPORT_LEVELUPLIST_FIELD.message_type = LEVELUP
CGGAMEREPORT_LEVELUPLIST_FIELD.type = 11
CGGAMEREPORT_LEVELUPLIST_FIELD.cpp_type = 10

CGGAMEREPORT_ACCOUNT_FIELD.name = "account"
CGGAMEREPORT_ACCOUNT_FIELD.full_name = ".com.zy.game.casino.message.CGGameReport.account"
CGGAMEREPORT_ACCOUNT_FIELD.number = 6
CGGAMEREPORT_ACCOUNT_FIELD.index = 5
CGGAMEREPORT_ACCOUNT_FIELD.label = 2
CGGAMEREPORT_ACCOUNT_FIELD.has_default_value = false
CGGAMEREPORT_ACCOUNT_FIELD.default_value = nil
CGGAMEREPORT_ACCOUNT_FIELD.message_type = PLAYERACCOUNT
CGGAMEREPORT_ACCOUNT_FIELD.type = 11
CGGAMEREPORT_ACCOUNT_FIELD.cpp_type = 10

CGGAMEREPORT.name = "CGGameReport"
CGGAMEREPORT.full_name = ".com.zy.game.casino.message.CGGameReport"
CGGAMEREPORT.nested_types = {}
CGGAMEREPORT.enum_types = {}
CGGAMEREPORT.fields = {CGGAMEREPORT_PID_FIELD, CGGAMEREPORT_SERIALNO_FIELD, CGGAMEREPORT_GAMEDATALIST_FIELD, CGGAMEREPORT_DOUBLEGAMELIST_FIELD, CGGAMEREPORT_LEVELUPLIST_FIELD, CGGAMEREPORT_ACCOUNT_FIELD}
CGGAMEREPORT.is_extendable = false
CGGAMEREPORT.extensions = {}
GCGAMEREPORT_RESULT_FIELD.name = "result"
GCGAMEREPORT_RESULT_FIELD.full_name = ".com.zy.game.casino.message.GCGameReport.result"
GCGAMEREPORT_RESULT_FIELD.number = 1
GCGAMEREPORT_RESULT_FIELD.index = 0
GCGAMEREPORT_RESULT_FIELD.label = 2
GCGAMEREPORT_RESULT_FIELD.has_default_value = false
GCGAMEREPORT_RESULT_FIELD.default_value = 0
GCGAMEREPORT_RESULT_FIELD.type = 5
GCGAMEREPORT_RESULT_FIELD.cpp_type = 1

GCGAMEREPORT_SERIALNO_FIELD.name = "serialNo"
GCGAMEREPORT_SERIALNO_FIELD.full_name = ".com.zy.game.casino.message.GCGameReport.serialNo"
GCGAMEREPORT_SERIALNO_FIELD.number = 2
GCGAMEREPORT_SERIALNO_FIELD.index = 1
GCGAMEREPORT_SERIALNO_FIELD.label = 2
GCGAMEREPORT_SERIALNO_FIELD.has_default_value = false
GCGAMEREPORT_SERIALNO_FIELD.default_value = 0
GCGAMEREPORT_SERIALNO_FIELD.type = 3
GCGAMEREPORT_SERIALNO_FIELD.cpp_type = 2

GCGAMEREPORT_NOTIFYLIST_FIELD.name = "notifyList"
GCGAMEREPORT_NOTIFYLIST_FIELD.full_name = ".com.zy.game.casino.message.GCGameReport.notifyList"
GCGAMEREPORT_NOTIFYLIST_FIELD.number = 3
GCGAMEREPORT_NOTIFYLIST_FIELD.index = 2
GCGAMEREPORT_NOTIFYLIST_FIELD.label = 3
GCGAMEREPORT_NOTIFYLIST_FIELD.has_default_value = false
GCGAMEREPORT_NOTIFYLIST_FIELD.default_value = {}
GCGAMEREPORT_NOTIFYLIST_FIELD.message_type = NOTIFYTYPE
GCGAMEREPORT_NOTIFYLIST_FIELD.type = 11
GCGAMEREPORT_NOTIFYLIST_FIELD.cpp_type = 10

GCGAMEREPORT.name = "GCGameReport"
GCGAMEREPORT.full_name = ".com.zy.game.casino.message.GCGameReport"
GCGAMEREPORT.nested_types = {}
GCGAMEREPORT.enum_types = {}
GCGAMEREPORT.fields = {GCGAMEREPORT_RESULT_FIELD, GCGAMEREPORT_SERIALNO_FIELD, GCGAMEREPORT_NOTIFYLIST_FIELD}
GCGAMEREPORT.is_extendable = false
GCGAMEREPORT.extensions = {}
NOTIFYTYPE_TYPE_FIELD.name = "type"
NOTIFYTYPE_TYPE_FIELD.full_name = ".com.zy.game.casino.message.NotifyType.type"
NOTIFYTYPE_TYPE_FIELD.number = 1
NOTIFYTYPE_TYPE_FIELD.index = 0
NOTIFYTYPE_TYPE_FIELD.label = 2
NOTIFYTYPE_TYPE_FIELD.has_default_value = false
NOTIFYTYPE_TYPE_FIELD.default_value = 0
NOTIFYTYPE_TYPE_FIELD.type = 5
NOTIFYTYPE_TYPE_FIELD.cpp_type = 1

NOTIFYTYPE.name = "NotifyType"
NOTIFYTYPE.full_name = ".com.zy.game.casino.message.NotifyType"
NOTIFYTYPE.nested_types = {}
NOTIFYTYPE.enum_types = {}
NOTIFYTYPE.fields = {NOTIFYTYPE_TYPE_FIELD}
NOTIFYTYPE.is_extendable = false
NOTIFYTYPE.extensions = {}

CGGameReport = protobuf.Message(CGGAMEREPORT)
DoubleGame = protobuf.Message(DOUBLEGAME)
GCGameReport = protobuf.Message(GCGAMEREPORT)
GameData = protobuf.Message(GAMEDATA)
LevelUp = protobuf.Message(LEVELUP)
NotifyType = protobuf.Message(NOTIFYTYPE)
PlayerAccount = protobuf.Message(PLAYERACCOUNT)

