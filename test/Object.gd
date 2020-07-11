extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = get_sprite()


func get_sprite():
	var max_n = 5
	var n = randi()%(max_n - 1) + 1
	return load("res://assets/n/n" + str(n) + ".jpg")
