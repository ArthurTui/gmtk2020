extends Node

export var damage := 20

func _on_Area2D_body_entered(body):
	if body is Player:
		body.take_damage(damage)
	$Sprite.stop()
	$Sprite.frame = 0
	$Sprite.play()


func _on_Sprite_animation_finished():
	$Sprite.stop()
	$Sprite.frame = 0
