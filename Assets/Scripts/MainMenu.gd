extends Control

onready var global = get_tree().get_root().get_node("global")

# Called when the node enters the scene tree for the first time.
func _ready():
	global.skinResource = load("res://Assets/Skins/" + str(global.totalStats["cosmetics"]["currentSkin"]) + "Skin.tscn")
	pass

func _on_UpgradeMenuButton_button_up():
	get_tree().change_scene("res://Assets/Menus/UpgradeMenu.tscn")

func _on_PlayButton_button_up():
	get_tree().change_scene("res://Assets/Game.tscn")

func _on_SkinMenuButton_button_up():
	get_tree().change_scene("res://Assets/Menus/SkinMenu.tscn")
