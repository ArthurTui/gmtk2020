extends Node2D

const ITEM_WIDTH = 50
const ITEM_HEIGHT = 50

onready var bg = $Background
onready var item_spawns = [$ItemSpawns/S1, $ItemSpawns/S2, $ItemSpawns/S3,
		$ItemSpawns/S4]

const BLACKHOLE_SCENE = preload("res://dangers/blackhole/Blackhole.tscn")
const PLAYER_SCENE = preload("res://player/Player.tscn")
const DANGER_SCENES = [preload("res://dangers/acid/Acid.tscn"),
		preload("res://dangers/elec_field/EletricField.tscn"),
		preload("res://dangers/iron_spikes/IronSpikes.tscn"),
		preload("res://dangers/lava/Lava.tscn"),
		preload("res://dangers/toxic_fumes/ToxicFumes.tscn")]

#Get a random valid position to position player
func random_valid_position():
	var limit = 10
	var valid_s = [Vector2(600, 500)]
	for spawn in $DangerSpawns.get_children():
		for danger in $Dangers.get_children():
			if (spawn.position - danger.position).length() > limit:
				valid_s.append(spawn.position)
	#Teleport player
	valid_s.shuffle()
	$YSort/Player.position = valid_s.back()


func _ready():
# warning-ignore:return_value_discarded
	$YSort/Player.connect("died", self, "_on_player_died")
# warning-ignore:return_value_discarded
	$YSort/Player.connect("update_life", self, "_on_player_update_life")
	
	AudioManager.play_bgm("gameplay", 2)


func set_time_of_day(time:int):
	bg.frame = time


func get_item_position(index:int):
	return item_spawns[index].position


func clear_danger():
	for child in $Dangers.get_children():
		child.queue_free()


func spawn_blackhole():
	var bh = BLACKHOLE_SCENE.instance()
	bh.position = $BlackholePosition.position
	$Dangers.add_child(bh)


func spawn_danger(amount:int):
	var random_danger = randi() % DANGER_SCENES.size()
	var positions := []
	
	for child in $DangerSpawns.get_children():
		positions.append(child.position)
	
	positions.shuffle()
	
	for i in amount:
		var danger = DANGER_SCENES[random_danger].instance()
		$Dangers.add_child(danger)
		danger.position = positions[i]


func _on_player_died():
	$Die.play()
	$Lose.play()
	#get random death sfx
	randomize()
	var n = randi()%$PlayerDeath.get_child_count() + 1
	get_node("PlayerDeath/AudioStreamPlayer" + str(n)).play()
	

func _on_player_update_life(amount):
	$PlayerHUD.update_life(amount)
	if amount > 30:
		AudioManager.stop_heartbeat()
	else:
		AudioManager.play_heartbeat()
