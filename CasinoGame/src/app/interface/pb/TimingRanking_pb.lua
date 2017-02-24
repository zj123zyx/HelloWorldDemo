-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('TimingRanking_pb')


local RANKINGMODEL = protobuf.Descriptor();
local RANKINGMODEL_PID_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_PICTUREID_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_FACEBOOKID_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_RANK_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_TOTALBETFORPERIOD_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_TOTALBET_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_NAME_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_ITEMID_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_ITEMCNT_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_LEVEL_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_VIPLEVEL_FIELD = protobuf.FieldDescriptor();
local RANKINGMODEL_RANKINGTYPE_FIELD = protobuf.FieldDescriptor();
local CGGETRANKINGLISTINROOM = protobuf.Descriptor();
local CGGETRANKINGLISTINROOM_GAMEID_FIELD = protobuf.FieldDescriptor();
local CGGETRANKINGLISTINROOM_ROOMID_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGLISTINROOM = protobuf.Descriptor();
local GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD = protobuf.FieldDescriptor();
local CGGETRANKINGLISTINGAME = protobuf.Descriptor();
local CGGETRANKINGLISTINGAME_GAMEID_FIELD = protobuf.FieldDescriptor();
local CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGLISTINGAME = protobuf.Descriptor();
local GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER = protobuf.Descriptor();
local GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_PID_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_NAME_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_LEVEL_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_GAMEID_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREWARDPLAYER_ITEMID_FIELD = protobuf.FieldDescriptor();
local CGGETSELFRANKINGS = protobuf.Descriptor();
local CGGETSELFRANKINGS_GAMEID_FIELD = protobuf.FieldDescriptor();
local CGGETSELFRANKINGS_ROOMID_FIELD = protobuf.FieldDescriptor();
local GCGETSELFRANKINGS = protobuf.Descriptor();
local GCGETSELFRANKINGS_SELFRANKINGS_FIELD = protobuf.FieldDescriptor();
local GCGETSELFRANKINGS_REWARDMAPPING_FIELD = protobuf.FieldDescriptor();
local CGGETRANKINGREMAINEDTIME = protobuf.Descriptor();
local CGGETRANKINGREMAINEDTIME_GAMEID_FIELD = protobuf.FieldDescriptor();
local CGGETRANKINGREMAINEDTIME_ROOMID_FIELD = protobuf.FieldDescriptor();
local RANKINGTIMEMODEL = protobuf.Descriptor();
local RANKINGTIMEMODEL_GAMEID_FIELD = protobuf.FieldDescriptor();
local RANKINGTIMEMODEL_ROOMID_FIELD = protobuf.FieldDescriptor();
local RANKINGTIMEMODEL_RANKINGTYPE_FIELD = protobuf.FieldDescriptor();
local RANKINGTIMEMODEL_REMAINEDTIME_FIELD = protobuf.FieldDescriptor();
local GCGETRANKINGREMAINEDTIME = protobuf.Descriptor();
local GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD = protobuf.FieldDescriptor();

RANKINGMODEL_PID_FIELD.name = "pid"
RANKINGMODEL_PID_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.pid"
RANKINGMODEL_PID_FIELD.number = 1
RANKINGMODEL_PID_FIELD.index = 0
RANKINGMODEL_PID_FIELD.label = 1
RANKINGMODEL_PID_FIELD.has_default_value = false
RANKINGMODEL_PID_FIELD.default_value = 0
RANKINGMODEL_PID_FIELD.type = 3
RANKINGMODEL_PID_FIELD.cpp_type = 2

RANKINGMODEL_PICTUREID_FIELD.name = "pictureId"
RANKINGMODEL_PICTUREID_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.pictureId"
RANKINGMODEL_PICTUREID_FIELD.number = 2
RANKINGMODEL_PICTUREID_FIELD.index = 1
RANKINGMODEL_PICTUREID_FIELD.label = 1
RANKINGMODEL_PICTUREID_FIELD.has_default_value = false
RANKINGMODEL_PICTUREID_FIELD.default_value = ""
RANKINGMODEL_PICTUREID_FIELD.type = 9
RANKINGMODEL_PICTUREID_FIELD.cpp_type = 9

