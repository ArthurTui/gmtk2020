extends Item
class_name TriggerItem

signal picked_up(type)

enum Types {BOOK, RING, BADGE, PILLS, MATCHES, PLANE}

const debuffs = [Status.TYPES.SPEEDDOWN, Status.TYPES.CONFUSED,
		Status.TYPES.TELEPORT, Status.TYPES.SLIPPERY, Status.TYPES.DARKNESS,
		Status.TYPES.SPEEDUP]
const images = [preload("res://assets/images/items/t6_livro.png"), preload("res://assets/images/items/t2 alianca.png"),
		preload("res://assets/images/items/t1_cracha.png"), preload("res://assets/images/items/t4_comprimidos.png"),
		preload("res://assets/images/items/t3_fosforo.png"), preload("res://assets/images/items/t5_aviao.png")]

var type : int


func set_type(new_type:int):
	type = new_type
	sprite.texture = images[type]


func _on_Area2D_body_entered(body):
	if body is Player:
		remove_child(sprite)
		(body as Player).pickup_item(sprite)
		(body as Player).add_status(debuffs[type])
		emit_signal("picked_up", type)
		queue_free()
