extends Node2D

export var pull_force := 1.0


func _ready():
	pass


func pull_player(movement:Vector2, player_pos:Vector2) -> Vector2:
	var pull_direction = (global_position - player_pos).normalized()
	pull_direction *= (1 / global_position.distance_to(player_pos)) * pull_force
	movement.slerp()
	
	return movement


func _on_Area2D_body_entered(body):
	if body is Player:
		(body as Player).blackhole_area_entered(self)


func _on_Area2D_body_exited(body):
	if body is Player:
		(body as Player).blackhole_area_exited()