RANKINGMODEL_FACEBOOKID_FIELD.name = "facebookId"
RANKINGMODEL_FACEBOOKID_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.facebookId"
RANKINGMODEL_FACEBOOKID_FIELD.number = 3
RANKINGMODEL_FACEBOOKID_FIELD.index = 2
RANKINGMODEL_FACEBOOKID_FIELD.label = 1
RANKINGMODEL_FACEBOOKID_FIELD.has_default_value = false
RANKINGMODEL_FACEBOOKID_FIELD.default_value = ""
RANKINGMODEL_FACEBOOKID_FIELD.type = 9
RANKINGMODEL_FACEBOOKID_FIELD.cpp_type = 9

RANKINGMODEL_RANK_FIELD.name = "rank"
RANKINGMODEL_RANK_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.rank"
RANKINGMODEL_RANK_FIELD.number = 4
RANKINGMODEL_RANK_FIELD.index = 3
RANKINGMODEL_RANK_FIELD.label = 1
RANKINGMODEL_RANK_FIELD.has_default_value = false
RANKINGMODEL_RANK_FIELD.default_value = 0
RANKINGMODEL_RANK_FIELD.type = 5
RANKINGMODEL_RANK_FIELD.cpp_type = 1

RANKINGMODEL_TOTALBETFORPERIOD_FIELD.name = "totalBetForPeriod"
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.totalBetForPeriod"
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.number = 5
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.index = 4
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.label = 1
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.has_default_value = false
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.default_value = 0
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.type = 3
RANKINGMODEL_TOTALBETFORPERIOD_FIELD.cpp_type = 2

RANKINGMODEL_TOTALBET_FIELD.name = "totalBet"
RANKINGMODEL_TOTALBET_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.totalBet"
RANKINGMODEL_TOTALBET_FIELD.number = 6
RANKINGMODEL_TOTALBET_FIELD.index = 5
RANKINGMODEL_TOTALBET_FIELD.label = 1
RANKINGMODEL_TOTALBET_FIELD.has_default_value = false
RANKINGMODEL_TOTALBET_FIELD.default_value = 0
RANKINGMODEL_TOTALBET_FIELD.type = 3
RANKINGMODEL_TOTALBET_FIELD.cpp_type = 2

RANKINGMODEL_NAME_FIELD.name = "name"
RANKINGMODEL_NAME_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.name"
RANKINGMODEL_NAME_FIELD.number = 7
RANKINGMODEL_NAME_FIELD.index = 6
RANKINGMODEL_NAME_FIELD.label = 1
RANKINGMODEL_NAME_FIELD.has_default_value = false
RANKINGMODEL_NAME_FIELD.default_value = ""
RANKINGMODEL_NAME_FIELD.type = 9
RANKINGMODEL_NAME_FIELD.cpp_type = 9

RANKINGMODEL_ITEMID_FIELD.name = "itemId"
RANKINGMODEL_ITEMID_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.itemId"
RANKINGMODEL_ITEMID_FIELD.number = 8
RANKINGMODEL_ITEMID_FIELD.index = 7
RANKINGMODEL_ITEMID_FIELD.label = 1
RANKINGMODEL_ITEMID_FIELD.has_default_value = false
RANKINGMODEL_ITEMID_FIELD.default_value = 0
RANKINGMODEL_ITEMID_FIELD.type = 5
RANKINGMODEL_ITEMID_FIELD.cpp_type = 1

RANKINGMODEL_ITEMCNT_FIELD.name = "itemCnt"
RANKINGMODEL_ITEMCNT_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.itemCnt"
RANKINGMODEL_ITEMCNT_FIELD.number = 9
RANKINGMODEL_ITEMCNT_FIELD.index = 8
RANKINGMODEL_ITEMCNT_FIELD.label = 1
RANKINGMODEL_ITEMCNT_FIELD.has_default_value = false
RANKINGMODEL_ITEMCNT_FIELD.default_value = 0
RANKINGMODEL_ITEMCNT_FIELD.type = 5
RANKINGMODEL_ITEMCNT_FIELD.cpp_type = 1

