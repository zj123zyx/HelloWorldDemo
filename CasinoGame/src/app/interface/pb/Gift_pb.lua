-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('Gift_pb')


local CGGETGIFTLIST = protobuf.Descriptor();
local CGGETGIFTLIST_PID_FIELD = protobuf.FieldDescriptor();
local CGGETGIFTLIST_STATE_FIELD = protobuf.FieldDescriptor();
local GCGIFT = protobuf.Descriptor();
local GCGIFT_ID_FIELD = protobuf.FieldDescriptor();
local GCGIFT_FROMPID_FIELD = protobuf.FieldDescriptor();
local GCGIFT_FROMNAME_FIELD = protobuf.FieldDescriptor();
local GCGIFT_PICTUREID_FIELD = protobuf.FieldDescriptor();
local GCGIFT_FACEBOOKID_FIELD = protobuf.FieldDescriptor();
local GCGIFT_TOPID_FIELD = protobuf.FieldDescriptor();
local GCGIFT_GIFTID_FIELD = protobuf.FieldDescriptor();
local GCGIFT_STATE_FIELD = protobuf.FieldDescriptor();
local GCGIFT_TYPE_FIELD = protobuf.FieldDescriptor();
local GCGIFT_ITEMID_FIELD = protobuf.FieldDescriptor();
local GCGIFT_ITEMCNT_FIELD = protobuf.FieldDescriptor();
local GCGIFT_TITLE_FIELD = protobuf.FieldDescriptor();
local GCGIFT_CONTENT_FIELD = protobuf.FieldDescriptor();
local GCGIFT_GIFTPICTURE_FIELD = protobuf.FieldDescriptor();
local GCGIFT_FROMVIPLEVEL_FIELD = protobuf.FieldDescriptor();
local GCGETGIFTLIST = protobuf.Descriptor();
local GCGETGIFTLIST_GIFTLIST_FIELD = protobuf.FieldDescriptor();
local CGSENDGIFT = protobuf.Descriptor();
local CGSENDGIFT_FROMPID_FIELD = protobuf.FieldDescriptor();
local CGSENDGIFT_TOPID_FIELD = protobuf.FieldDescriptor();
local CGSENDGIFT_GIFTID_FIELD = protobuf.FieldDescriptor();
local GCSENDGIFT = protobuf.Descriptor();
local GCSENDGIFT_RESULT_FIELD = protobuf.FieldDescriptor();
local GCSENDGIFT_COSTCOINS_FIELD = protobuf.FieldDescriptor();
local GCSENDGIFT_COSTGEMS_FIELD = protobuf.FieldDescriptor();
local CGRECEIVEGIFT = protobuf.Descriptor();
local CGRECEIVEGIFT_ID_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEGIFT = protobuf.Descriptor();
local GCRECEIVEGIFT_RESULT_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEGIFT_REWARDCOINS_FIELD = protobuf.FieldDescriptor();
local GCRECEIVEGIFT_REWARDGEMS_FIELD = protobuf.FieldDescriptor();

CGGETGIFTLIST_PID_FIELD.name = "pid"
CGGETGIFTLIST_PID_FIELD.full_name = ".com.zy.game.casino.message.CGGetGiftList.pid"
CGGETGIFTLIST_PID_FIELD.number = 1
CGGETGIFTLIST_PID_FIELD.index = 0
CGGETGIFTLIST_PID_FIELD.label = 2
CGGETGIFTLIST_PID_FIELD.has_default_value = false
CGGETGIFTLIST_PID_FIELD.default_value = 0
CGGETGIFTLIST_PID_FIELD.type = 3
CGGETGIFTLIST_PID_FIELD.cpp_type = 2

CGGETGIFTLIST_STATE_FIELD.name = "state"
CGGETGIFTLIST_STATE_FIELD.full_name = ".com.zy.game.casino.message.CGGetGiftList.state"
CGGETGIFTLIST_STATE_FIELD.number = 2
CGGETGIFTLIST_STATE_FIELD.index = 1
CGGETGIFTLIST_STATE_FIELD.label = 2
CGGETGIFTLIST_STATE_FIELD.has_default_value = false
CGGETGIFTLIST_STATE_FIELD.default_value = 0
CGGETGIFTLIST_STATE_FIELD.type = 5
CGGETGIFTLIST_STATE_FIELD.cpp_type = 1

