extends Area2D

onready var global = get_tree().get_root().get_node("global")
onready var player = get_tree().get_root().get_node("Node2D/Player")

var pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pos = position

func _physics_process(delta):
	if(player.powerUpActive["magnet"]):
		pos += (player.position - pos) * delta*global.moveSpeed/global.defaultMoveSpeed 
	else:
		pos.x -= delta*global.moveSpeed
		if pos.x <= - 320:
			queue_free()
		position.x = int(pos.x)
		position.y = int(pos.y)
