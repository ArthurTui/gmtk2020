extends Node

onready var room = $Room

enum States {DAY, NIGHT}

const TRIGGER_SCENE = preload("res://items/TriggerItem.tscn")
const SAFE_SCENE = preload("res://items/SafeItem.tscn")
const DANGER_AMOUNT = [4, 5, 6, 8, 10]
const OPPOSITE_INDEX = [3, 2, 1, 0]

var curr_state : int
var player : Player
var safe_pos : Vector2
var trigger_items : Array
var curr_triggers := {} # item_type:position_index
var level := 0
var safe_item_index := 0


func _ready():
	randomize()
	
	player = $Room/YSort/Player
	trigger_items = range(TriggerItem.Types.size())
	# warning-ignore:return_value_discarded
	player.connect("teleport", self, "random_valid_position")
	
	new_level()

#Get a random valid position to position player
func random_valid_position():
	var pos = Vector2()
	while(true):
		#Get random position inside room
		randomize()
		pos.x = rand_range($Room/Walls/Left.position.x + player.get_width()/2,
						   $Room/Walls/Right.position.x - player.get_width()/2)
		pos.y = rand_range($Room/Walls/Upper.position.y + player.get_height()/2,
						   $Room/Walls/Lower.position.y - player.get_height()/2)
		
		var transform = Transform2D()
		transform.translated(pos)
		if not player.test_move(transform, Vector2()):
			break

	#Teleport player
	player.position = pos


func new_level():
	if not trigger_items.size():
		boss_level()
		return
	
	room.clear_danger()
	
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
	pass


func _on_item_picked_up(type:int):
	for trigger in $TriggerItems.get_children():
		if trigger.type != type:
			trigger.queue_free()
	
	get_tree().call_group("furniture", "set_time_of_day", Furniture.NIGHT)
	
	safe_item_index = OPPOSITE_INDEX[curr_triggers[type]]
	
	yield(get_tree(), "idle_frame")
	var safe_item = SAFE_SCENE.instance()
	$SafeItems.add_child(safe_item)
	safe_item.position = room.get_item_position(safe_item_index)
	safe_item.set_type(type)
	safe_item.connect("reached", self, "_on_safe_reached")
	
	room.spawn_danger(DANGER_AMOUNT[level])


func _on_safe_reached():
	for safe in $SafeItems.get_children():
		safe.queue_free()
	
	player.remove_all_status()
	level += 1
	get_tree().call_group("furniture", "set_time_of_day", Furniture.DAY)
	new_level()