CGGETGIFTLIST.name = "CGGetGiftList"
CGGETGIFTLIST.full_name = ".com.zy.game.casino.message.CGGetGiftList"
CGGETGIFTLIST.nested_types = {}
CGGETGIFTLIST.enum_types = {}
CGGETGIFTLIST.fields = {CGGETGIFTLIST_PID_FIELD, CGGETGIFTLIST_STATE_FIELD}
CGGETGIFTLIST.is_extendable = false
CGGETGIFTLIST.extensions = {}
GCGIFT_ID_FIELD.name = "id"
GCGIFT_ID_FIELD.full_name = ".com.zy.game.casino.message.GCGift.id"
GCGIFT_ID_FIELD.number = 1
GCGIFT_ID_FIELD.index = 0
GCGIFT_ID_FIELD.label = 2
GCGIFT_ID_FIELD.has_default_value = false
GCGIFT_ID_FIELD.default_value = 0
GCGIFT_ID_FIELD.type = 3
GCGIFT_ID_FIELD.cpp_type = 2

GCGIFT_FROMPID_FIELD.name = "fromPid"
GCGIFT_FROMPID_FIELD.full_name = ".com.zy.game.casino.message.GCGift.fromPid"
GCGIFT_FROMPID_FIELD.number = 2
GCGIFT_FROMPID_FIELD.index = 1
GCGIFT_FROMPID_FIELD.label = 2
GCGIFT_FROMPID_FIELD.has_default_value = false
GCGIFT_FROMPID_FIELD.default_value = 0
GCGIFT_FROMPID_FIELD.type = 3
GCGIFT_FROMPID_FIELD.cpp_type = 2

GCGIFT_FROMNAME_FIELD.name = "fromName"
GCGIFT_FROMNAME_FIELD.full_name = ".com.zy.game.casino.message.GCGift.fromName"
GCGIFT_FROMNAME_FIELD.number = 3
GCGIFT_FROMNAME_FIELD.index = 2
GCGIFT_FROMNAME_FIELD.label = 2
GCGIFT_FROMNAME_FIELD.has_default_value = false
GCGIFT_FROMNAME_FIELD.default_value = ""
GCGIFT_FROMNAME_FIELD.type = 9
GCGIFT_FROMNAME_FIELD.cpp_type = 9

GCGIFT_PICTUREID_FIELD.name = "pictureId"
GCGIFT_PICTUREID_FIELD.full_name = ".com.zy.game.casino.message.GCGift.pictureId"
GCGIFT_PICTUREID_FIELD.number = 4
GCGIFT_PICTUREID_FIELD.index = 3
GCGIFT_PICTUREID_FIELD.label = 1
GCGIFT_PICTUREID_FIELD.has_default_value = false
GCGIFT_PICTUREID_FIELD.default_value = 0
GCGIFT_PICTUREID_FIELD.type = 5
GCGIFT_PICTUREID_FIELD.cpp_type = 1

GCGIFT_FACEBOOKID_FIELD.name = "facebookId"
GCGIFT_FACEBOOKID_FIELD.full_name = ".com.zy.game.casino.message.GCGift.facebookId"
GCGIFT_FACEBOOKID_FIELD.number = 5
GCGIFT_FACEBOOKID_FIELD.index = 4
GCGIFT_FACEBOOKID_FIELD.label = 1
GCGIFT_FACEBOOKID_FIELD.has_default_value = false
GCGIFT_FACEBOOKID_FIELD.default_value = ""
GCGIFT_FACEBOOKID_FIELD.type = 9
GCGIFT_FACEBOOKID_FIELD.cpp_type = 9

GCGIFT_TOPID_FIELD.name = "toPid"
GCGIFT_TOPID_FIELD.full_name = ".com.zy.game.casino.message.GCGift.toPid"
GCGIFT_TOPID_FIELD.number = 6
GCGIFT_TOPID_FIELD.index = 5
GCGIFT_TOPID_FIELD.label = 2
GCGIFT_TOPID_FIELD.has_default_value = false
GCGIFT_TOPID_FIELD.default_value = 0
GCGIFT_TOPID_FIELD.type = 3
GCGIFT_TOPID_FIELD.cpp_type = 2

