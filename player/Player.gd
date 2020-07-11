extends KinematicBody2D

onready var status_array = $StatusNode.get_children()

const SPEED = 4000
const FRICTION_SPEED = 8000
const MAX_SPEED = 400

var movement = Vector2()


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
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

	if move_vec != Vector2.ZERO:
		apply_movement(move_vec * SPEED * delta)
	else:
		apply_friction(FRICTION_SPEED * delta)
	
	movement = move_and_slide(movement)


func apply_movement(acceleration):
	movement += acceleration
	movement = movement.clamped(MAX_SPEED)


func apply_friction(acceleration):
	if movement.length() > acceleration:
		movement -= movement.normalized() * acceleration
	else:
		movement = Vector2()


func has_status(status:int) -> bool:
	for s in status_array:
		if s.type == status:
			return true
	return false
