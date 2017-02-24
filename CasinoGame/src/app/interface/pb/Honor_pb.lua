-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('Honor_pb')


local CGGETHONORLIST = protobuf.Descriptor();
local CGGETHONORLIST_PID_FIELD = protobuf.FieldDescriptor();
local GCHONOR = protobuf.Descriptor();
local GCHONOR_HONORID_FIELD = protobuf.FieldDescriptor();
local GCHONOR_LEVEL_FIELD = protobuf.FieldDescriptor();
local GCHONOR_MAXLEVEL_FIELD = protobuf.FieldDescriptor();
local GCHONOR_TITLE_FIELD = protobuf.FieldDescriptor();
local GCHONOR_CURRENTPOINT_FIELD = protobuf.FieldDescriptor();
local GCHONOR_TARGETPOINT_FIELD = protobuf.FieldDescriptor();
local GCHONOR_STATE_FIELD = protobuf.FieldDescriptor();
local GCHONOR_REWARDTYPE_FIELD = protobuf.FieldDescriptor();
local GCHONOR_REWARDCNT_FIELD = protobuf.FieldDescriptor();
local GCHONOR_PICTURE_FIELD = protobuf.FieldDescriptor();
local GCHONOR_CATEGORY_FIELD = protobuf.FieldDescriptor();
local GCGETHONORLIST = protobuf.Descriptor();
local GCGETHONORLIST_HONORLIST_FIELD = protobuf.FieldDescriptor();
local CGRECEIVEHONORREWARD = protobuf.Descriptor();
local CGRECEIVEHONORREWARD_PID_FIELD = protobuf.FieldDescriptor();
local CGRECEIVEHONORREWARD_HONORID_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEHONORREWARD = protobuf.Descriptor();
local GCRECEIVEHONORREWARD_RESULT_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEHONORREWARD_REWARDTYPE_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEHONORREWARD_REWARDCNT_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEHONORREWARD_NEWLEVEL_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEHONORREWARD_NEWSTATE_FIELD = protobuf.FieldDescriptor();

CGGETHONORLIST_PID_FIELD.name = "pid"
CGGETHONORLIST_PID_FIELD.full_name = ".com.zy.game.casino.message.CGGetHonorList.pid"
CGGETHONORLIST_PID_FIELD.number = 1
CGGETHONORLIST_PID_FIELD.index = 0
CGGETHONORLIST_PID_FIELD.label = 2
CGGETHONORLIST_PID_FIELD.has_default_value = false
CGGETHONORLIST_PID_FIELD.default_value = 0
CGGETHONORLIST_PID_FIELD.type = 3
CGGETHONORLIST_PID_FIELD.cpp_type = 2

CGGETHONORLIST.name = "CGGetHonorList"
CGGETHONORLIST.full_name = ".com.zy.game.casino.message.CGGetHonorList"
CGGETHONORLIST.nested_types = {}
CGGETHONORLIST.enum_types = {}
CGGETHONORLIST.fields = {CGGETHONORLIST_PID_FIELD}
CGGETHONORLIST.is_extendable = false
CGGETHONORLIST.extensions = {}
GCHONOR_HONORID_FIELD.name = "honorId"
GCHONOR_HONORID_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.honorId"
GCHONOR_HONORID_FIELD.number = 1
GCHONOR_HONORID_FIELD.index = 0
GCHONOR_HONORID_FIELD.label = 2
GCHONOR_HONORID_FIELD.has_default_value = false
GCHONOR_HONORID_FIELD.default_value = 0
GCHONOR_HONORID_FIELD.type = 5
GCHONOR_HONORID_FIELD.cpp_type = 1

GCHONOR_LEVEL_FIELD.name = "level"
GCHONOR_LEVEL_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.level"
GCHONOR_LEVEL_FIELD.number = 2
GCHONOR_LEVEL_FIELD.index = 1
GCHONOR_LEVEL_FIELD.label = 2
GCHONOR_LEVEL_FIELD.has_default_value = false
GCHONOR_LEVEL_FIELD.default_value = 0
GCHONOR_LEVEL_FIELD.type = 5
GCHONOR_LEVEL_FIELD.cpp_type = 1

