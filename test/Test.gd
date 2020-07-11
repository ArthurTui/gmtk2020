extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#TOP
	var top = $Walls/StaticBody2D.position.y
	
	#Bottom
	var bottom = $Walls/StaticBody2D2.position.y

	#Left
	var left = $Walls/StaticBody2D3.position.x
	
	#Right
	var right = $Walls/StaticBody2D4.position.x
		
	$Player.add_camera_bounds(left, right, bottom, top)
	
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

		#Check if position doesn't collide with any obstacles
		var valid = true
		var margin = 10
		for object in $Objects.get_children():
			if object.position.x - object.get_width()/2 - margin < $Player.position.x + $Player.get_width()/2 and \
			   object.position.x + object.get_width()/2 + margin > $Player.position.x - $Player.get_width()/2 and \
			   object.position.y - object.get_height()/2 - margin < $Player.position.y + $Player.get_height()/2 and \
			   object.position.y + object.get_height()/2 + margin > $Player.position.y - $Player.get_height()/2:
				#Collided with an object
				valid = false
				break
		if valid:
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
