extends KinematicBody2D

var currentSkin = 0 #0 = default skin
const GRAVITY = 12
var velY = 0
var posY = 24
var jumpPower = 200
var jumpCount = 2
var onGround = false
var safetyPlatformInstance
var timeStart
var timePassed
var dead = false

var collisionPoint
var collisionDistance

onready var rayCast2D = get_node("RayCast2D")
onready var global = get_tree().get_root().get_node("global")
onready var hud = get_tree().get_root().get_node("Node2D/HUD")
onready var deathMenu = hud.get_node("./DeathMenu")
onready var safetyPlatformResource = load("res://Assets/Level/RevivePlatform.tscn")

onready var powerUpTimers = {
	"boost": get_node("../PowerUpTimers/Boost"),
	"magnet": get_node("../PowerUpTimers/Magnet"),
	"multiplier": get_node("../PowerUpTimers/Multiplier")
}

onready var powerUpActive = {
	"boost": false,
	"magnet": false,
	"multiplier": false
}

onready var powerUpSFX = {
	"boost": get_node("BoostParticles"),
	"magnet": get_node("MagnetParticles"),
	"multiplier": get_node("MultiplierParticles")
}

onready var roundStats = {
	"coins": 0,
	"gems": 0,
	"score": 0,
	"revives": 0
}

func _ready():
	update_hud()
	
	timeStart = OS.get_unix_time()
	rayCast2D.enabled = true
	
	get_node("Skin").add_child(global.skinResource.instance())
	 
	
	for key in powerUpTimers.keys():
		powerUpTimers[key].wait_time = global.upgradeEffects[key][global.totalStats["upgrades"][key]]
		print(powerUpTimers[key].wait_time)

func _physics_process(delta):
	if not dead:
		timePassed = OS.get_unix_time() - timeStart
		
		if(not powerUpActive["boost"]):
			global.moveSpeed = (timePassed + global.defaultMoveSpeed) * 2
		else:
			global.moveSpeed = (timePassed + global.defaultMoveSpeed) * 2 * 2
		
		
		if(not powerUpActive["boost"]):
			velY += GRAVITY
		position.x = 24
		
		#if(rayCast2D.is_colliding() == true):
		#	collisionPoint = rayCast2D.get_collision_point()
		#	collisionDistance = collisionPoint.y - 5 - position.y
		#	#print(rayCast2D.get_collider().name)
		#	#print(rayCast2D.get_collision_normal())
		#	if(collisionDistance <= && velY > 0):
		#		velY = 0
		#		posY = collisionPoint.y - 5
		#else:
		#	collisionDistance = 999
		
		onGround = test_move(transform, Vector2(0, velY * delta))#(collisionDistance == 0)
		
		if onGround:
			velY = 0
			jumpCount = 2
		
		if(Input.is_action_just_released("ui_jump") and jumpCount > 0):
			#if (safetyPlatformInstance != null):
			#	safetyPlatformInstance.queue_free()
			jumpCount -= 1
			velY = -jumpPower
		
		#print_debug(position.x)
		
		if position.y >= 100:
			print("player went beyond ground limit")
			death()
			
		update_hud()
		
		roundStats["score"] = int(timePassed * global.moveSpeed/global.defaultMoveSpeed) + roundStats["coins"] * 5
		
		if(not powerUpActive["boost"]):
			posY += velY * delta
		else:
			posY = get_global_mouse_position().y
		position.y = int(ceil(posY+0.9))
	else:
		pass
		

func update_hud():
	hud.get_node("CoinCount").text = str(roundStats["coins"])
	hud.get_node("ScoreCount").text = str(roundStats["score"])
	for powerUp in ["Boost", "Magnet", "Multiplier"]:
			var powerUpType = powerUp.to_lower()
			var rectSize = int(powerUpTimers[powerUpType].time_left * 38/global.upgradeEffects[powerUpType][global.totalStats["upgrades"][powerUpType]])
			hud.get_node(powerUp + "Bar").rect_size.x = rectSize; hud.get_node(powerUp + "Bar").rect_position.x = 160 - rectSize
	
func death():
	dead = true
	timeStart = OS.get_unix_time()
	global.moveSpeed = 0
	velY = 0
	posY = -1000
	for key in ["coins", "gems", "score"]:
		global.totalStats["stats"][key] += roundStats[key]
	global.save_game(global.totalStats)
	deathMenu.show()
	print("died")

func revive():
	posY = -20
	for key in global.totalStats["stats"].keys():
		global.totalStats["stats"][key] -= roundStats[key]
	roundStats["revives"] += 1
	deathMenu.hide()
	print("revived")
	var safetyPlatformInstance = safetyPlatformResource.instance()
	safetyPlatformInstance.position.y = 30
	get_tree().get_root().get_node("Node2D").add_child(safetyPlatformInstance)	
	dead = false

func _on_Area2D_body_entered(body):
	print(body.name)
	if("Coin" in body.name):
		body.queue_free()
		var coinType = int(body.name[body.name.find("Coin")+4])
		if(not powerUpActive["multiplier"]):
			roundStats["coins"] += global.upgradeEffects["coins"][coinType] * 1
		else:
			roundStats["coins"] += global.upgradeEffects["coins"][coinType] * 2
	elif("Gem" in body.name):
		body.queue_free()
		roundStats["gems"] += 1
	elif("PowerUp" in body.name):
		body.queue_free()
		var powerUpType
		for powerUp in ["Boost", "Magnet", "Multiplier"]:
			if(powerUp in body.name):
				powerUpType = powerUp.to_lower()
				enable_powerUp(powerUpType)
		print(powerUpType)

func enable_powerUp(powerUpType):
	powerUpSFX[powerUpType].emitting = true
	powerUpActive[powerUpType] = true
	powerUpTimers[powerUpType].start()

func disable_powerUp(powerUpType):
	powerUpSFX[powerUpType].emitting = false
	powerUpActive[powerUpType] = false

func _on_Boost_timeout():
	disable_powerUp("boost")

func _on_Magnet_timeout():
	disable_powerUp("magnet")

func _on_Multiplier_timeout():
	disable_powerUp("multiplier")