RANKINGMODEL_LEVEL_FIELD.name = "level"
RANKINGMODEL_LEVEL_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.level"
RANKINGMODEL_LEVEL_FIELD.number = 10
RANKINGMODEL_LEVEL_FIELD.index = 9
RANKINGMODEL_LEVEL_FIELD.label = 1
RANKINGMODEL_LEVEL_FIELD.has_default_value = false
RANKINGMODEL_LEVEL_FIELD.default_value = 0
RANKINGMODEL_LEVEL_FIELD.type = 5
RANKINGMODEL_LEVEL_FIELD.cpp_type = 1

RANKINGMODEL_VIPLEVEL_FIELD.name = "vipLevel"
RANKINGMODEL_VIPLEVEL_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.vipLevel"
RANKINGMODEL_VIPLEVEL_FIELD.number = 11
RANKINGMODEL_VIPLEVEL_FIELD.index = 10
RANKINGMODEL_VIPLEVEL_FIELD.label = 1
RANKINGMODEL_VIPLEVEL_FIELD.has_default_value = false
RANKINGMODEL_VIPLEVEL_FIELD.default_value = 0
RANKINGMODEL_VIPLEVEL_FIELD.type = 5
RANKINGMODEL_VIPLEVEL_FIELD.cpp_type = 1

RANKINGMODEL_RANKINGTYPE_FIELD.name = "rankingType"
RANKINGMODEL_RANKINGTYPE_FIELD.full_name = ".com.zy.game.casino.message.RankingModel.rankingType"
RANKINGMODEL_RANKINGTYPE_FIELD.number = 12
RANKINGMODEL_RANKINGTYPE_FIELD.index = 11
RANKINGMODEL_RANKINGTYPE_FIELD.label = 1
RANKINGMODEL_RANKINGTYPE_FIELD.has_default_value = false
RANKINGMODEL_RANKINGTYPE_FIELD.default_value = 0
RANKINGMODEL_RANKINGTYPE_FIELD.type = 5
RANKINGMODEL_RANKINGTYPE_FIELD.cpp_type = 1

RANKINGMODEL.name = "RankingModel"
RANKINGMODEL.full_name = ".com.zy.game.casino.message.RankingModel"
RANKINGMODEL.nested_types = {}
RANKINGMODEL.enum_types = {}
RANKINGMODEL.fields = {RANKINGMODEL_PID_FIELD, RANKINGMODEL_PICTUREID_FIELD, RANKINGMODEL_FACEBOOKID_FIELD, RANKINGMODEL_RANK_FIELD, RANKINGMODEL_TOTALBETFORPERIOD_FIELD, RANKINGMODEL_TOTALBET_FIELD, RANKINGMODEL_NAME_FIELD, RANKINGMODEL_ITEMID_FIELD, RANKINGMODEL_ITEMCNT_FIELD, RANKINGMODEL_LEVEL_FIELD, RANKINGMODEL_VIPLEVEL_FIELD, RANKINGMODEL_RANKINGTYPE_FIELD}
RANKINGMODEL.is_extendable = false
RANKINGMODEL.extensions = {}
CGGETRANKINGLISTINROOM_GAMEID_FIELD.name = "gameId"
CGGETRANKINGLISTINROOM_GAMEID_FIELD.full_name = ".com.zy.game.casino.message.CGGetRankingListInRoom.gameId"
CGGETRANKINGLISTINROOM_GAMEID_FIELD.number = 1
CGGETRANKINGLISTINROOM_GAMEID_FIELD.index = 0
CGGETRANKINGLISTINROOM_GAMEID_FIELD.label = 2
CGGETRANKINGLISTINROOM_GAMEID_FIELD.has_default_value = false
CGGETRANKINGLISTINROOM_GAMEID_FIELD.default_value = 0
CGGETRANKINGLISTINROOM_GAMEID_FIELD.type = 5
CGGETRANKINGLISTINROOM_GAMEID_FIELD.cpp_type = 1

