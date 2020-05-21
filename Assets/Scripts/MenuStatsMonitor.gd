extends Node2D

onready var global = get_tree().get_root().get_node("global")

func _ready():
	pass

func _process(delta):
	if (global.totalStats != null):
		get_node("TotalCoinsLabel").text = str(global.totalStats["stats"]["coins"])
		get_node("TotalGemsLabel").text = str(global.totalStats["stats"]["gems"])