GCGIFT_GIFTID_FIELD.name = "giftId"
GCGIFT_GIFTID_FIELD.full_name = ".com.zy.game.casino.message.GCGift.giftId"
GCGIFT_GIFTID_FIELD.number = 7
GCGIFT_GIFTID_FIELD.index = 6
GCGIFT_GIFTID_FIELD.label = 1
GCGIFT_GIFTID_FIELD.has_default_value = false
GCGIFT_GIFTID_FIELD.default_value = 0
GCGIFT_GIFTID_FIELD.type = 5
GCGIFT_GIFTID_FIELD.cpp_type = 1

GCGIFT_STATE_FIELD.name = "state"
GCGIFT_STATE_FIELD.full_name = ".com.zy.game.casino.message.GCGift.state"
GCGIFT_STATE_FIELD.number = 8
GCGIFT_STATE_FIELD.index = 7
GCGIFT_STATE_FIELD.label = 2
GCGIFT_STATE_FIELD.has_default_value = false
GCGIFT_STATE_FIELD.default_value = 0
GCGIFT_STATE_FIELD.type = 5
GCGIFT_STATE_FIELD.cpp_type = 1

GCGIFT_TYPE_FIELD.name = "type"
GCGIFT_TYPE_FIELD.full_name = ".com.zy.game.casino.message.GCGift.type"
GCGIFT_TYPE_FIELD.number = 9
GCGIFT_TYPE_FIELD.index = 8
GCGIFT_TYPE_FIELD.label = 2
GCGIFT_TYPE_FIELD.has_default_value = false
GCGIFT_TYPE_FIELD.default_value = 0
GCGIFT_TYPE_FIELD.type = 5
GCGIFT_TYPE_FIELD.cpp_type = 1

GCGIFT_ITEMID_FIELD.name = "itemId"
GCGIFT_ITEMID_FIELD.full_name = ".com.zy.game.casino.message.GCGift.itemId"
GCGIFT_ITEMID_FIELD.number = 10
GCGIFT_ITEMID_FIELD.index = 9
GCGIFT_ITEMID_FIELD.label = 1
GCGIFT_ITEMID_FIELD.has_default_value = false
GCGIFT_ITEMID_FIELD.default_value = 0
GCGIFT_ITEMID_FIELD.type = 5
GCGIFT_ITEMID_FIELD.cpp_type = 1

GCGIFT_ITEMCNT_FIELD.name = "itemCnt"
GCGIFT_ITEMCNT_FIELD.full_name = ".com.zy.game.casino.message.GCGift.itemCnt"
GCGIFT_ITEMCNT_FIELD.number = 11
GCGIFT_ITEMCNT_FIELD.index = 10
GCGIFT_ITEMCNT_FIELD.label = 1
GCGIFT_ITEMCNT_FIELD.has_default_value = false
GCGIFT_ITEMCNT_FIELD.default_value = 0
GCGIFT_ITEMCNT_FIELD.type = 5
GCGIFT_ITEMCNT_FIELD.cpp_type = 1

GCGIFT_TITLE_FIELD.name = "title"
GCGIFT_TITLE_FIELD.full_name = ".com.zy.game.casino.message.GCGift.title"
GCGIFT_TITLE_FIELD.number = 12
GCGIFT_TITLE_FIELD.index = 11
GCGIFT_TITLE_FIELD.label = 1
GCGIFT_TITLE_FIELD.has_default_value = false
GCGIFT_TITLE_FIELD.default_value = ""
GCGIFT_TITLE_FIELD.type = 9
GCGIFT_TITLE_FIELD.cpp_type = 9

GCGIFT_CONTENT_FIELD.name = "content"
GCGIFT_CONTENT_FIELD.full_name = ".com.zy.game.casino.message.GCGift.content"
GCGIFT_CONTENT_FIELD.number = 13
GCGIFT_CONTENT_FIELD.index = 12
GCGIFT_CONTENT_FIELD.label = 1
GCGIFT_CONTENT_FIELD.has_default_value = false
GCGIFT_CONTENT_FIELD.default_value = ""
GCGIFT_CONTENT_FIELD.type = 9
GCGIFT_CONTENT_FIELD.cpp_type = 9

GCGIFT_GIFTPICTURE_FIELD.name = "giftPicture"
GCGIFT_GIFTPICTURE_FIELD.full_name = ".com.zy.game.casino.message.GCGift.giftPicture"
GCGIFT_GIFTPICTURE_FIELD.number = 14
GCGIFT_GIFTPICTURE_FIELD.index = 13
GCGIFT_GIFTPICTURE_FIELD.label = 1
GCGIFT_GIFTPICTURE_FIELD.has_default_value = false
GCGIFT_GIFTPICTURE_FIELD.default_value = ""
GCGIFT_GIFTPICTURE_FIELD.type = 9
GCGIFT_GIFTPICTURE_FIELD.cpp_type = 9

