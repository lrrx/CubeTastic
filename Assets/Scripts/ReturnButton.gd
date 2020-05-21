extends TextureButton

func _ready():
	pass

func _on_ReturnButton_pressed():
	get_tree().change_scene("res://Assets/Menus/MainMenu.tscn")
