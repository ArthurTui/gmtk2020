extends KinematicBody2D

signal get_position

const SPEED = 300

var target = null

func _ready():
	scale = Vector2()
	$Tween.interpolate_property(self, "scale", Vector2(), Vector2(1,1), 3.2, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")

	get_new_position()


func _process(delta):
	if target:
		var move_amount = Vector2(move_to(position.x, target.x, SPEED  * delta), move_to(position.y, target.y, SPEED * delta))
# warning-ignore:return_value_discarded
		move_and_collide(move_amount)
		
		if move_amount.length() <= .1:
			get_new_position()


func move_to(orig, final, amount):
	var difference = (final - orig)

	if abs(difference) >= amount:
		return -amount if difference < 0 else amount
	else:
		return -difference

func set_target(target_pos):
	target = target_pos

func get_new_position():
	print("hey")
	randomize()
	var x = rand_range(450,650)
	var y = rand_range(400,500)
	target = Vector2(x, y)
	print(target)
	#emit_signal("get_position")