GCGIFT_FROMVIPLEVEL_FIELD.name = "fromVipLevel"
GCGIFT_FROMVIPLEVEL_FIELD.full_name = ".com.zy.game.casino.message.GCGift.fromVipLevel"
GCGIFT_FROMVIPLEVEL_FIELD.number = 15
GCGIFT_FROMVIPLEVEL_FIELD.index = 14
GCGIFT_FROMVIPLEVEL_FIELD.label = 1
GCGIFT_FROMVIPLEVEL_FIELD.has_default_value = false
GCGIFT_FROMVIPLEVEL_FIELD.default_value = 0
GCGIFT_FROMVIPLEVEL_FIELD.type = 5
GCGIFT_FROMVIPLEVEL_FIELD.cpp_type = 1

GCGIFT.name = "GCGift"
GCGIFT.full_name = ".com.zy.game.casino.message.GCGift"
GCGIFT.nested_types = {}
GCGIFT.enum_types = {}
GCGIFT.fields = {GCGIFT_ID_FIELD, GCGIFT_FROMPID_FIELD, GCGIFT_FROMNAME_FIELD, GCGIFT_PICTUREID_FIELD, GCGIFT_FACEBOOKID_FIELD, GCGIFT_TOPID_FIELD, GCGIFT_GIFTID_FIELD, GCGIFT_STATE_FIELD, GCGIFT_TYPE_FIELD, GCGIFT_ITEMID_FIELD, GCGIFT_ITEMCNT_FIELD, GCGIFT_TITLE_FIELD, GCGIFT_CONTENT_FIELD, GCGIFT_GIFTPICTURE_FIELD, GCGIFT_FROMVIPLEVEL_FIELD}
GCGIFT.is_extendable = false
GCGIFT.extensions = {}
GCGETGIFTLIST_GIFTLIST_FIELD.name = "giftList"
GCGETGIFTLIST_GIFTLIST_FIELD.full_name = ".com.zy.game.casino.message.GCGetGiftList.giftList"
GCGETGIFTLIST_GIFTLIST_FIELD.number = 1
GCGETGIFTLIST_GIFTLIST_FIELD.index = 0
GCGETGIFTLIST_GIFTLIST_FIELD.label = 3
GCGETGIFTLIST_GIFTLIST_FIELD.has_default_value = false
GCGETGIFTLIST_GIFTLIST_FIELD.default_value = {}
GCGETGIFTLIST_GIFTLIST_FIELD.message_type = GCGIFT
GCGETGIFTLIST_GIFTLIST_FIELD.type = 11
GCGETGIFTLIST_GIFTLIST_FIELD.cpp_type = 10

GCGETGIFTLIST.name = "GCGetGiftList"
GCGETGIFTLIST.full_name = ".com.zy.game.casino.message.GCGetGiftList"
GCGETGIFTLIST.nested_types = {}
GCGETGIFTLIST.enum_types = {}
GCGETGIFTLIST.fields = {GCGETGIFTLIST_GIFTLIST_FIELD}
GCGETGIFTLIST.is_extendable = false
GCGETGIFTLIST.extensions = {}
CGSENDGIFT_FROMPID_FIELD.name = "fromPid"
CGSENDGIFT_FROMPID_FIELD.full_name = ".com.zy.game.casino.message.CGSendGift.fromPid"
CGSENDGIFT_FROMPID_FIELD.number = 1
CGSENDGIFT_FROMPID_FIELD.index = 0
CGSENDGIFT_FROMPID_FIELD.label = 2
CGSENDGIFT_FROMPID_FIELD.has_default_value = false
CGSENDGIFT_FROMPID_FIELD.default_value = 0
CGSENDGIFT_FROMPID_FIELD.type = 3
CGSENDGIFT_FROMPID_FIELD.cpp_type = 2

