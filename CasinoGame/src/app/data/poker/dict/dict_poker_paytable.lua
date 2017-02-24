--dict_poker_paytable table
 
dict_poker_paytable = {
    ["1"] = {id = "1", name = "Royal Straight Flush(皇家同花顺)", multiple = "250"},
    ["2"] = {id = "2", name = "Straight Flush(同花顺)", multiple = "90"},
    ["3"] = {id = "3", name = "Four of a Kind(四条)", multiple = "35"},
    ["4"] = {id = "4", name = "Full house(满堂红)", multiple = "8"},
    ["5"] = {id = "5", name = "Flush(同花)", multiple = "8"},
    ["6"] = {id = "6", name = "Straight(顺子)", multiple = "8"},
    ["7"] = {id = "7", name = "Three of a kind(三条)", multiple = "3"},
    ["8"] = {id = "8", name = "Two Pairs(两对)", multiple = "1"},
    ["9"] = {id = "9", name = "Jacks or better(杰克高手)", multiple = "1"}
}

poker_reward_effect = {
    ["1"] = {ccb1 = "royalstraightflush_win.ccbi", image = "royalstraightflush.png",small_image = "royalstraightflush_small.png",     ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["2"] = {ccb1 = "straightflush_win.ccbi",      image = "straightflush.png",     small_image = "straightflush_small.png",       ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["3"] = {ccb1 = "4ofakind_win.ccbi",           image = "4ofakind.png",          small_image = "4ofakind_small.png",       ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["4"] = {ccb1 = "general_win.ccbi",            image = "fullhouse.png" ,        small_image = "fullhouse_small.png",       ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["5"] = {ccb1 = "general_win.ccbi",            image = "flush.png",             small_image = "flush_small.png",       ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["6"] = {ccb1 = "general_win.ccbi",            image = "straight.png",          small_image = "straight_small.png",      ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["7"] = {ccb1 = "general_win.ccbi",            image = "3ofakind.png",          small_image = "3ofakind_small.png",       ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["8"] = {ccb1 = "general_win.ccbi",            image = "2pairs.png",            small_image = "2pairs_small.png",       ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
    ["9"] = {ccb1 = "general_win.ccbi",            image = "jacksorbetter.png",     small_image = "jacksorbetter_small.png",      ccb2 = "general_win.ccbi", ccb3 = "videopoker25_win.ccbi"},
}

