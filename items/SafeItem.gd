extends Item
class_name SafeItem

signal reached

enum Types {BOOK, RING, BADGE, PILLS, MATCHES, PLANE}

const images = [preload("res://icon.png"), preload("res://icon.png"),
		preload("res://icon.png"), preload("res://icon.png"),
		preload("res://icon.png"), preload("res://icon.png")]


func _on_Area2D_body_entered(body):
	if body is Player:
		emit_signal("reached")
