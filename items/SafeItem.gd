extends Item
class_name SafeItem

signal reached

enum Types {BOOK, RING, BADGE, PILLS, MATCHES, PLANE}

const images = [preload("res://icon.png"), preload("res://icon.png"),
		preload("res://icon.png"), preload("res://icon.png"),
		preload("res://icon.png"), preload("res://icon.png")]

var type : int


func set_type(new_type:int):
	type = new_type
	sprite.texture = images[type]


func _on_Area2D_body_entered(body):
	if body is Player:
		emit_signal("reached")
