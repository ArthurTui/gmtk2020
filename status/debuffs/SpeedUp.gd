extends Status

export var acceleration_factor := .2
export var friction_factor := .5
export var speed_multiplier := 3.0


func move(movement:Vector2, new_movement:Vector2):
	new_movement *= speed_multiplier
	if new_movement != Vector2.ZERO:
		movement = lerp(movement, new_movement, acceleration_factor)
	else:
		movement = lerp(movement, new_movement, friction_factor)
	
	return movement
