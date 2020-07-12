extends Node

onready var room = $Room

enum States {DAY, NIGHT}

const TRIGGER_SCENE = preload("res://items/TriggerItem.tscn")
const SAFE_SCENE = preload("res://items/SafeItem.tscn")
const PLAYER_SCENE = preload("res://player/Player.tscn")

const LOC_SFX = [
	[
		preload("res://assets/sound/sfx/boss_speaks_book1.wav"),
		preload("res://assets/sound/sfx/boss_speaks_book2.wav"),
		preload("res://assets/sound/sfx/boss_speaks_book3.wav"),
	],
	[
		preload("res://assets/sound/sfx/boss_speaks_ring1.wav"),
		preload("res://assets/sound/sfx/boss_speaks_ring2.wav"),
		preload("res://assets/sound/sfx/boss_speaks_ring3.wav"),
	],
	[
		preload("res://assets/sound/sfx/boss_speaks_badge1.wav"),
		preload("res://assets/sound/sfx/boss_speaks_badge2.wav"),
		preload("res://assets/sound/sfx/boss_speaks_badge3.wav"),

	],
	[
		preload("res://assets/sound/sfx/boss_speaks_wormhole1.wav"),
		preload("res://assets/sound/sfx/boss_speaks_wormhole2.wav"),
		preload("res://assets/sound/sfx/boss_speaks_wormhole3.wav"),
	],
	[
		preload("res://assets/sound/sfx/boss_speaks_matches1.wav"),
		preload("res://assets/sound/sfx/boss_speaks_matches2.wav"),
		preload("res://assets/sound/sfx/boss_speaks_matches3.wav"),
	],
	[
		preload("res://assets/sound/sfx/boss_speaks_airplane1.wav"),
		preload("res://assets/sound/sfx/boss_speaks_airplane2.wav"),
		preload("res://assets/sound/sfx/boss_speaks_airplane3.wav"),
	]
]

const BOSS_SCENE = preload("res://boss/Boss.tscn")
const DANGER_AMOUNT = [4, 5, 6, 7, 8, 9]
const OPPOSITE_INDEX = [3, 2, 1, 0]

var curr_state : int
var player : Player
var safe_pos : Vector2
var respawn_position : Vector2
var trigger_items : Array
var curr_triggers := {} # item_type:position_index
var level := 0
var safe_item_index := 0


func _ready():
	AudioManager.update_tracks(1)
	randomize()
	
	player = $Room/YSort/Player
	trigger_items = range(TriggerItem.Types.size())
	# warning-ignore:return_value_discarded
	player.connect("teleport", $Room, "random_valid_position")
	player.connect("died", self, "_on_player_death")
	
	new_level()

func new_level():
	if not trigger_items.size():
		boss_level()
		return
	
	var trigger_pos = range(4)
	var items_to_add = min(2, trigger_items.size())
	
	curr_triggers.clear()
	trigger_items.shuffle()
	trigger_pos.shuffle()
	
	trigger_pos.erase(safe_item_index)
	trigger_pos.append(safe_item_index)
	
	for i in items_to_add:
		var item := TRIGGER_SCENE.instance()
		var pos_index = trigger_pos.pop_front()
		var type = trigger_items.pop_front()
		$TriggerItems.add_child(item)
		item.position = room.get_item_position(pos_index)
		item.set_type(type)
		item.connect("picked_up", self, "_on_item_picked_up")
		curr_triggers[type] = pos_index


func boss_level():
	AudioManager.play_bgm("boss", 2)
	var boss = BOSS_SCENE.instance()
	room.add_child(boss)
	boss.position = $Room/BlackholePosition.position
	
	var safe_item = SAFE_SCENE.instance()
	$SafeItems.add_child(safe_item)
	safe_item.position = respawn_position
	respawn_position = player.position
	safe_item.set_type(SafeItem.Types.CLOCK)
	safe_item.connect("reached", self, "_on_safe_reached")


func gameover():
	pass


func _on_item_picked_up(type:int):
	$PickedItem.play()
	randomize()
	$Laugh.stream = LOC_SFX[type][randi()%3]
	$Laugh.play()
	
	for trigger in $TriggerItems.get_children():
		if trigger.type != type:
			trigger_items.append(trigger.type)
			trigger.queue_free()
	
	respawn_position = player.position
	
	get_tree().call_group("furniture", "set_time_of_day", Furniture.NIGHT)
	AudioManager.update_tracks(2)
	
	safe_item_index = OPPOSITE_INDEX[curr_triggers[type]]
	
	yield(get_tree(), "idle_frame")
	var safe_item = SAFE_SCENE.instance()
	$SafeItems.add_child(safe_item)
	safe_item.position = room.get_item_position(safe_item_index)
	safe_item.set_type(type)
	safe_item.connect("reached", self, "_on_safe_reached")
	
	if trigger_items.size():
		room.spawn_danger(DANGER_AMOUNT[level])
	else:
		room.spawn_blackhole()


func _on_safe_reached():
	$Reached.play()
	for safe in $SafeItems.get_children():
		if safe.type == SafeItem.Types.CLOCK:
			gameover()
			return
		else:
			safe.queue_free()
	
	player.remove_all_status()
	level += 1
	if trigger_items.size():
		get_tree().call_group("furniture", "set_time_of_day", Furniture.DAY)
		AudioManager.update_tracks(1)
	room.clear_danger()
	new_level()


func _on_player_death():
	# RESPAWN
	player.queue_free()
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	player = PLAYER_SCENE.instance()
	player.position = respawn_position
	$Room/YSort.add_child(player)
	
# warning-ignore:return_value_discarded
	player.connect("died", room, "_on_player_died")
# warning-ignore:return_value_discarded
	player.connect("update_life", room, "_on_player_update_life")
	player.connect("teleport", room, "random_valid_position")
	player.connect("died", self, "_on_player_death")
	
	player.emit_signal("update_life", player.hp)
