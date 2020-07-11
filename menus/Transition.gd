extends CanvasLayer

signal fade_in_completed
signal fade_out_completed

onready var bg = $Background
onready var tween = $Tween

const DURATION := 1


func transition_to_scene(path:String, duration := DURATION):
	tween.interpolate_property(bg, "color:a", 0, 1, duration)
	yield(tween, "tween_completed")
	emit_signal("fade_in_completed")
	
	get_tree().change_scene(path)
	
	tween.interpolate_property(bg, "color:a", 1, 0, duration)
	yield(tween, "tween_completed")
	emit_signal("fade_out_completed")
