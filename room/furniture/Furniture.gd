extends Node2D
class_name Furniture

onready var sprite = $AnimatedSprite

enum {DAY, NIGHT}

const anim_names = ["day", "night"]


func set_time_of_day(time:int):
	sprite.play(anim_names[time])