CGGETRANKINGLISTINROOM_ROOMID_FIELD.name = "roomId"
CGGETRANKINGLISTINROOM_ROOMID_FIELD.full_name = ".com.zy.game.casino.message.CGGetRankingListInRoom.roomId"
CGGETRANKINGLISTINROOM_ROOMID_FIELD.number = 2
CGGETRANKINGLISTINROOM_ROOMID_FIELD.index = 1
CGGETRANKINGLISTINROOM_ROOMID_FIELD.label = 2
CGGETRANKINGLISTINROOM_ROOMID_FIELD.has_default_value = false
CGGETRANKINGLISTINROOM_ROOMID_FIELD.default_value = 0
CGGETRANKINGLISTINROOM_ROOMID_FIELD.type = 5
CGGETRANKINGLISTINROOM_ROOMID_FIELD.cpp_type = 1

CGGETRANKINGLISTINROOM.name = "CGGetRankingListInRoom"
CGGETRANKINGLISTINROOM.full_name = ".com.zy.game.casino.message.CGGetRankingListInRoom"
CGGETRANKINGLISTINROOM.nested_types = {}
CGGETRANKINGLISTINROOM.enum_types = {}
CGGETRANKINGLISTINROOM.fields = {CGGETRANKINGLISTINROOM_GAMEID_FIELD, CGGETRANKINGLISTINROOM_ROOMID_FIELD}
CGGETRANKINGLISTINROOM.is_extendable = false
CGGETRANKINGLISTINROOM.extensions = {}
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.name = "rankingList"
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingListInRoom.rankingList"
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.number = 1
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.index = 0
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.label = 3
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.has_default_value = false
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.default_value = {}
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.message_type = RANKINGMODEL
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.type = 11
GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD.cpp_type = 10

GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.name = "remainedTimeLimit"
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingListInRoom.remainedTimeLimit"
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.number = 2
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.index = 1
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.label = 1
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.has_default_value = false
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.default_value = 0
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.type = 3
GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD.cpp_type = 2

GCGETRANKINGLISTINROOM.name = "GCGetRankingListInRoom"
GCGETRANKINGLISTINROOM.full_name = ".com.zy.game.casino.message.GCGetRankingListInRoom"
GCGETRANKINGLISTINROOM.nested_types = {}
GCGETRANKINGLISTINROOM.enum_types = {}
GCGETRANKINGLISTINROOM.fields = {GCGETRANKINGLISTINROOM_RANKINGLIST_FIELD, GCGETRANKINGLISTINROOM_REMAINEDTIMELIMIT_FIELD}
GCGETRANKINGLISTINROOM.is_extendable = false
GCGETRANKINGLISTINROOM.extensions = {}
CGGETRANKINGLISTINGAME_GAMEID_FIELD.name = "gameId"
CGGETRANKINGLISTINGAME_GAMEID_FIELD.full_name = ".com.zy.game.casino.message.CGGetRankingListInGame.gameId"
CGGETRANKINGLISTINGAME_GAMEID_FIELD.number = 1
CGGETRANKINGLISTINGAME_GAMEID_FIELD.index = 0
CGGETRANKINGLISTINGAME_GAMEID_FIELD.label = 2
CGGETRANKINGLISTINGAME_GAMEID_FIELD.has_default_value = false
CGGETRANKINGLISTINGAME_GAMEID_FIELD.default_value = 0
CGGETRANKINGLISTINGAME_GAMEID_FIELD.type = 5
CGGETRANKINGLISTINGAME_GAMEID_FIELD.cpp_type = 1

CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.name = "rankingType"
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.full_name = ".com.zy.game.casino.message.CGGetRankingListInGame.rankingType"
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.number = 2
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.index = 1
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.label = 2
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.has_default_value = false
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.default_value = 0
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.type = 5
CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD.cpp_type = 1

