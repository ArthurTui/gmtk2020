extends Node

export var damage := 40

func _on_Area2D_body_entered(body):
	if body is Player:
		body.take_damage(damage)
		body.add_status(Status.TYPES.ACIDBURNING)

func _on_Area2D_body_exited(body):
	if body is Player:
		body.remove_status(body.status_array[Status.TYPES.ACIDBURNING])
