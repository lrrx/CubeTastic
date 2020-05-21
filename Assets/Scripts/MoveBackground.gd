extends Sprite

onready var global = get_tree().get_root().get_node("global")

var posX = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	posX = position.x

func _physics_process(delta):
	posX -= delta*global.moveSpeed / 4
	if posX <= - 640:
		queue_free()
	position.x = int(posX)