CGGETRANKINGLISTINGAME.name = "CGGetRankingListInGame"
CGGETRANKINGLISTINGAME.full_name = ".com.zy.game.casino.message.CGGetRankingListInGame"
CGGETRANKINGLISTINGAME.nested_types = {}
CGGETRANKINGLISTINGAME.enum_types = {}
CGGETRANKINGLISTINGAME.fields = {CGGETRANKINGLISTINGAME_GAMEID_FIELD, CGGETRANKINGLISTINGAME_RANKINGTYPE_FIELD}
CGGETRANKINGLISTINGAME.is_extendable = false
CGGETRANKINGLISTINGAME.extensions = {}
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.name = "rankingList"
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingListInGame.rankingList"
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.number = 1
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.index = 0
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.label = 3
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.has_default_value = false
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.default_value = {}
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.message_type = RANKINGMODEL
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.type = 11
GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD.cpp_type = 10

GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.name = "remainedTimeLimit"
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingListInGame.remainedTimeLimit"
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.number = 2
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.index = 1
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.label = 1
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.has_default_value = false
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.default_value = 0
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.type = 3
GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD.cpp_type = 2

GCGETRANKINGLISTINGAME.name = "GCGetRankingListInGame"
GCGETRANKINGLISTINGAME.full_name = ".com.zy.game.casino.message.GCGetRankingListInGame"
GCGETRANKINGLISTINGAME.nested_types = {}
GCGETRANKINGLISTINGAME.enum_types = {}
GCGETRANKINGLISTINGAME.fields = {GCGETRANKINGLISTINGAME_RANKINGLIST_FIELD, GCGETRANKINGLISTINGAME_REMAINEDTIMELIMIT_FIELD}
GCGETRANKINGLISTINGAME.is_extendable = false
GCGETRANKINGLISTINGAME.extensions = {}
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.name = "rankingType"
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.rankingType"
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.number = 1
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.index = 0
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.label = 2
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.type = 5
GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD.cpp_type = 1

GCGETRANKINGREWARDPLAYER_PID_FIELD.name = "pid"
GCGETRANKINGREWARDPLAYER_PID_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.pid"
GCGETRANKINGREWARDPLAYER_PID_FIELD.number = 2
GCGETRANKINGREWARDPLAYER_PID_FIELD.index = 1
GCGETRANKINGREWARDPLAYER_PID_FIELD.label = 2
GCGETRANKINGREWARDPLAYER_PID_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_PID_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_PID_FIELD.type = 3
GCGETRANKINGREWARDPLAYER_PID_FIELD.cpp_type = 2

GCGETRANKINGREWARDPLAYER_NAME_FIELD.name = "name"
GCGETRANKINGREWARDPLAYER_NAME_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.name"
GCGETRANKINGREWARDPLAYER_NAME_FIELD.number = 3
GCGETRANKINGREWARDPLAYER_NAME_FIELD.index = 2
GCGETRANKINGREWARDPLAYER_NAME_FIELD.label = 1
GCGETRANKINGREWARDPLAYER_NAME_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_NAME_FIELD.default_value = ""
GCGETRANKINGREWARDPLAYER_NAME_FIELD.type = 9
GCGETRANKINGREWARDPLAYER_NAME_FIELD.cpp_type = 9

GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.name = "pictureId"
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.pictureId"
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.number = 4
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.index = 3
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.label = 1
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.type = 5
GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD.cpp_type = 1

GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.name = "facebookId"
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.facebookId"
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.number = 5
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.index = 4
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.label = 1
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.default_value = ""
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.type = 9
GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD.cpp_type = 9

GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.name = "level"
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.level"
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.number = 6
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.index = 5
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.label = 1
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.type = 5
GCGETRANKINGREWARDPLAYER_LEVEL_FIELD.cpp_type = 1

GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.name = "vipLevel"
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.vipLevel"
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.number = 7
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.index = 6
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.label = 1
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.type = 5
GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD.cpp_type = 1

GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.name = "gameId"
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.gameId"
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.number = 8
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.index = 7
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.label = 2
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.type = 5
GCGETRANKINGREWARDPLAYER_GAMEID_FIELD.cpp_type = 1

GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.name = "rewardItemCnt"
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.rewardItemCnt"
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.number = 9
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.index = 8
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.label = 2
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.type = 3
GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD.cpp_type = 2

GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.name = "itemId"
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer.itemId"
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.number = 10
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.index = 9
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.label = 2
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.has_default_value = false
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.default_value = 0
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.type = 5
GCGETRANKINGREWARDPLAYER_ITEMID_FIELD.cpp_type = 1

GCGETRANKINGREWARDPLAYER.name = "GCGetRankingRewardPlayer"
GCGETRANKINGREWARDPLAYER.full_name = ".com.zy.game.casino.message.GCGetRankingRewardPlayer"
GCGETRANKINGREWARDPLAYER.nested_types = {}
GCGETRANKINGREWARDPLAYER.enum_types = {}
GCGETRANKINGREWARDPLAYER.fields = {GCGETRANKINGREWARDPLAYER_RANKINGTYPE_FIELD, GCGETRANKINGREWARDPLAYER_PID_FIELD, GCGETRANKINGREWARDPLAYER_NAME_FIELD, GCGETRANKINGREWARDPLAYER_PICTUREID_FIELD, GCGETRANKINGREWARDPLAYER_FACEBOOKID_FIELD, GCGETRANKINGREWARDPLAYER_LEVEL_FIELD, GCGETRANKINGREWARDPLAYER_VIPLEVEL_FIELD, GCGETRANKINGREWARDPLAYER_GAMEID_FIELD, GCGETRANKINGREWARDPLAYER_REWARDITEMCNT_FIELD, GCGETRANKINGREWARDPLAYER_ITEMID_FIELD}
GCGETRANKINGREWARDPLAYER.is_extendable = false
GCGETRANKINGREWARDPLAYER.extensions = {}
CGGETSELFRANKINGS_GAMEID_FIELD.name = "gameId"
CGGETSELFRANKINGS_GAMEID_FIELD.full_name = ".com.zy.game.casino.message.CGGetSelfRankings.gameId"
CGGETSELFRANKINGS_GAMEID_FIELD.number = 1
CGGETSELFRANKINGS_GAMEID_FIELD.index = 0
CGGETSELFRANKINGS_GAMEID_FIELD.label = 2
CGGETSELFRANKINGS_GAMEID_FIELD.has_default_value = false
CGGETSELFRANKINGS_GAMEID_FIELD.default_value = 0
CGGETSELFRANKINGS_GAMEID_FIELD.type = 5
CGGETSELFRANKINGS_GAMEID_FIELD.cpp_type = 1

CGGETSELFRANKINGS_ROOMID_FIELD.name = "roomId"
CGGETSELFRANKINGS_ROOMID_FIELD.full_name = ".com.zy.game.casino.message.CGGetSelfRankings.roomId"
CGGETSELFRANKINGS_ROOMID_FIELD.number = 2
CGGETSELFRANKINGS_ROOMID_FIELD.index = 1
CGGETSELFRANKINGS_ROOMID_FIELD.label = 1
CGGETSELFRANKINGS_ROOMID_FIELD.has_default_value = false
CGGETSELFRANKINGS_ROOMID_FIELD.default_value = 0
CGGETSELFRANKINGS_ROOMID_FIELD.type = 5
CGGETSELFRANKINGS_ROOMID_FIELD.cpp_type = 1

