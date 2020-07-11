extends KinematicBody2D

onready var status_node = $StatusNode

const ACCELERATION_FACTOR = .1
const FRICTION_FACTOR = .5
const SPEED = 400
const STATUS = {
	"speed_up": preload("res://status/debuffs/SpeedUp.tscn"),
	"petrify": preload("res://status/debuffs/Petrify.tscn"),
}

var movement = Vector2.ZERO
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
	move(get_input_movement())


func get_input_movement() -> Vector2:
	var move_vec = Vector2.ZERO
	if Input.is_action_pressed("player_down"):
		move_vec += Vector2(0, 1)
	if Input.is_action_pressed("player_up"):
		move_vec += Vector2(0, -1)
	if Input.is_action_pressed("player_left"):
		move_vec += Vector2(-1, 0)
	if Input.is_action_pressed("player_right"):
		move_vec += Vector2(1, 0)
	
	move_vec = move_vec.normalized() * SPEED
	
	return move_vec


func move(new_movement:Vector2):
	if new_movement != Vector2.ZERO:
		movement = lerp(movement, new_movement, ACCELERATION_FACTOR)
	else:
		movement = lerp(movement, new_movement, FRICTION_FACTOR)
	
	movement = move_and_slide(movement)

func stun(duration: float):
	if stunned:
		return
	
	stunned = true
	yield(get_tree().create_timer(duration), "timeout")
	stunned = false

func add_status(name: String):
	var status = STATUS[name].instance()
	
	var signals = status.get_signal_list()
	for sig in signals:
		if sig.name == "stun":
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
