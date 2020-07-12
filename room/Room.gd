extends Node2D

onready var bg = $Background
onready var item_spawns = [$ItemSpawns/S1, $ItemSpawns/S2, $ItemSpawns/S3,
		$ItemSpawns/S4]
onready var opposite_spawns = [$ItemSpawns/S4, $ItemSpawns/S3, $ItemSpawns/S2,
		$ItemSpawns/S1]

func _ready():
# warning-ignore:return_value_discarded
	$YSort/Player.connect("died", self, "_on_player_died")
# warning-ignore:return_value_discarded
	$YSort/Player.connect("update_life", self, "_on_player_update_life")

func set_time_of_day(time:int):
	bg.frame = time

func _on_player_died():
	$Lose.play()
	#get random death sfx
	randomize()
	var n = randi()%$PlayerDeath.get_child_count() + 1
	get_node("PlayerDeath/AudioStreamPlayer" + str(n)).play()
	

func _on_player_update_life(amount):
	$PlayerHUD.update_life(amount)
