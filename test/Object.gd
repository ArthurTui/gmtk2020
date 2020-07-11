extends StaticBody2D

const BASE_WIDTH = 100
const BASE_HEIGHT = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = get_sprite()
	$Sprite.scale.x = float(BASE_WIDTH)/$Sprite.texture.get_width()
	$Sprite.scale.y = float(BASE_HEIGHT)/$Sprite.texture.get_height()


func get_sprite():
	var max_n = 5
	randomize()
	var n = randi()%(max_n - 1) + 1
	return load("res://assets/n/n" + str(n) + ".jpg")
