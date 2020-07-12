extends Node

export var damage := 20

func _ready():
	$Loop.play()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.take_damage(damage)
