extends KinematicBody2D

onready var status_node = $StatusNode

const SPEED = 4000
const FRICTION_SPEED = 8000
const MAX_SPEED = 400
const STATUS = {
	"speed_up": preload("res://status/debuffs/SpeedUp.tscn"),
	"petrify": preload("res://status/debuffs/Petrify.tscn"),
}

var movement = Vector2()
var stunned = false


func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_1:
		add_status("speed_up")
	elif event is InputEventKey and event.pressed and event.scancode == KEY_2:
		add_status("petrify")


func _physics_process(delta):
	
	if stunned:
		return

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
	var max_speed = MAX_SPEED
	if has_status(Status.TYPES.SPEEDUP):
		acceleration *= 3
		max_speed *= 3
	
	movement += acceleration
	movement = movement.clamped(max_speed)


func apply_friction(acceleration):
	if movement.length() > acceleration:
		movement -= movement.normalized() * acceleration
	else:
		movement = Vector2()

func stun(duration: float):
	if stunned:
		return

	stunned = true
	yield(get_tree().create_timer(duration), "timeout")
	stunned = false


func add_status(name: String):
	var status = STATUS[name].instance()
	
	var signals = status.get_signal_list()
	if signals.has("stun"):
		status.connect("stun", self, "stun")

	status_node.add_child(status)

func has_status(status:int) -> bool:
	for s in status_node.get_children():
		if s.type == status:
			return true
	return false

func get_status(status:int) -> Status:
	for s in status_node.get_children():
		if s.type == status:
			return s
	return null