CGSENDGIFT_TOPID_FIELD.name = "toPid"
CGSENDGIFT_TOPID_FIELD.full_name = ".com.zy.game.casino.message.CGSendGift.toPid"
CGSENDGIFT_TOPID_FIELD.number = 2
CGSENDGIFT_TOPID_FIELD.index = 1
CGSENDGIFT_TOPID_FIELD.label = 2
CGSENDGIFT_TOPID_FIELD.has_default_value = false
CGSENDGIFT_TOPID_FIELD.default_value = ""
CGSENDGIFT_TOPID_FIELD.type = 9
CGSENDGIFT_TOPID_FIELD.cpp_type = 9

CGSENDGIFT_GIFTID_FIELD.name = "giftId"
CGSENDGIFT_GIFTID_FIELD.full_name = ".com.zy.game.casino.message.CGSendGift.giftId"
CGSENDGIFT_GIFTID_FIELD.number = 3
CGSENDGIFT_GIFTID_FIELD.index = 2
CGSENDGIFT_GIFTID_FIELD.label = 2
CGSENDGIFT_GIFTID_FIELD.has_default_value = false
CGSENDGIFT_GIFTID_FIELD.default_value = 0
CGSENDGIFT_GIFTID_FIELD.type = 5
CGSENDGIFT_GIFTID_FIELD.cpp_type = 1

CGSENDGIFT.name = "CGSendGift"
CGSENDGIFT.full_name = ".com.zy.game.casino.message.CGSendGift"
CGSENDGIFT.nested_types = {}
CGSENDGIFT.enum_types = {}
CGSENDGIFT.fields = {CGSENDGIFT_FROMPID_FIELD, CGSENDGIFT_TOPID_FIELD, CGSENDGIFT_GIFTID_FIELD}
CGSENDGIFT.is_extendable = false
CGSENDGIFT.extensions = {}
GCSENDGIFT_RESULT_FIELD.name = "result"
GCSENDGIFT_RESULT_FIELD.full_name = ".com.zy.game.casino.message.GCSendGift.result"
GCSENDGIFT_RESULT_FIELD.number = 1
GCSENDGIFT_RESULT_FIELD.index = 0
GCSENDGIFT_RESULT_FIELD.label = 2
GCSENDGIFT_RESULT_FIELD.has_default_value = false
GCSENDGIFT_RESULT_FIELD.default_value = 0
GCSENDGIFT_RESULT_FIELD.type = 5
GCSENDGIFT_RESULT_FIELD.cpp_type = 1

GCSENDGIFT_COSTCOINS_FIELD.name = "costCoins"
GCSENDGIFT_COSTCOINS_FIELD.full_name = ".com.zy.game.casino.message.GCSendGift.costCoins"
GCSENDGIFT_COSTCOINS_FIELD.number = 2
GCSENDGIFT_COSTCOINS_FIELD.index = 1
GCSENDGIFT_COSTCOINS_FIELD.label = 1
GCSENDGIFT_COSTCOINS_FIELD.has_default_value = false
GCSENDGIFT_COSTCOINS_FIELD.default_value = 0
GCSENDGIFT_COSTCOINS_FIELD.type = 3
GCSENDGIFT_COSTCOINS_FIELD.cpp_type = 2

GCSENDGIFT_COSTGEMS_FIELD.name = "costGems"
GCSENDGIFT_COSTGEMS_FIELD.full_name = ".com.zy.game.casino.message.GCSendGift.costGems"
GCSENDGIFT_COSTGEMS_FIELD.number = 3
GCSENDGIFT_COSTGEMS_FIELD.index = 2
GCSENDGIFT_COSTGEMS_FIELD.label = 1
GCSENDGIFT_COSTGEMS_FIELD.has_default_value = false
GCSENDGIFT_COSTGEMS_FIELD.default_value = 0
GCSENDGIFT_COSTGEMS_FIELD.type = 3
GCSENDGIFT_COSTGEMS_FIELD.cpp_type = 2

GCSENDGIFT.name = "GCSendGift"
GCSENDGIFT.full_name = ".com.zy.game.casino.message.GCSendGift"
GCSENDGIFT.nested_types = {}
GCSENDGIFT.enum_types = {}
GCSENDGIFT.fields = {GCSENDGIFT_RESULT_FIELD, GCSENDGIFT_COSTCOINS_FIELD, GCSENDGIFT_COSTGEMS_FIELD}
GCSENDGIFT.is_extendable = false
GCSENDGIFT.extensions = {}
CGRECEIVEGIFT_ID_FIELD.name = "id"
CGRECEIVEGIFT_ID_FIELD.full_name = ".com.zy.game.casino.message.CGReceiveGift.id"
CGRECEIVEGIFT_ID_FIELD.number = 1
CGRECEIVEGIFT_ID_FIELD.index = 0
CGRECEIVEGIFT_ID_FIELD.label = 2
CGRECEIVEGIFT_ID_FIELD.has_default_value = false
CGRECEIVEGIFT_ID_FIELD.default_value = 0
CGRECEIVEGIFT_ID_FIELD.type = 3
CGRECEIVEGIFT_ID_FIELD.cpp_type = 2

