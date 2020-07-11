extends Node
class_name Status

signal finished

enum TYPES {NONE, SPEEDUP, PETRIFY, BURNING, SLIPPERY, CONFUSED, SPEEDDOWN,
			BLEEDING}

export var duration := 0.0
export(TYPES) var type = 0


func _ready():
	if duration:
		yield(get_tree().create_timer(duration), "timeout")
		finish()


func finish():
	emit_signal("finished")
	queue_free()
