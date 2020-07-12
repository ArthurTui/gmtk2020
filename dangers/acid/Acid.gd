extends Node

func _ready():
	$AudioStreamPlayer.play()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.add_status(Status.TYPES.ACIDBURNING)

func _on_Area2D_body_exited(body):
	if body is Player:
		body.remove_status(body.status_array[Status.TYPES.ACIDBURNING])
