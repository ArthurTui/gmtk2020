extends KinematicBody2D

onready var status_node = $StatusNode

const ACCELERATION_FACTOR = .1
const FRICTION_FACTOR = .5
const MAX_HP = 100
const SPEED = 400
const STATUS = [null,
		preload("res://status/debuffs/SpeedUp.tscn"),
		preload("res://status/debuffs/Petrify.tscn"),
		preload("res://status/debuffs/Burning.tscn")]

var movement := Vector2.ZERO
var stunned := false
var has_status := []
var status_array := []
var hp


func _ready():
	hp = MAX_HP
	$HP.text = str(hp)
	for i in Status.TYPES.size():
		has_status.append(false)
		status_array.append(null)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_1:
		add_status(Status.TYPES.SPEEDUP)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_2:
		add_status(Status.TYPES.PETRIFY)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_3:
		add_status(Status.TYPES.BURNING)


func _physics_process(_delta):
	if is_stunned():
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


func heal(amount: int):
	hp = min(hp + amount, MAX_HP)
	$HP.text = str(hp)


func take_damage(amount: int):
	hp = max(hp - amount, 0)
	$HP.text = str(hp)
	
	if hp <= 0:
		die()


func die():
	queue_free()


func is_stunned() -> bool:
	return has_status[Status.TYPES.PETRIFY]


func add_status(type:int):
	if has_status[type]:
		return
	
	assert(type != Status.TYPES.NONE, "Status type can't be NONE")
	var status : Status = STATUS[type].instance()
	has_status[status.type] = true
	
	status.connect("finished", self, "remove_status", [status])
	status_node.add_child(status)
	status_array[type] = status


func remove_status(status:Status):
	has_status[status.type] = false
	status_array[status.type] = null
	status_node.remove_child(status)
