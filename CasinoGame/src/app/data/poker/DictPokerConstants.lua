
require "app.data.poker.dict.dict_poker_card"
require "app.data.poker.dict.dict_poker_paytable"

DICT_POKER_CARD=dict_poker_card
DICT_POKER_PAYTABLE=dict_poker_paytable

--Video Poker config
VP = {}

VP.CARD_COLOR = {
    spade="spade",
    heart="heart",
    club="club",
    diamond="diamond",
    default=""
}

VP.CARD_TYPE ={
    NORMAL="normal",
    JOKER="joker"
}

VP.PATTERN_RULE ={
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

VP.PATTERN_ID={
    Royal_Straight_Flush=1,
    Straight_Flush=2,
    Four_of_a_Kind=3,
    Full_house=4,
    Flush=5,
    Straight=6,
    Three_of_a_Kind=7,
    Two_Pairs=8,
    Jacks_or_better=9
}


