extends CanvasLayer

signal completed

onready var bg = $Background
onready var tween = $Tween

const DURATION := .5


func transition_to_scene(path:String, duration := DURATION, delay := 0):
	tween.interpolate_property(bg, "color:a", 0, 1, duration)
	tween.start()
	yield(tween, "tween_completed")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene(path)
	
	tween.interpolate_property(bg, "color:a", 1, 0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	yield(tween, "tween_completed")
	emit_signal("completed")
