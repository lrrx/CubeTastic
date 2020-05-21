extends StaticBody2D

onready var global = get_tree().get_root().get_node("global")
onready var player = get_tree().get_root().get_node("Node2D/Player")

var posX = 0
var posY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	posX = position.x
	posY = position.y

func _physics_process(delta):
	if "Coin" in self.name and player.powerUpActive["magnet"] and not player.dead:
		var playerPosition = player.position
		var playerAngle = rad2deg(position.angle_to_point(player.position))
		posX += position.direction_to(playerPosition).x * 1/(position.distance_to(playerPosition)+0.1) * 100  
		posY += position.direction_to(playerPosition).y * 1/(position.distance_to(playerPosition)+0.1) * 100
	posX -= delta * global.moveSpeed
	
	if posX <= - 320:
		queue_free()
		
	position = Vector2(int(posX),int(posY))
