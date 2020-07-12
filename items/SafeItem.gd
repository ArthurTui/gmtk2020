extends Item
class_name SafeItem

signal reached

enum Types {BOOK, RING, BADGE, PILLS, MATCHES, PLANE}

const images = [preload("res://assets/images/items/s6_chapeu formatura.png"), preload("res://assets/images/items/s2_buque.png"),
		preload("res://assets/images/items/s1_carteira.png"), preload("res://assets/images/items/s5_vacina.png"),
		preload("res://assets/images/items/s4_lanterna.png"), preload("res://assets/images/items/s3_carro.png")]

var type : int


func set_type(new_type:int):
	type = new_type
	sprite.texture = images[type]


func _on_Area2D_body_entered(body):
	if body is Player:
		emit_signal("reached")