CGGETSELFRANKINGS.name = "CGGetSelfRankings"
CGGETSELFRANKINGS.full_name = ".com.zy.game.casino.message.CGGetSelfRankings"
CGGETSELFRANKINGS.nested_types = {}
CGGETSELFRANKINGS.enum_types = {}
CGGETSELFRANKINGS.fields = {CGGETSELFRANKINGS_GAMEID_FIELD, CGGETSELFRANKINGS_ROOMID_FIELD}
CGGETSELFRANKINGS.is_extendable = false
CGGETSELFRANKINGS.extensions = {}
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.name = "selfRankings"
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.full_name = ".com.zy.game.casino.message.GCGetSelfRankings.selfRankings"
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.number = 1
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.index = 0
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.label = 3
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.has_default_value = false
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.default_value = {}
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.message_type = RANKINGMODEL
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.type = 11
GCGETSELFRANKINGS_SELFRANKINGS_FIELD.cpp_type = 10

GCGETSELFRANKINGS_REWARDMAPPING_FIELD.name = "rewardMapping"
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.full_name = ".com.zy.game.casino.message.GCGetSelfRankings.rewardMapping"
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.number = 2
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.index = 1
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.label = 3
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.has_default_value = false
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.default_value = {}
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.message_type = RANKINGMODEL
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.type = 11
GCGETSELFRANKINGS_REWARDMAPPING_FIELD.cpp_type = 10

GCGETSELFRANKINGS.name = "GCGetSelfRankings"
GCGETSELFRANKINGS.full_name = ".com.zy.game.casino.message.GCGetSelfRankings"
GCGETSELFRANKINGS.nested_types = {}
GCGETSELFRANKINGS.enum_types = {}
GCGETSELFRANKINGS.fields = {GCGETSELFRANKINGS_SELFRANKINGS_FIELD, GCGETSELFRANKINGS_REWARDMAPPING_FIELD}
GCGETSELFRANKINGS.is_extendable = false
GCGETSELFRANKINGS.extensions = {}
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.name = "gameId"
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.full_name = ".com.zy.game.casino.message.CGGetRankingRemainedTime.gameId"
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.number = 1
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.index = 0
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.label = 1
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.has_default_value = false
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.default_value = 0
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.type = 5
CGGETRANKINGREMAINEDTIME_GAMEID_FIELD.cpp_type = 1

CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.name = "roomId"
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.full_name = ".com.zy.game.casino.message.CGGetRankingRemainedTime.roomId"
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.number = 2
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.index = 1
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.label = 1
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.has_default_value = false
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.default_value = 0
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.type = 5
CGGETRANKINGREMAINEDTIME_ROOMID_FIELD.cpp_type = 1

CGGETRANKINGREMAINEDTIME.name = "CGGetRankingRemainedTime"
CGGETRANKINGREMAINEDTIME.full_name = ".com.zy.game.casino.message.CGGetRankingRemainedTime"
CGGETRANKINGREMAINEDTIME.nested_types = {}
CGGETRANKINGREMAINEDTIME.enum_types = {}
CGGETRANKINGREMAINEDTIME.fields = {CGGETRANKINGREMAINEDTIME_GAMEID_FIELD, CGGETRANKINGREMAINEDTIME_ROOMID_FIELD}
CGGETRANKINGREMAINEDTIME.is_extendable = false
CGGETRANKINGREMAINEDTIME.extensions = {}
RANKINGTIMEMODEL_GAMEID_FIELD.name = "gameId"
RANKINGTIMEMODEL_GAMEID_FIELD.full_name = ".com.zy.game.casino.message.RankingTimeModel.gameId"
RANKINGTIMEMODEL_GAMEID_FIELD.number = 1
RANKINGTIMEMODEL_GAMEID_FIELD.index = 0
RANKINGTIMEMODEL_GAMEID_FIELD.label = 1
RANKINGTIMEMODEL_GAMEID_FIELD.has_default_value = false
RANKINGTIMEMODEL_GAMEID_FIELD.default_value = 0
RANKINGTIMEMODEL_GAMEID_FIELD.type = 5
RANKINGTIMEMODEL_GAMEID_FIELD.cpp_type = 1

