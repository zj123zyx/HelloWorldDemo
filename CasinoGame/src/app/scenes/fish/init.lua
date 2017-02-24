PATH_TYPE={
	LINE 	= 0,
	CURVE 	= 1,
	CIRCLE 	= 2,
}

MOVE_TYPE={
	--移动状态
	MOVE 	= 1,
	DIE 	= 2,
	STOP 	= 3,
	ONE 	= 4,
	LOOP 	= 5,
	COUGHT	= 6,
	ESCAPE 	= 7
}

COUGHT_TIME	= 5
ESCAPE_TIME = 2

GEM={
	BaseRoute 		= require("app.scenes.fish.base.BaseRoute"),
	Line 			= require("app.scenes.fish.base.Line"),
	Curve 			= require("app.scenes.fish.base.Curve"),
	Circle 			= require("app.scenes.fish.base.Circle"),
	Bezier 			= require("app.scenes.fish.base.Bezier"),
	BezierThree 	= require("app.scenes.fish.base.BezierThree"),
	BezierTwo 		= require("app.scenes.fish.base.BezierTwo"),
	Cubic 			= require("app.scenes.fish.base.Cubic"),
	Circle 			= require("app.scenes.fish.base.Circle"),
}

Fish 			= require("app.scenes.fish.base.Fish")
Weapon 			= require("app.scenes.fish.base.Weapon")
WeaponTrap 		= require("app.scenes.fish.base.WeaponTrap")
PathPool 		= require("app.scenes.fish.base.PathPool")
FishManager 	= require("app.scenes.fish.FishManager")
SceneManager 	= require("app.scenes.fish.SceneManager")
FishController 	= require("app.scenes.fish.controllers.FishController")


require "app.scenes.fish.data.dict_fish"
require "app.scenes.fish.data.dict_combo"
require "app.scenes.fish.data.dict_cycle"
require "app.scenes.fish.data.dict_weapon"
require "app.scenes.fish.data.dict_scene_cd"
require "app.scenes.fish.data.dict_hitrate"
require "app.scenes.fish.data.dict_fish_path"
require "app.scenes.fish.data.dict_fish_scene"
require "app.scenes.fish.data.dict_fish_cluster"
require "app.scenes.fish.data.dict_fishcluster_weight"
require "app.scenes.fish.data.dict_path_config"
require "app.scenes.fish.data.dict_pathfish_config"

DICT_FISH 	    			= 	dict_fish
DICT_CYCLE 	    			= 	dict_cycle
DICT_WEAPON 	    		= 	dict_weapon
DICT_FISH_PATH    			= 	dict_fish_path
DICT_COMBO 	    			= 	dict_combo
DICT_SCENE_CD 	    		= 	dict_scene_cd
DICT_HITRATE 	    		= 	dict_hitrate
DICT_FISH_SCENE 	    	= 	dict_fish_scene
DICT_FISH_CLUSTER 	    	= 	dict_fish_cluster
DICT_PATH_CONFIG 	    	= 	dict_path_config
DICT_PATHFISH_CONFIG 	   	= 	dict_pathfish_config
DICT_FISHCLUSTER_WEIGHT 	= 	dict_fishcluster_weight
