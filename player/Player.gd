extends KinematicBody2D
class_name Player

signal teleport
signal remove_status
signal died
signal update_life

onready var status_node = $StatusNode
onready var sprite = $AnimatedSprite

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
		preload("res://status/debuffs/Bleeding.tscn"),
		preload("res://status/debuffs/AcidBurning.tscn"),
		preload("res://status/debuffs/Teleport.tscn")]

var movement := Vector2.ZERO
var has_status := []
var status_array := []
var hp : float
var blink_chance := 0.0

#BLACKHOLE
var blackhole = null


func _ready():
	hp = MAX_HP
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
		toggle_status(Status.TYPES.TELEPORT)
	elif event is InputEventKey and event.pressed and event.scancode == KEY_9:
		toggle_vision_cone()


func _physics_process(dt):
	if not is_stunned():
		move(get_input_movement())
	
	if has_status[Status.TYPES.BURNING]:
		var burn = status_array[Status.TYPES.BURNING]
		take_damage(burn.damage * dt)
	if has_status[Status.TYPES.ACIDBURNING]:
		var acidburn = status_array[Status.TYPES.ACIDBURNING]
		take_damage(acidburn.damage * dt)
	
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
	
	if move_vec.length() > 0:
		if has_status[Status.TYPES.SLIPPERY]:
			$WalkSFX.stop()
			if not $SlipperySFX.playing:
				$SlipperySFX.play()
		else:
			$SlipperySFX.stop()
			if not $WalkSFX.playing:
				$WalkSFX.play()
	else:
		$SlipperySFX.stop()
		$WalkSFX.stop()
	
	if has_status[Status.TYPES.CONFUSED]:
		move_vec *= -1
	
	move_vec = move_vec.normalized() * SPEED
	
	animate_movement(move_vec)
	
	return move_vec


func animate_movement(move_input:Vector2):
	if move_input == Vector2.ZERO:
		change_animation("idle")
	else:
		change_animation("walk")
		if move_input.x != 0:
			sprite.flip_h = move_input.x < 0


func change_animation(anim:String):
	if sprite.is_playing() and sprite.animation.begins_with(anim):
		return
	
	sprite.play(anim)


func move(new_movement:Vector2):
	var acc_factor = ACCELERATION_FACTOR
	var fric_factor = FRICTION_FACTOR
	
	# SPEEDUP
	if has_status[Status.TYPES.SPEEDUP]:
		new_movement *= status_array[Status.TYPES.SPEEDUP].speed_multiplier
	# SPEEDDOWN
	if has_status[Status.TYPES.SPEEDDOWN]:
		new_movement *= status_array[Status.TYPES.SPEEDDOWN].speed_multiplier
	# SLIPPERY
	if has_status[Status.TYPES.SLIPPERY]:
		acc_factor = status_array[Status.TYPES.SLIPPERY].acceleration_factor
		fric_factor = status_array[Status.TYPES.SLIPPERY].friction_factor
	
	if new_movement != Vector2.ZERO:
		movement = lerp(movement, new_movement, acc_factor)
	else:
		movement = lerp(movement, new_movement, fric_factor)
	
	# BLEEDING
	if has_status[Status.TYPES.BLEEDING]:
		take_damage(status_array[Status.TYPES.BLEEDING].damage * movement.length())
	
	# BLACKHOLE
	if blackhole:
		movement = blackhole.pull_player(movement, global_position)
	
	movement = move_and_slide(movement)


func get_width():
	return $CollisionShape2D.shape.extents.x * 2


func get_height():
	return $CollisionShape2D.shape.extents.y * 2


func heal(amount: float):
	hp = min(hp + amount, MAX_HP)

func _on_teleport():
	emit_signal("teleport")

func take_damage(amount: float):
	
	hp = max(hp - amount, 0)
	emit_signal("update_life", hp)
	if hp <= 0:
		die()
	else:
		if not $DamageSFX.playing:
			$DamageSFX.play()


func die():
	emit_signal("died")
	queue_free()


func is_stunned() -> bool:
	return has_status[Status.TYPES.PETRIFY]


func add_status(type:int):
	if has_status[type]:
		return
	
	assert(type != Status.TYPES.NONE, "Status type can't be NONE")
	has_status[type] = true
	
	if type == Status.TYPES.DARKNESS:
		toggle_vision_cone()
	elif type == Status.TYPES.TELEPORT:
		var status : Status = STATUS[type].instance()
	# warning-ignore:return_value_discarded
		status.connect("finished", self, "remove_status", [status])
		status.connect("teleport", self, "_on_teleport")
		status_node.add_child(status)
		status_array[type] = status
	else:
		var status : Status = STATUS[type].instance()
	# warning-ignore:return_value_discarded
		status.connect("finished", self, "remove_status", [status])
		status_node.add_child(status)
		status_array[type] = status
	
	#DEBUG
#	emit_signal("add_status", status.name)


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


func pickup_item(item:Item):
	pass


func blackhole_area_entered(bhole):
	blackhole = bhole


func blackhole_area_exited():
	blackhole = null


func _on_AnimatedSprite_animation_finished():
	match sprite.animation:
		"celebrate":
			sprite.play("idle")
		"idle":
			if blink_chance > randf():
				blink_chance = 0
				sprite.play("idle_blink")
			else:
				blink_chance += .05
		"idle_blink":
			sprite.play("idle")
		"use_item":
			sprite.play("idle")
		"walk":
			if blink_chance > randf():
				blink_chance = 0
				sprite.play("walk_blink")
			else:
				blink_chance += .05
		"walk_blink":
			sprite.play("walk")
