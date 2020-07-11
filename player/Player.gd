extends KinematicBody2D

signal teleport
signal add_status
signal remove_status

onready var status_node = $StatusNode

const ACCELERATION_FACTOR = .1
const FRICTION_FACTOR = .5
const MAX_HP = 100
const SPEED = 400
const STATUS = [null,
		preload("res://status/debuffs/SpeedUp.tscn"),
		preload("res://status/debuffs/Petrify.tscn"),
		preload("res://status/debuffs/Burning.tscn"),
		preload("res://status/debuffs/Slippery.tscn"),
		preload("res://status/debuffs/Confused.tscn"),
		preload("res://status/debuffs/SpeedDown.tscn"),
		preload("res://status/debuffs/Bleeding.tscn")]

var movement := Vector2.ZERO
var stunned := false
var has_status := []
var status_array := []
var hp : float


func _ready():
	hp = MAX_HP
	$HP.text = str(ceil(hp))
	for i in Status.TYPES.size():
		has_status.append(false)
		status_array.append(null)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_1:
		toggle_status(Status.TYPES.SPEEDUP)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_2:
		toggle_status(Status.TYPES.PETRIFY)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_3:
		toggle_status(Status.TYPES.BURNING)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_4:
		toggle_status(Status.TYPES.SLIPPERY)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_5:
		toggle_status(Status.TYPES.CONFUSED)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_6:
		toggle_status(Status.TYPES.SPEEDDOWN)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_7:
		toggle_status(Status.TYPES.BLEEDING)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_8:
		emit_signal("teleport")
	elif event is InputEventKey and event.pressed and event.scancode == KEY_9:
		toggle_vision_cone()


func _physics_process(dt):
	if not is_stunned():
		move(get_input_movement())
	
	if has_status[Status.TYPES.BURNING]:
		var burn = status_array[Status.TYPES.BURNING]
		take_damage(burn.damage * dt)
	
	if $Vision.visible:
		update_vision_cone()

func update_vision_cone():
	var angle = (get_global_mouse_position() - global_position).angle() + PI/2
	$Vision.rotation = angle

func toggle_vision_cone():
	$Vision.visible = not $Vision.visible

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
	
	if has_status[Status.TYPES.CONFUSED]:
		move_vec *= -1

	move_vec = move_vec.normalized() * SPEED
	
	return move_vec


func move(new_movement:Vector2):
	var acc_factor = ACCELERATION_FACTOR
	var fric_factor = FRICTION_FACTOR
	
	if has_status[Status.TYPES.SPEEDUP]:
		new_movement *= status_array[Status.TYPES.SPEEDUP].speed_multiplier
	if has_status[Status.TYPES.SPEEDDOWN]:
		new_movement *= status_array[Status.TYPES.SPEEDDOWN].speed_multiplier
	if has_status[Status.TYPES.SLIPPERY]:
		acc_factor = status_array[Status.TYPES.SLIPPERY].acceleration_factor
		fric_factor = status_array[Status.TYPES.SLIPPERY].friction_factor
	
	if new_movement != Vector2.ZERO:
		movement = lerp(movement, new_movement, acc_factor)
	else:
		movement = lerp(movement, new_movement, fric_factor)
	
	if has_status[Status.TYPES.BLEEDING]:
		take_damage(status_array[Status.TYPES.BLEEDING].damage * movement.length())
	movement = move_and_slide(movement)

func get_width():
	return $CollisionShape2D.shape.extents.x * 2

func get_height():
	return $CollisionShape2D.shape.extents.y * 2

func heal(amount: float):
	hp = min(hp + amount, MAX_HP)
	$HP.text = str(ceil(hp))


func take_damage(amount: float):
	hp = max(hp - amount, 0)
	$HP.text = str(ceil(hp))
	
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
	
# warning-ignore:return_value_discarded
	status.connect("finished", self, "remove_status", [status])
	status_node.add_child(status)
	status_array[type] = status
	
	#DEBUG
	emit_signal("add_status", status.name)

func remove_status(status:Status):
	has_status[status.type] = false
	status_array[status.type] = null
	status_node.remove_child(status)
	
	#DEBUG
	emit_signal("remove_status", status.name)
	
func toggle_status(status_type: int):
	if not has_status[status_type]:
		add_status(status_type)
	else:
		remove_status(status_array[status_type])

func add_camera_bounds(left:int, right:int, bottom:int, top:int):
	$Camera2D.limit_left = left
	$Camera2D.limit_right = right	
	$Camera2D.limit_bottom = bottom
	$Camera2D.limit_top = top
	
