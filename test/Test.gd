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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
