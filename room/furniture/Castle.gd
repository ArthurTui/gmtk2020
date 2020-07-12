extends Furniture

onready var day_shape = $StaticBody2D/DayShape


func set_time_of_day(time:int):
	.set_time_of_day(time)
