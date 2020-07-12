extends Node

export var damage := 20

func _ready():
	$Loop.play()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.take_damage(damage)
		$DamageSFX.play()
		$Sprite.stop()
		$Sprite.animation = "activate"
		$Sprite.frame = 0
		$Sprite.play()
		yield($Sprite, "animation_finished")
		$Sprite.stop()
		$Sprite.animation = "default"
		$Sprite.frame = 0
		$Sprite.play()

