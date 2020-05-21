extends Node2D

onready var platformResources = {
"grass":
	{
	"short": load("res://Assets/Level/Grass/Grass-Platform-Short.tscn"),
	"medium": load("res://Assets/Level/Grass/Grass-Platform-Medium.tscn"),
	"long": load("res://Assets/Level/Grass/Grass-Platform-Long.tscn")
	}
}

onready var backgroundResources = {
"grass":
	{
	"bg1": load("res://Assets/Level/Grass/Cloud.tscn")
	}
}

onready var powerUpResources = {
	"boost": load("res://Assets/Collectibles/PowerUps/BoostPowerUp.tscn"),
	"magnet": load("res://Assets/Collectibles/PowerUps/MagnetPowerUp.tscn"),
	"multiplier": load("res://Assets/Collectibles/PowerUps/MultiplierPowerUp.tscn")
}

onready var coinResources = [
load("res://Assets/Collectibles/Coins/Coin0.tscn"),
load("res://Assets/Collectibles/Coins/Coin1.tscn"),
load("res://Assets/Collectibles/Coins/Coin2.tscn"),
load("res://Assets/Collectibles/Coins/Coin3.tscn"),
load("res://Assets/Collectibles/Coins/Coin4.tscn")
]

onready var global = get_tree().get_root().get_node("global")

onready var gemResource = load("res://Assets/Collectibles/Gem.tscn")

onready var timer = get_node("Timer")

var platformY
var platformMaxWaitTime = 1.5
var platformMinWaitTime = 1.4
var platformLengthList = ["short", "medium", "long"]
var platformType

var levelTypes = ["grass","desert","mountains","ice","forest","cave","mushrooms","volcano","scrapyard"]
var currentBiome = 0

func _ready():
	pass

func _physics_process(delta):
	pass

func _on_Timer_timeout():
	if global.moveSpeed > 0:
		randomize()
		
		timer.wait_time = (platformMinWaitTime + randf() * float(platformMaxWaitTime - platformMinWaitTime)) * float(float(global.defaultMoveSpeed) / float(global.moveSpeed))
		print(timer.wait_time)
		print(global.moveSpeed)
		randomize()
		#generate Platforms
		platformY = randi()%30+40
		var platformInstance = platformResources[levelTypes[currentBiome]][platformLengthList[randi()%2]].instance()
		platformInstance.position = Vector2(200, platformY)
		add_child(platformInstance)
		
		randomize()
		
		if(randi()%10 == 0):
			var powerUpType = ["boost", "magnet", "multiplier"]
			powerUpType.shuffle()
			powerUpType = powerUpType[0]
			var powerUpInstance = powerUpResources[powerUpType].instance()
			powerUpInstance.position = Vector2(200 + randi()%20, platformY + randi()%10 - 25)
			add_child(powerUpInstance)
		#platformInstance.move_and_collide( Vector2(-1,0), true, true, false )
	
		randomize()
		#generate Coins
		for i in range(randi()%4 + 1):
			if (randi()%2 == 0):
				var coinInstance
				if(global.totalStats["upgrades"]["coins"] >= 1):
					coinInstance = coinResources[randi()%int(global.totalStats["upgrades"]["coins"]+1)].instance()
				else:
					coinInstance = coinResources[0].instance()
				var coinBasePosition = randi()%80
				coinInstance.position = Vector2(200 - 20 + coinBasePosition + i * 20, platformY - 10)
				add_child(coinInstance)
	
		if (randi()%30 == 0):
			var gemInstance = gemResource.instance()
			gemInstance.position = Vector2(200 + randi()%100, platformY - 25)
			add_child(gemInstance)
		
		randomize()
		
		if (randi()%3 == 0):
			var bg1Instance = backgroundResources[levelTypes[currentBiome]]["bg1"].instance()
			bg1Instance.position = Vector2(200 + randi()%100, randi()%90)
			add_child(bg1Instance)

