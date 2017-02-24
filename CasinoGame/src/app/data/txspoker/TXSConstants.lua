
require "app.data.txspoker.dict.dict_txs_card"
require "app.data.txspoker.dict.dict_txs_paytable"

TXS = {}

TXS.DICT_TXS_CARD=dict_txs_card
TXS.DICT_TXS_PAYTABLE=dict_txs_paytable

TXS.CARD_COLOR = {
    spade="spade",
    heart="heart",
    club="club",
    diamond="diamond",
    default=""
}

TXS.CARD_TYPE ={
    NORMAL="normal",
    JOKER="joker"
}

TXS.ROUND_STATE ={
    INIT=0, 
    ING=1, 
    END=2
}

TXS.PATTERN_ID={
    Royal_Straight_Flush=1,
    Straight_Flush=2,
    Four_of_a_Kind=3,
    Full_house=4,
    Flush=5,
    Straight=6,
    Three_of_a_Kind=7,
    Two_Pairs=8,
    One_Pair=9,
    High_Card=10
}

TXS.ROUND_RESULT ={
    INIT=0,
    WIN=1, --赢
    PUSH=2, --平手
    NO_WIN=3 --输
}
TXS.ROUND_RESULT_NAME ={"WIN","PUSH","NO WIN"}

TXS.PATTERN_RULE ={
    Royal_Straight_Flush={flush=1,card_nums={"1_10_11_12_13"}},
    Straight_Flush={flush=1,card_nums={"1_2_3_4_5","2_3_4_5_6","3_4_5_6_7","5_6_7_8_9","6_7_8_9_10","7_8_9_10_11","8_9_10_11_12","9_10_11_12_13"}},
    Four_of_a_Kind={flush=0,kindA=4},
    Full_house={flush=0,kindA=3,kindB=2},
    Flush={flush=1},
    Straight={flush=0,card_nums={"1_10_11_12_13","1_2_3_4_5","2_3_4_5_6","3_4_5_6_7","5_6_7_8_9","6_7_8_9_10","7_8_9_10_11","8_9_10_11_12","9_10_11_12_13"}},
    Three_of_a_Kind={flush=0,kindA=3},
    Two_Pairs={flush=0,kindA=2,kindB=2},
    Jacks_or_better={flush=0,kindA=2,card_nums={"1","11","12","13"}}
}