RANKINGTIMEMODEL_ROOMID_FIELD.name = "roomId"
RANKINGTIMEMODEL_ROOMID_FIELD.full_name = ".com.zy.game.casino.message.RankingTimeModel.roomId"
RANKINGTIMEMODEL_ROOMID_FIELD.number = 2
RANKINGTIMEMODEL_ROOMID_FIELD.index = 1
RANKINGTIMEMODEL_ROOMID_FIELD.label = 1
RANKINGTIMEMODEL_ROOMID_FIELD.has_default_value = false
RANKINGTIMEMODEL_ROOMID_FIELD.default_value = 0
RANKINGTIMEMODEL_ROOMID_FIELD.type = 5
RANKINGTIMEMODEL_ROOMID_FIELD.cpp_type = 1

RANKINGTIMEMODEL_RANKINGTYPE_FIELD.name = "rankingType"
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.full_name = ".com.zy.game.casino.message.RankingTimeModel.rankingType"
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.number = 3
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.index = 2
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.label = 1
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.has_default_value = false
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.default_value = 0
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.type = 5
RANKINGTIMEMODEL_RANKINGTYPE_FIELD.cpp_type = 1

RANKINGTIMEMODEL_REMAINEDTIME_FIELD.name = "remainedTime"
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.full_name = ".com.zy.game.casino.message.RankingTimeModel.remainedTime"
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.number = 4
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.index = 3
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.label = 1
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.has_default_value = false
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.default_value = 0
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.type = 5
RANKINGTIMEMODEL_REMAINEDTIME_FIELD.cpp_type = 1

RANKINGTIMEMODEL.name = "RankingTimeModel"
RANKINGTIMEMODEL.full_name = ".com.zy.game.casino.message.RankingTimeModel"
RANKINGTIMEMODEL.nested_types = {}
RANKINGTIMEMODEL.enum_types = {}
RANKINGTIMEMODEL.fields = {RANKINGTIMEMODEL_GAMEID_FIELD, RANKINGTIMEMODEL_ROOMID_FIELD, RANKINGTIMEMODEL_RANKINGTYPE_FIELD, RANKINGTIMEMODEL_REMAINEDTIME_FIELD}
RANKINGTIMEMODEL.is_extendable = false
RANKINGTIMEMODEL.extensions = {}
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.name = "remainedTimeList"
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.full_name = ".com.zy.game.casino.message.GCGetRankingRemainedTime.remainedTimeList"
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.number = 1
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.index = 0
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.label = 3
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.has_default_value = false
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.default_value = {}
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.message_type = RANKINGTIMEMODEL
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.type = 11
GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD.cpp_type = 10

GCGETRANKINGREMAINEDTIME.name = "GCGetRankingRemainedTime"
GCGETRANKINGREMAINEDTIME.full_name = ".com.zy.game.casino.message.GCGetRankingRemainedTime"
GCGETRANKINGREMAINEDTIME.nested_types = {}
GCGETRANKINGREMAINEDTIME.enum_types = {}
GCGETRANKINGREMAINEDTIME.fields = {GCGETRANKINGREMAINEDTIME_REMAINEDTIMELIST_FIELD}
GCGETRANKINGREMAINEDTIME.is_extendable = false
GCGETRANKINGREMAINEDTIME.extensions = {}

CGGetRankingListInGame = protobuf.Message(CGGETRANKINGLISTINGAME)
CGGetRankingListInRoom = protobuf.Message(CGGETRANKINGLISTINROOM)
CGGetRankingRemainedTime = protobuf.Message(CGGETRANKINGREMAINEDTIME)
CGGetSelfRankings = protobuf.Message(CGGETSELFRANKINGS)
GCGetRankingListInGame = protobuf.Message(GCGETRANKINGLISTINGAME)
GCGetRankingListInRoom = protobuf.Message(GCGETRANKINGLISTINROOM)
GCGetRankingRemainedTime = protobuf.Message(GCGETRANKINGREMAINEDTIME)
GCGetRankingRewardPlayer = protobuf.Message(GCGETRANKINGREWARDPLAYER)
GCGetSelfRankings = protobuf.Message(GCGETSELFRANKINGS)
RankingModel = protobuf.Message(RANKINGMODEL)
RankingTimeModel = protobuf.Message(RANKINGTIMEMODEL)
