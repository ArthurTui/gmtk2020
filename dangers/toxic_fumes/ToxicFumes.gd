extends Node

func _on_Area2D_body_entered(body):
	if body is Player:
		body.add_status(Status.TYPES.BURNING)

func _on_Area2D_body_exited(body):
	if body is Player:
		body.remove_status(body.status_array[Status.TYPES.BURNING])
