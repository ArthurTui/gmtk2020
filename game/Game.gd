extends Node

onready var room = $Room

enum States {DAY, NIGHT}

const TRIGGER_SCENE = preload("res://items/TriggerItem.tscn")
const SAFE_SCENE = preload("res://items/SafeItem.tscn")

var curr_state : int
var player : Player
var safe_pos : Vector2
var trigger_items : Array
var curr_triggers := {} # item_type:position_index


func _ready():
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
	
	var trigger_pos = range(4)
	var items_to_add = min(2, trigger_items.size())
	
	curr_triggers.clear()
	trigger_items.shuffle()
	trigger_pos.shuffle()
	
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
	
	
