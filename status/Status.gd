extends Node
class_name Status

signal finished

enum TYPES {NONE, SPEEDUP, PETRIFY}

export var duration := 0.0
export(TYPES) var type = 0


func _ready():
	if duration:
		yield(get_tree().create_timer(duration), "timeout")
		emit_signal("finished")
		queue_free()
