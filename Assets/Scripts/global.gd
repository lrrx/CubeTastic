extends Node

var savegameFile
var totalStats
const defaultMoveSpeed = 50
var moveSpeed = defaultMoveSpeed

var skinResource

onready var initStats = {
	"stats": {
		"coins": 0,
		"gems": 0,
		"score": 0
	},
	"upgrades":{
		"coins": 0,
		"boost": 0,
		"magnet": 0,
		"multiplier": 0,
		"treasure": 0
	},
	"skinsUnlocked":{
		0: true,
		1: false,
		2: false,
		3: true,
		4: false,
		5: false,
		6: true,
		7: true,
		8: false,
		9: false,
		10: false
	},
	"cosmetics":{
		"currentSkin": 0
	}
}

onready var currentSavegame

const upgradePrices = {
	"coins": [100, 250, 500, 1000, 2000],
	"boost": [100, 250, 500, 1000, 2000],
	"magnet": [100, 250, 500, 1000, 2000],
	"multiplier": [100, 250, 500, 1000, 2000],
	"treasure": [100, 250, 500, 1000, 2000]
}

const upgradeEffects = {
	"coins": [1, 2, 3, 5, 10],
	"boost": [5, 10, 15, 20, 25],
	"magnet": [5, 10, 15, 20, 25],
	"multiplier": [5, 10, 15, 20, 25],
	"treasure": [10,20,30,50,100]
}


func _ready():
	currentSavegame = load_game()
	if (currentSavegame == null):
		currentSavegame = initStats
	totalStats = currentSavegame
	
	#add missing Dictionary parts
	for index1 in initStats.keys():
		if not totalStats.has(index1):
			totalStats[index1] = initStats[index1]
		for index2 in initStats[index1].keys():
			if not totalStats[index1].has(index2):
				totalStats[index1][index2] = initStats[index1][index2]
	
	save_game(totalStats)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		quit_game()

func _process(delta):
	pass

func quit_game():
	print("Quitting game")
	get_tree().quit()


func load_game():
	savegameFile = File.new()
	savegameFile.open("user://savegame.json", File.READ)
	var ret = parse_json(savegameFile.get_line())
	savegameFile.close()
	print("::::Loaded Game")
	return ret
	
	

func save_game(data):
	savegameFile = File.new()
	savegameFile.open("user://savegame.json", File.WRITE)
	savegameFile.store_line(to_json(data))
	savegameFile.close()
	print("::::Saved Game")
	
#TODO: cross-version savegame compatibility and ensurace implementation
