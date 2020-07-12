extends Node

onready var room = $Room

enum States {DAY, NIGHT}

var curr_state : int
var player : Player
var safe_pos : Vector2
var trigger_items : Array
var curr_triggers := {} # item_type:position_index


func _ready():
	player = $Room/YSort/Player
	trigger_items = range(TriggerItem.Types.size())


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
		var item := TriggerItem.new()
		var pos_index = trigger_pos.pop_front()
		var type = trigger_items.pop_front()
		item.position = room.get_item_position(pos_index)
		item.set_type(type)
		add_child(item)
		curr_triggers[type] = pos_index


func boss_level():
	pass


func _on_item_picked_up(type:int):
	get_tree().call_group("furniture", "set_time_of_day", Furniture.NIGHT)
