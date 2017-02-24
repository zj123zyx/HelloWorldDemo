
require "app.data.bj.dict.dict_bj_card"

BJ = {}

BJ.DICT_BJ_CARD=dict_bj_card

BJ.CARD_COLOR = {
    spade="spade",
    heart="heart",
    club="club",
    diamond="diamond",
    default=""
}

BJ.CARD_TYPE ={
    NORMAL="normal",
    JOKER="joker"
}

BJ.STANDARD_NUM=21
BJ.BANKER_NUM=17

BJ.HAND_ID ={
    HAND1="1",
    HAND1_SPLIT="11",
    HAND2="2",
    HAND2_SPLIT="22",
    HAND3="3",
    HAND3_SPLIT="33",
    BANKER="4"
}

--发牌顺序
BJ.HAND_SEQ ={
    BJ.HAND_ID.HAND1,
    BJ.HAND_ID.HAND1_SPLIT,
    BJ.HAND_ID.HAND2,
    BJ.HAND_ID.HAND2_SPLIT,
    BJ.HAND_ID.HAND3,
    BJ.HAND_ID.HAND3_SPLIT
}

BJ.HAND_RESULT ={
    INIT=0, --初始化两张牌
    HIT_ING=1, --抽牌中
    BUST=2, --爆牌
    WAIT_FOR_COMPARE=3, --已停牌,等待和庄家比较
    WIN=4, --赢
    PUSH=5, --平手
    NO_WIN=6 --输
}

BJ.ROUND_STATE ={
    INIT=0, 
    ING=1, 
    END=2
}

BJ.GAME_STATE = {
    BET = 1,
    DEAL = 2,
    DOUBLE_JACK = 3,
    INSURANCE = 4,
    CHECK_BJ = 5,
    ROUND = 6,
    ANIMATION=7,
    BANKER=8,
    END=9,
}


BJ.BETS = {100,200,300,500,1000,2000,5000,10000}
