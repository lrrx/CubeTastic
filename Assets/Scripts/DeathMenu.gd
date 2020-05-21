extends Control

var shown = false
var reviveCost = 1
onready var global = get_tree().get_root().get_node("global")
onready var panel = get_node("./Panel")
onready var player = get_tree().get_root().get_node("Node2D/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	reviveCost = pow(2, player.roundStats["revives"])
	if (shown == true):
		panel.position.y = 90 - 20
	else:
		panel.position.y = 90 - 0
	panel.get_node("TotalCoinsLabel").text = str(global.totalStats["stats"]["coins"])
	panel.get_node("TotalGemsLabel").text = str(global.totalStats["stats"]["gems"])
	panel.get_node("ReviveCostLabel").text = str(reviveCost)


func show():
	shown = true

func hide():
	shown = false

func _on_ReviveButton_pressed():
	if (shown == true):
		if (global.totalStats["stats"]["gems"] - reviveCost >= 0):
			global.totalStats["stats"]["gems"] -= reviveCost
			player.revive()
