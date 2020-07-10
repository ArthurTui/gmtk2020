extends Node2D

const SPEED = 200

func _ready():
	pass # Replace with function body.


func _process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("player_down"):
		move_vec += Vector2(0,1)
	if Input.is_action_pressed("player_up"):
		move_vec += Vector2(0,-1)
	if Input.is_action_pressed("player_left"):
		move_vec += Vector2(-1,0)
	if Input.is_action_pressed("player_right"):
		move_vec += Vector2(1,0)
	move_vec = move_vec.normalized()
	position += SPEED*move_vec*delta
