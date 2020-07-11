extends Node2D

export var pull_force := 5000


func _ready():
	pass


func pull_player(movement:Vector2, player_pos:Vector2) -> Vector2:
	var pull_direction = (global_position - player_pos).normalized()
	pull_direction *= (1 / global_position.distance_to(player_pos)) * pull_force
	
	return movement + pull_direction


func _on_PullArea_body_entered(body):
	if body is Player:
		(body as Player).blackhole_area_entered(self)


func _on_PullArea_body_exited(body):
	if body is Player:
		(body as Player).blackhole_area_exited()


func _on_DeathArea_body_entered(body):
	if body is Player:
		(body as Player).die()
