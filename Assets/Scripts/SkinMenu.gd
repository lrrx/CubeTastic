extends Control

onready var global = get_tree().get_root().get_node("global")
var skinDist = 16
var skinInstanceArray = []

onready var skins = {
	0: load("res://Assets/Skins/0Skin.tscn"),
	1: load("res://Assets/Skins/1Skin.tscn"),
	2: load("res://Assets/Skins/2Skin.tscn"),
	3: load("res://Assets/Skins/3Skin.tscn"),
	4: load("res://Assets/Skins/4Skin.tscn"),
	5: load("res://Assets/Skins/5Skin.tscn"),
	6: load("res://Assets/Skins/6Skin.tscn"),
	7: load("res://Assets/Skins/7Skin.tscn"),
	8: load("res://Assets/Skins/8Skin.tscn"),
	9: load("res://Assets/Skins/9Skin.tscn"),
	10: load("res://Assets/Skins/10Skin.tscn")
}

onready var skinPrices = {
	00: 0,
	01: 100,
	02: 200,
	03: 300,
	04: 400,
	05: 500,
	06: 600,
	07: 700,
	08: 800,
	09: 900,
	10: 1000
}

func _ready():
	global.load_game()
	print(global.totalStats)
	for key in skins.keys():
		var skinInstance = skins[key].instance()
		var skinPositionOffset = 0
		if (global.totalStats["skinsUnlocked"][key] == true):
			skinPositionOffset = 95
		skinInstance.position = Vector2(skinPositionOffset + skinDist/2 + (key % 4) * skinDist, skinDist/2 + int(key/4) * skinDist + 2)
		skinInstanceArray.append(skinInstance)
		add_child(skinInstance)
	print(skinInstanceArray)
	


func _process(delta):
	pass

func selectSkin(id):
	#if(global.totalStats["skins"][id] == true):
	global.totalsStats["stats"]["currentSkin"] = id

func buySkin(id):
	var skinPrice = skinPrices[id]
	if (global.totalStats["stats"]["coins"] - skinPrice >= 0 and global.totalStats["skins"][id] == false):
		global.totalStats["stats"]["coins"] -= skinPrice
		global.totalStats["skins"][id] = true
		global.save_game(global.totalStats)
