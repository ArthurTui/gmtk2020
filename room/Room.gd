extends Node2D

onready var bg = $Background
onready var item_spawns = [$ItemSpawns/S1, $ItemSpawns/S2, $ItemSpawns/S3,
		$ItemSpawns/S4]
onready var opposite_spawns = [$ItemSpawns/S4, $ItemSpawns/S3, $ItemSpawns/S2,
		$ItemSpawns/S1]


func set_time_of_day(time:int):
	bg.frame = time