GCHONOR_MAXLEVEL_FIELD.name = "maxLevel"
GCHONOR_MAXLEVEL_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.maxLevel"
GCHONOR_MAXLEVEL_FIELD.number = 3
GCHONOR_MAXLEVEL_FIELD.index = 2
GCHONOR_MAXLEVEL_FIELD.label = 2
GCHONOR_MAXLEVEL_FIELD.has_default_value = false
GCHONOR_MAXLEVEL_FIELD.default_value = 0
GCHONOR_MAXLEVEL_FIELD.type = 5
GCHONOR_MAXLEVEL_FIELD.cpp_type = 1

GCHONOR_TITLE_FIELD.name = "title"
GCHONOR_TITLE_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.title"
GCHONOR_TITLE_FIELD.number = 4
GCHONOR_TITLE_FIELD.index = 3
GCHONOR_TITLE_FIELD.label = 2
GCHONOR_TITLE_FIELD.has_default_value = false
GCHONOR_TITLE_FIELD.default_value = ""
GCHONOR_TITLE_FIELD.type = 9
GCHONOR_TITLE_FIELD.cpp_type = 9

GCHONOR_CURRENTPOINT_FIELD.name = "currentPoint"
GCHONOR_CURRENTPOINT_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.currentPoint"
GCHONOR_CURRENTPOINT_FIELD.number = 5
GCHONOR_CURRENTPOINT_FIELD.index = 4
GCHONOR_CURRENTPOINT_FIELD.label = 2
GCHONOR_CURRENTPOINT_FIELD.has_default_value = false
GCHONOR_CURRENTPOINT_FIELD.default_value = 0
GCHONOR_CURRENTPOINT_FIELD.type = 3
GCHONOR_CURRENTPOINT_FIELD.cpp_type = 2

GCHONOR_TARGETPOINT_FIELD.name = "targetPoint"
GCHONOR_TARGETPOINT_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.targetPoint"
GCHONOR_TARGETPOINT_FIELD.number = 6
GCHONOR_TARGETPOINT_FIELD.index = 5
GCHONOR_TARGETPOINT_FIELD.label = 2
GCHONOR_TARGETPOINT_FIELD.has_default_value = false
GCHONOR_TARGETPOINT_FIELD.default_value = 0
GCHONOR_TARGETPOINT_FIELD.type = 3
GCHONOR_TARGETPOINT_FIELD.cpp_type = 2

GCHONOR_STATE_FIELD.name = "state"
GCHONOR_STATE_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.state"
GCHONOR_STATE_FIELD.number = 7
GCHONOR_STATE_FIELD.index = 6
GCHONOR_STATE_FIELD.label = 2
GCHONOR_STATE_FIELD.has_default_value = false
GCHONOR_STATE_FIELD.default_value = 0
GCHONOR_STATE_FIELD.type = 5
GCHONOR_STATE_FIELD.cpp_type = 1

GCHONOR_REWARDTYPE_FIELD.name = "rewardType"
GCHONOR_REWARDTYPE_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.rewardType"
GCHONOR_REWARDTYPE_FIELD.number = 8
GCHONOR_REWARDTYPE_FIELD.index = 7
GCHONOR_REWARDTYPE_FIELD.label = 1
GCHONOR_REWARDTYPE_FIELD.has_default_value = false
GCHONOR_REWARDTYPE_FIELD.default_value = 0
GCHONOR_REWARDTYPE_FIELD.type = 5
GCHONOR_REWARDTYPE_FIELD.cpp_type = 1

GCHONOR_REWARDCNT_FIELD.name = "rewardCnt"
GCHONOR_REWARDCNT_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.rewardCnt"
GCHONOR_REWARDCNT_FIELD.number = 9
GCHONOR_REWARDCNT_FIELD.index = 8
GCHONOR_REWARDCNT_FIELD.label = 1
GCHONOR_REWARDCNT_FIELD.has_default_value = false
GCHONOR_REWARDCNT_FIELD.default_value = 0
GCHONOR_REWARDCNT_FIELD.type = 5
GCHONOR_REWARDCNT_FIELD.cpp_type = 1

GCHONOR_PICTURE_FIELD.name = "picture"
GCHONOR_PICTURE_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.picture"
GCHONOR_PICTURE_FIELD.number = 10
GCHONOR_PICTURE_FIELD.index = 9
GCHONOR_PICTURE_FIELD.label = 1
GCHONOR_PICTURE_FIELD.has_default_value = false
GCHONOR_PICTURE_FIELD.default_value = ""
GCHONOR_PICTURE_FIELD.type = 9
GCHONOR_PICTURE_FIELD.cpp_type = 9

