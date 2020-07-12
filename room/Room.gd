extends Node2D

onready var bg = $Background


func set_time_of_day(time:int):
	bg.frame = time
