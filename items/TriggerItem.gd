extends Item
class_name TriggerItem

signal picked_up(type)

enum Types {BOOK, RING, BADGE, PILLS, MATCHES, PLANE}

const debuffs = [Status.TYPES.SPEEDDOWN, Status.TYPES.CONFUSED,
		Status.TYPES.TELEPORT, Status.TYPES.SLIPPERY, Status.TYPES.DARKNESS,
		Status.TYPES.SPEEDUP]
const images = [preload("res://icon.png"), preload("res://icon.png"),
		preload("res://icon.png"), preload("res://icon.png"),
		preload("res://icon.png"), preload("res://icon.png")]

var type : int


func set_type(new_type:int):
	type = new_type
	$Sprite.texture = images[type]


func _on_Area2D_body_entered(body):
	if body is Player:
		remove_child(sprite)
		(body as Player).pickup_item(sprite)
		(body as Player).add_status(debuffs[type])
		emit_signal("picked_up", type)
		queue_free()