GCHONOR_CATEGORY_FIELD.name = "category"
GCHONOR_CATEGORY_FIELD.full_name = ".com.zy.game.casino.message.GCHonor.category"
GCHONOR_CATEGORY_FIELD.number = 11
GCHONOR_CATEGORY_FIELD.index = 10
GCHONOR_CATEGORY_FIELD.label = 2
GCHONOR_CATEGORY_FIELD.has_default_value = false
GCHONOR_CATEGORY_FIELD.default_value = ""
GCHONOR_CATEGORY_FIELD.type = 9
GCHONOR_CATEGORY_FIELD.cpp_type = 9

GCHONOR.name = "GCHonor"
GCHONOR.full_name = ".com.zy.game.casino.message.GCHonor"
GCHONOR.nested_types = {}
GCHONOR.enum_types = {}
GCHONOR.fields = {GCHONOR_HONORID_FIELD, GCHONOR_LEVEL_FIELD, GCHONOR_MAXLEVEL_FIELD, GCHONOR_TITLE_FIELD, GCHONOR_CURRENTPOINT_FIELD, GCHONOR_TARGETPOINT_FIELD, GCHONOR_STATE_FIELD, GCHONOR_REWARDTYPE_FIELD, GCHONOR_REWARDCNT_FIELD, GCHONOR_PICTURE_FIELD, GCHONOR_CATEGORY_FIELD}
GCHONOR.is_extendable = false
GCHONOR.extensions = {}
GCGETHONORLIST_HONORLIST_FIELD.name = "honorList"
GCGETHONORLIST_HONORLIST_FIELD.full_name = ".com.zy.game.casino.message.GCGetHonorList.honorList"
GCGETHONORLIST_HONORLIST_FIELD.number = 1
GCGETHONORLIST_HONORLIST_FIELD.index = 0
GCGETHONORLIST_HONORLIST_FIELD.label = 3
GCGETHONORLIST_HONORLIST_FIELD.has_default_value = false
GCGETHONORLIST_HONORLIST_FIELD.default_value = {}
GCGETHONORLIST_HONORLIST_FIELD.message_type = GCHONOR
GCGETHONORLIST_HONORLIST_FIELD.type = 11
GCGETHONORLIST_HONORLIST_FIELD.cpp_type = 10

GCGETHONORLIST.name = "GCGetHonorList"
GCGETHONORLIST.full_name = ".com.zy.game.casino.message.GCGetHonorList"
GCGETHONORLIST.nested_types = {}
GCGETHONORLIST.enum_types = {}
GCGETHONORLIST.fields = {GCGETHONORLIST_HONORLIST_FIELD}
GCGETHONORLIST.is_extendable = false
GCGETHONORLIST.extensions = {}
CGRECEIVEHONORREWARD_PID_FIELD.name = "pid"
CGRECEIVEHONORREWARD_PID_FIELD.full_name = ".com.zy.game.casino.message.CGReceiveHonorReward.pid"
CGRECEIVEHONORREWARD_PID_FIELD.number = 1
CGRECEIVEHONORREWARD_PID_FIELD.index = 0
CGRECEIVEHONORREWARD_PID_FIELD.label = 2
CGRECEIVEHONORREWARD_PID_FIELD.has_default_value = false
CGRECEIVEHONORREWARD_PID_FIELD.default_value = 0
CGRECEIVEHONORREWARD_PID_FIELD.type = 3
CGRECEIVEHONORREWARD_PID_FIELD.cpp_type = 2

CGRECEIVEHONORREWARD_HONORID_FIELD.name = "honorId"
CGRECEIVEHONORREWARD_HONORID_FIELD.full_name = ".com.zy.game.casino.message.CGReceiveHonorReward.honorId"
CGRECEIVEHONORREWARD_HONORID_FIELD.number = 2
CGRECEIVEHONORREWARD_HONORID_FIELD.index = 1
CGRECEIVEHONORREWARD_HONORID_FIELD.label = 2
CGRECEIVEHONORREWARD_HONORID_FIELD.has_default_value = false
CGRECEIVEHONORREWARD_HONORID_FIELD.default_value = 0
CGRECEIVEHONORREWARD_HONORID_FIELD.type = 5
CGRECEIVEHONORREWARD_HONORID_FIELD.cpp_type = 1

