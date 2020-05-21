extends Control

const rectSizes = [5,11,17,23,27]

onready var global = get_tree().get_root().get_node("global")

func _ready():
	global.load_game()
	print(global.totalStats["upgrades"].keys())


func _process(delta):
	for upgradeType in global.totalStats["upgrades"].keys():
		get_node("Upgrade" + upgradeType[0].to_upper() + upgradeType.substr(1,len(upgradeType)-1) + "Button/StatusBar").rect_size = Vector2(rectSizes[global.totalStats["upgrades"][upgradeType]],2)
		if global.totalStats["upgrades"][upgradeType] < 4:
			get_node("Upgrade" + upgradeType[0].to_upper() + upgradeType.substr(1,len(upgradeType)-1) + "Button/PriceLabel").text = str(global.upgradePrices[upgradeType][global.totalStats["upgrades"][upgradeType]])
		else:
			get_node("Upgrade" + upgradeType[0].to_upper() + upgradeType.substr(1,len(upgradeType)-1) + "Button/PriceLabel").text = ""
		
func upgrade(upgradeType):
	var upgradePrice = global.upgradePrices[upgradeType][global.totalStats["upgrades"][upgradeType]]
	if (global.totalStats["stats"]["coins"] - upgradePrice >= 0 and global.totalStats["upgrades"][upgradeType] < 4):
		global.totalStats["stats"]["coins"] -= upgradePrice
		global.totalStats["upgrades"][upgradeType] += 1
		global.save_game(global.totalStats)

func _on_ExitButton_button_up():
	get_tree().change_scene("res://MainMenu.tscn")


func _on_UpgradeCoinsButton_pressed():
	upgrade("coins")


func _on_UpgradeBoostButton_pressed():
	upgrade("boost")


func _on_UpgradeMagnetButton_pressed():
	upgrade("magnet")


func _on_UpgradeMultiplierButton_pressed():
	upgrade("multiplier")


func _on_UpgradeTreasureButton_pressed():
	upgrade("treasure")
