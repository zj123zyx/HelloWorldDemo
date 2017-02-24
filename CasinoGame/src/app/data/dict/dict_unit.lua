-- 游戏列表项配置文件

-- 字段说明：
-- unit_id：         列表项ID
-- p_unit_id：
-- zipname：
-- desc：            列表项描述
-- type：            列表项类型，包括层布局，以及游戏类型
-- dict_id：         老虎机的ID
-- category：
-- ccb：             资源文件名
-- config：
-- need_download：   默认是否需要下载
 
dict_unit = {
    ["1"] = {unit_id = "1", p_unit_id = "0", zipname = "slots_share", desc = "slots", type = "Layout", dict_id = "2", category = "1", ccb = "cell_slots_icon", config = "", need_download = "0"},
    ["101"] = {unit_id = "101", p_unit_id = "1", zipname = "slots_egypt", desc = "Pharaoh's Treasures Slot", type = "COMINGSOON", dict_id = "1", category = "1", ccb = "cell_slots01", config = {min_bet=30, max_bet=9000}, need_download = "1"},
    ["102"] = {unit_id = "102", p_unit_id = "1", zipname = "slots_greek", desc = "Greek Gods Slot", type = "Slots", dict_id = "2", category = "1", ccb = "cell_slots02", config = {min_bet=60, max_bet=9000}, need_download = "1"},
    ["103"] = {unit_id = "103", p_unit_id = "1", zipname = "slots_spacewar", desc = "Space War Slot", type = "COMINGSOON", dict_id = "3", category = "1", ccb = "cell_slots03", config = {min_bet=60, max_bet=9000}, need_download = "1"},
    ["104"] = {unit_id = "104", p_unit_id = "1", zipname = "slots_maya", desc = "Mayan Mystery Slot", type = "Slots", dict_id = "4", category = "1", ccb = "cell_slots04", config = {min_bet=200, max_bet=10000}, need_download = "1"},
    ["105"] = {unit_id = "105", p_unit_id = "1", zipname = "slots_pirate", desc = "Pirate Legends Slot", type = "COMINGSOON", dict_id = "5", category = "1", ccb = "cell_slots05", config = {min_bet=400, max_bet=12000}, need_download = "1"},
    ["106"] = {unit_id = "106", p_unit_id = "1", zipname = "slots_wildwest", desc = "Wild West Slot", type = "COMINGSOON", dict_id = "6", category = "1", ccb = "cell_slots06", config = {min_bet=300, max_bet=12000}, need_download = "1"},
    ["107"] = {unit_id = "107", p_unit_id = "1", zipname = "slots_ice", desc = "Ice Kingdom Slot", type = "Slots", dict_id = "7", category = "1", ccb = "cell_slots07", config = {min_bet=150, max_bet=12000}, need_download = "1"},
    ["108"] = {unit_id = "108", p_unit_id = "1", zipname = "slots_farm", desc = "Happy Farm Slot", type = "Slots", dict_id = "8", category = "1", ccb = "cell_slots08", config = {min_bet=30, max_bet=9000}, need_download = "0"},
    ["109"] = {unit_id = "109", p_unit_id = "1", zipname = "slots_beach", desc = "Beach Slot", type = "Slots", dict_id = "9", category = "1", ccb = "cell_slots09", config = {min_bet=200, max_bet=12000}, need_download = "1"},
    ["110"] = {unit_id = "110", p_unit_id = "1", zipname = "slots_magiccity", desc = "Magic City Slot", type = "Slots", dict_id = "10", category = "1", ccb = "cell_slots10", config = {min_bet=300, max_bet=15000}, need_download = "1"},
    ["111"] = {unit_id = "111", p_unit_id = "1", zipname = "slots_chinesestyle", desc = "Chinese Style", type = "Slots", dict_id = "11", category = "1", ccb = "cell_slots11", config = {min_bet=450, max_bet=15000}, need_download = "1"},
    ["112"] = {unit_id = "112", p_unit_id = "1", zipname = "slots_prince", desc = "Prince Slot", type = "Slots", dict_id = "12", category = "1", ccb = "cell_slots12", config = {min_bet=450, max_bet=15000}, need_download = "1"},
    ["2"] = {unit_id = "2", p_unit_id = "0", zipname = "poker_black", desc = "BlackJack", type = "Layout", dict_id = "3", category = "2", ccb = "cell_bj", config = "", need_download = "1"},
    ["201"] = {unit_id = "201", p_unit_id = "2", zipname = "poker", desc = "BlackJack Poker", type = "BlackJack", dict_id = "201", category = "2", ccb = "cell_bj_bj1", config = {min_bet=10, max_bet=500, chips={'3','5','6'}}, need_download = "0"},
    ["202"] = {unit_id = "202", p_unit_id = "2", zipname = "poker", desc = "BlackJack Poker", type = "BlackJack", dict_id = "202", category = "2", ccb = "cell_bj_bj2", config = {min_bet=100, max_bet=5000, chips={'6','8','9'}}, need_download = "0"},
    ["203"] = {unit_id = "203", p_unit_id = "2", zipname = "poker", desc = "BlackJack Poker", type = "BlackJack", dict_id = "203", category = "2", ccb = "cell_bj_bj3", config = {min_bet=1000, max_bet=50000, chips={'9','11','12'}}, need_download = "0"},
    ["204"] = {unit_id = "204", p_unit_id = "2", zipname = "poker", desc = "BlackJack Poker", type = "BlackJack", dict_id = "204", category = "2", ccb = "cell_bj_bj4", config = {min_bet=5000, max_bet=250000, chips={'11','12','14'}}, need_download = "0"},
    ["3"] = {unit_id = "3", p_unit_id = "0", zipname = "poker_vedio", desc = "VideoPoker", type = "Layout", dict_id = "4", category = "3", ccb = "cell_video_icon", config = "", need_download = "1"},
    ["301"] = {unit_id = "301", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "301", category = "3", ccb = "cell_vp_1", config = {min_bet=20, max_bet=1000, hands=1, bet_list={20,30,40,50,100,200,300,400,500,1000}}, need_download = "0"},
    ["302"] = {unit_id = "302", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "302", category = "3", ccb = "cell_vp_5", config = {min_bet=100, max_bet=5000, hands=5, bet_list={20,30,40,50,100,200,300,400,500,1000}}, need_download = "0"},
    ["303"] = {unit_id = "303", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "303", category = "3", ccb = "cell_vp_10", config = {min_bet=200, max_bet=10000, hands=10,  bet_list={20,30,40,50,100,200,300,400,500,1000}}, need_download = "0"},
    ["304"] = {unit_id = "304", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "304", category = "3", ccb = "cell_vp_25", config = {min_bet=500, max_bet=25000, hands=25,  bet_list={20,30,40,50,100,150,200,300,400,500,1000}}, need_download = "0"},
    ["305"] = {unit_id = "305", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "305", category = "3", ccb = "cell_vp_jokerwild", config = {min_bet=20, max_bet=1000, hands=1, bet_list={20,30,40,50,100,200,300,400,500,1000}}, need_download = "0"},
    ["306"] = {unit_id = "306", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "306", category = "3", ccb = "cell_vp_jokerwild", config = {min_bet=100, max_bet=5000, hands=5, bet_list={20,30,40,50,100,200,300,400,500,1000}}, need_download = "0"},
    ["307"] = {unit_id = "307", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "307", category = "3", ccb = "cell_vp_jokerwild", config = {min_bet=200, max_bet=10000, hands=10,  bet_list={20,30,40,50,100,200,300,400,500,1000}}, need_download = "0"},
    ["308"] = {unit_id = "308", p_unit_id = "3", zipname = "poker", desc = "Video Poker", type = "VideoPoker", dict_id = "308", category = "3", ccb = "cell_vp_jokerwild", config = {min_bet=500, max_bet=25000, hands=25,  bet_list={20,30,40,50,100,150,200,300,400,500,1000}}, need_download = "0"},
    ["4"] = {unit_id = "4", p_unit_id = "0", zipname = "poker_texas", desc = "Texas Hold'em", type = "Layout", dict_id = "5", category = "4", ccb = "cell_holdem_icon", config = "", need_download = "1"},
    ["401"] = {unit_id = "401", p_unit_id = "4", zipname = "poker", desc = "Casino Hold'EM", type = "Texas", dict_id = "401", category = "4", ccb = "cell_dz_casino01", config = {min_bet=10, max_bet=1000, rule='casino_holdem', chips={'3','5','6'}}, need_download = "0"},
    ["402"] = {unit_id = "402", p_unit_id = "4", zipname = "poker", desc = "Casino Hold'EM", type = "Texas", dict_id = "402", category = "4", ccb = "cell_dz_casino02", config = {min_bet=100, max_bet=10000, rule='casino_holdem', chips={'6','8','9'}}, need_download = "0"},
    ["403"] = {unit_id = "403", p_unit_id = "4", zipname = "poker", desc = "Casino Hold'EM", type = "Texas", dict_id = "403", category = "4", ccb = "cell_dz_casino02", config = {min_bet=1000, max_bet=100000, rule='casino_holdem', chips={'9','11','12'}}, need_download = "0"},
    ["404"] = {unit_id = "404", p_unit_id = "4", zipname = "poker", desc = "Texas Hold'EM", type = "Texas", dict_id = "404", category = "4", ccb = "cell_dz_txs01", config = {min_bet=10, max_bet=1000, rule='texas_holdem', chips={'3','5','6'}}, need_download = "0"},
    ["405"] = {unit_id = "405", p_unit_id = "4", zipname = "poker", desc = "Texas Hold'EM", type = "Texas", dict_id = "405", category = "4", ccb = "cell_dz_txs01", config = {min_bet=100, max_bet=10000, rule='texas_holdem', chips={'6','8','9'}}, need_download = "0"},
    ["406"] = {unit_id = "406", p_unit_id = "4", zipname = "poker", desc = "Texas Hold'EM", type = "Texas", dict_id = "406", category = "4", ccb = "cell_dz_txs02", config = {min_bet=1000, max_bet=100000, rule='texas_holdem', chips={'9','11','12'}}, need_download = "0"},
    ["407"] = {unit_id = "407", p_unit_id = "4", zipname = "poker", desc = "Texas Hold'EM", type = "TexasOnline", dict_id = "407", category = "4", ccb = "cell_dz_online01", config = {min_bet=1000, max_bet=100000, rule='texas_holdem', chips={'9','11','12'}}, need_download = "0"},
    ["5"] = {unit_id = "5", p_unit_id = "0", zipname = "fish", desc = "Fish", type = "Layout", dict_id = "7", category = "5", ccb = "cell_fish_icon", config = "", need_download = "1"},
    ["501"] = {unit_id = "501", p_unit_id = "501", zipname = "fish", desc = "Deep Sea", type = "Fish", dict_id = "501", category = "5", ccb = "cell_fish_icon", config = {min_bet=10, max_bet=1000}, need_download = "1"},
    ["10"] = {unit_id = "10", p_unit_id = "0", zipname = "challengegame", desc = "challengegame", type = "Layout", dict_id = "6", category = "5", ccb = "cell_challengegame", config = "", need_download = "0"},
    ["1001"] = {unit_id = "1001", p_unit_id = "10", zipname = "challenge_dragon", desc = "Challenge_Dragon", type = "Challenge", dict_id = "1001", category = "5", ccb = "cell_challengegame_long", config = {cost_gems=50}, need_download = "1"},
    ["1002"] = {unit_id = "1002", p_unit_id = "10", zipname = "challenge_bigwheel", desc = "Big Wheel", type = "Challenge", dict_id = "1002", category = "5", ccb = "cell_challengegame_bigrell", config = {cost_gems=5}, need_download = "0"},
    ["11"] = {unit_id = "11", p_unit_id = "0", zipname = "daily_task", desc = "每日任务", type = "Task", dict_id = "", category = "0", ccb = "cell_dailytask_icon", config = "", need_download = "0"},
    ["16"] = {unit_id = "16", p_unit_id = "0", zipname = "coming_soon", desc = "即将开启", type = "COMINGSOON", dict_id = "", category = "0", ccb = "cell_comingsoon1", config = "", need_download = "0"},
    ["17"] = {unit_id = "17", p_unit_id = "0", zipname = "coming_soon", desc = "即将开启", type = "COMINGSOON", dict_id = "", category = "0", ccb = "cell_comingsoon2", config = "", need_download = "0"}
}

    