CGRECEIVEHONORREWARD.name = "CGReceiveHonorReward"
CGRECEIVEHONORREWARD.full_name = ".com.zy.game.casino.message.CGReceiveHonorReward"
CGRECEIVEHONORREWARD.nested_types = {}
CGRECEIVEHONORREWARD.enum_types = {}
CGRECEIVEHONORREWARD.fields = {CGRECEIVEHONORREWARD_PID_FIELD, CGRECEIVEHONORREWARD_HONORID_FIELD}
CGRECEIVEHONORREWARD.is_extendable = false
CGRECEIVEHONORREWARD.extensions = {}
GCRECEIVEHONORREWARD_RESULT_FIELD.name = "result"
GCRECEIVEHONORREWARD_RESULT_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward.result"
GCRECEIVEHONORREWARD_RESULT_FIELD.number = 1
GCRECEIVEHONORREWARD_RESULT_FIELD.index = 0
GCRECEIVEHONORREWARD_RESULT_FIELD.label = 2
GCRECEIVEHONORREWARD_RESULT_FIELD.has_default_value = false
GCRECEIVEHONORREWARD_RESULT_FIELD.default_value = 0
GCRECEIVEHONORREWARD_RESULT_FIELD.type = 5
GCRECEIVEHONORREWARD_RESULT_FIELD.cpp_type = 1

GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.name = "rewardType"
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward.rewardType"
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.number = 2
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.index = 1
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.label = 1
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.has_default_value = false
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.default_value = 0
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.type = 5
GCRECEIVEHONORREWARD_REWARDTYPE_FIELD.cpp_type = 1

GCRECEIVEHONORREWARD_REWARDCNT_FIELD.name = "rewardCnt"
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward.rewardCnt"
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.number = 3
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.index = 2
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.label = 1
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.has_default_value = false
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.default_value = 0
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.type = 5
GCRECEIVEHONORREWARD_REWARDCNT_FIELD.cpp_type = 1

GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.name = "newLevel"
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward.newLevel"
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.number = 4
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.index = 3
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.label = 1
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.has_default_value = false
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.default_value = 0
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.type = 5
GCRECEIVEHONORREWARD_NEWLEVEL_FIELD.cpp_type = 1

GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.name = "newTargetPoint"
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward.newTargetPoint"
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.number = 5
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.index = 4
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.label = 1
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.has_default_value = false
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.default_value = 0
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.type = 5
GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD.cpp_type = 1

GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.name = "newLevelReward"
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward.newLevelReward"
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.number = 6
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.index = 5
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.label = 1
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.has_default_value = false
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.default_value = 0
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.type = 5
GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD.cpp_type = 1

GCRECEIVEHONORREWARD_NEWSTATE_FIELD.name = "newState"
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward.newState"
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.number = 7
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.index = 6
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.label = 1
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.has_default_value = false
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.default_value = 0
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.type = 5
GCRECEIVEHONORREWARD_NEWSTATE_FIELD.cpp_type = 1

GCRECEIVEHONORREWARD.name = "GCReceiveHonorReward"
GCRECEIVEHONORREWARD.full_name = ".com.zy.game.casino.message.GCReceiveHonorReward"
GCRECEIVEHONORREWARD.nested_types = {}
GCRECEIVEHONORREWARD.enum_types = {}
GCRECEIVEHONORREWARD.fields = {GCRECEIVEHONORREWARD_RESULT_FIELD, GCRECEIVEHONORREWARD_REWARDTYPE_FIELD, GCRECEIVEHONORREWARD_REWARDCNT_FIELD, GCRECEIVEHONORREWARD_NEWLEVEL_FIELD, GCRECEIVEHONORREWARD_NEWTARGETPOINT_FIELD, GCRECEIVEHONORREWARD_NEWLEVELREWARD_FIELD, GCRECEIVEHONORREWARD_NEWSTATE_FIELD}
GCRECEIVEHONORREWARD.is_extendable = false
GCRECEIVEHONORREWARD.extensions = {}

CGGetHonorList = protobuf.Message(CGGETHONORLIST)
CGReceiveHonorReward = protobuf.Message(CGRECEIVEHONORREWARD)
GCGetHonorList = protobuf.Message(GCGETHONORLIST)
GCHonor = protobuf.Message(GCHONOR)
GCReceiveHonorReward = protobuf.Message(GCRECEIVEHONORREWARD)

