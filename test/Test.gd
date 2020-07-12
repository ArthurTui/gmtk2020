extends Node2D

func _ready():	
# warning-ignore:return_value_discarded
	$Player.connect("teleport", self, "random_valid_position")
# warning-ignore:return_value_discarded
	$Player.connect("add_status", self, "_on_player_add_status")
# warning-ignore:return_value_discarded
	$Player.connect("remove_status", self, "_on_player_remove_status")

#Get a random valid position to position player
func random_valid_position():
	var pos = Vector2()
	while(true):
		#Get random position inside room
		randomize()
		pos.x = rand_range($Walls/StaticBody2D3.position.x + $Player.get_width()/2,
						   $Walls/StaticBody2D4.position.x - $Player.get_width()/2)
		pos.y = rand_range($Walls/StaticBody2D.position.y + $Player.get_height()/2,
						   $Walls/StaticBody2D2.position.y - $Player.get_height()/2)
		
		var transform = Transform2D()
		transform.translated(pos)
		if not $Player.test_move(transform, Vector2()):
			break

	#Teleport player
	$Player.position = pos

func _on_player_add_status(name):
	var label = Label.new()
	label.name = name
	label.text = name
	$DebugHUD/VBoxContainer.add_child(label)

func _on_player_remove_status(name):
	var label = $DebugHUD/VBoxContainer.get_node(name)
	$DebugHUD/VBoxContainer.remove_child(label)	