CGRECEIVEGIFT.name = "CGReceiveGift"
CGRECEIVEGIFT.full_name = ".com.zy.game.casino.message.CGReceiveGift"
CGRECEIVEGIFT.nested_types = {}
CGRECEIVEGIFT.enum_types = {}
CGRECEIVEGIFT.fields = {CGRECEIVEGIFT_ID_FIELD}
CGRECEIVEGIFT.is_extendable = false
CGRECEIVEGIFT.extensions = {}
GCRECEIVEGIFT_RESULT_FIELD.name = "result"
GCRECEIVEGIFT_RESULT_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveGift.result"
GCRECEIVEGIFT_RESULT_FIELD.number = 1
GCRECEIVEGIFT_RESULT_FIELD.index = 0
GCRECEIVEGIFT_RESULT_FIELD.label = 2
GCRECEIVEGIFT_RESULT_FIELD.has_default_value = false
GCRECEIVEGIFT_RESULT_FIELD.default_value = 0
GCRECEIVEGIFT_RESULT_FIELD.type = 5
GCRECEIVEGIFT_RESULT_FIELD.cpp_type = 1

GCRECEIVEGIFT_REWARDCOINS_FIELD.name = "rewardCoins"
GCRECEIVEGIFT_REWARDCOINS_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveGift.rewardCoins"
GCRECEIVEGIFT_REWARDCOINS_FIELD.number = 2
GCRECEIVEGIFT_REWARDCOINS_FIELD.index = 1
GCRECEIVEGIFT_REWARDCOINS_FIELD.label = 1
GCRECEIVEGIFT_REWARDCOINS_FIELD.has_default_value = false
GCRECEIVEGIFT_REWARDCOINS_FIELD.default_value = 0
GCRECEIVEGIFT_REWARDCOINS_FIELD.type = 3
GCRECEIVEGIFT_REWARDCOINS_FIELD.cpp_type = 2

GCRECEIVEGIFT_REWARDGEMS_FIELD.name = "rewardGems"
GCRECEIVEGIFT_REWARDGEMS_FIELD.full_name = ".com.zy.game.casino.message.GCReceiveGift.rewardGems"
GCRECEIVEGIFT_REWARDGEMS_FIELD.number = 3
GCRECEIVEGIFT_REWARDGEMS_FIELD.index = 2
GCRECEIVEGIFT_REWARDGEMS_FIELD.label = 1
GCRECEIVEGIFT_REWARDGEMS_FIELD.has_default_value = false
GCRECEIVEGIFT_REWARDGEMS_FIELD.default_value = 0
GCRECEIVEGIFT_REWARDGEMS_FIELD.type = 3
GCRECEIVEGIFT_REWARDGEMS_FIELD.cpp_type = 2

GCRECEIVEGIFT.name = "GCReceiveGift"
GCRECEIVEGIFT.full_name = ".com.zy.game.casino.message.GCReceiveGift"
GCRECEIVEGIFT.nested_types = {}
GCRECEIVEGIFT.enum_types = {}
GCRECEIVEGIFT.fields = {GCRECEIVEGIFT_RESULT_FIELD, GCRECEIVEGIFT_REWARDCOINS_FIELD, GCRECEIVEGIFT_REWARDGEMS_FIELD}
GCRECEIVEGIFT.is_extendable = false
GCRECEIVEGIFT.extensions = {}

CGGetGiftList = protobuf.Message(CGGETGIFTLIST)
CGReceiveGift = protobuf.Message(CGRECEIVEGIFT)
CGSendGift = protobuf.Message(CGSENDGIFT)
GCGetGiftList = protobuf.Message(GCGETGIFTLIST)
GCGift = protobuf.Message(GCGIFT)
GCReceiveGift = protobuf.Message(GCRECEIVEGIFT)
GCSendGift = protobuf.Message(GCSENDGIFT)

